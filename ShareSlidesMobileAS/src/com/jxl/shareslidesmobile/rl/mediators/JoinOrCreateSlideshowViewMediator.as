package com.jxl.shareslidesmobile.rl.mediators
{
	import com.jxl.shareslidesmobile.events.controller.DeleteSlideshowEvent;
	import com.jxl.shareslidesmobile.events.controller.JoinSlideshowEvent;
	import com.jxl.shareslidesmobile.events.model.NetworkModelEvent;
	import com.jxl.shareslidesmobile.events.model.SlideshowModelEvent;
	import com.jxl.shareslidesmobile.events.view.SlideshowItemRendererEvent;
	import com.jxl.shareslidesmobile.rl.models.NetworkModel;
	import com.jxl.shareslidesmobile.rl.models.SlideshowModel;
	import com.jxl.shareslidesmobile.views.JoinOrCreateSlideshowView;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class JoinOrCreateSlideshowViewMediator extends Mediator
	{
		
		[Inject]
		public var view:JoinOrCreateSlideshowView;
		
		[Inject]
		public var slideshowModel:SlideshowModel;
		
		[Inject]
		public var networkModel:NetworkModel;
		
		public function JoinOrCreateSlideshowViewMediator()
		{
			super();
		}
		
		[PostInstruct]
		public function init():void
		{
			eventMap.mapListener(eventDispatcher, SlideshowModelEvent.SLIDESHOWS_CHANGED, onSlideshowsChanged, SlideshowModelEvent);
			
			eventMap.mapListener(eventDispatcher, NetworkModelEvent.CLIENTS_CHANGED, onClientsChanged);
			eventMap.mapListener(eventDispatcher, NetworkModelEvent.RECEIVED_OBJECTS_CHANGED, onReceivedObjectsChanged);
		}
		
		public override function onRegister():void
		{
			super.onRegister();
			
			this.addViewListener(SlideshowItemRendererEvent.JOIN, onJoin, SlideshowItemRendererEvent);
			this.addViewListener(SlideshowItemRendererEvent.DELETE_SLIDESHOW, onDeleteSlideshow, SlideshowItemRendererEvent);
			
			onSlideshowsChanged();
			onClientsChanged();
			onReceivedObjectsChanged();
		}
		
		private function onJoin(event:SlideshowItemRendererEvent):void
		{
			var evt:JoinSlideshowEvent 	= new JoinSlideshowEvent(JoinSlideshowEvent.JOIN_SLIDESHOW);
			evt.slideshow 				= event.slideshow;
			dispatch(evt);
		}
		
		private function onSlideshowsChanged(event:SlideshowModelEvent=null):void
		{
			view.slideshows = slideshowModel.slideshows;
		}
		
		private function onDeleteSlideshow(event:SlideshowItemRendererEvent):void
		{
			var evt:DeleteSlideshowEvent 	= new DeleteSlideshowEvent(DeleteSlideshowEvent.DELETE_SLIDESHOW);
			evt.slideshow					= event.slideshow;
			dispatch(evt);
		}
		
		private function onClientsChanged(event:NetworkModelEvent=null):void
		{
			view.clients = networkModel.localNetworkDiscovery.clients;
		}
		
		private function onReceivedObjectsChanged(event:NetworkModelEvent=null):void
		{
			view.slideshows = networkModel.localNetworkDiscovery.receivedObjects;
		}
		
		
	}
}