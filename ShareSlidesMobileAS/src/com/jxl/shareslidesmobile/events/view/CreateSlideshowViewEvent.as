package com.jxl.shareslidesmobile.events.view
{
	import flash.events.Event;
	
	public class CreateSlideshowViewEvent extends Event
	{
		public static const CREATE_SLIDESHOW:String = "createSlideshow";
		public static const CANCEL:String 			= "cancel";
		
		public var name:String;
		public var files:Array;
		
		public function CreateSlideshowViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}