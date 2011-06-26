package com.jxl.shareslidesmobile.rl.commands
{

	import com.jxl.shareslides.services.ImagesToSlideshowService;
	import com.jxl.shareslidesmobile.events.controller.StartSlideshowEvent;
	import com.jxl.shareslidesmobile.events.view.NewSlideshowViewEvent;
	import com.jxl.shareslidesmobile.rl.models.SavedSlideshowsModel;
	import com.jxl.shareslidesmobile.rl.services.SaveSlideshowService;

	import org.robotlegs.mvcs.Command;

	public class CreateSlideshowCommand extends AsyncCommand
	{
		[Inject]
		public var event:NewSlideshowViewEvent;

		[Inject]
		public var model:SavedSlideshowsModel;

		[Inject]
		public var slideshowService:ImagesToSlideshowService;

		[Inject]
		public var saveSlideshowService:SaveSlideshowService;

		public function CreateSlideshowCommand()
		{
			super();
		}

		public override function execute():void
		{
			Debug.log("CreateSlideshowCommand::execute");
			slideshowService.conversionCompleteSignal.add(onSlideshowReady);
			slideshowService.getSlideshow(event.name, event.files);
		}

		private function onSlideshowReady():void
		{
			Debug.log("CreateSlideshowCommand::onSlideshowReady");
			saveSlideshowService.saveSlideshow(slideshowService.slideshow);
			var evt:StartSlideshowEvent = new StartSlideshowEvent(StartSlideshowEvent.START_SLIDESHOW);
			evt.slideshow = slideshowService.slideshow;
			dispatch(evt);
		}

	}
}

