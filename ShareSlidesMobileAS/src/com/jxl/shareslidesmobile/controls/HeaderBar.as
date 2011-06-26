package com.jxl.shareslidesmobile.controls
{

	import com.bit101.components.Component;

	import flash.display.DisplayObjectContainer;

	import flash.display.Sprite;

	public class HeaderBar extends Component
	{
		[Embed(source="/assets/images/header-bar.png", scaleGridLeft=40, scaleGridTop=0, scaleGridRight=760, scaleGridBottom=76)]
		private var HeaderBarImage:Class;

		private var image:Sprite;

		public function HeaderBar(parent:DisplayObjectContainer=null)
		{
			super(parent);
		}

		protected override function init():void
		{
			super.init();

			width 	= 762;
			height 	= 74;
		}

		protected override function addChildren():void
		{
			super.addChildren();

			image = new HeaderBarImage();
			addChild(image);
		}

		protected override function commitProperties():void
		{
			super.commitProperties();

		}

		public override function draw():void
		{
			super.draw();

			image.width = width;
		}
	}
}

