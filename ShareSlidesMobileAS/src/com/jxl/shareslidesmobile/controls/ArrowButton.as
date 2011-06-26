package com.jxl.shareslidesmobile.controls
{

	import flash.display.DisplayObjectContainer;


	public class ArrowButton extends SkinButton
	{
		public function ArrowButton(parent:DisplayObjectContainer=null, clickHandler:Function=null)
		{
			super(parent, clickHandler, ButtonArrowUpSymbol, ButtonArrowOverSymbol, ButtonArrowDownSymbol);
		}

		protected override function init():void
		{
			super.init();

			width = 38;
			height = 39;
		}



	}
}

