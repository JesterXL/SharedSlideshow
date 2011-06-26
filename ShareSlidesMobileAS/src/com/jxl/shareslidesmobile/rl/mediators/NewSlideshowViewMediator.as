package com.jxl.shareslidesmobile.rl.mediators
{

	import com.jxl.shareslidesmobile.events.view.NewSlideshowViewEvent;
	import com.jxl.shareslidesmobile.views.mainviews.startslideshowviews.NewSlideshowView;

	import org.robotlegs.mvcs.Mediator;

	public class NewSlideshowViewMediator extends Mediator
	{

		[Inject]
		public var view:NewSlideshowView;

		public function NewSlideshowViewMediator()
		{
			super();
		}

		public override function onRegister():void
		{
			super.onRegister();

			addViewListener(NewSlideshowViewEvent.CREATE_SLIDESHOW, onCreateSlideshow, NewSlideshowViewEvent);
		}

		private function onCreateSlideshow(event:NewSlideshowViewEvent):void
		{
			Debug.log("NewSlideshowViewMediator::onCreateSlideshow");
			dispatch(event);
		}

	}
}

