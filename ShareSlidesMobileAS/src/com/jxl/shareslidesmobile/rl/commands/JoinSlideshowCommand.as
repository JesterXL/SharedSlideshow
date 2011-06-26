package com.jxl.shareslidesmobile.rl.commands
{
	import com.jxl.shareslidesmobile.events.controller.JoinSlideshowEvent;
	import com.jxl.shareslidesmobile.rl.models.SlideshowModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class JoinSlideshowCommand extends Command
	{
		[Inject]
		public var event:JoinSlideshowEvent;
		
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
			
			dispatch(new JoinSlideshowEvent(JoinSlideshowEvent.SLIDESHOW_SUCCESSFULLY_JOINED));
		}
	}
}