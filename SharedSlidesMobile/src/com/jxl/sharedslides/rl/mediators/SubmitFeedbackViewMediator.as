package com.jxl.sharedslides.rl.mediators
{
	import com.jxl.sharedslides.views.SubmitFeedbackView;
	import com.jxl.shareslides.services.SendFeedbackEmailService;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class SubmitFeedbackViewMediator extends Mediator
	{
		
		[Inject]
		public var view:SubmitFeedbackView;
		
		[Inject]
		public var service:SendFeedbackEmailService;
		
		public function SubmitFeedbackViewMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			addViewListener("submitFeedback", onSendFeedback);
		}
		
		private function onSendFeedback(event:Event):void
		{
			service.sendFeedbackEmail(view.feedbackTextArea.text);
		}
	}
}