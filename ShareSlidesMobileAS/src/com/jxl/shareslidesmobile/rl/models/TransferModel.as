package com.jxl.shareslidesmobile.rl.models
{
	import com.jxl.shareslidesmobile.events.model.TransferModelEvent;
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.ObjectEvent;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Actor;
	
	public class TransferModel extends Actor
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
				dispatch(new TransferModelEvent(TransferModelEvent.CONNECTED));
			}
			else
			{
				dispatch(new TransferModelEvent(TransferModelEvent.DISCONNECTED));
			}
		}
		
		public function TransferModel()
		{
			super();
		}
		
		[PostConstruct]
		public function init():void
		{
			Debug.log("TransferModel::init");
			localNetworkDiscovery.loopback = false;
			localNetworkDiscovery.groupName = "com.jxl.shareslides.transfer";
			
			localNetworkDiscovery.addEventListener(ObjectEvent.OBJECT_ANNOUNCED, onObjectAnnounced);
			localNetworkDiscovery.addEventListener("receivedObjectsChange", onReceivedObjectsChanged);
			localNetworkDiscovery.addEventListener(GroupEvent.GROUP_CONNECTED, onGroupConnected);
			localNetworkDiscovery.addEventListener(GroupEvent.GROUP_CLOSED, onGroupClosed);
			
			localNetworkDiscovery.connect();
		}
		
		private function onGroupConnected(event:GroupEvent):void
		{
			connected = true;
		}
		
		private function onGroupClosed(event:GroupEvent):void
		{
			connected = false;
		}
		
		private function onObjectAnnounced(event:ObjectEvent):void
		{
			Debug.log("TransferModel::onObjectAnnounced");
			localNetworkDiscovery.requestObject(event.metadata);
		}
		
		private function onReceivedObjectsChanged(event:Event):void
		{
			Debug.log("TransferModel::onReceivedObjectsChanged");
			dispatch(new TransferModelEvent(TransferModelEvent.RECEIVED_OBJECTS_CHANGED));
		}
	}
}