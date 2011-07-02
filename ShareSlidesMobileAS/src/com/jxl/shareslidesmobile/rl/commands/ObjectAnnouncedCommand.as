package com.jxl.shareslidesmobile.rl.commands
{
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.jxl.shareslidesmobile.events.model.NetworkModelEvent;
	import com.jxl.shareslidesmobile.rl.models.NetworkModel;
	import com.jxl.shareslidesmobile.rl.models.SlideshowModel;
	import com.jxl.shareslidesmobile.rl.services.SaveSlideshowService;
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;

	import org.robotlegs.mvcs.Command;
	
	public class ObjectAnnouncedCommand extends AsyncCommand
	{
		[Inject]
		public var event:NetworkModelEvent;
		
		[Inject]
		public var slideshowModel:SlideshowModel;
		
		[Inject]
		public var networkModel:NetworkModel;

		[Inject]
		public var saveSlideshowService:SaveSlideshowService;

		private var metadata:ObjectMetadataVO;

		public function ObjectAnnouncedCommand()
		{
			super();
		}

		// [jwarden 7.2.2011] TODO/FIXME: Memory leak waiting to happen... (<-- see what I did thar)
		public override function execute():void
		{
			Debug.log("ObjectAnnouncedCommand::execute");
			metadata = event.metadata;
			networkModel.localNetworkDiscovery.requestObject(metadata);
			event.metadata.completedSignal.add(onComplete);
		}

		private function onComplete():void
		{
			if(metadata.object && metadata.object is SlideshowVO)
			{
				saveSlideshowService.saveSlideshow(metadata.object as SlideshowVO);
			}
			metadata = null;
			finish();
		}
	}
}