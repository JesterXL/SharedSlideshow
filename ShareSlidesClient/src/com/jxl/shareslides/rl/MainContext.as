package com.jxl.shareslides.rl
{
	import com.jxl.shareslides.controls.ConnectionLight;
	import com.jxl.shareslides.controls.TabNavigationBar;
	import com.jxl.shareslides.events.controller.SetCurrentSlideEvent;
	import com.jxl.shareslides.events.model.NetworkModelEvent;
	import com.jxl.shareslides.events.model.SlideshowModelEvent;
	import com.jxl.shareslides.events.view.CreateSlideshowViewEvent;
	import com.jxl.shareslides.events.view.MainViewEvent;
	import com.jxl.shareslides.events.view.PhoneItemEvent;
	import com.jxl.shareslides.rl.commands.AskIfClientNeedsSlideshowCommand;
	import com.jxl.shareslides.rl.commands.JoinSlideshowCommand;
	import com.jxl.shareslides.rl.commands.RequestSlideshowIfNeededCommand;
	import com.jxl.shareslides.rl.commands.SaveSlideshowCommand;
	import com.jxl.shareslides.rl.commands.ShareSlideshowCommand;
	import com.jxl.shareslides.rl.commands.ShareSlideshowWithClientCommand;
	import com.jxl.shareslides.rl.commands.UpdateCurrentSlideCommand;
	import com.jxl.shareslides.rl.mediators.ConnectionLightMediator;
	import com.jxl.shareslides.rl.mediators.CreateSlideshowViewMediator;
	import com.jxl.shareslides.rl.mediators.MainViewMediator;
	import com.jxl.shareslides.rl.mediators.SlideshowViewMediator;
	import com.jxl.shareslides.rl.mediators.TabNavigationBarMediator;
	import com.jxl.shareslides.rl.models.NetworkModel;
	import com.jxl.shareslides.rl.models.SlideshowModel;
	import com.jxl.shareslides.views.MainView;
	import com.jxl.shareslides.views.CreateSlideshowView;
	import com.jxl.shareslides.views.SlideshowView;
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
			
			injector.mapClass(LocalNetworkDiscovery, LocalNetworkDiscovery);
			
			injector.mapSingleton(NetworkModel);
			injector.mapSingleton(SlideshowModel);

			commandMap.mapEvent(CreateSlideshowViewEvent.SAVE_SLIDESHOW, SaveSlideshowCommand, CreateSlideshowViewEvent);
			commandMap.mapEvent(SlideshowModelEvent.SLIDESHOW_CREATED, ShareSlideshowCommand, SlideshowModelEvent);
			commandMap.mapEvent(SetCurrentSlideEvent.HOST_UPDATED_CURRENT_SLIDE, UpdateCurrentSlideCommand, SetCurrentSlideEvent);

			commandMap.mapEvent(MainViewEvent.JOIN_SLIDESHOW, JoinSlideshowCommand, MainViewEvent);

			commandMap.mapEvent(NetworkModelEvent.CLIENT_UPDATE, AskIfClientNeedsSlideshowCommand, NetworkModelEvent);
			commandMap.mapEvent(NetworkModelEvent.RECEIVED_REQUEST_SLIDESHOW_MESSAGE, RequestSlideshowIfNeededCommand, NetworkModelEvent);
			commandMap.mapEvent(NetworkModelEvent.CLIENT_NEEDS_SLIDESHOW, ShareSlideshowWithClientCommand, NetworkModelEvent);

			mediatorMap.mapView(MainView, MainViewMediator);
			mediatorMap.mapView(TabNavigationBar, TabNavigationBarMediator);
			mediatorMap.mapView(ConnectionLight, ConnectionLightMediator);
			mediatorMap.mapView(CreateSlideshowView, CreateSlideshowViewMediator);
			mediatorMap.mapView(SlideshowView, SlideshowViewMediator);
			
			
			super.startup();
			
		}
	}
}