package com.jxl.sharedslides.rl.models
{
	import com.jxl.sharedslides.events.model.NetworkModelEvent;
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	import com.projectcocoon.p2p.events.ClientEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.events.ObjectEvent;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.utils.SHA256;
	
	import org.robotlegs.mvcs.Actor;
	
	public class NetworkModel extends Actor
	{
		
		[Inject]
		public var localNetworkDiscovery:LocalNetworkDiscovery;
		
		private var _connected:Boolean = false;
		
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
		
		[Bindable(event="clientsChange")]
		public function get clients():ArrayCollection { return localNetworkDiscovery.clients; }
		
		[Bindable(event="sharedObjectsChange")]
		public function get sharedObjects():ArrayCollection { return localNetworkDiscovery.sharedObjects; }
		
		[Bindable(event="receivedObjectsChange")]
		public function get receivedObjects():ArrayCollection { return localNetworkDiscovery.receivedObjects; }
		
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
			//localNetworkDiscovery.addEventListener(MessageEvent.DATA_RECEIVED, onMessageEvent);
			
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
			Debug.debug(getTimer() + " NetworkModel::shareSlideshow");
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(slideshow);
			Debug.debug(getTimer() + " write done at " + bytes.length + " bytes, computing digest...");
			var hash:String = SHA256.computeDigest(bytes);
			Debug.debug(getTimer() + " computing digest done, compressing...");
			slideshow.hash = hash;
			bytes.position = 0;
			bytes.compress();
			Debug.debug(getTimer() + " compression done at " + bytes.length + " bytes.");
			Debug.debug(getTimer() + " hash: " + hash);
			Debug.debug(getTimer() + " sharing with all...");
			localNetworkDiscovery.shareWithAll(slideshow, slideshow.name);
			Debug.debug(getTimer() + " done sharing with all.");
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
			Debug.info("NetworkModel::onObjectAnnounced");
			localNetworkDiscovery.requestObject(event.metadata);
		}
		
		private function onObjectProgress(event:ObjectEvent):void
		{
			localNetworkDiscovery.receivedObjects.refresh();
		}
		
		private function onObjectComplete(event:ObjectEvent):void
		{
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
			
			dispatch(new Event("clientAdded"));
			
			//var evt:NetworkModelEvent 		= new NetworkModelEvent(NetworkModelEvent.CLIENT_ADDED);
			//evt.client 						= event.client;
			//dispatch(evt);
		}
		
		private function onClientUpdate(event:ClientEvent):void
		{
			Debug.info("NetworkModel::onClientUpdate, clientName:  " + event.client.clientName);
			if(event.client.isLocal)
				return;
			
			dispatch(new Event("clientUpdate"));
			
			//var evt:NetworkModelEvent 		= new NetworkModelEvent(NetworkModelEvent.CLIENT_UPDATED);
			//evt.client 						= event.client;
			//dispatch(evt);
		}
		
		private function onClientRemoved(event:ClientEvent):void
		{
			Debug.info("NetworkModel::onClientRemoved, clientName:  " + event.client.clientName);
			if(event.client.isLocal)
				return;
			
			dispatch(new Event("clientRemoved"));
		}
	}
}