package com.jxl.shareslides.events.view
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	public class SlideItemRendererEvent extends Event
	{
		
		public static const REMOVE_FILE:String = "removeFile";
		
		public var file:File;
		
		public function SlideItemRendererEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}