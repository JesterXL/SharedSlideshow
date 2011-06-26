package com.jxl.shareslidesmobile.events.view
{
	import com.jxl.shareslides.vo.SlideshowVO;
	
	import flash.events.Event;
	
	public class TransferredSlideshowItemEvent extends Event
	{
		
		public static const HOST:String = "host";
		
		public var slideshow:SlideshowVO;
		
		public function TransferredSlideshowItemEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}