package com.jxl.shareslides.rl.models
{
	import com.jxl.shareslides.events.model.*;
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	import com.projectcocoon.p2p.events.ClientEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.vo.ClientVO;

	import org.robotlegs.mvcs.Actor;
	
	public class TransferModel extends Actor
	{
		[Inject]
		public var localNetworkDiscovery:LocalNetworkDiscovery;
		
		private var _connected:Boolean = false;
		
		public function get connected():Boolean { return _connected; }
		public function set connected(value:Boolean):void
		{
			_connected = value;
			if(_connected)
			{
				dispatch(new TransferModelEvent(TransferModelEvent.CONNECTED));
			}
			else
			{
				dispatch(new TransferModelEvent(TransferModelEvent.DISCONNECTED));
			}
		}
		
		[PostConstruct]
		public function init():void
		{
			localNetworkDiscovery.groupName = "com.jxl.shareslides.transfer";
			localNetworkDiscovery.addEventListener(GroupEvent.GROUP_CONNECTED, onGroupConnected);
			localNetworkDiscovery.addEventListener(GroupEvent.GROUP_CLOSED, onGroupDisconnected);
			localNetworkDiscovery.addEventListener(MessageEvent.DATA_RECEIVED, onMessageReceived);
			localNetworkDiscovery.connect();
		}
		
		
		
		/*
		<ns:LocalNetworkDiscovery id="slideChannel"
		autoConnect="false"
		groupName="com.jxl.shareslides.transfer"
		groupConnected="currentState = 'main'"
		groupClosed="currentState = 'disconnected'"
		dataReceived="onMessage(event)"/>
			*/
		
		public function TransferModel()
		{
			super();
		}


		public function sendSlideshow(slideshow:SlideshowVO, client:ClientVO):void
		{
			localNetworkDiscovery.shareWithClient(slideshow, client.groupID, slideshow.name);
		}

		private function onMessageReceived(event:MessageEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		private function onGroupDisconnected(event:GroupEvent):void
		{
			connected = false;
		}
		
		private function onGroupConnected(event:GroupEvent):void
		{
			connected = true;
		}
		
	}
}