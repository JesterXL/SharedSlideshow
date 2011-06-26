package com.jxl.shareslidesmobile.events.view
{
	import flash.events.Event;
	import flash.filesystem.File;

	public class SlideEditItemRendererEvent extends Event
	{
		public static const DELETE_SLIDE:String = "deleteSlide";

		public var file:File;

		public function SlideEditItemRendererEvent(type:String, file:File)
		{
			super(type, true);
			this.file = file;
		}

		public override function clone():Event
		{
			return new SlideEditItemRendererEvent(type, file);
		}
	}
}
