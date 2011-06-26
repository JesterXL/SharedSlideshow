package com.projectcocoon.p2p.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.osflash.signals.Signal;

	public class ObjectMetadataVO
	{
		public var identifier:String;
		public var size:uint;
		public var chunks:uint;
		public var info:Object;
		
		[Transient]
		public var chunksReceived:int;
		
		[Transient]
		public var object:Object;
		
		[Transient]
		public var progressSignal:Signal = new Signal();
		
		[Transient]
		public var completedSignal:Signal = new Signal();
		
		public function ObjectMetadataVO()
		{
			chunksReceived = 0;
		}
		
		public function get progress():Number
		{
			if (chunks > 0)
				return chunksReceived / chunks;
			return 0;
		}
		
		public function get isComplete():Boolean
		{
			return progress == 1;
		}
	}
}