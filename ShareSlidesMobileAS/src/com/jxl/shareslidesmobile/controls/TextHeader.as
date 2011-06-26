package com.jxl.shareslidesmobile.controls
{

import assets.Styles;

import com.bit101.components.Component;

	import flash.display.DisplayObjectContainer;

	import flash.text.TextField;
import flash.text.TextFieldAutoSize;

public class TextHeader extends Component
	{
		private var textHeaderSymbol:TextHeaderSymbol;
		private var textField:TextField;

		private var _label:String;
		private var labelDirty:Boolean = false;


		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			_label = value;
			labelDirty = true;
			invalidateProperties();
		}

		public function TextHeader(parent:DisplayObjectContainer=null, defaultLabel:String = "")
		{
			super(parent);
			label = defaultLabel;
		}

		protected override function init():void
		{
			super.init();

			width = 320;
			height = 25;
		}

		protected override function addChildren():void
		{
			super.addChildren();

			textHeaderSymbol = new TextHeaderSymbol();
			addChild(textHeaderSymbol);

			textField = new TextField();
			addChild(textField);
			textField.multiline = textField.wordWrap = false;
			textField.mouseWheelEnabled = textField.mouseEnabled = textField.tabEnabled = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.defaultTextFormat = Styles.TEXT_HEADER_LABEL;
		}

		protected override function commitProperties():void
		{
			super.commitProperties();

			if(labelDirty)
			{
				labelDirty = false;
				textField.text = _label;
			}

		}

		public override function draw():void
		{
			super.draw();

			textHeaderSymbol.width = width;

			textField.x = 5;
			textField.y = (height / 2) - ((textField.textHeight + 4) / 2);
		}
	}
}

