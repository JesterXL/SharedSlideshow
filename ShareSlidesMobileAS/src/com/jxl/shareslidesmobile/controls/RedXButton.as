package com.jxl.shareslidesmobile.controls
{

	import flash.display.DisplayObjectContainer;

	public class RedXButton extends SkinButton
	{
		public function RedXButton(parent:DisplayObjectContainer=null, clickHandler:Function=null)
		{
			super(parent, clickHandler, ButtonCloseUpSymbol, ButtonCloseOverSymbol, ButtonCloseDownSymbol);
		}

		protected override function init():void
		{
			super.init();

			width = 38;
			height = 39;
		}

	}
}

