/**
 * Created by IntelliJ IDEA.
 * User: jesterxl
 * Date: 6/22/11
 * Time: 8:31 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.shareslides.rl.mediators
{
	import com.jxl.shareslides.events.view.PhoneItemEvent;
	import com.jxl.shareslides.rl.models.TransferModel;
	import com.jxl.shareslides.views.transferviews.SendToPhoneView;

	import org.robotlegs.mvcs.Mediator;

	public class SendToPhoneViewMediator extends Mediator
	{
		[Inject]
		public var sendToPhoneView:SendToPhoneView;

		[Inject]
		public var transferModel:TransferModel;

		public function SendToPhoneViewMediator()
		{
		}

		public override function onRegister():void
		{
			super.onRegister();

			addViewListener(PhoneItemEvent.SEND_SLIDES, onSendSlides, PhoneItemEvent);

			sendToPhoneView.clients = transferModel.localNetworkDiscovery.clients;
		}

		private function onSendSlides(event:PhoneItemEvent):void
		{
			dispatch(event);
		}
	}
}
