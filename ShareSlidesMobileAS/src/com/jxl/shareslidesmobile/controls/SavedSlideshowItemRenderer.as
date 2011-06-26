package com.jxl.shareslidesmobile.controls
{

	import com.bit101.components.Component;
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.jxl.shareslidesmobile.events.view.SavedSlideshowItemRendererEvent;

	import flash.events.MouseEvent;

	public class SavedSlideshowItemRenderer extends DefaultDroidItemRenderer
	{

		private var arrowButton:ArrowButton;

		public function SavedSlideshowItemRenderer()
		{
			super();
		}

		protected override function init():void
		{
			super.init();

			this.mouseChildren = tabChildren = false;
			buttonMode = useHandCursor = true;

			addEventListener(MouseEvent.CLICK, onJoin);
		}

		protected override function addChildren():void
		{
			super.addChildren();

			arrowButton = new ArrowButton();
			addChild(arrowButton);
		}


		public override function draw():void
		{
			super.draw();

			arrowButton.x = width - (arrowButton.width + 4);
			arrowButton.y = (height / 2) - (arrowButton.height / 2);
		}

		private function onJoin(event:MouseEvent):void
		{
			var evt:SavedSlideshowItemRendererEvent = new SavedSlideshowItemRendererEvent(SavedSlideshowItemRendererEvent.JOIN_SLIDESHOW);
			evt.slideshow = data as SlideshowVO;
			dispatchEvent(evt);
		}
	}
}

