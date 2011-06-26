package com.jxl.shareslidesmobile.events.controller
{
	import com.jxl.shareslides.vo.SlideshowVO;
	
	import flash.events.Event;
	
	public class JoinSlideshowEvent extends Event
	{
		
		public static const JOIN_SLIDESHOW:String = "joinSlideshow";
		public static const SLIDESHOW_SUCCESSFULLY_JOINED:String = "slideshowSuccessfullyJoined";
		
		public var slideshow:SlideshowVO;
		
		public function JoinSlideshowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}