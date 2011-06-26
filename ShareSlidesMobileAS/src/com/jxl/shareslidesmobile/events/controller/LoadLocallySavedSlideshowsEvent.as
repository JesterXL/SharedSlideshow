package com.jxl.shareslidesmobile.events.controller
{

	import flash.events.Event;

	public class LoadLocallySavedSlideshowsEvent extends Event
	{

		public static const LOAD:String = "load";



		public function LoadLocallySavedSlideshowsEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
		}
	}
}

