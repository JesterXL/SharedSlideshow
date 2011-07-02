package com.jxl.shareslides.rl.commands
{
	import com.jxl.shareslides.events.model.NetworkModelEvent;
	import com.jxl.shareslides.rl.models.NetworkModel;
	import com.jxl.shareslides.rl.models.SlideshowModel;
	import com.jxl.shareslides.vo.SlideshowVO;

	import org.robotlegs.mvcs.Command;
	
	public class ShareSlideshowWithClientCommand extends Command
	{
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
			Debug.log("ShareSlideshowWithClientCommand::execute, slideshowName: " + event.message.data.slideshowName);

			var slideshow:SlideshowVO = networkModel.getSlideshowByName(event.message.data.slideshowName);
			Debug.log("\tslideshow found by that name: " + slideshow);
			if(slideshow)
			{
				networkModel.localNetworkDiscovery.shareWithClient(slideshow, event.message.client.groupID, slideshow.name);
			}
		}
	}
}