package com.jxl.shareslidesmobile.controls
{

	import assets.Styles;

	import flash.display.DisplayObjectContainer;

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class LabelField extends TextField
	{


		public override function set text(value:String):void
		{
			 super.text = (value != null) ? value : "";
		}

		public function LabelField(parent:DisplayObjectContainer=null, defaultText:String = "")
		{
			super();
			if(parent)
				parent.addChild(this);


			init(defaultText);
		}

		private function init(defaultText:String):void
		{
			wordWrap = multiline = false;
			selectable = false;
			mouseEnabled = mouseWheelEnabled = tabEnabled = false;
			autoSize = TextFieldAutoSize.LEFT;
			defaultTextFormat = Styles.LABEL_FIELD;

			if(defaultText && defaultText.length > 0)
				text = defaultText;
		}

	}
}

