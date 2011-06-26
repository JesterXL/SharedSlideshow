package com.jxl.shareslides.rl.models
{
	import com.jxl.shareslides.events.model.NetworkModelEvent;
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	import com.projectcocoon.p2p.events.ClientEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.events.ObjectEvent;
	
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
			//localNetworkDiscovery.addEventListener(ClientEvent.CLIENT_ADDED, onClientsChanged);
			localNetworkDiscovery.addEventListener("receivedObjectsChange", onReceivedObjectsChange);
			localNetworkDiscovery.connect();
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
			var evt:NetworkModelEvent 	= new NetworkModelEvent(NetworkModelEvent.MESSAGE);
			evt.message 				= event.message;
			dispatch(evt);
		}
		
		private function onObjectAnnounced(event:ObjectEvent):void
		{
			localNetworkDiscovery.requestObject(event.metadata);
		}
		
		private function onClientsChanged(event:Event):void
		{
			dispatch(new NetworkModelEvent(NetworkModelEvent.CLIENTS_CHANGE));
		}
		
		private function onReceivedObjectsChange(event:Event):void
		{
			dispatch(new NetworkModelEvent(NetworkModelEvent.RECEIVED_OBJECTS_CHANGE));
		}
	}
}