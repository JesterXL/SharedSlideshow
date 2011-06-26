/**
 * Created by IntelliJ IDEA.
 * User: jesterxl
 * Date: 6/22/11
 * Time: 8:46 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.shareslides.rl.mediators
{
	import com.jxl.shareslides.events.model.SlideshowModelEvent;
	import com.jxl.shareslides.events.view.CreateSlideshowViewEvent;
	import com.jxl.shareslides.views.TransferView;
	import com.jxl.shareslides.views.transferviews.CreateSlideshowView;

	import org.robotlegs.mvcs.Mediator;

	public class TransferViewMediator extends Mediator
	{
		[Inject]
		public var transferView:TransferView;

		public function TransferViewMediator()
		{
		}

		public override function onRegister():void
		{
			super.onRegister();

			addContextListener(SlideshowModelEvent.SLIDESHOW_CREATED, onSlideshowCreated, SlideshowModelEvent);
		}

		private function onSlideshowCreated(event:SlideshowModelEvent):void
		{
			transferView.onReadyToTransfer();
		}
	}
}
