package com.jxl.shareslidesmobile.events.view
{

	import com.jxl.shareslides.vo.SlideshowVO;

	import flash.events.Event;

	public class StartSlideshowViewEvent extends Event
	{
		public static const DELETE_SLIDESHOW:String = "deleteSlideshow";

		public var slideshow:SlideshowVO;

		public function StartSlideshowViewEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
		}

		public override function clone():Event
		{
			var evt:StartSlideshowViewEvent = new StartSlideshowViewEvent(type,  bubbles, cancelable);
			evt.slideshow = slideshow;
			return evt;
		}
	}
}

