package com.jxl.shareslidesmobile.controls
{
	
	import assets.Styles;

	import com.bit101.components.Component;

	import flash.events.KeyboardEvent;

	import flash.text.TextFieldType;

	//import assets.images.InputTextBackground;
	
	import com.bit101.components.InputText;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class InputText extends Component
	{
		private var background:TextInputSymbol;
		private var textField:TextField;
		private var clickField:TextField;

		private var _text:String = "";
		private var textDirty:Boolean = false;


		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			if(value !== _text)
			{
				_text = (value != null) ? value : "";
				textDirty = true;
				invalidateProperties();
			}
		}

		public function InputText(parent:DisplayObjectContainer=null, text:String="")
		{
			super(parent);
			text = _text;
		}

		protected override function init():void
		{
			super.init();

			setSize(224, 47);

			this.name = "inputText";
		}

		protected override function addChildren():void
		{
			super.addChildren();
			
			background = new TextInputSymbol();
			addChild(background);

			textField = new TextField();
			addChild(textField);
			textField.type = TextFieldType.INPUT;
			textField.defaultTextFormat = Styles.FORM_INPUT;
			textField.name = "inputTextField";
			//textField.embedFonts = true;
			//textField.antiAliasType = AntiAliasType.ADVANCED;
			
			clickField = new TextField();
			addChild(clickField);
			clickField.name = "clickField";
			clickField.type = TextFieldType.INPUT;
			clickField.addEventListener(Event.CHANGE, onClickFieldChange);
			clickField.addEventListener(Event.CLEAR, onClickFieldClear);
			clickField.addEventListener(Event.CUT, onClickFieldCutOrPaste);
			clickField.addEventListener(Event.PASTE, onClickFieldCutOrPaste);
			clickField.addEventListener(TextEvent.TEXT_INPUT, onClickFieldChange);
			clickField.alpha = 0;


		}

		protected override function commitProperties():void
		{
			super.commitProperties();

			if(textDirty)
			{
				textDirty = false;
				textField.text = _text;
				clickField.text = _text;
			}
		}

		public override function draw():void
		{
			super.draw();

			background.width =  width;
			//background.height = height;
			
            textField.width = width - 20;
			textField.height = height;

			textField.x = 12;
			textField.y = 9;
			
			//textField.border = true;
			//textField.borderColor = 0xFF0000;
			//textField.background = true;
			//textField.backgroundColor = 0xFFFFFF;

			clickField.x = 0;
			clickField.y = 0;
			clickField.width = width;
			clickField.height = height;
		}
		
		private function onClickFieldChange(event:Event):void
		{
			_text = clickField.text;
			textField.text = _text;
		}
		
		private function onClickFieldClear(event:Event):void
		{
			_text = "";
			textField.text = _text;
		}
		
		private function onClickFieldCutOrPaste(event:Event):void
		{
			_text = clickField.text;
			textField.text = _text;
		}
	}
}