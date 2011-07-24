package com.jxl.shareslides.rl.mediators
{
	import com.jxl.shareslides.controls.TabNavigationBar;
	import com.jxl.shareslides.events.controller.NavigationEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.events.IndexChangeEvent;
	
	public class TabNavigationBarMediator extends Mediator
	{
		[Inject]
		public var tabNavigationBar:TabNavigationBar;
		
		public function TabNavigationBarMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			super.onRegister();
			
			addViewListener(IndexChangeEvent.CHANGE, onIndexChange, IndexChangeEvent);
			addContextListener(NavigationEvent.NAVIGATION_CHANGE, onNavigationChanged, NavigationEvent);
		}
		
		private function onIndexChange(event:IndexChangeEvent):void
		{
			var evt:NavigationEvent 	= new NavigationEvent(NavigationEvent.NAVIGATION_CHANGE);
			evt.location 				= tabNavigationBar.selectedItem;
			dispatch(evt);
		}

		private function onNavigationChanged(event:NavigationEvent):void
		{
			tabNavigationBar.selectedItem = event.location;
		}
	}
}