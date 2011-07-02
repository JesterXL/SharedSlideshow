package com.jxl.shareslides.rl.mediators
{

	import com.jxl.shareslides.events.model.SlideshowModelEvent;
	import com.jxl.shareslides.rl.models.SlideshowModel;
	import com.jxl.shareslides.views.SlideshowView;

	import org.robotlegs.mvcs.Mediator;

	public class SlideshowViewMediator extends Mediator
	{

		[Inject]
		public var view:SlideshowView;

		[Inject]
		public var slideshowModel:SlideshowModel;

		public function SlideshowViewMediator()
		{
			super();
		}

		public override function onRegister():void
		{
			super.onRegister();

			addContextListener(SlideshowModelEvent.CURRENT_SLIDE_CHANGED, onUpdateCurrentSlide, SlideshowModelEvent);
			addContextListener(SlideshowModelEvent.SLIDESHOW_CHANGED, onSlideshowChanged, SlideshowModelEvent);

			onSlideshowChanged();
			onUpdateCurrentSlide();
		}

		private function onUpdateCurrentSlide(event:SlideshowModelEvent=null):void
		{
		   view.currentSlide = slideshowModel.currentSlide;
		}

		private function onSlideshowChanged(event:SlideshowModelEvent=null):void
		{
		   view.slideshow = slideshowModel.slideshow;
		}

	}
}

