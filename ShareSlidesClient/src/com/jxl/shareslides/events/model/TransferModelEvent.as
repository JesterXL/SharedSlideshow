package com.jxl.shareslides.events.model
{
	import flash.events.Event;
	
	public class TransferModelEvent extends Event
	{
		public static const CONNECTED:String 				= "connected";
		public static const DISCONNECTED:String 			= "disconnected";
		
		public function TransferModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}