package com.jxl.shareslides.rl.mediators
{
	import com.jxl.shareslides.events.view.CreateSlideshowViewEvent;
	import com.jxl.shareslides.views.CreateSlideshowView;

	import org.robotlegs.mvcs.Mediator;

	public class CreateSlideshowViewMediator extends Mediator
	{
		[Inject]
		public var createSlideshowView:CreateSlideshowView;

		public function CreateSlideshowViewMediator()
		{
		}

		public override function onRegister():void
		{
			super.onRegister();

			addViewListener(CreateSlideshowViewEvent.SAVE_SLIDESHOW, onSaveSlideshow, CreateSlideshowViewEvent);
		}

		private function onSaveSlideshow(event:CreateSlideshowViewEvent):void
		{
			Debug.log("CreateSlideshowViewMediator::onSaveSlideshow");
			dispatch(event);
		}
	}
}
