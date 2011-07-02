package com.jxl.shareslides.rl.commands
{
	import com.jxl.shareslides.events.view.MainViewEvent;
	import com.jxl.shareslides.rl.models.SlideshowModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class JoinSlideshowCommand extends Command
	{
		[Inject]
		public var event:MainViewEvent;
		
		[Inject]
		public var slideshowModel:SlideshowModel;
		
		public function JoinSlideshowCommand()
		{
			super();
		}
		
		public override function execute():void
		{
			slideshowModel.slideshow = event.slideshow;
			slideshowModel.currentSlide = 0;
		}
	}
}