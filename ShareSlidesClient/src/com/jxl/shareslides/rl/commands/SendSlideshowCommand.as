/**
 * Created by IntelliJ IDEA.
 * User: jesterxl
 * Date: 6/22/11
 * Time: 8:38 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.shareslides.rl.commands
{
	import com.jxl.shareslides.events.view.PhoneItemEvent;
	import com.jxl.shareslides.rl.models.SlideshowModel;
	import com.jxl.shareslides.rl.models.TransferModel;

	import org.robotlegs.mvcs.Command;

	public class SendSlideshowCommand extends Command
	{
		[Inject]
		public var event:PhoneItemEvent;

		[Inject]
		public var transferModel:TransferModel;

		[Inject]
		public var slideshowModel:SlideshowModel;

		public function SendSlideshowCommand()
		{
		}

		public override function execute():void
		{
			transferModel.sendSlideshow(slideshowModel.builtSlidehow, event.client);
		}


	}
}
