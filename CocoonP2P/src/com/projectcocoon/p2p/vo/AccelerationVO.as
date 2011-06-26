package com.projectcocoon.p2p.vo
{
	
	[Bindable]
	public class AccelerationVO
	{
		
		public var client:ClientVO;
		public var accelerationX:Number;
		public var accelerationY:Number;
		public var accelerationZ:Number;
		public var timestamp:Number;
		
		public function AccelerationVO(_client:ClientVO, _accelerationX:Number, _accelerationY:Number, _accelerationZ:Number, _timestamp:Number)
		{
			client = _client;
			accelerationX = _accelerationX;
			accelerationY = _accelerationY;
			accelerationZ = _accelerationZ;
			timestamp = _timestamp;
		}
		
	}
}