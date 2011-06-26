
package com.jxl.shareslidesmobile.controls
{
	import assets.Styles;
	
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Event(name="change", type="flash.events.Event")]
	public class Checkbox extends Component
	{
		private var openImage:CheckboxUpSymbol;
		private var selectedImage:CheckboxSelectedSymbol;
		private var labelField:LabelField;
		
		private var _label:String = "";
		private var labelDirty:Boolean = false;
		private var _selected:Boolean = false;
		
		public function get label():String { return _label; }
		public function set label(value:String):void
		{
			_label = value;
			labelDirty = true;
			invalidateProperties();
		}
		
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void
		{
			_selected = value;
			invalidateDraw();
		}
		
		public function Checkbox(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);

            setSize(33, 33);
		}
		
		protected override function init():void
		{
			super.init();
			
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			openImage = new CheckboxUpSymbol();
			
			selectedImage = new CheckboxSelectedSymbol();
		
			labelField = new LabelField();
			addChild(labelField);
			
			addEventListener(MouseEvent.CLICK, onClicked);
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(labelDirty)
			{
				labelDirty = false;
				labelField.text = _label;
				callNextFrame(invalidateDraw);
			}
		}
		
		public override function draw():void
		{
			super.draw();
			
			if(_selected == false)
			{
				if(contains(openImage) == false) addChild(openImage);
				if(contains(selectedImage)) removeChild(selectedImage)
			}
			else
			{
				if(contains(selectedImage) == false) addChild(selectedImage);
				if(contains(openImage)) removeChild(openImage)
			}
			
			labelField.x = selectedImage.x + selectedImage.width + 4;
			labelField.y = (height / 2) - (labelField.textHeight / 2) - 2;
		}
		
		private function onClicked(event:MouseEvent):void
		{
			_selected = !_selected;
			draw();
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}