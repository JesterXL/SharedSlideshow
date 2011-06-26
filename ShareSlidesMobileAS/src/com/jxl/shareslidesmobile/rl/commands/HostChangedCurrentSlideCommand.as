package com.jxl.shareslidesmobile.rl.commands
{
	import com.jxl.shareslidesmobile.events.controller.SetCurrentSlideEvent;
	import com.jxl.shareslidesmobile.rl.models.SlideshowModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class HostChangedCurrentSlideCommand extends Command
	{
		[Inject]
		public var event:SetCurrentSlideEvent;
		
		[Inject]
		public var slideshowModel:SlideshowModel;
		
		public function HostChangedCurrentSlideCommand()
		{
			super();
		}
		
		public override function execute():void
		{
			slideshowModel.currentSlide = event.currentSlide;
		}
	}
}