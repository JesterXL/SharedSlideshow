package com.jxl.sharedslides.rl.mediators
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
			addContextListener("sharedObjectsChange", onUpdateState);
			
			addViewListener(JoinSlideshowViewEvent.CHANGE_NAME, onChangeName, JoinSlideshowViewEvent);
			
			onUpdateState();
		}
		
		private function onChangeName(event:JoinSlideshowViewEvent):void
		{
			model.changeName(event.name);
		}
		
		private function onUpdateState(event:Event=null):void
		{
			if(model.receivedObjects.length < 1)
			{
				view.currentState = "noSlideshows";
			}
			else
			{
				view.currentState = "slideshows";
			}
		}
	}
}