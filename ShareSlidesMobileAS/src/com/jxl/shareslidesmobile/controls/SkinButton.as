package com.jxl.shareslidesmobile.controls
{

	import com.bit101.components.Component;

	import flash.display.DisplayObject;

	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SkinButton extends Component
	{

		protected static const STATE_UP:String = "up";
		protected static const STATE_OVER:String = "over";
		protected static const STATE_DOWN:String = "down";

		private var upClass:Class;
		private var overClass:Class;
		private var downClass:Class;

		private var up:DisplayObject;
		private var over:DisplayObject;
		private var down:DisplayObject;

		private var mouseOver:Boolean = false;
		private var mouseClicked:Boolean = false;

		public function SkinButton(parent:DisplayObjectContainer=null, clickHandler:Function=null, upSkin:Class=null, overSkin:Class=null, downSkin:Class=null)
		{
			super(parent);

			if(clickHandler)
				addEventListener(MouseEvent.CLICK, clickHandler);

			upClass = upSkin;
			overClass = overSkin;
			downClass = downSkin;
			addSkins();
		}

		protected override function init():void
		{
			super.init();

			width = 100;
			height = 100;

			mouseChildren = tabChildren = false;
			buttonMode = useHandCursor = true;

			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			currentState = STATE_UP;
		}

		protected function addSkins():void
		{
			if(upClass)
			{
				up = new upClass();
				addChild(up);
			}
		}

		protected override function commitProperties():void
		{
			super.commitProperties();

		}

		public override function draw():void
		{
			super.draw();
			if(width < 60 || height < 60)
			{
				const halfW:Number = width / 2;
				const halfH:Number = height / 2;

				var g:Graphics = graphics;
				g.clear();
				g.beginFill(0x000000, 0);
				g.drawRect(-halfW, -halfH, width,  height);
				g.endFill();
			}
		}

		private function onRollOver(event:MouseEvent):void
		{
			mouseOver = true;
			currentState = STATE_OVER;
		}

		private function onRollOut(event:MouseEvent):void
		{
			mouseOver = false;
			if(mouseClicked == false)
			{
				currentState = STATE_UP;
			}
			else
			{
				currentState = STATE_DOWN;
			}
		}

		private function onMouseDown(event:MouseEvent):void
		{
			mouseClicked = true;
			currentState = STATE_DOWN;
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
		}

		private function onMouseUp(event:MouseEvent):void
		{
			mouseClicked = false;
			if(mouseOver)
			{
				currentState = STATE_OVER;
			}
			else
			{
				currentState = STATE_UP;
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		protected override function onEnterState(state:String):void
		{
			switch(state)
			{
				case STATE_UP:
					if(up.parent == null)
						addChild(up);
				break;

				case STATE_OVER:
					if(over == null)
						over = new overClass();

					if(over.parent == null)
						addChild(over);
				break;

				case STATE_DOWN:
					if(down == null)
						down = new downClass();

					if(down.parent == null)
						addChild(down);
				break;
			}
		}

		protected override function onExitState(oldState:String):void
		{
			switch(oldState)
			{
				case STATE_UP:
				    if(up.parent)
						removeChild(up);
				break;

				case STATE_OVER:
					if(over && over.parent)
						removeChild(over);
				break;

				case STATE_DOWN:
					if(down && down.parent)
						removeChild(down);

				break;
			}
		}
	}
}

