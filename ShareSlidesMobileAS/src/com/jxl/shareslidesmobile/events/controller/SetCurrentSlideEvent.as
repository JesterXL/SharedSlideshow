package com.jxl.shareslidesmobile.events.controller
{
	import flash.events.Event;
	
	public class SetCurrentSlideEvent extends Event
	{
		
		public static const SET_CURRENT_SLIDE_EVENT:String 		= "setCurrentSlideEvent";
		public static const HOST_UPDATED_CURRENT_SLIDE:String 	= "hostUpdatedCurrentSlide";
		
		public var currentSlide:int;
		
		public function SetCurrentSlideEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}