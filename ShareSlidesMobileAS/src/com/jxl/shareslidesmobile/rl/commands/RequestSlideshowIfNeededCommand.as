package com.jxl.shareslidesmobile.rl.commands
{
	import com.jxl.shareslidesmobile.events.model.NetworkModelEvent;
	import com.jxl.shareslidesmobile.rl.models.NetworkModel;
	import com.jxl.shareslidesmobile.rl.models.SlideshowModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class RequestSlideshowIfNeededCommand extends Command
	{
		[Inject]
		public var networkModel:NetworkModel;
		
		[Inject]
		public var event:NetworkModelEvent;
		
		[Inject]
		public var slideshowModel:SlideshowModel;
		
		public function RequestSlideshowIfNeededCommand()
		{
			super();
		}
		
		public override function execute():void
		{
			Debug.log("RequestSlideshowIfNeededCommand::execute");
			if(event.message.client.isLocal)
				return;
			
			if(networkModel.containsSlideshow(event.message.data.slideshowName) == false)
			{
				Debug.log("\tYes, I need it.");
				networkModel.localNetworkDiscovery.sendMessageToClient({message: "doYouNeedSlideshowAck", request: true}, event.message.client.groupID);
			}
			else
			{
				Debug.log("\tNo, I already have it.");
			}
		}
	}
}