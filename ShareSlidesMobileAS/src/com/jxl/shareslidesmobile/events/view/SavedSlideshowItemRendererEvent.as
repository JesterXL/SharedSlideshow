package com.jxl.shareslidesmobile.events.view
{

	import com.jxl.shareslides.vo.SlideshowVO;

	import flash.events.Event;

	public class SavedSlideshowItemRendererEvent extends Event
	{

		public static const JOIN_SLIDESHOW:String = "joinSlideshow";
		public static const DELETE_SLIDESHOW:String = "deleteSlideshow";

		public var slideshow:SlideshowVO;

		public function SavedSlideshowItemRendererEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
		}
	}
}

