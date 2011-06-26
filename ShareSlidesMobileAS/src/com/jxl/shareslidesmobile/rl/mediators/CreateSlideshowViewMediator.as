package com.jxl.shareslidesmobile.rl.mediators
{
	import com.jxl.shareslidesmobile.events.controller.StartSlideshowEvent;
	import com.jxl.shareslidesmobile.events.view.CreateSlideshowViewEvent;
	import com.jxl.shareslidesmobile.views.CreateSlideshowView;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class CreateSlideshowViewMediator extends Mediator
	{
		
		[Inject]
		public var view:CreateSlideshowView;
		
		public function CreateSlideshowViewMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			super.onRegister();
			
			addViewListener(CreateSlideshowViewEvent.CREATE_SLIDESHOW, onCreateSlideshow);
		}
		
		private function onCreateSlideshow(event:CreateSlideshowViewEvent):void
		{
			var evt:StartSlideshowEvent = new StartSlideshowEvent(StartSlideshowEvent.START_SLIDESHOW);
			evt.name 					= event.name;
			evt.slides 					= event.files;
			dispatch(evt);
		}
	}
}