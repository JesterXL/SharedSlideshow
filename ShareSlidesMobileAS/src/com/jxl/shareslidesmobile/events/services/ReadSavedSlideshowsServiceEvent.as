package com.jxl.shareslidesmobile.events.services
{

	import flash.events.Event;

	public class ReadSavedSlideshowsServiceEvent extends Event
	{

		public static const READ_SAVED_SLIDESHOWS_COMPLETE:String = "readSavedSlideshowsComplete";

		public var slideshows:Array;

		public function ReadSavedSlideshowsServiceEvent(type:String, slideshows:Array):void
		{
			super(type);

			this.slideshows = slideshows;
		}

	}
}

