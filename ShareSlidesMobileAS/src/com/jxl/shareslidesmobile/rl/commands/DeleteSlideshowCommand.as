package com.jxl.shareslidesmobile.rl.commands
{
	import com.jxl.shareslidesmobile.events.controller.DeleteSlideshowEvent;
	import com.jxl.shareslidesmobile.rl.models.NetworkModel;
	import com.jxl.shareslidesmobile.rl.models.SlideshowModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class DeleteSlideshowCommand extends Command
	{
		[Inject]
		public var slideshowModel:SlideshowModel;
		
		[Inject]
		public var event:DeleteSlideshowEvent;
		
		[Inject]
		public var networkModel:NetworkModel;
		
		public function DeleteSlideshowCommand()
		{
			super();
		}
		
		public override function execute():void
		{
			Debug.log("StartSlideshowCommand::execute");
			if(slideshowModel.slideshows && slideshowModel.slideshows.length > 0)
			{
				slideshowModel.slideshows.removeItemAt(slideshowModel.slideshows.getItemIndex(event.slideshow));
				networkModel.localNetworkDiscovery.sendMessageToAll({message: "delete", slideshow: event.slideshow.name, name: networkModel.name});
				
			}
		}
		
	}
}