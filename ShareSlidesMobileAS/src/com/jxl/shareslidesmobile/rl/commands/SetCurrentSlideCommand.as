package com.jxl.shareslidesmobile.rl.commands
{
	import com.jxl.shareslidesmobile.events.controller.SetCurrentSlideEvent;
	import com.jxl.shareslidesmobile.rl.models.NetworkModel;
	import com.jxl.shareslidesmobile.rl.models.SlideshowModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class SetCurrentSlideCommand extends Command
	{
		[Inject]
		public var event:SetCurrentSlideEvent;
		
		[Inject]
		public var slideshowModel:SlideshowModel;
		
		[Inject]
		public var networkModel:NetworkModel;
		
		public function SetCurrentSlideCommand()
		{
			super();
		}
		
		public override function execute():void
		{
			if(slideshowModel.slideshow && slideshowModel.slideshow.host)
			{
				slideshowModel.currentSlide = event.currentSlide;
				networkModel.localNetworkDiscovery.sendMessageToAll({message: "setCurrentSlide", currentSlide: event.currentSlide});
			}
		}
	}
}