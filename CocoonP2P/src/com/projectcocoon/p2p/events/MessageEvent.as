package com.projectcocoon.p2p.events
{
	import com.projectcocoon.p2p.vo.ClientVO;
	import com.projectcocoon.p2p.vo.MessageVO;
	
	import flash.events.Event;
	import flash.net.NetGroup;
	
	public class MessageEvent extends Event
	{
		
		public static const DATA_RECEIVED:String = "dataReceived";
		
		[Bindable] public var message:MessageVO;
		public var group:NetGroup;
		
		public function MessageEvent(type:String, message:MessageVO=null, group:NetGroup = null)
		{
			super(type);
			this.message = message;
			this.group = group;
		}
		
		public override function clone():Event
		{
			return new MessageEvent(type, message, group);
		}

		
	}
}