package com.jxl.shareslides.rl.commands
{

	import com.jxl.shareslides.events.controller.SetCurrentSlideEvent;
	import com.jxl.shareslides.rl.models.SlideshowModel;

	import org.robotlegs.mvcs.Command;

	public class UpdateCurrentSlideCommand extends Command
	{
		[Inject]
		public var event:SetCurrentSlideEvent;

		[Inject]
		public var model:SlideshowModel;

		public function UpdateCurrentSlideCommand()
		{
			super();
		}

		public override function execute():void
		{
			model.currentSlide = event.currentSlide;
		}

	}
}

