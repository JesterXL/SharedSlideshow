package com.jxl.shareslidesmobile.rl.commands
{
	import com.jxl.shareslidesmobile.events.model.NetworkModelEvent;
	import com.jxl.shareslidesmobile.rl.models.NetworkModel;
	import com.jxl.shareslidesmobile.rl.models.SlideshowModel;
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;

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
			/*
			Debug.log("AskIfclientNeedsSlideshowCommand::execute");
			if(event.client.isLocal)
				return;
			
			if(slideshowModel.slideshow)
			{
				networkModel.localNetworkDiscovery.sendMessageToClient({message: "doYouNeedSlideshow", slideshowName: slideshowModel.slideshow.name}, event.client.groupID);
			}
			*/

			Debug.log("AskIfclientNeedsSlideshowCommand::execute");
			if(event.client.isLocal)
				return;

			var len:int = networkModel.localNetworkDiscovery.receivedObjects.length;
			Debug.log("\tlen: " + len);
			while(len--)
			{
				var om:ObjectMetadataVO = networkModel.localNetworkDiscovery.receivedObjects.getItemAt(len) as ObjectMetadataVO;
				Debug.log("\tDo you need " + om.info + "?");
				networkModel.localNetworkDiscovery.sendMessageToClient({message: "doYouNeedSlideshow", slideshowName: om.info}, event.client.groupID);
			}

			len = networkModel.localNetworkDiscovery.sharedObjects.length;
			Debug.log("\tlen: " + len);
			while(len--)
			{
				var om:ObjectMetadataVO = networkModel.localNetworkDiscovery.sharedObjects.getItemAt(len) as ObjectMetadataVO;
				Debug.log("\tDo you need " + om.info + "?");
				networkModel.localNetworkDiscovery.sendMessageToClient({message: "doYouNeedSlideshow", slideshowName: om.info}, event.client.groupID);
			}
		}
	}
}