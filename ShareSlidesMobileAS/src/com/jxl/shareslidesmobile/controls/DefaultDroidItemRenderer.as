
package com.jxl.shareslidesmobile.controls
{
	import com.bit101.components.Component;
	import com.jxl.minimalcomps.IItemRenderer;

	public class DefaultDroidItemRenderer extends Component implements IItemRenderer
	{

		protected var _data:*;
		protected var dataDirty:Boolean = false;
		protected var _labelFunction:Function;

		protected var labelField:LabelField;
		protected var divider:ListDividerSymbol;


		public function get data():*
		{
			return _data;
		}

		public function set data(value:*):void
		{
			_data = value;
			dataDirty = true;
			invalidateProperties();
		}


		public function get labelFunction():Function
		{
			return _labelFunction;
		}

		public function set labelFunction(value:Function):void
		{
			_labelFunction = value;
			dataDirty = true;
			invalidateProperties();
		}

		public function DefaultDroidItemRenderer()
		{
		}

		protected override function init():void
		{
			super.init();

			width = 480;
			height = 65;
		}

		protected override function addChildren():void
		{
			super.addChildren();

			labelField = new LabelField();
			addChild(labelField);

			divider = new ListDividerSymbol();
			addChild(divider);
		}

		protected override function commitProperties():void
		{
			super.commitProperties();

			if(dataDirty)
			{
				dataDirty = false;
				updateLabelFromData();
			}
		}

		protected function updateLabelFromData():void
		{
			if(_labelFunction)
			{
				labelField.text = _labelFunction(_data);
			}
			else
			{
				labelField.text = String(_data);
			}
		}

		public override function draw():void
		{
			super.draw();

			labelField.x = 8;
			labelField.y = (height / 2) - ((labelField.textHeight + 4) / 2);

			divider.y = height - divider.height;
			divider.width = width;
		}
	}
}
