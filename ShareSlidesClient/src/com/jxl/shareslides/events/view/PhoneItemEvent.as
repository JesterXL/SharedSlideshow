package com.jxl.shareslides.events.view
{
	import com.projectcocoon.p2p.vo.ClientVO;
	
	import flash.events.Event;
	
	public class PhoneItemEvent extends Event
	{
		public static const PING:String = "ping";
		public static const SEND_SLIDES:String = "sendSlides";
		
		public var client:ClientVO;
		
		public function PhoneItemEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}