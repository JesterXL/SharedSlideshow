package com.jxl.shareslides.events.model
{
	import com.projectcocoon.p2p.vo.ClientVO;
	import com.projectcocoon.p2p.vo.MessageVO;
	
	import flash.events.Event;
	
	public class NetworkModelEvent extends Event
	{
		
		public static const CONNECTED:String 								= "connected";
		public static const DISCONNECTED:String 							= "disconnected";
		public static const CLIENTS_CHANGE:String 							= "clientsChange";
		public static const RECEIVED_OBJECTS_CHANGE:String 					= "receivedObjectsChange";

		public static const CLIENT_ADDED:String 							= "clientAdded";
		public static const CLIENT_UPDATE:String 							= "clientUpdate";
		public static const RECEIVED_REQUEST_SLIDESHOW_MESSAGE:String 		= "receivedRequestSlideshowMessage";
		public static const CLIENT_NEEDS_SLIDESHOW:String 					= "clientNeedsSldeshow";
		
		
		public var message:MessageVO;
		public var client:ClientVO;
		
		public function NetworkModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}