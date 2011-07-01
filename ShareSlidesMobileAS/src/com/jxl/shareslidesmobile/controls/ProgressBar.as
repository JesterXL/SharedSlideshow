package com.jxl.shareslidesmobile.controls
{
	import com.bit101.components.Component;

	import flash.display.Graphics;
	import flash.display.MovieClip;
	
	import mx.core.UIComponent;
	
	public class ProgressBar extends Component
	{
		private var symbol:ProgressBarSymbol;
		
		private var _indeterminate:Boolean = false;
		private var indeterminateDirty:Boolean = false;
		private var _progress:Number = 0;
		private var progressDirty:Boolean = false;
		
		public function get indeterminate():Boolean { return _indeterminate; }
		public function set indeterminate(value:Boolean):void
		{
			_indeterminate = value;
			indeterminateDirty = true;
			invalidateProperties();
		}
		
		public function get progress():Number { return _progress; }
		public function set progress(value:Number):void
		{
			_progress = value;
			progressDirty = true;
			invalidateProperties();
		}
		
		public function ProgressBar()
		{
			super();
		}
		
		protected override function init():void
		{
			super.init();

			width = 100;
			height = 16;
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			symbol = new ProgressBarSymbol();
			addChild(symbol);
			symbol.stop();
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(indeterminateDirty)
			{
				indeterminateDirty = false;
				if(_indeterminate)
				{
					symbol.gotoAndStop(1);
					progressDirty = false;
					this.invalidateDraw();
				}
				else
				{
					progressDirty = true;
				}
			}
			
			if(progressDirty)
			{
				progressDirty = false;
				var progressFrame:uint = Math.max(2, Math.floor(_progress * 100));
				symbol.gotoAndStop(progressFrame);
			}
		}
		
		public override function draw():void
		{
			super.draw();
			
			if(this.indeterminate)
			{
				symbol.width = width * 2.7;
				symbol.height = height;
			}
			else
			{
				symbol.width = width;
				symbol.height = height;
			}
			
			/*
			var g:Graphics = graphics;
			g.clear();
			g.lineStyle(4, 0xFF0000);
			g.drawRect(0, 0, width, height);
			g.endFill();
			*/
		}
		
	}
}