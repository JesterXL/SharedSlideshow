package com.jxl.shareslidesmobile.rl.commands
{
	import com.jxl.shareslidesmobile.events.model.NetworkModelEvent;
	import com.jxl.shareslidesmobile.rl.models.NetworkModel;
	import com.jxl.shareslidesmobile.rl.models.SlideshowModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class ObjectAnnouncedCommand extends Command
	{
		[Inject]
		public var event:NetworkModelEvent;
		
		[Inject]
		public var slideshowModel:SlideshowModel;
		
		[Inject]
		public var networkModel:NetworkModel;
		
		public function ObjectAnnouncedCommand()
		{
			super();
		}
		
		public override function execute():void
		{
			Debug.log("ObjectAnnouncedCommand::execute");
			//if(slideshowModel.containsObjectMetadata(event.metadata.info as String) == false)
			//if(networkModel.containsObjectMetadata(event.metadata) == false)
			//{
			//	Debug.log("\tI don't have this metadata, requesting it.");
				networkModel.localNetworkDiscovery.requestObject(event.metadata);
			//}
		}
	}
}