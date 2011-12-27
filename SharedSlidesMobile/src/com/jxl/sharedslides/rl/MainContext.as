package com.jxl.sharedslides.rl
{
	import com.jxl.sharedslides.rl.models.NetworkModel;
	import com.jxl.sharedslides.views.JoinSlideshowView;
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
			injector.mapSingleton(LocalNetworkDiscovery);
			
			injector.mapSingleton(NetworkModel);
			
			mediatorMap.mapView(JoinSlideshowView, JoinSlideshowViewMediator);
		}
	}
}