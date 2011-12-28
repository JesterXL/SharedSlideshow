package com.jxl.sharedslides.events.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class BrowseForSlidesViewEvent extends Event
	{
		public static const CREATE_SLIDESHOW:String = "createSlideshow";
		
		public var name:String;
		public var passcode:String;
		public var slides:ArrayCollection;
		
		public function BrowseForSlidesViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}