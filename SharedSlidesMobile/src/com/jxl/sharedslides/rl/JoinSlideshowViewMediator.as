package com.jxl.sharedslides.rl
{
	import com.jxl.sharedslides.events.view.JoinSlideshowViewEvent;
	import com.jxl.sharedslides.rl.models.NetworkModel;
	import com.jxl.sharedslides.views.JoinSlideshowView;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class JoinSlideshowViewMediator extends Mediator
	{
		[Inject]
		public var view:JoinSlideshowView;
		
		[Inject]
		public var model:NetworkModel;
		
		public function JoinSlideshowViewMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			//addContextListener("clientAdded", onClientsUpdate);
			//addContextListener("clientUpdate", onClientsUpdate);
			//addContextListener("clientRemoved", onClientsUpdate);
			
			addViewListener(JoinSlideshowViewEvent.CHANGE_NAME, onChangeName, JoinSlideshowViewEvent);
			
			view.participants = model.clients;
		}
		
		//private function onClientsUpdate(event:Event):void
		//{
		//	view.participants = model.clients;
		//}
		
		private function onChangeName(event:JoinSlideshowViewEvent):void
		{
			model.changeName(event.name);
		}
	}
}