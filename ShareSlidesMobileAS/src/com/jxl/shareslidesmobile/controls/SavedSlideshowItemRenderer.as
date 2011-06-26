package com.jxl.shareslidesmobile.controls
{

	import com.bit101.components.Component;
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.jxl.shareslidesmobile.events.view.SavedSlideshowItemRendererEvent;

	import flash.events.MouseEvent;

	public class SavedSlideshowItemRenderer extends DefaultDroidItemRenderer
	{

		private var redXButton:RedXButton;
		private var arrowButton:ArrowButton;

		public function SavedSlideshowItemRenderer()
		{
			super();
		}

		protected override function init():void
		{
			super.init();

			this.mouseChildren = tabChildren = true;
			buttonMode = useHandCursor = true;

			addEventListener(MouseEvent.CLICK, onJoin);
		}

		protected override function addChildren():void
		{
			super.addChildren();

			arrowButton = new ArrowButton();
			addChild(arrowButton);
		}

		protected override function commitProperties():void
		{
			if(dataDirty)
			{
				updateEditMode();
			}

			super.commitProperties();


		}

		private function updateEditMode():void
		{
			if(data && data is SlideshowVO && SlideshowVO(data).edit)
			{
				if(redXButton == null)
					redXButton = new RedXButton(this, onDelete);

				if(redXButton.parent == null)
					addChild(redXButton);

			}
			else
			{
				if(redXButton && redXButton.parent)
					removeChild(redXButton)
			}
			invalidateDraw();
		}

		public override function draw():void
		{
			if(redXButton && redXButton.parent)
			{
				super.draw();

				redXButton.x = 8;
				redXButton.y = (height / 2) - (redXButton.height / 2);

				labelField.x = redXButton.x + redXButton.width + 8;
			}
			else
			{
				super.draw();
			}



			arrowButton.x = width - (arrowButton.width + 4);
			arrowButton.y = (height / 2) - (arrowButton.height / 2);

		}

		private function onJoin(event:MouseEvent):void
		{
			var evt:SavedSlideshowItemRendererEvent = new SavedSlideshowItemRendererEvent(SavedSlideshowItemRendererEvent.JOIN_SLIDESHOW);
			evt.slideshow = data as SlideshowVO;
			dispatchEvent(evt);
		}

		private function onDelete(event:MouseEvent):void
		{
			var evt:SavedSlideshowItemRendererEvent = new SavedSlideshowItemRendererEvent(SavedSlideshowItemRendererEvent.DELETE_SLIDESHOW);
			evt.slideshow = data as SlideshowVO;
			dispatchEvent(evt);
		}
	}
}

