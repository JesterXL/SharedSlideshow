
package com.jxl.shareslides.events.view
{
	import com.jxl.shareslides.events.view.CreateSlideshowViewEvent;

	import flash.events.Event;

	public class CreateSlideshowViewEvent extends Event
	{

		public static const SAVE_SLIDESHOW:String = "saveSlideshow";

		public var slideshowName:String;
		public var slides:Array;
		public var passcode:String;

		public function CreateSlideshowViewEvent(type:String,  bubbles:Boolean = false, cancelable:Boolean = true)
		{
			super(type,  bubbles,  cancelable);
		}

		public override function clone():Event
		{
			var evt:CreateSlideshowViewEvent = new CreateSlideshowViewEvent(type,  bubbles, cancelable);
			evt.slides = slides;
			evt.slideshowName = slideshowName;
			evt.passcode = passcode;
			return evt;
		}


	}
}
