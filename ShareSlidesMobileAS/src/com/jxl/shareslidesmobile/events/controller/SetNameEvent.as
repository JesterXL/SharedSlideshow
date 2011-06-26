package com.jxl.shareslidesmobile.events.controller
{
	import flash.events.Event;
	
	public class SetNameEvent extends Event
	{
		public static const SET_NAME:String = "setName";
		public static const NAME_CHANGED:String = "nameChanged";
		
		public var name:String;
		public var transfer:Boolean = false;
		
		public function SetNameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}