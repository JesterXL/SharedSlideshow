package com.jxl.shareslidesmobile.controls
{
	import assets.Styles;

	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class HeaderField extends TextField
	{
		public function HeaderField(parent:DisplayObjectContainer=null, defaultText:String = "")
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
			defaultTextFormat = Styles.HEADER_LABEL;

			if(defaultText && defaultText.length > 0)
				text = defaultText;

			filters = Styles.HEADER_LABEL_FILTERS.concat();
		}

	}
}
