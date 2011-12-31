package com.jxl.sharedslides.rl.models
{
	import com.adobe.crypto.MD5;
	import com.jxl.sharedslides.events.model.NetworkModelEvent;
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	import com.projectcocoon.p2p.events.ClientEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.events.ObjectEvent;
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;
	
	public class NetworkModel extends Actor
	{
		
		[Inject]
		public var localNetworkDiscovery:LocalNetworkDiscovery;
		
		private var _connected:Boolean = false;
		private var _currentSlide:int = 0;
		private var awaitingSlideshows:Object = {};
		
		public function get connected():Boolean { return _connected; }
		public function set connected(value:Boolean):void
		{
			_connected = value;
			if(_connected)
			{
				dispatch(new NetworkModelEvent(NetworkModelEvent.GROUP_CONNECTED));
			}
			else
			{
				dispatch(new NetworkModelEvent(NetworkModelEvent.GROUP_DISCONNECTED));
			}
		}
		
		public function get currentSlide():int { return _currentSlide; }
		public function set currentSlide(value:int):void
		{
			if(value !== _currentSlide)
			{
				_currentSlide = value;
				dispatch(new NetworkModelEvent(NetworkModelEvent.HOST_CURRENT_SLIDE_INDEX_CHANGED));
			}
		}
		
		[Bindable(event="clientsChange")]
		public function get clients():ArrayCollection { return localNetworkDiscovery.clients; }
		
		[Bindable(event="sharedObjectsChange")]
		public function get sharedObjects():ArrayCollection { return localNetworkDiscovery.sharedObjects; }
		
		[Bindable(event="receivedObjectsChange")]
		public function get receivedObjects():ArrayCollection { return localNetworkDiscovery.receivedObjects; }
		
		public var currentSlideshowHash:String;
		
		/*
		[Bindable(event="nearIDChanged")]
		public function get nearID():String { return localNetworkDiscovery.connection.nearID; }
		*/
		
		public function NetworkModel()
		{
			super();
		}
		
		[PostConstruct]
		public function connect():void
		{
			Debug.log("NetworkModel::init");
			
			localNetworkDiscovery.loopback = false;
			localNetworkDiscovery.groupName = "com.jxl.shareslides";
			localNetworkDiscovery.addEventListener(GroupEvent.GROUP_CONNECTED, onGroupConnected);
			localNetworkDiscovery.addEventListener(GroupEvent.GROUP_CLOSED, onGroupClosed);
			localNetworkDiscovery.addEventListener(ObjectEvent.OBJECT_ANNOUNCED, onObjectAnnounced);
			localNetworkDiscovery.addEventListener(ObjectEvent.OBJECT_PROGRESS, onObjectProgress);
			localNetworkDiscovery.addEventListener(ObjectEvent.OBJECT_COMPLETE, onObjectComplete);
			localNetworkDiscovery.addEventListener("sharedObjectsChange", onSharedObjectsChanged);
			//localNetworkDiscovery.addEventListener("receivedObjectsChange", onReceivedObjectsChanged);
			//localNetworkDiscovery.addEventListener("clientsConnectedChange", onClientsConnectedChanged);
			//localNetworkDiscovery.addEventListener("clientsChange", onClientsChanged);
			localNetworkDiscovery.addEventListener(ClientEvent.CLIENT_ADDED, onClientAdded);
			localNetworkDiscovery.addEventListener(ClientEvent.CLIENT_UPDATE, onClientUpdate);
			localNetworkDiscovery.addEventListener(ClientEvent.CLIENT_REMOVED, onClientRemoved);
			localNetworkDiscovery.addEventListener(MessageEvent.DATA_RECEIVED, onMessageEvent);
			
			if(localNetworkDiscovery.clientName == "" || localNetworkDiscovery.clientName == null)
				localNetworkDiscovery.clientName = "Default User";
			
			Debug.log("NetworkModel::connect");
			localNetworkDiscovery.connect();
		}
		
		public function changeName(name:String):void
		{
			if(localNetworkDiscovery.clientName != name)
				localNetworkDiscovery.clientName = name;
		}
		
		public function shareSlideshow(slideshow:SlideshowVO):void
		{
			slideshow.updateHashIfNeeded();
			localNetworkDiscovery.shareWithAll(slideshow, {name: slideshow.name, hash: slideshow.hash});
		}
		
		public function setHostCurrentIndex(slideshowHash:String, index:int):void
		{
			localNetworkDiscovery.sendMessageToAll({message: "setCurrentSlide", currentSlide: index, slideshowHash: slideshowHash});
		}
		
		private function onGroupConnected(event:GroupEvent):void
		{
			Debug.info("NetworkModel::onGroupConnected");
			connected = true;
			Debug.info("localNetworkDiscovery.clientName: " + localNetworkDiscovery.clientName + ", nearID: " + localNetworkDiscovery.connection.nearID);
			
		}
		
		private function onGroupClosed(event:GroupEvent):void
		{
			Debug.info("NetworkModel::onGroupClosed");
			connected = false;
		}
		
		private function onObjectAnnounced(event:ObjectEvent):void
		{
			Debug.info("NetworkModel::onObjectAnnounced, hash: " + event.metadata.info.hash);
			if(awaitingSlideshows[event.metadata.info.hash] != null)
			{
				Debug.info("I was awaiting this slideshow, thank you, requesting...");
				delete awaitingSlideshows[event.metadata.info.hash];
				localNetworkDiscovery.requestObject(event.metadata);
			}
			else
			{
				// verify I don't have it
				var len:int = localNetworkDiscovery.receivedObjects.length;
				var om:ObjectMetadataVO;
				var slideshow:SlideshowVO;
				while(len--)
				{
					om = localNetworkDiscovery.receivedObjects[len];
					if(om.info.hash == event.metadata.info.hash)
					{
						Debug.info("Thanks, I already have this slideshow in received.");
						return;
					}
				}
				
				len = localNetworkDiscovery.sharedObjects.length;
				while(len--)
				{
					om = localNetworkDiscovery.sharedObjects[len];
					if(om.info.hash == event.metadata.info.hash)
					{
						Debug.info("Thanks, I already have this slideshow, I'm hosting it.");
						return;
					}
				}
				
				Debug.info("I have no record of requesting this, so thanks, requesting it now!");
				localNetworkDiscovery.requestObject(event.metadata);
			}
		}
		
		private function onObjectProgress(event:ObjectEvent):void
		{
			localNetworkDiscovery.receivedObjects.refresh();
		}
		
		private function onObjectComplete(event:ObjectEvent):void
		{
			Debug.debug("NetworkModel::onObjectComplete");
			// [jwarden 12.30.2011] HACK: My hashes aren't matching up... whether MD5 or SHA256.
			Debug.debug("hash on info: "+ event.metadata.info.hash);
			var slideshow:SlideshowVO = event.metadata.object as SlideshowVO;
			slideshow.hash = event.metadata.info.hash;
			localNetworkDiscovery.receivedObjects.refresh();
		}
		
		private function onSharedObjectsChanged(event:Event):void
		{
			Debug.info("NetworkModel::onSharedObjectsChanged");
			dispatch(new Event("sharedObjectsChange"));
		}
		
		private function onClientAdded(event:ClientEvent):void
		{
			Debug.info("NetworkModel::onClientAdded, event.client.clientName: " + event.client.clientName);
			if(event.client.isLocal)
				return;
			
			var hash:Object = {};
			var len:int = localNetworkDiscovery.receivedObjects.length;
			var om:ObjectMetadataVO;
			var slideshow:SlideshowVO;
			while(len--)
			{
				om = localNetworkDiscovery.receivedObjects[len];
				hash[om.info.hash] = om.info.hash;
			}
			
			len = localNetworkDiscovery.sharedObjects.length;
			while(len--)
			{
				om = localNetworkDiscovery.sharedObjects[len];
				hash[om.info.hash] = om.info.hash;
			}
			
			var hashes:Array = [];
			for(var prop:String in hash)
			{
				hashes.push(prop);
			}
			
			localNetworkDiscovery.sendMessageToClient({message: "doYouNeedSlideshow", hashes: hashes}, event.client.groupID);
			
			dispatch(new Event("clientAdded"));
		}
		
		private function onClientUpdate(event:ClientEvent):void
		{
			Debug.info("NetworkModel::onClientUpdate, clientName:  " + event.client.clientName);
			if(event.client.isLocal)
				return;
			
			dispatch(new Event("clientUpdate"));
		}
		
		private function onClientRemoved(event:ClientEvent):void
		{
			Debug.info("NetworkModel::onClientRemoved, clientName:  " + event.client.clientName);
			if(event.client.isLocal)
				return;
			
			dispatch(new Event("clientRemoved"));
		}
		
		private function onMessageEvent(event:MessageEvent):void
		{
			Debug.info("NetworkModel::onMessageEvent");
			if(event.message.data)
				Debug.info("\tmessage: " + event.message.data.message);
			
			var networkModelEvent:NetworkModelEvent;
			switch(event.message.data.message)
			{
				case "setCurrentSlide":
					Debug.info("currentSlideshowHash: " + currentSlideshowHash);
					Debug.info("event.message.data.slideshowHash: " + event.message.data.slideshowHash);
					if(currentSlideshowHash == event.message.data.slideshowHash)
						currentSlide = event.message.data.currentSlide;
					break;
				
				case "doYouNeedSlideshow":
					onVerifyIfINeedSlideshows(event);
					break;
				
				case "doYouNeedSlideshowAck":
					onSendNeededSlideshows(event);
					break;
				
				
			}
		}
		
		private function onVerifyIfINeedSlideshows(messageEvent:MessageEvent):void
		{
			var hashes:Array = messageEvent.message.data.hashes as Array;
			var missing:Array = [];
			var len:int = hashes.length;
			var hashObject:Object = {};
			while(len--)
			{
				var hashString:String = hashes[len];
				hashObject[hashString] = false;
			}
			
			var om:ObjectMetadataVO;
			var slideshow:SlideshowVO;
			len = localNetworkDiscovery.receivedObjects.length;
			while(len--)
			{
				om = localNetworkDiscovery.receivedObjects[len];
				hashObject[om.info.hash] = true;
			}
			
			len = localNetworkDiscovery.sharedObjects.length;
			while(len--)
			{
				om = localNetworkDiscovery.sharedObjects[len];
				slideshow = om.object as SlideshowVO;
				slideshow.updateHashIfNeeded();
				hashObject[slideshow.hash] = true;
			}
			
			for(var prop:String in hashObject)
			{
				if(hashObject[prop] == false)
				{
					missing.push(prop);
					awaitingSlideshows[prop] = prop;
				}
			}
			
			if(missing.length > 0)
			{
				localNetworkDiscovery.sendMessageToClient({message: "doYouNeedSlideshowAck", missing: missing}, messageEvent.message.client.groupID);
			}
		}
		
		private function onSendNeededSlideshows(event:MessageEvent):void
		{
			var missing:Array = event.message.data.missing as Array;
			var missingHash:Object = {};
			var len:int = missing.length;
			var hash:String;
			while(len--)
			{
				hash = missing[len] as String;
				missingHash[hash] = true;
			}
			
			len = localNetworkDiscovery.receivedObjects.length;
			var om:ObjectMetadataVO;
			var slideshow:SlideshowVO;
			while(len--)
			{
				om = localNetworkDiscovery.receivedObjects[len];
				slideshow = om.object as SlideshowVO;
				if(missingHash[slideshow.hash] == true)
				{
					missingHash[slideshow.hash] = false;
					localNetworkDiscovery.shareWithClient(slideshow, event.message.client.groupID, {name: slideshow.name, hash: slideshow.hash});
				}
			}
			
			len = localNetworkDiscovery.sharedObjects.length;
			while(len--)
			{
				om = localNetworkDiscovery.sharedObjects[len];
				slideshow = om.object as SlideshowVO;
				if(missingHash[slideshow.hash] == true)
				{
					missingHash[slideshow.hash] = false;
					localNetworkDiscovery.shareWithClient(slideshow, event.message.client.groupID, {name: slideshow.name, hash: slideshow.hash});
				}
			}
		}
	}
}