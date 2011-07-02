package com.jxl.shareslidesmobile.rl
{

	import com.jxl.shareslides.services.ImagesToSlideshowService;
	import com.jxl.shareslidesmobile.events.controller.DeleteSlideshowEvent;
	import com.jxl.shareslidesmobile.events.controller.JoinSlideshowEvent;
	import com.jxl.shareslidesmobile.events.controller.LoadLocallySavedSlideshowsEvent;
	import com.jxl.shareslidesmobile.events.controller.SetCurrentSlideEvent;
	import com.jxl.shareslidesmobile.events.controller.SetNameEvent;
	import com.jxl.shareslidesmobile.events.controller.StartSlideshowEvent;
	import com.jxl.shareslidesmobile.events.model.NetworkModelEvent;
	import com.jxl.shareslidesmobile.events.services.ReadSavedSlideshowsServiceEvent;
	import com.jxl.shareslidesmobile.events.view.NewSlideshowViewEvent;
	import com.jxl.shareslidesmobile.events.view.StartSlideshowViewEvent;
	import com.jxl.shareslidesmobile.rl.commands.AskIfClientNeedsSlideshowCommand;
	import com.jxl.shareslidesmobile.rl.commands.CreateSlideshowCommand;
	import com.jxl.shareslidesmobile.rl.commands.DeleteSavedSlideshowCommand;
	import com.jxl.shareslidesmobile.rl.commands.DeleteSlideshowCommand;
	import com.jxl.shareslidesmobile.rl.commands.HostChangedCurrentSlideCommand;
	import com.jxl.shareslidesmobile.rl.commands.JoinSlideshowCommand;
	import com.jxl.shareslidesmobile.rl.commands.LoadLocallySavedSlideshowsCommand;
	import com.jxl.shareslidesmobile.rl.commands.ObjectAnnouncedCommand;
	import com.jxl.shareslidesmobile.rl.commands.RequestSlideshowIfNeededCommand;
	import com.jxl.shareslidesmobile.rl.commands.SetCurrentSlideCommand;
	import com.jxl.shareslidesmobile.rl.commands.SetNameCommand;
	import com.jxl.shareslidesmobile.rl.commands.ShareSlideshowWithClientCommand;
	import com.jxl.shareslidesmobile.rl.commands.StartSlideshowCommand;
	import com.jxl.shareslidesmobile.rl.commands.UpdateSavedSlideshowsCommand;
	import com.jxl.shareslidesmobile.rl.mediators.JoinViewMediator;
	import com.jxl.shareslidesmobile.rl.mediators.NewSlideshowViewMediator;
	import com.jxl.shareslidesmobile.rl.mediators.SetNameViewMediator;
	import com.jxl.shareslidesmobile.rl.mediators.SlideshowViewMediator;
	import com.jxl.shareslidesmobile.rl.mediators.StartSlideshowViewMediator;
	import com.jxl.shareslidesmobile.rl.models.NetworkModel;
	import com.jxl.shareslidesmobile.rl.models.SavedSlideshowsModel;
	import com.jxl.shareslidesmobile.rl.models.SlideshowModel;
	import com.jxl.shareslidesmobile.rl.services.DeleteSavedSlideshowService;
	import com.jxl.shareslidesmobile.rl.services.ReadSavedSlideshowsService;
	import com.jxl.shareslidesmobile.rl.services.SaveSlideshowService;
	import com.jxl.shareslidesmobile.views.mainviews.JoinView;
	import com.jxl.shareslidesmobile.views.mainviews.SlideshowView;
	import com.jxl.shareslidesmobile.views.mainviews.StartSlideshowView;
	import com.jxl.shareslidesmobile.views.mainviews.joinviewclasses.SetNameView;
	import com.jxl.shareslidesmobile.views.mainviews.startslideshowviews.NewSlideshowView;
	import com.projectcocoon.p2p.LocalNetworkDiscovery;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	
	public class MainContext extends Context
	{
		public function MainContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		public override function startup():void
		{
			injector.mapClass(ImagesToSlideshowService, ImagesToSlideshowService);
			injector.mapClass(DeleteSavedSlideshowService, DeleteSavedSlideshowService);

			injector.mapSingleton(NetworkModel);
			injector.mapSingleton(SlideshowModel);
			injector.mapSingleton(SavedSlideshowsModel);

			injector.mapSingleton(ReadSavedSlideshowsService);
			injector.mapSingleton(SaveSlideshowService);

			injector.mapClass(LocalNetworkDiscovery, LocalNetworkDiscovery);

			mediatorMap.mapView(JoinView, JoinViewMediator);
			mediatorMap.mapView(SetNameView, SetNameViewMediator);
			mediatorMap.mapView(SlideshowView, SlideshowViewMediator);
			mediatorMap.mapView(StartSlideshowView, StartSlideshowViewMediator);
			mediatorMap.mapView(NewSlideshowView, NewSlideshowViewMediator);
			/*
			mediatorMap.mapView(ShareSlidesMobile, ShareSlidesMobileMediator);
			mediatorMap.mapView(SetNameView, SetNameViewMediator);
			mediatorMap.mapView(JoinOrCreateSlideshowView, JoinOrCreateSlideshowViewMediator);
			mediatorMap.mapView(CreateSlideshowView, CreateSlideshowViewMediator);
			mediatorMap.mapView(TransferSlideshowView, TransferSlideshowViewMediator);
			*/

			commandMap.mapEvent(SetNameEvent.SET_NAME, SetNameCommand, SetNameEvent);
			commandMap.mapEvent(LoadLocallySavedSlideshowsEvent.LOAD, LoadLocallySavedSlideshowsCommand);
			commandMap.mapEvent(ReadSavedSlideshowsServiceEvent.READ_SAVED_SLIDESHOWS_COMPLETE, UpdateSavedSlideshowsCommand);
			commandMap.mapEvent(NewSlideshowViewEvent.CREATE_SLIDESHOW, CreateSlideshowCommand);
			commandMap.mapEvent(StartSlideshowEvent.START_SLIDESHOW, StartSlideshowCommand, StartSlideshowEvent);
			commandMap.mapEvent(StartSlideshowViewEvent.DELETE_SLIDESHOW, DeleteSavedSlideshowCommand,  StartSlideshowViewEvent);
			commandMap.mapEvent(JoinSlideshowEvent.JOIN_SLIDESHOW, JoinSlideshowCommand, JoinSlideshowEvent);
			commandMap.mapEvent(NetworkModelEvent.OBJECT_ANNOUNCED, ObjectAnnouncedCommand, NetworkModelEvent);
			//commandMap.mapEvent(DeleteSlideshowEvent.DELETE_SLIDESHOW, DeleteSlideshowCommand, DeleteSlideshowEvent);
			commandMap.mapEvent(SetCurrentSlideEvent.SET_CURRENT_SLIDE_EVENT, SetCurrentSlideCommand);
			commandMap.mapEvent(SetCurrentSlideEvent.HOST_UPDATED_CURRENT_SLIDE, HostChangedCurrentSlideCommand);
			commandMap.mapEvent(NetworkModelEvent.CLIENT_UPDATED, AskIfClientNeedsSlideshowCommand);
			commandMap.mapEvent(NetworkModelEvent.RECEIVED_REQUEST_SLIDESHOW_MESSAGE, RequestSlideshowIfNeededCommand);
			commandMap.mapEvent(NetworkModelEvent.CLIENT_NEEDS_SLIDESHOW, ShareSlideshowWithClientCommand);

			injector.instantiate(LocalNetworkDiscovery);


			
			super.startup();
		}
	}
}