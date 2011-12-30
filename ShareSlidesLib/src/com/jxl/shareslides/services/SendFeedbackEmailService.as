package com.jxl.shareslides.services
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;

	public class SendFeedbackEmailService
	{
		public function SendFeedbackEmailService()
		{
		}
		
		public function sendFeedbackEmail(feedback:String):void
		{
			Debug.log("SendFeedbackEmailService::sendFeedbackEmail");
			const NEWLINE:String = "%0A";
			
			var str:String = "mailto:slideshare@jessewarden.com";
			str 				+= "?subject=ShareSlides Feedback&body=";
			str 				+= feedback + NEWLINE + NEWLINE;
			str					+= escape("-- capabilities: " + Capabilities.serverString) + NEWLINE;
			//str					+= escape("errors: " + Debug.errorsString) + NEWLINE;
			
			try
			{
				Debug.log("message str: " + str);
				navigateToURL(new URLRequest(str));
			}
			catch(err:Error)
			{
				Debug.log("SendErrorEmailService::sendErrorEmail, err: " + err);
			}
		}
	}
}