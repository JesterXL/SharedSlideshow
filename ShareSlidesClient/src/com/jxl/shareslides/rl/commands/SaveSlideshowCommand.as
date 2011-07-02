/**
 * Created by IntelliJ IDEA.
 * User: jesterxl
 * Date: 6/22/11
 * Time: 7:51 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.shareslides.rl.commands
{
	import com.jxl.shareslides.events.view.CreateSlideshowViewEvent;
	import com.jxl.shareslides.rl.models.SlideshowModel;

	import org.robotlegs.mvcs.Command;

	public class SaveSlideshowCommand extends Command
	{

		[Inject]
		public var slideshowModel:SlideshowModel;

		[Inject]
		public var event:CreateSlideshowViewEvent;

		public function SaveSlideshowCommand()
		{
		}

		public override function execute():void
		{
			Debug.log("SaveSlideshowCommand::execute");
			slideshowModel.saveSlideshow(event.slideshowName, event.slides, event.passcode);
		}
	}
}
