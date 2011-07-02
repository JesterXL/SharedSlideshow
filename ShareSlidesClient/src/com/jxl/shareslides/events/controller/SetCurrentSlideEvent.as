package com.jxl.shareslides.events.controller
{

	import flash.events.Event;

	public class SetCurrentSlideEvent extends Event
	{

		public static const HOST_UPDATED_CURRENT_SLIDE:String = "hostUpdatedCurrentSlide";


		public var currentSlide:int;

		public function SetCurrentSlideEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
		}
	}
}

