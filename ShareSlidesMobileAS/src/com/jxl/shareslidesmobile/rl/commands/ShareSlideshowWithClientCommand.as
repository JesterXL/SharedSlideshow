package com.jxl.shareslidesmobile.rl.commands
{
	import com.jxl.shareslides.vo.SlideshowVO;
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

			var slideshow:SlideshowVO = networkModel.getSlideshowByName(event.message.data.slideshowName);
			Debug.log("\tslideshow found by that name: " + slideshow);
			if(slideshow)
			{
				networkModel.localNetworkDiscovery.shareWithClient(slideshow, event.message.client.groupID, slideshow.name);
			}
		}
	}
}