package com.projectcocoon.p2p.vo
{
	
	[Bindable]
	public class MessageVO
	{

		private static var SEQ:uint = 0;
		
		public var client:ClientVO;
		public var data:Object;
		public var destination:String;
		public var type:String;
		public var command:String;
		public var sequenceId:uint;
		public var timestamp:Date;
		
		public function MessageVO(_client:ClientVO=null, _data:Object=null, _destination:String="", _type:String="", _command:String="")
		{
			client = _client;
			data = _data;
			destination = _destination;
			type = _type;
			command = _command;
			timestamp = new Date();
			sequenceId = ++SEQ;
		}
		
		public function get isDirectMessage():Boolean
		{
			return (destination && destination != "") 
		}
		
		public function toString():String
		{
			return "MessageVO{client: " + client + ", data: " + data + ", destination: \"" + destination + "\", type: \"" + type + "\", command: \"" + command + "\", sequenceId: " + sequenceId + ", timestamp: " + timestamp + "}";
		}

	}
	
}