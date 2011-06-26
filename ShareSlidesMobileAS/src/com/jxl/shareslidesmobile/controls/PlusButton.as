package com.jxl.shareslidesmobile.controls
{

	import com.bit101.components.Component;

	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;

	public class PlusButton extends SkinButton
	{
		public function PlusButton(parent:DisplayObjectContainer=null, clickHandler:Function=null)
		{
			super(parent, clickHandler, ButtonPlusUpSymbol, ButtonPlusOverSymbol, ButtonPlusDownSymbol);
		}

		protected override function init():void
		{
			super.init();

			width = 38;
			height = 39;
		}


	}
}

