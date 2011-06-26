package com.jxl.shareslidesmobile.rl.mediators
{
	import com.jxl.shareslidesmobile.events.controller.JoinSlideshowEvent;
	import com.jxl.shareslidesmobile.events.controller.SetNameEvent;
	import com.jxl.shareslidesmobile.events.controller.StartSlideshowEvent;
	import com.jxl.shareslidesmobile.events.view.TransferSlideshowViewEvent;
	import com.jxl.shareslidesmobile.events.view.TransferredSlideshowItemEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ShareSlidesMobileMediator extends Mediator
	{
		[Inject]
		public var view:ShareSlidesMobile;
		
		
		public function ShareSlidesMobileMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			Debug.debug("ShareSlidesMobileMedaitor::onRegister");
			super.onRegister();
			
			eventMap.mapListener(eventDispatcher, SetNameEvent.SET_NAME, onSetName, SetNameEvent);
			eventMap.mapListener(eventDispatcher, StartSlideshowEvent.START_SLIDESHOW, onStartSlideshow, StartSlideshowEvent);
			eventMap.mapListener(eventDispatcher, JoinSlideshowEvent.SLIDESHOW_SUCCESSFULLY_JOINED, onJoinSlideshow, JoinSlideshowEvent);
		}
		
		private function onSetName(event:SetNameEvent):void
		{
			if(event.transfer == false)
			{
				view.onNameSet();
			}
			else
			{
				view.onTransferNameSet();
			}
		}
		
		private function onStartSlideshow(event:StartSlideshowEvent):void
		{
			view.onSlideshowStarted();
		}
		
		private function onJoinSlideshow(evnet:JoinSlideshowEvent):void
		{
			view.onSlideshowStarted();
		}
	}
}