package com.jxl.shareslides.rl.models
{
	import com.jxl.shareslides.events.controller.SetCurrentSlideEvent;
	import com.jxl.shareslides.events.model.NetworkModelEvent;
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	import com.projectcocoon.p2p.events.ClientEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.events.ObjectEvent;
	import com.projectcocoon.p2p.vo.ClientVO;
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;

	import flash.events.Event;
	
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
				dispatch(new NetworkModelEvent(NetworkModelEvent.CONNECTED));
			}
			else
			{
				dispatch(new NetworkModelEvent(NetworkModelEvent.DISCONNECTED));
			}
		}
		
		public function NetworkModel()
		{
			super();
		}
		
		[PostConstruct]
		public function init():void
		{
			localNetworkDiscovery.clientName = "Slideshow Player";
			localNetworkDiscovery.groupName = "com.jxl.shareslides";
			localNetworkDiscovery.addEventListener(GroupEvent.GROUP_CONNECTED, onConnected);
			localNetworkDiscovery.addEventListener(GroupEvent.GROUP_CLOSED, onClosed);
			localNetworkDiscovery.addEventListener(MessageEvent.DATA_RECEIVED, onMessage);
			localNetworkDiscovery.addEventListener(ObjectEvent.OBJECT_ANNOUNCED, onObjectAnnounced);	
			//localNetworkDiscovery.addEventListener("clientsChange", onClientsChanged);
			localNetworkDiscovery.addEventListener(ClientEvent.CLIENT_ADDED, onClientAdded);
			localNetworkDiscovery.addEventListener(ClientEvent.CLIENT_UPDATE, onClientUpdated);
			localNetworkDiscovery.addEventListener("receivedObjectsChange", onReceivedObjectsChange);
			localNetworkDiscovery.addEventListener("sharedObjectsChange", onSharedObjectsChange);
			localNetworkDiscovery.connect();
		}

		public function shareSlideshow(slideshow:SlideshowVO):void
		{
			localNetworkDiscovery.shareWithAll(slideshow, slideshow.name);
		}
		
		private function onConnected(event:GroupEvent):void
		{
			connected = true;
		}
		
		private function onClosed(event:GroupEvent):void
		{
			connected = false;
		}
		
		private function onMessage(event:MessageEvent):void
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
		
		private function onObjectAnnounced(event:ObjectEvent):void
		{
			localNetworkDiscovery.requestObject(event.metadata);
		}
		
		private function onClientAdded(event:ClientEvent):void
		{
			Debug.log("NetworkModel::onClientAdded");
			if(event.client.isLocal)
				return;

			Debug.log("\tnot local, dispatching client added event");
			var evt:NetworkModelEvent 		= new NetworkModelEvent(NetworkModelEvent.CLIENT_ADDED);
			evt.client 						= event.client;
			dispatch(evt);
		}

		private function onClientUpdated(event:ClientEvent):void
		{
			Debug.log("NetworkModel::onClientUpdated");
			if(event.client.isLocal)
				return;

			Debug.log("\tnot local, dispatching client added event");
			var evt:NetworkModelEvent 		= new NetworkModelEvent(NetworkModelEvent.CLIENT_UPDATE);
			evt.client 						= event.client;
			dispatch(evt);
		}
		
		private function onReceivedObjectsChange(event:Event):void
		{
			dispatch(new NetworkModelEvent(NetworkModelEvent.RECEIVED_OBJECTS_CHANGE));
		}

		private function onSharedObjectsChange(event:Event):void
		{
			dispatch(new NetworkModelEvent(NetworkModelEvent.SHARED_OBJECTS_CHANGE));
		}

		public function containsSlideshow(slideshowName:String):Boolean
		{
			if(localNetworkDiscovery.receivedObjects == null && localNetworkDiscovery.sharedObjects == null)
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

			len = localNetworkDiscovery.sharedObjects.length;
			while(len--)
			{
				var om:ObjectMetadataVO = localNetworkDiscovery.sharedObjects.getItemAt(len) as ObjectMetadataVO;
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

	}
}