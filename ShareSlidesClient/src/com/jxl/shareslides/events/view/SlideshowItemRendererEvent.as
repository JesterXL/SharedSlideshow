package com.jxl.shareslides.events.view
{
	import com.jxl.shareslides.vo.SlideshowVO;
	
	import flash.events.Event;
	
	public class SlideshowItemRendererEvent extends Event
	{
		
		public static const JOIN_SLIDESHOW:String = "joinSlideshow";
		
		public var slideshow:SlideshowVO;
		
		public function SlideshowItemRendererEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}