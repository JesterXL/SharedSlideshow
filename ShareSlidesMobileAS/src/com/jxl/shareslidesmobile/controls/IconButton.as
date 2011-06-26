package com.jxl.shareslidesmobile.controls
{
import assets.Styles;

import com.bit101.components.Component;
import com.jxl.minimalcomps.ImageLoader;
import com.jxl.minimalcomps.events.ImageLoaderEvent;

import flash.display.BlendMode;

import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

    [Event(name="change", type="flash.events.Event")]
	public class IconButton extends Component
	{
		private var _selected:Boolean = false;
		private var selectedDirty:Boolean = false;
		private var _label:String;
		private var labelDirty:Boolean = false;
		private var _icon:*;
		private var iconDirty:Boolean = false;

		private var imageLoader:ImageLoader;
		private var textField:TextField;
		private var overlay:ButtonBarSelectionSymbol;

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if(_selected !== value)
			{
				_selected = value;
				selectedDirty = true;
				invalidateProperties();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}


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


		public function get icon():*
		{
			return _icon;
		}

		public function set icon(value:*):void
		{
			_icon = value;
			iconDirty = true;
			invalidateProperties();
		}

		public function IconButton(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		protected override function init():void
		{
			super.init();
			
			width 	= 90;
			height 	= 57;

			this.addEventListener(MouseEvent.CLICK, onClicked);
			this.mouseChildren = false;
			this.tabChildren = false;
			this.buttonMode = this.useHandCursor = true;
		}

		protected override function addChildren():void
		{
			super.addChildren();

			imageLoader = new ImageLoader();
			addChild(imageLoader);
			imageLoader.addEventListener(ImageLoaderEvent.IMAGE_LOAD_COMPLETE, onImageLoadComplete);

			textField = new TextField();
			addChild(textField);
			textField.multiline = textField.wordWrap = false;
			textField.selectable = textField.mouseWheelEnabled = textField.mouseEnabled = false;
			textField.defaultTextFormat = Styles.BUTTON_BAR_LABEL;
			textField.autoSize = TextFieldAutoSize.CENTER;
		}

		protected override function commitProperties():void
		{
			super.commitProperties();

			if(selectedDirty)
			{
				selectedDirty = false;
				if(selected)
				{
					if(overlay == null)
					{
						overlay = new ButtonBarSelectionSymbol();
					}
					addChildAt(overlay, 0);
					overlay.blendMode = BlendMode.OVERLAY;
					overlay.visible = false;
					this.invalidateDraw();
				}
				else
				{
					if(overlay && overlay.parent)
						removeChild(overlay);
				}
			}

			if(labelDirty)
			{
				labelDirty = false;
				textField.text = _label;
			}

			if(iconDirty)
			{
				iconDirty = false;
				imageLoader.source = _icon;
			}
		}

		public override function draw():void
		{
			super.draw();

			var g:Graphics = graphics;
			g.clear();
			g.beginFill(0x000000, 0);
			g.drawRect(0, 0, width,  height);
			g.endFill();

			imageLoader.x = (width / 2) - (imageLoader.width / 2);
			textField.y = height - (textField.textHeight + 4);

			if(overlay)
			{
				overlay.width = width;
				overlay.height = height;
				overlay.visible = true;
			}
		}

		private function onImageLoadComplete(event:ImageLoaderEvent):void
		{
			invalidateDraw();
		}

		private function onClicked(event:MouseEvent):void
		{
			selected = !selected;
		}
		
	}
}