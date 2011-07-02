package com.jxl.shareslidesmobile.events.view
{

	import flash.events.Event;

	public class ConfirmPasscodeViewEvent extends Event
	{

		public static const SUBMIT_PASSCODE:String = "submitPasscode";

		public var passcode:String;

		public function ConfirmPasscodeViewEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
		}
	}
}

