package com.jxl.shareslidesmobile.events.view
{
	import flash.events.Event;
	
	public class TransferSlideshowViewEvent extends Event
	{
		
		public static const SUBMIT_NAME:String = "submitName";
		
		public function TransferSlideshowViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new TransferredSlideshowItemEvent(type, bubbles, cancelable);
		}
	}
}