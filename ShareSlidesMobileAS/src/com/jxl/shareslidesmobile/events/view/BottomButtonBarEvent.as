
package com.jxl.shareslidesmobile.events.view
{
import flash.events.Event;

public class BottomButtonBarEvent extends Event
	{
		public static const JOIN_SLIDESHOW:String 	= "joinSlideshow";
		public static const START_SLIDESHOW:String 	= "startSlideshow";
		public static const TRANSFER:String 		= "transfer";
		public static const CHANGE_LOG:String 		= "changeLog";
		public static const SUBMIT_BUG:String 		= "submitBug";

		public function BottomButtonBarEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true)
		{
			super(type,  bubbles, cancelable);
		}
	}
}
