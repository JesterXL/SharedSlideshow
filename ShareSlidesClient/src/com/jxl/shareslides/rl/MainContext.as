package com.jxl.shareslides.rl
{
	import com.jxl.shareslides.controls.ConnectionLight;
	import com.jxl.shareslides.controls.TabNavigationBar;
	import com.jxl.shareslides.events.model.NetworkModelEvent;
	import com.jxl.shareslides.events.view.CreateSlideshowViewEvent;
	import com.jxl.shareslides.events.view.PhoneItemEvent;
	import com.jxl.shareslides.rl.commands.MessageCommand;
	import com.jxl.shareslides.rl.commands.SaveSlideshowCommand;
	import com.jxl.shareslides.rl.commands.SendSlideshowCommand;
	import com.jxl.shareslides.rl.mediators.ConnectionLightMediator;
	import com.jxl.shareslides.rl.mediators.CreateSlideshowViewMediator;
	import com.jxl.shareslides.rl.mediators.MainViewMediator;
	import com.jxl.shareslides.rl.mediators.TabNavigationBarMediator;
	import com.jxl.shareslides.rl.mediators.TransferViewMediator;
	import com.jxl.shareslides.rl.models.NetworkModel;
	import com.jxl.shareslides.rl.models.SlideshowModel;
	import com.jxl.shareslides.rl.models.TransferModel;
	import com.jxl.shareslides.views.MainView;
	import com.jxl.shareslides.views.TransferView;
	import com.jxl.shareslides.views.transferviews.CreateSlideshowView;
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
			injector.mapSingleton(TransferModel);
			
			commandMap.mapEvent(NetworkModelEvent.MESSAGE, MessageCommand, NetworkModelEvent);
			commandMap.mapEvent(CreateSlideshowViewEvent.SAVE_SLIDESHOW, SaveSlideshowCommand, CreateSlideshowViewEvent);
			commandMap.mapEvent(PhoneItemEvent.SEND_SLIDES, SendSlideshowCommand, PhoneItemEvent);
			
			mediatorMap.mapView(MainView, MainViewMediator);
			mediatorMap.mapView(TabNavigationBar, TabNavigationBarMediator);
			mediatorMap.mapView(ConnectionLight, ConnectionLightMediator);
			mediatorMap.mapView(CreateSlideshowView, CreateSlideshowViewMediator);
			mediatorMap.mapView(TransferView, TransferViewMediator);
			
			
			super.startup();
			
		}
	}
}