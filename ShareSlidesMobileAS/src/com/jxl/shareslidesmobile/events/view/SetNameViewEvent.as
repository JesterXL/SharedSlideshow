package com.jxl.shareslidesmobile.events.view
{
	import flash.events.Event;
	
	public class SetNameViewEvent extends Event
	{
		public static const SET_NAME:String = "setName";
		
		public var name:String;
		
		public function SetNameViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}