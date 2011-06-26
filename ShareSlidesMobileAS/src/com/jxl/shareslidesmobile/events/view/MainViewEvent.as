package com.jxl.shareslidesmobile.events.view
{
	import flash.events.Event;
	
	public class MainViewEvent extends Event
	{
		public static const CREATE_SLIDESHOW:String = "createSlideshow";
		
		public function MainViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}