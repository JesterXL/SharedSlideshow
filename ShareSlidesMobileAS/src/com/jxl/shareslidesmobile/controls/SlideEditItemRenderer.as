package com.jxl.shareslidesmobile.controls
{

	import com.bit101.components.Component;
	import com.jxl.minimalcomps.ImageLoader;
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.jxl.shareslidesmobile.events.view.SlideEditItemRendererEvent;

	import flash.display.Graphics;

	import flash.events.MouseEvent;

	import flash.filesystem.File;

	import spark.components.Image;

	public class SlideEditItemRenderer extends DefaultDroidItemRenderer
	{

		private var image:ImageLoader;
		private var deleteButton:RedXButton;

		public function SlideEditItemRenderer()
		{
			super();
		}

		protected override function init():void
		{
			super.init();

		}

		protected override function addChildren():void
		{
			super.addChildren();

			image = new ImageLoader(this);
			image.scaleContent = true;

			deleteButton = new RedXButton(this, onDelete);
		}

		protected override function commitProperties():void
		{
			if(dataDirty)
			{
				dataDirty = false;
				if(data && data is File)
				{
					var file:File = data as File;
					image.source = file.url;
				}
				else
				{
					image.source = null;
				}
			}

			super.commitProperties();



		}

		protected override function updateLabelFromData():void
		{
			if(data && data is File)
			{
				var file:File = data as File;
				labelField.text = file.name;
			}
			else
			{
				labelField.text = "";
			}
		}

		public override function draw():void
		{
			super.draw();

			image.setSize(48, 48);
			image.x = 8;
			image.y = 8;

			labelField.x = image.x + image.width + 8;
			labelField.width = width - labelField.x - deleteButton.width;

			deleteButton.x = width - (deleteButton.width + 8);
			deleteButton.y = (height / 2) - (deleteButton.height / 2);
		}

		private function onDelete(event:MouseEvent):void
		{
			dispatchEvent(new SlideEditItemRendererEvent(SlideEditItemRendererEvent.DELETE_SLIDE, data as File));
		}
	}
}

