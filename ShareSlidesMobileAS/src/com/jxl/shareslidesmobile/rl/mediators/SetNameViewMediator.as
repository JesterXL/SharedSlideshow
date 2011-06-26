package com.jxl.shareslidesmobile.rl.mediators
{
	import com.jxl.shareslidesmobile.events.controller.SetNameEvent;
	import com.jxl.shareslidesmobile.events.model.NetworkModelEvent;
	import com.jxl.shareslidesmobile.events.view.SetNameViewEvent;
	import com.jxl.shareslidesmobile.rl.models.NetworkModel;
	import com.jxl.shareslidesmobile.views.mainviews.joinviewclasses.SetNameView;
	import com.projectcocoon.p2p.events.GroupEvent;

	import flash.events.Event;

	import org.robotlegs.mvcs.Mediator;
	
	public class SetNameViewMediator extends Mediator
	{
		
		[Inject]
		public var view:SetNameView;

		[Inject]
		public var networkModel:NetworkModel;

		public function SetNameViewMediator()
		{
			super();
		}

		
		public override function onRegister():void
		{
			super.onRegister();

			addContextListener(NetworkModelEvent.CLIENT_UPDATED, onClientUpdated, NetworkModelEvent);
			addContextListener(SetNameEvent.NAME_CHANGED, onClientUpdated, SetNameEvent);
			addViewListener(SetNameViewEvent.SET_NAME, onSetName, SetNameViewEvent);

			onClientUpdated();
		}

		private function onClientUpdated(event:Event=null):void
		{
			view.clientName = networkModel.localNetworkDiscovery.clientName;
		}
		
		private function onSetName(event:SetNameViewEvent):void
		{
			var evt:SetNameEvent		= new SetNameEvent(SetNameEvent.SET_NAME);
			evt.name					= event.name;
			dispatch(evt);
		}
	}
}