package com.projectcocoon.p2p.vo
{
	
	[Bindable]
	public class ClientVO
	{
		
		public var clientName:String;
		public var peerID:String;
		public var groupID:String;
		
		[Transient]
		public var isLocal:Boolean;
		
		public function ClientVO(_clientName:String = null, _peerID:String = null, _groupID:String = null)
		{
			clientName = _clientName;
			peerID = _peerID;
			groupID = _groupID;
		}
		
	}
}