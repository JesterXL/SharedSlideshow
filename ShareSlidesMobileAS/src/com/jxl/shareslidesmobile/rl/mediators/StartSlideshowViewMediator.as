
package com.jxl.shareslidesmobile.rl.mediators
{

	import com.jxl.shareslidesmobile.events.controller.LoadLocallySavedSlideshowsEvent;
	import com.jxl.shareslidesmobile.events.model.SavedSlideshowModelEvent;
	import com.jxl.shareslidesmobile.rl.models.SavedSlideshowsModel;
	import com.jxl.shareslidesmobile.views.mainviews.StartSlideshowView;

	import org.robotlegs.mvcs.Mediator;

	public class StartSlideshowViewMediator extends Mediator
	{

		[Inject]
		public var view:StartSlideshowView;

		[Inject]
		public var savedSlideshows:SavedSlideshowsModel;

		public function StartSlideshowViewMediator()
		{
			super();
		}

		public override function onRegister():void
		{
			super.onRegister();

			addContextListener(SavedSlideshowModelEvent.SLIDESHOWS_CHANGED, onSlideshowsChanged);

			onSlideshowsChanged();

			dispatch(new LoadLocallySavedSlideshowsEvent(LoadLocallySavedSlideshowsEvent.LOAD));

		}

		private function onSlideshowsChanged(event:SavedSlideshowModelEvent=null):void
		{
			view.slideshows = savedSlideshows.slideshows;
		}

	}
}

