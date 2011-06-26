package com.jxl.shareslides.events.controller
{
	import flash.events.Event;
	
	public class NavigationEvent extends Event
	{
		public static const NAVIGATION_CHANGE:String = "navigationChange";
		
		public var location:String;
		
		public function NavigationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}