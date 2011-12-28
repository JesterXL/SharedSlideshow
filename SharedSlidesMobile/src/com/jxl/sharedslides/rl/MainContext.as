package com.jxl.sharedslides.rl
{
	import com.jxl.sharedslides.rl.mediators.BrowseForSlidesViewMediator;
	import com.jxl.sharedslides.rl.mediators.JoinSlideshowViewMediator;
	import com.jxl.sharedslides.rl.mediators.StartSlideshowViewMediator;
	import com.jxl.sharedslides.rl.models.NetworkModel;
	import com.jxl.sharedslides.views.JoinSlideshowView;
	import com.jxl.sharedslides.views.StartSlideshowView;
	import com.jxl.sharedslides.views.startslideshowviews.BrowseForSlidesView;
	import com.jxl.shareslides.services.ImagesToSlideshowService;
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
			
			injector.mapSingleton(LocalNetworkDiscovery);
			
			injector.mapSingleton(NetworkModel);
			
			mediatorMap.mapView(JoinSlideshowView, JoinSlideshowViewMediator);
			mediatorMap.mapView(StartSlideshowView, StartSlideshowViewMediator);
			mediatorMap.mapView(BrowseForSlidesView, BrowseForSlidesViewMediator);
		}
	}
}