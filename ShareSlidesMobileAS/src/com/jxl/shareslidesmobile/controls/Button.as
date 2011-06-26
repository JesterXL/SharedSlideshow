package com.jxl.shareslidesmobile.controls
{

	import assets.Styles;

	import com.bit101.components.Component;
	import com.bit101.components.Style;

	import flash.display.DisplayObjectContainer;

	import flash.display.Graphics;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class Button extends Component
	{
		private var background:ButtonSymbol;
		private var textField:LabelField;
		private var hitAreaSprite:Sprite;

		private var _label:String;
		private var labelDirty:Boolean = false;
		private var _autoSize:Boolean = true;
		private var autoSizeDirty:Boolean = false;


		public function get autoSize():Boolean
		{
			return _autoSize;
		}

		public function set autoSize(value:Boolean):void
		{
			_autoSize = value;
			autoSizeDirty = true;
			invalidateProperties();
		}

		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			if(value !== _label)
			{
				_label = value;
				labelDirty = true;
				invalidateProperties();
			}
		}

		public function Button(parent:DisplayObjectContainer = null, label:String = "", clickHandler:Function=null)
		{
			super(parent);

			if(label && label.length > 0)
				this.label = label;

			if(clickHandler)
				addEventListener(MouseEvent.CLICK, clickHandler);
		}

		protected override function init():void
		{
			super.init();

			width 	= 106;
			height 	= 60;
			
			mouseChildren = false;
			tabChildren = false;
			buttonMode = useHandCursor = true;
		}

		protected override function addChildren():void
		{
			super.addChildren();

			background = new ButtonSymbol();
			addChild(background);

			textField = new LabelField();
			addChild(textField);
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.defaultTextFormat = Styles.BUTTON_LABEL;

			hitAreaSprite = new Sprite();
			addChild(hitAreaSprite);
			hitArea = hitAreaSprite;
		}

		protected override function commitProperties():void
		{
			super.commitProperties();

			if(labelDirty)
			{
				labelDirty = false;
				textField.text = _label;
				updateWidth();
			}
			
			if(autoSizeDirty)
			{
				autoSizeDirty = false;
				updateWidth();
			}
		}

		public override function draw():void
		{
			super.draw();
			
			background.width = width;
			background.y = (height / 2) - (background.height / 2);

			textField.x = (width / 2) - ((textField.textWidth + 4) / 2);
			textField.y = (height / 2) - ((textField.textHeight + 4) / 2);

			var g:Graphics = hitAreaSprite.graphics;
			g.clear();
			g.beginFill(0xFF0000, 0);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
		
		private function updateWidth():void
		{
			if(autoSize)
				width = Math.max(80, textField.textWidth + 4 + 8);
		}
	}
}

