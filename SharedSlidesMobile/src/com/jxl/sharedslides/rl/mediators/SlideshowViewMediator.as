package com.jxl.sharedslides.rl.mediators
{
	import com.jxl.sharedslides.events.model.NetworkModelEvent;
	import com.jxl.sharedslides.rl.models.NetworkModel;
	import com.jxl.sharedslides.views.joinslideshowviews.SlideshowView;
	
	import flash.events.Event;
	import flash.text.ReturnKeyLabel;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class SlideshowViewMediator extends Mediator
	{
		[Inject]
		public var view:SlideshowView;
		
		[Inject]
		public var model:NetworkModel;
		
		
		public function SlideshowViewMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			addContextListener(NetworkModelEvent.HOST_CURRENT_SLIDE_INDEX_CHANGED, onHostIndexChanged, NetworkModelEvent);
			
			addViewListener("syncToHostChanged", onSyncToHostChange);
			addViewListener("currentIndexChanged", onCurrentIndexChanged);
			
			view.data.object.updateHashIfNeeded();
			model.currentSlideshowHash = view.data.object.hash;
			
			updateToHostSlide();
		}
		
		private function onHostIndexChanged(event:NetworkModelEvent):void
		{
			updateToHostSlide();
		}
		
		private function onSyncToHostChange(event:Event):void
		{
			updateToHostSlide();
		}
		
		private function updateToHostSlide():void
		{
			if(view.host)
				return;
			
			if(view.syncToHost)
				view.currentIndex = model.currentSlide;
		}
		
		private function onCurrentIndexChanged(event:Event):void
		{
			model.setHostCurrentIndex(view.data.object.hash, view.currentIndex);
		}
	}
}