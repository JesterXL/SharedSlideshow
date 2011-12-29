package com.jxl.sharedslides.events.model
{
	import com.projectcocoon.p2p.vo.ClientVO;
	import com.projectcocoon.p2p.vo.MessageVO;
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;
	
	import flash.events.Event;
	
	public class NetworkModelEvent extends Event
	{
		public static const GROUP_CONNECTED:String = "groupConnected";
		public static const GROUP_DISCONNECTED:String = "groupDisconnected";
		public static const HOST_CURRENT_SLIDE_INDEX_CHANGED:String = "hostCurrentSlideIndexChanged";
		
		/*
		public static const CLIENTS_CONNECTED_CHANGED:String = "clientsConnectedChanged";
		public static const CLIENTS_CHANGED:String = "clientsChanged";
		public static const RECEIVED_OBJECTS_CHANGED:String = "receivedObjectsChanged";
		public static const CLIENT_ADDED:String = "clientAdded";
		public static const CLIENT_UPDATED:String = "clientUpdated";
		public static const RECEIVED_REQUEST_SLIDESHOW_MESSAGE:String = "receivedRequestSlideshowMessage";
		public static const CLIENT_NEEDS_SLIDESHOW:String = "clientNeedsSlideshow";
		public static const OBJECT_ANNOUNCED:String = "objectAnnounced";
		
		public var client:ClientVO;
		public var message:MessageVO;
		public var metadata:ObjectMetadataVO;
		*/
		
		public function NetworkModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}