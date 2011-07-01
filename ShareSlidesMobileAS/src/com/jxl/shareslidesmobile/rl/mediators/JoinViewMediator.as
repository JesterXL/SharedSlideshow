
package com.jxl.shareslidesmobile.rl.mediators
{
	import com.jxl.shareslidesmobile.events.controller.JoinSlideshowEvent;
	import com.jxl.shareslidesmobile.events.controller.SetNameEvent;
	import com.jxl.shareslidesmobile.events.model.NetworkModelEvent;
	import com.jxl.shareslidesmobile.events.model.SlideshowModelEvent;
	import com.jxl.shareslidesmobile.events.view.SlideshowItemRendererEvent;
	import com.jxl.shareslidesmobile.rl.models.NetworkModel;
	import com.jxl.shareslidesmobile.rl.models.SlideshowModel;
	import com.jxl.shareslidesmobile.views.mainviews.JoinView;

	import flash.events.Event;

	import mx.events.CollectionEvent;

	import org.robotlegs.mvcs.Mediator;

	public class JoinViewMediator extends Mediator
	{
		[Inject]
		public var view:JoinView;

		[Inject]
		public var slideshowModel:SlideshowModel;

		[Inject]
		public var networkModel:NetworkModel;

		public function JoinViewMediator()
		{
		}

		public override function onRegister():void
		{
			super.onRegister();

			addContextListener(NetworkModelEvent.CLIENTS_CHANGED, onClientsChanged, NetworkModelEvent);
			addContextListener(NetworkModelEvent.RECEIVED_OBJECTS_CHANGED, onReceivedObjectsChanged, NetworkModelEvent);

			eventMap.mapListener(networkModel.localNetworkDiscovery.clients, CollectionEvent.COLLECTION_CHANGE, onClientsChanged);


			addViewListener(SlideshowItemRendererEvent.JOIN, onJoin, SlideshowItemRendererEvent);

			onClientsChanged();
			onReceivedObjectsChanged();

		}

		private function onClientsChanged(event:Event=null):void
		{
			view.clients = networkModel.localNetworkDiscovery.clients;
		}

		private function onJoin(event:SlideshowItemRendererEvent):void
		{
			 var evt:JoinSlideshowEvent = new JoinSlideshowEvent(JoinSlideshowEvent.JOIN_SLIDESHOW);
			evt.slideshow 				= event.slideshow;
			dispatch(evt);
		}

		private function onReceivedObjectsChanged(event:NetworkModelEvent=null):void
		{
			view.slideshows = networkModel.localNetworkDiscovery.receivedObjects;
		}

	}
}

  /*
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

eventMap.mapListener(eventDispatcher, SlideshowModelEvent.SLIDESHOWS_CHANGED, onSlideshowsChanged, SlideshowModelEvent);

			eventMap.mapListener(eventDispatcher, NetworkModelEvent.CLIENTS_CHANGED, onClientsChanged);
			eventMap.mapListener(eventDispatcher, NetworkModelEvent.RECEIVED_OBJECTS_CHANGED, onReceivedObjectsChanged);

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
		  */