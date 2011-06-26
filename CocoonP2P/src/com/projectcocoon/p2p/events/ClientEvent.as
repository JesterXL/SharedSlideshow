package com.projectcocoon.p2p.events
{
	import com.projectcocoon.p2p.vo.ClientVO;
	
	import flash.events.Event;
	import flash.net.NetGroup;
	
	public class ClientEvent extends Event
	{
		
		public static const CLIENT_ADDED:String = "clientAdded";
		public static const CLIENT_UPDATE:String = "clientUpdate";
		public static const CLIENT_REMOVED:String = "clientRemoved";
		
		[Bindable] public var client:ClientVO;
		public var group:NetGroup;
		
		public function ClientEvent(type:String, client:ClientVO=null, group:NetGroup=null)
		{
			super(type);
			this.client = client;
			this.group = group;
		}
		
		public override function clone():Event
		{
			return new ClientEvent(type, client, group);
		}
	}
}