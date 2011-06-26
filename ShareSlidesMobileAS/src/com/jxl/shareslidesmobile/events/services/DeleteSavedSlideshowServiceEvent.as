package com.jxl.shareslidesmobile.events.services
{

	import flash.events.Event;

	public class DeleteSavedSlideshowServiceEvent extends Event
	{
		public static const SLIDESHOW_FILE_DELETED:String = "slideshowFileDeleted";

		public function DeleteSavedSlideshowServiceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
		}
	}
}

