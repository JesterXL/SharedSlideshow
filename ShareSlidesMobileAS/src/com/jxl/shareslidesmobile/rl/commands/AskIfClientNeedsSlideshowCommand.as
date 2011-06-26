package com.jxl.shareslidesmobile.rl.commands
{
	import com.jxl.shareslidesmobile.events.model.NetworkModelEvent;
	import com.jxl.shareslidesmobile.rl.models.NetworkModel;
	import com.jxl.shareslidesmobile.rl.models.SlideshowModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class AskIfClientNeedsSlideshowCommand extends Command
	{
		
		[Inject]
		public var event:NetworkModelEvent;
		
		[Inject]
		public var networkModel:NetworkModel;
		
		[Inject]
		public var slideshowModel:SlideshowModel;
		
		public function AskIfClientNeedsSlideshowCommand()
		{
			super();
		}
		
		public override function execute():void
		{
			Debug.log("AskIfclientNeedsSlideshowCommand::execute");
			if(event.client.isLocal)
				return;
			
			if(slideshowModel.slideshow)
			{
				networkModel.localNetworkDiscovery.sendMessageToClient({message: "doYouNeedSlideshow", slideshowName: slideshowModel.slideshow.name}, event.client.groupID);
			}
		}
	}
}