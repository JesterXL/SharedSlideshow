package com.jxl.shareslidesmobile.events.model
{

	import flash.events.Event;

	public class SavedSlideshowModelEvent extends Event
	{

		public static const SLIDESHOWS_CHANGED:String = "slideshowsChanged";

		public function SavedSlideshowModelEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
		}
	}
}

