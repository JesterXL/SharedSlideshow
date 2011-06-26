package com.jxl.shareslidesmobile.events.view
{

	import flash.events.Event;

	public class NewSlideshowViewEvent extends Event
	{

		public static const CREATE_SLIDESHOW:String = "createSlideshow";
		public static const CANCEL_CREATE_SLIDESHOW:String = "cancelCreateSlideshow";

		public var name:String;
		public var files:Array;


		public function NewSlideshowViewEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
		}

		public override function clone():Event
		{
			var event:NewSlideshowViewEvent = new NewSlideshowViewEvent(type, bubbles, cancelable);
			event.name = name;
			event.files = files;
			return event;
		}
	}
}

