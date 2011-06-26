package com.jxl.shareslidesmobile.events.controller
{
	import com.jxl.shareslides.vo.SlideshowVO;
	
	import flash.events.Event;
	
	public class DeleteSlideshowEvent extends Event
	{
		
		public static const DELETE_SLIDESHOW:String = "deleteSlideshow";
		
		public var slideshow:SlideshowVO;
		
		public function DeleteSlideshowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}