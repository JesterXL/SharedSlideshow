package com.jxl.shareslidesmobile.rl.mediators
{
	import com.jxl.shareslidesmobile.events.controller.SetCurrentSlideEvent;
	import com.jxl.shareslidesmobile.events.model.SlideshowModelEvent;
	import com.jxl.shareslidesmobile.events.view.SlideshowViewEvent;
	import com.jxl.shareslidesmobile.rl.models.SlideshowModel;
	import com.jxl.shareslidesmobile.views.mainviews.SlideshowView;

	import org.robotlegs.mvcs.Mediator;
	
	public class SlideshowViewMediator extends Mediator
	{
		
		[Inject]
		public var view:SlideshowView;
		
		[Inject]
		public var slideshowModel:SlideshowModel;
		
		[PostConstruct]
		public function init():void
		{
			eventMap.mapListener(eventDispatcher, SlideshowModelEvent.SLIDESHOW_CHANGED, onSlideshowChanged, SlideshowModelEvent);
			eventMap.mapListener(eventDispatcher, SlideshowModelEvent.CURRENT_SLIDE_CHANGED, onCurrentSlideChanged, SlideshowModelEvent);
			eventMap.mapListener(eventDispatcher, SlideshowModelEvent.HOST_CHANGED, onHostChanged, SlideshowModelEvent);
		}
		
		public function SlideshowViewMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			super.onRegister();
			
			onSlideshowChanged();
			onCurrentSlideChanged();
			onHostChanged();
			
			this.addViewListener(SlideshowViewEvent.NEXT_IMAGE, onNextImage, SlideshowViewEvent);
			this.addViewListener(SlideshowViewEvent.PREVIOUS_IMAGE, onPreviousImage, SlideshowViewEvent);
			this.addViewListener(SlideshowViewEvent.SYNC_CHANGE, onSyncChange, SlideshowViewEvent);
		}
		
		private function onSlideshowChanged(event:SlideshowModelEvent=null):void
		{
			view.slideshow = slideshowModel.slideshow;
		}
		
		private function onCurrentSlideChanged(event:SlideshowModelEvent=null):void
		{
			if(view.syncCheckBox.selected)
				view.currentSlide = slideshowModel.currentSlide;
		}
		
		private function onHostChanged(event:SlideshowModelEvent=null):void
		{
			view.setHost(slideshowModel.host);
		}
		
		private function onNextImage(event:SlideshowViewEvent):void
		{
			var evt:SetCurrentSlideEvent 	= new SetCurrentSlideEvent(SetCurrentSlideEvent.SET_CURRENT_SLIDE_EVENT);
			evt.currentSlide 				= view.currentSlide;
			dispatch(evt);
		}
		
		private function onPreviousImage(event:SlideshowViewEvent):void
		{
			var evt:SetCurrentSlideEvent 	= new SetCurrentSlideEvent(SetCurrentSlideEvent.SET_CURRENT_SLIDE_EVENT);
			evt.currentSlide 				= view.currentSlide;
			dispatch(evt);
		}
		
		private function onSyncChange(event:SlideshowViewEvent):void
		{
			if(view.syncCheckBox.selected)
				view.currentSlide = slideshowModel.currentSlide;
		}
	}
}