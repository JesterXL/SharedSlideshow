package com.jxl.shareslides.skins
{
	import flash.display.DisplayObject;
	
	import mx.core.UIComponent;
	
	[DefaultProperty("children")]
	public class FlashSymbolContainer extends UIComponent
	{
		
		private var _children:Array;
		private var childrenDirty:Boolean = false;
		
		public function get children():Array { return _children; }
		public function set children(value:Array):void
		{
			if(value != null)
			{
				_children = value;
				childrenDirty = true;
				invalidateProperties();
			}
		}
		public function FlashSymbolContainer()
		{
			super();
			
			width 	= 300;
			height 	= 200;
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(childrenDirty)
			{
				childrenDirty = false;
				redraw();
			}
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			/*
			var len:int = numChildren;
			while(len--)
			{
				var display:DisplayObject = getChildAt(len);
				display.width = width;
				display.height = height;
			}
			*/
		}
		
		private function redraw():void
		{
			if(_children == null)
				return;
			
			var len:int = _children.length;
			if(len == 0)
				return;
			
			for(var index:int = 0; index < len; index++)
			{
				var obj:DisplayObject = _children[index] as DisplayObject;
				if(obj == null)
				{
					throw new Error("Children must be of type DisplayObject.");
					return;
				}
				
				if(obj.parent)
					obj.parent.removeChild(obj);
				
				addChild(obj);
			}
		}
	}
}