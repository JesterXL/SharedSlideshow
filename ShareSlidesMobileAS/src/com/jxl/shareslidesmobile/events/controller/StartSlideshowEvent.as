package com.jxl.shareslidesmobile.events.controller
{
	import com.jxl.shareslides.vo.SlideshowVO;

	import flash.events.Event;
	
	public class StartSlideshowEvent extends Event
	{
		public static const START_SLIDESHOW:String 			= "startSlideshow";
		
		public var name:String;
		public var slides:Array;
		public var slideshow:SlideshowVO;
		
		public function StartSlideshowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}