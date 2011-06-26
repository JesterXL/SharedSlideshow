package com.jxl.shareslidesmobile.rl.mediators
{
	import com.jxl.shareslidesmobile.events.controller.SetNameEvent;
	import com.jxl.shareslidesmobile.events.model.TransferModelEvent;
	import com.jxl.shareslidesmobile.events.view.TransferSlideshowViewEvent;
	import com.jxl.shareslidesmobile.rl.models.TransferModel;
	import com.jxl.shareslidesmobile.views.transferviews.TransferSlideshowView;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class TransferSlideshowViewMediator extends Mediator
	{
		[Inject]
		public var view:TransferSlideshowView;
		
		[Inject]
		public var transferModel:TransferModel;
		
		public function TransferSlideshowViewMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(eventDispatcher, TransferModelEvent.CONNECTED, onConnectionChanged, TransferModelEvent);
			eventMap.mapListener(eventDispatcher, TransferModelEvent.DISCONNECTED, onConnectionChanged, TransferModelEvent);
			
			this.addViewListener(TransferSlideshowViewEvent.SUBMIT_NAME, onSubmitName, TransferSlideshowViewEvent);
			
			view.username = transferModel.localNetworkDiscovery.clientName;
			onConnectionChanged();
		}
		
		private function onConnectionChanged(event:TransferModelEvent=null):void
		{
			view.setConnected(transferModel.connected);
		}
		
		private function onSubmitName(event:TransferSlideshowViewEvent):void
		{
			var evt:SetNameEvent		= new SetNameEvent(SetNameEvent.SET_NAME);
			evt.name					= view.username;
			evt.transfer				= true;
			dispatch(evt);
		}
	}
}