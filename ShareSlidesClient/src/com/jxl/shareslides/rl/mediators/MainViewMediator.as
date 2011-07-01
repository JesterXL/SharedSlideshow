package com.jxl.shareslides.rl.mediators
{
	import com.jxl.shareslides.events.controller.NavigationEvent;
	import com.jxl.shareslides.events.model.NetworkModelEvent;
	import com.jxl.shareslides.rl.models.NetworkModel;
	import com.jxl.shareslides.views.MainView;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MainViewMediator extends Mediator
	{
		[Inject]
		public var mainView:MainView;
		
		[Inject]
		public var networkModel:NetworkModel;
		
		
		public function MainViewMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			super.onRegister();
			
			addContextListener(NetworkModelEvent.CONNECTED, onConnected, NetworkModelEvent);
			addContextListener(NetworkModelEvent.DISCONNECTED, onDisconnected, NetworkModelEvent);
			addContextListener(NavigationEvent.NAVIGATION_CHANGE, onNavChange, NavigationEvent);
			addContextListener(NetworkModelEvent.CLIENTS_CHANGE, onClientsChange, NetworkModelEvent);
			addContextListener(NetworkModelEvent.RECEIVED_OBJECTS_CHANGE, onReceivedObjectsChange, NetworkModelEvent);
			addContextListener(StartSlideshowViewEvent.START_SLIDESHOW, onStartSlideshow, StartSlideshowViewEvent);
			
			mainView.setConnected(networkModel.connected);
			
			onClientsChange();
			onReceivedObjectsChange();
		}
		
		private function onConnected(event:NetworkModelEvent):void
		{
			mainView.setConnected(true);
		}
		
		private function onDisconnected(event:NetworkModelEvent):void
		{
			mainView.setConnected(false);
		}
		
		private function onNavChange(event:NavigationEvent):void
		{
			mainView.gotoSection(event.location);
		}
		
		private function onClientsChange(event:NetworkModelEvent=null):void
		{
			mainView.clients = networkModel.localNetworkDiscovery.clients;
		}
		
		private function onReceivedObjectsChange(event:NetworkModelEvent=null):void
		{
			mainView.slideshows = networkModel.localNetworkDiscovery.receivedObjects;
		}
			
	}
}