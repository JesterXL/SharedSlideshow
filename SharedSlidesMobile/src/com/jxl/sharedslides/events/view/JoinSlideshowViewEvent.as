package com.jxl.sharedslides.events.view
{
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;
	
	import flash.events.Event;
	
	public class JoinSlideshowViewEvent extends Event
	{
		public static const CHANGE_NAME:String = "changeName";
		
		public var name:String;
		
		public function JoinSlideshowViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}