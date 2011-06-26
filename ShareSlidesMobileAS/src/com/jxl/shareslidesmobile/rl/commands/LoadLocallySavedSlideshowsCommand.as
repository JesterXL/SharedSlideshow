

package com.jxl.shareslidesmobile.rl.commands
{

	import com.jxl.shareslidesmobile.events.controller.LoadLocallySavedSlideshowsEvent;
	import com.jxl.shareslidesmobile.rl.models.SavedSlideshowsModel;
	import com.jxl.shareslidesmobile.rl.services.ReadSavedSlideshowsService;

	import org.robotlegs.mvcs.Command;

	public class LoadLocallySavedSlideshowsCommand extends Command
	{
		[Inject]
		public var event:LoadLocallySavedSlideshowsEvent;

		[Inject]
		public var service:ReadSavedSlideshowsService;

		public function LoadLocallySavedSlideshowsCommand()
		{
			super();
		}

		public override function execute():void
		{
			 service.readSavedSlideshows();
		}

	}
}

