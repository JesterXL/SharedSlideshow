package com.jxl.shareslides.events.view
{

	import com.jxl.shareslides.views.MainView;
	import com.jxl.shareslides.vo.SlideshowVO;

	import flash.events.Event;

	public class MainViewEvent extends Event
	{

		public static const JOIN_SLIDESHOW:String = "joinSlideshow";

		public var slideshow:SlideshowVO;

		public function MainViewEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
		}

		public override function clone():Event
		{
			var evt:MainViewEvent = new MainViewEvent(type,  bubbles, cancelable);
			evt.slideshow = slideshow;
			return evt;
		}
	}
}

