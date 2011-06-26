package com.jxl.shareslidesmobile.events.view
{
	import flash.events.Event;
	
	public class SlideshowViewEvent extends Event
	{
		
		public static const NEXT_IMAGE:String 			= "nextImage";
		public static const PREVIOUS_IMAGE:String 		= "previousImage";
		public static const SYNC_CHANGE:String 			= "syncChange";
		
		public function SlideshowViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}