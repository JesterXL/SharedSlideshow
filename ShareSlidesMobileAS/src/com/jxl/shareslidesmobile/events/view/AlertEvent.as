package com.jxl.shareslidesmobile.events.view
{

	import flash.events.Event;

	public class AlertEvent extends Event
	{

		public static const YES:uint 			= 0x0001;
	    public static const NO:uint 			= 0x0002;
	    public static const OK:uint 			= 0x0004;
	    public static const CANCEL:uint			= 0x0008;

		public static const ALERT_CLOSED:String = "alertClosed";

		public var detail:uint;

		public function AlertEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
		}
	}
}

