package com.jxl.shareslidesmobile.rl.commands
{

	import com.jxl.shareslidesmobile.events.view.StartSlideshowViewEvent;
	import com.jxl.shareslidesmobile.rl.models.SavedSlideshowsModel;
	import com.jxl.shareslidesmobile.rl.services.DeleteSavedSlideshowService;

	import org.robotlegs.mvcs.Command;

	public class DeleteSavedSlideshowCommand extends Command
	{
		[Inject]
		public var event:StartSlideshowViewEvent;

		[Inject]
		public var service:DeleteSavedSlideshowService;

		[Inject]
		public var model:SavedSlideshowsModel;

		public function DeleteSavedSlideshowCommand()
		{
			super();
		}

		public override function execute():void
		{
			model.slideshows.removeItemAt(model.slideshows.getItemIndex(event.slideshow));
			service.deleteSavedSlideshow(event.slideshow);
		}

	}
}

