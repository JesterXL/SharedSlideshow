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
	import com.jxl.shareslides.rl.models.NetworkModel;
	import com.jxl.shareslides.rl.models.SlideshowModel;

	import org.robotlegs.mvcs.Command;

	public class ShareSlideshowCommand extends Command
	{
		[Inject]
		public var networkModel:NetworkModel;

		[Inject]
		public var slideshowModel:SlideshowModel;

		public function ShareSlideshowCommand()
		{
		}

		public override function execute():void
		{
			networkModel.shareSlideshow(slideshowModel.builtSlidehow);
		}


	}
}
