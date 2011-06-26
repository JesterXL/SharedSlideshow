package com.jxl.shareslidesmobile.views.mainviews.joinviewclasses
{

	import com.bit101.components.Component;
	import com.jxl.shareslidesmobile.controls.Button;
	import com.jxl.shareslidesmobile.controls.InputText;
	import com.jxl.shareslidesmobile.controls.LabelField;
	import com.jxl.shareslidesmobile.events.view.SetNameViewEvent;

	import flash.events.MouseEvent;

	import flash.text.TextField;

	[Event(name="setName", type="com.jxl.shareslidesmobile.events.view.SetNameViewEvent")]
	public class SetNameView extends Component
	{

		private var labelField:LabelField;
		private var inputField:InputText;
		private var loginButton:Button;

		private var _clientName:String = "";
		private var clientNameDirty:Boolean = false;


		public function get clientName():String
		{
			return _clientName;
		}

		public function set clientName(value:String):void
		{
			if(value !== _clientName)
			{
				_clientName = value;
				clientNameDirty = true;
				invalidateProperties();
			}
		}

		public function SetNameView()
		{
			super();
		}

		protected override function init():void
		{
			super.init();

			width = 444;
			height = 47;
		}

		protected override function addChildren():void
		{
			super.addChildren();

			labelField = new LabelField();
			addChild(labelField);
			labelField.text = "Username:";

			inputField = new InputText();
			addChild(inputField);

			loginButton = new Button();
			addChild(loginButton);
			loginButton.addEventListener(MouseEvent.CLICK, onLogin);
			loginButton.label = "Login";
		}

		protected override function commitProperties():void
		{
			super.commitProperties();

			if(clientNameDirty)
			{
				clientNameDirty = false;
				inputField.text = _clientName;
			}

		}

		public override function draw():void
		{
			super.draw();

			const HEIGHT2:Number = height / 2;

			labelField.y = HEIGHT2 - (labelField.height / 2);

			loginButton.x = width - loginButton.width;
			loginButton.y = HEIGHT2 - (loginButton.height / 2);

			const MARGIN:int = 8;
			inputField.width = width - (MARGIN * 2) - loginButton.width - labelField.width;
			inputField.x = labelField.x + labelField.width + MARGIN;
			inputField.y = HEIGHT2 - (inputField.height / 2);
		}

		private function onLogin(event:MouseEvent):void
		{
			var evt:SetNameViewEvent = new SetNameViewEvent(SetNameViewEvent.SET_NAME);
			evt.name = inputField.text;
			dispatchEvent(evt);
		}
	}
}

