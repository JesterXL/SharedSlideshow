package com.jxl.shareslidesmobile.events.services
{

	import flash.events.Event;

	public class SaveSlideshowServiceEvent extends Event
	{

		public static const SLIDESSHOW_SAVED:String = "slideshowSaved";

		public function SaveSlideshowServiceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
		}
	}
}

