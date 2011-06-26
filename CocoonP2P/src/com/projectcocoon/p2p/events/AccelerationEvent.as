package com.projectcocoon.p2p.events
{
	import com.projectcocoon.p2p.vo.AccelerationVO;
	
	import flash.events.Event;
	
	public class AccelerationEvent extends Event
	{
		
		public static const ACCELEROMETER:String = "accelerometerUpdate";
		
		[Bindable] public var acceleration:AccelerationVO;
		
		public function AccelerationEvent(type:String, data:AccelerationVO=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			acceleration = data;
			super(type, bubbles, cancelable);
		}
		
	}
}