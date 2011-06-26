package com.jxl.shareslides.events.model
{
	import com.projectcocoon.p2p.vo.MessageVO;
	
	import flash.events.Event;
	
	public class NetworkModelEvent extends Event
	{
		
		public static const CONNECTED:String 					= "connected";
		public static const DISCONNECTED:String 				= "disconnected";
		public static const MESSAGE:String 						= "message";
		public static const CLIENTS_CHANGE:String 				= "clientsChange";
		public static const RECEIVED_OBJECTS_CHANGE:String 		= "receivedObjectsChange";
		
		
		public var message:MessageVO;
		
		public function NetworkModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}