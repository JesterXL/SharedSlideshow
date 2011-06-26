package com.jxl.shareslidesmobile.rl.commands
{
	import com.jxl.shareslidesmobile.events.model.NetworkModelEvent;
	import com.jxl.shareslidesmobile.rl.models.NetworkModel;
	import com.jxl.shareslidesmobile.rl.models.SlideshowModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class ShareSlideshowWithClientCommand extends Command
	{
		[Inject]
		public var slideshowModel:SlideshowModel;
		
		[Inject]
		public var networkModel:NetworkModel;
		
		[Inject]
		public var event:NetworkModelEvent;
		
		public function ShareSlideshowWithClientCommand()
		{
			super();
		}
		
		public override function execute():void
		{
			Debug.log("ShareSlideshowWithClientCommand::execute");
			if(slideshowModel.slideshow)
			{
				networkModel.localNetworkDiscovery.shareWithClient(slideshowModel.slideshow, event.message.client.groupID, slideshowModel.slideshow.name);
			}
		}
	}
}