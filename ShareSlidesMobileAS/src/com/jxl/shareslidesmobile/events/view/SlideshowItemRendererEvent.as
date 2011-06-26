package com.jxl.shareslidesmobile.events.view
{
	import com.jxl.shareslides.vo.SlideshowVO;
	
	import flash.events.Event;
	
	public class SlideshowItemRendererEvent extends Event
	{
		
		public static const JOIN:String 			= "join";
		public static const DELETE_SLIDESHOW:String = "deleteSlideshow";
		
		public var slideshow:SlideshowVO;
		
		public function SlideshowItemRendererEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}