package com.jxl.sharedslides.rl.models
{
	import com.jxl.sharedslides.events.model.NetworkModelEvent;
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	import com.projectcocoon.p2p.events.ClientEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.events.ObjectEvent;
	
	import flash.events.Event;
	
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
		
		[Bindable(event="clientsChange")]
		public function get clients():ArrayCollection { return localNetworkDiscovery.clients; }
		
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
			//localNetworkDiscovery.addEventListener(GroupEvent.GROUP_CONNECTED, onGroupConnected);
			localNetworkDiscovery.addEventListener("groupConnected", onGroupConnected);
			localNetworkDiscovery.addEventListener(GroupEvent.GROUP_CLOSED, onGroupClosed);
			
			//localNetworkDiscovery.addEventListener(ObjectEvent.OBJECT_ANNOUNCED, onObjectAnnounced);
			
			//localNetworkDiscovery.addEventListener("sharedObjectsChange", onSharedObjectsChanged);
			//localNetworkDiscovery.addEventListener("receivedObjectsChange", onReceivedObjectsChanged);
			//localNetworkDiscovery.addEventListener("clientsConnectedChange", onClientsConnectedChanged);
			//localNetworkDiscovery.addEventListener("clientsChange", onClientsChanged);
			
			localNetworkDiscovery.addEventListener(ClientEvent.CLIENT_ADDED, onClientAdded);
			localNetworkDiscovery.addEventListener(ClientEvent.CLIENT_UPDATE, onClientUpdate);
			localNetworkDiscovery.addEventListener(ClientEvent.CLIENT_REMOVED, onClientRemoved);
			
			//localNetworkDiscovery.addEventListener(MessageEvent.DATA_RECEIVED, onMessageEvent);
			
			if(localNetworkDiscovery.clientName == "" || localNetworkDiscovery.clientName == null)
				localNetworkDiscovery.clientName = "Default User";
			
			trace("NetworkModel::connect");
			localNetworkDiscovery.connect();
		}
		
		public function changeName(name:String):void
		{
			if(localNetworkDiscovery.clientName != name)
				localNetworkDiscovery.clientName = name;
		}
		
		
		
		private function onGroupConnected(event:GroupEvent):void
		{
			Debug.info("NetworkModel::onGroupConnected");
			connected = true;
			Debug.info("localNetworkDiscovery.clientName: " + localNetworkDiscovery.clientName);
			
		}
		
		private function onGroupClosed(event:GroupEvent):void
		{
			Debug.error("NetworkModel::onGroupClosed");
			connected = false;
		}
		
		private function onClientAdded(event:ClientEvent):void
		{
			Debug.log("NetworkModel::onClientAdded, event.client.clientName: " + event.client.clientName);
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