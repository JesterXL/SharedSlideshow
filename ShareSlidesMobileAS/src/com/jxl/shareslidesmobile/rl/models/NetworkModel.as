package com.jxl.shareslidesmobile.rl.models
{
	import com.jxl.shareslidesmobile.events.controller.SetCurrentSlideEvent;
	import com.jxl.shareslidesmobile.events.model.NetworkModelEvent;
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	import com.projectcocoon.p2p.events.ClientEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.events.ObjectEvent;
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;
	
	import flash.debugger.enterDebugger;
	import flash.events.Event;
	import flash.net.NetGroup;
	
	import mx.collections.ArrayCollection;
	
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
		
		public function get clientsConnected():int { return localNetworkDiscovery.clientsConnected; }
		public function set clientsConnected(value:int):void
		{
		}
		
		public function get clients():ArrayCollection { return localNetworkDiscovery.clients; }
		public function set clients(value:ArrayCollection):void
		{
		}
		
		public function NetworkModel()
		{
			super();
		}
		
		[PostConstruct]
		public function init():void
		{
			Debug.log("NetworkModel::init");
			localNetworkDiscovery.loopback = false;
			localNetworkDiscovery.groupName = "com.jxl.shareslides";
			localNetworkDiscovery.addEventListener(GroupEvent.GROUP_CONNECTED, onGroupConnected);
			localNetworkDiscovery.addEventListener(GroupEvent.GROUP_CLOSED, onGroupClosed);

			localNetworkDiscovery.addEventListener(ObjectEvent.OBJECT_ANNOUNCED, onObjectAnnounced);

			localNetworkDiscovery.addEventListener("sharedObjectsChange", onSharedObjectsChanged);
			localNetworkDiscovery.addEventListener("receivedObjectsChange", onReceivedObjectsChanged);
			localNetworkDiscovery.addEventListener("clientsConnectedChange", onClientsConnectedChanged);
			localNetworkDiscovery.addEventListener("clientsChange", onClientsChanged);
			
			localNetworkDiscovery.addEventListener(ClientEvent.CLIENT_ADDED, onClientAdded);
			localNetworkDiscovery.addEventListener(ClientEvent.CLIENT_UPDATE, onClientUpdate);
			
			localNetworkDiscovery.addEventListener(MessageEvent.DATA_RECEIVED, onMessageEvent);
			
			localNetworkDiscovery.connect();
		}
		
		public function containsSlideshow(slideshowName:String):Boolean
		{
			if(localNetworkDiscovery.receivedObjects == null)
				return false;
			
			var len:int = localNetworkDiscovery.receivedObjects.length;
			while(len--)
			{
				var om:ObjectMetadataVO = localNetworkDiscovery.receivedObjects.getItemAt(len) as ObjectMetadataVO;
				if(om.info as String == slideshowName)
				{
					return true;
				}
			}
				
			return false;
		}

		public function getSlideshowByName(slideshowName:String):SlideshowVO
		{
			if(localNetworkDiscovery.receivedObjects == null)
				return null;

			var len:int = localNetworkDiscovery.receivedObjects.length;
			while(len--)
			{
				var om:ObjectMetadataVO = localNetworkDiscovery.receivedObjects.getItemAt(len) as ObjectMetadataVO;
				if(om.info as String == slideshowName)
				{
					return om.object as SlideshowVO;
				}
			}

			len = localNetworkDiscovery.sharedObjects.length;
			while(len--)
			{
				var om:ObjectMetadataVO = localNetworkDiscovery.sharedObjects.getItemAt(len) as ObjectMetadataVO;
				if(om.info as String == slideshowName)
				{
					return om.object as SlideshowVO;
				}
			}

			return null;
		}
		
		private function onGroupConnected(event:GroupEvent):void
		{
			Debug.info("NetworkModel::onGroupConnected");
			connected = true;
		}
		
		private function onGroupClosed(event:GroupEvent):void
		{
			Debug.error("NetworkModel::onGroupClosed");
			connected = false;
		}

		private function onObjectAnnounced(event:ObjectEvent):void
		{
			var evt:NetworkModelEvent = new NetworkModelEvent(NetworkModelEvent.OBJECT_ANNOUNCED);
			evt.metadata = event.metadata;
			dispatch(evt);
		}
		
		private function onClientAdded(event:ClientEvent):void
		{
			Debug.log("NetworkModel::onClientAdded, event.client.clientName: " + event.client.clientName);
			if(event.client.isLocal)
				return;
			
			var evt:NetworkModelEvent 		= new NetworkModelEvent(NetworkModelEvent.CLIENT_ADDED);
			evt.client 						= event.client;
			dispatch(evt);
		}

		private function onClientUpdate(event:ClientEvent):void
		{
			Debug.info("NetworkModel::onClientUpdate, clientName:  " + event.client.clientName);
			var evt:NetworkModelEvent 		= new NetworkModelEvent(NetworkModelEvent.CLIENT_UPDATED);
			evt.client 						= event.client;
			dispatch(evt);
		}
		
		private function onSharedObjectsChanged(event:Event):void
		{
			Debug.log("NetworkModel::onSharedObjectsChanged, len: " + localNetworkDiscovery.sharedObjects.length);
		}
		
		private function onClientsConnectedChanged(event:Event):void
		{
			Debug.log("NetworkModel::onClientsConnectedChanged");
			
			dispatch(new NetworkModelEvent(NetworkModelEvent.CLIENTS_CONNECTED_CHANGED));
		}
		
		private function onClientsChanged(evnet:Event):void
		{
			Debug.log("NetworkModel::onClientsChanged");
			dispatch(new NetworkModelEvent(NetworkModelEvent.CLIENTS_CHANGED));
		}
		
		private function onReceivedObjectsChanged(evnet:Event):void
		{
			Debug.info("NetworkModel::onReceivedObjectsChanged, len: " + localNetworkDiscovery.receivedObjects.length);
			dispatch(new NetworkModelEvent(NetworkModelEvent.RECEIVED_OBJECTS_CHANGED));
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
					var evt:SetCurrentSlideEvent = new SetCurrentSlideEvent(SetCurrentSlideEvent.HOST_UPDATED_CURRENT_SLIDE);
					evt.currentSlide = event.message.data.currentSlide;
					dispatch(evt);
				break;

				case "doYouNeedSlideshow":
				    networkModelEvent = new NetworkModelEvent(NetworkModelEvent.RECEIVED_REQUEST_SLIDESHOW_MESSAGE);
					networkModelEvent.message = event.message;
					dispatch(networkModelEvent);
				break;

				case "doYouNeedSlideshowAck":
					if(event.message.data.request == true)
					{
						networkModelEvent = new NetworkModelEvent(NetworkModelEvent.CLIENT_NEEDS_SLIDESHOW);
						networkModelEvent.message = event.message;
						dispatch(networkModelEvent);
					}
				break;


			}
		}
	}
}