
package com.jxl.shareslidesmobile.rl.commands
{

	import com.jxl.shareslidesmobile.events.services.ReadSavedSlideshowsServiceEvent;
	import com.jxl.shareslidesmobile.rl.models.SavedSlideshowsModel;

	import mx.collections.ArrayCollection;

	import org.robotlegs.mvcs.Command;

	public class UpdateSavedSlideshowsCommand extends Command
	{
		[Inject]
		public var event:ReadSavedSlideshowsServiceEvent;

		[Inject]
		public var model:SavedSlideshowsModel;

		public function UpdateSavedSlideshowsCommand()
		{
			super();
		}

		public override function execute():void
		{
			model.slideshows = new ArrayCollection(event.slideshows);
		}

	}
}

