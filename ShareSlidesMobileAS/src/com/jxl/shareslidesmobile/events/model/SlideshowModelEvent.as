package com.jxl.shareslidesmobile.events.model
{
	import flash.events.Event;
	
	public class SlideshowModelEvent extends Event
	{
		
		public static const SLIDESHOW_CHANGED:String 		= "slideshowChanged";
		public static const CURRENT_SLIDE_CHANGED:String 	= "currentSlideChanged";
		
		public function SlideshowModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}