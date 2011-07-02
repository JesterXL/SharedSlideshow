package com.jxl.shareslidesmobile.views.mainviews.startslideshowviews
{

	import com.bit101.components.Component;
	import com.jxl.shareslidesmobile.controls.Button;
	import com.jxl.shareslidesmobile.controls.InputText;
	import com.jxl.shareslidesmobile.controls.LabelField;
	import com.jxl.shareslidesmobile.controls.TextHeader;
	import com.jxl.shareslidesmobile.events.view.ConfirmPasscodeViewEvent;
	import com.jxl.shareslidesmobile.views.MobileView;

	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	[Event(name="submitPasscode", type="com.jxl.shareslidesmobile.events.view.ConfirmPasscodeViewEvent")]
	public class ConfirmPasscodeView extends MobileView
	{

		private var header:TextHeader;
		private var labelField:LabelField;
		private var passcodeInputText:InputText;
		private var confirmButton:Button;

		public function ConfirmPasscodeView(parent:DisplayObjectContainer = null)
		{
			super(parent);
		}

		protected override function init():void
		{
			super.init();

			width = 480;
			height = 800;
		}

		protected override function addChildren():void
		{
			super.addChildren();

			header = new TextHeader(this, "Confirm Passcode");

			labelField = new LabelField(this, "Passcode:");

			passcodeInputText = new InputText(this);

			confirmButton = new Button(this, "Submit", onConfirmPasscode);

		}

		protected override function commitProperties():void
		{
			super.commitProperties();


		}

		public override function draw():void
		{
			super.draw();

			header.width = width;

			labelField.x = 8;
			labelField.y = header.y + header.height + 8;

			passcodeInputText.x = labelField.x;
			passcodeInputText.y = labelField.y + labelField.textHeight + 4 + 8;
			passcodeInputText.width = width - (passcodeInputText.x * 2) ;

			confirmButton.move(passcodeInputText.x, passcodeInputText.y + passcodeInputText.height + 8);
		}

		private function onConfirmPasscode(event:MouseEvent):void
		{
			var evt:ConfirmPasscodeViewEvent = new ConfirmPasscodeViewEvent(ConfirmPasscodeViewEvent.SUBMIT_PASSCODE);
			evt.passcode = passcodeInputText.text;
			dispatchEvent(evt);
		}
	}
}

