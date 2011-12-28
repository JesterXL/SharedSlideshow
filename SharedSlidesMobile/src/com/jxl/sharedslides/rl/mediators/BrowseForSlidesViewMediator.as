package com.jxl.sharedslides.rl.mediators
{
	import com.jxl.sharedslides.events.view.BrowseForSlidesViewEvent;
	import com.jxl.sharedslides.rl.models.NetworkModel;
	import com.jxl.sharedslides.views.startslideshowviews.BrowseForSlidesView;
	import com.jxl.shareslides.services.ImagesToSlideshowService;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class BrowseForSlidesViewMediator extends Mediator
	{
		[Inject]
		public var view:BrowseForSlidesView;
		
		[Inject]
		public var service:ImagesToSlideshowService;
		
		[Inject]
		public var model:NetworkModel;
		
		public function BrowseForSlidesViewMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			addViewListener(BrowseForSlidesViewEvent.CREATE_SLIDESHOW, onCreateSlideshow, BrowseForSlidesViewEvent);
			
			eventMap.mapListener(service, "loadingFilesComplete", onLoadingFilesComplete);
		}
		
		private function onCreateSlideshow(event:BrowseForSlidesViewEvent):void
		{
			service.getSlideshow(event.name, event.slides.source, event.passcode);
		}
		
		private function onLoadingFilesComplete(event:Event):void
		{
			Debug.log("BrowseForSlidesViewMediator::onLoadingFilesComplete");
			view.onCreateSlideshowComplete();
			model.shareSlideshow(service.slideshow);
		}
	}
}