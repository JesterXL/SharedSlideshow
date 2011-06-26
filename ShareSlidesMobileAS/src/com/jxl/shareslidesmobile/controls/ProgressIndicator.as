package com.jxl.shareslidesmobile.controls
{

	import com.bit101.components.Component;

	import flash.display.DisplayObjectContainer;

	public class ProgressIndicator extends Component
	{

		private var _label:String;
		private var labelDirty:Boolean = false;

		private var anime:LoadingAnimation;
		private var labelField:LabelField;


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

		public function ProgressIndicator(parent:DisplayObjectContainer = null)
		{
			super(parent);
		}

		protected override function init():void
		{
			super.init();

			width = 120;
			height = 26;
		}

		protected override function addChildren():void
		{
			super.addChildren();

			anime = new LoadingAnimation();
			addChild(anime);

			labelField = new LabelField(this);
		}

		protected override function commitProperties():void
		{
			super.commitProperties();

			if(labelDirty)
			{
				labelDirty = false;
				labelField.text = _label;
			}
		}

		public override function draw():void
		{
			super.draw();

			anime.y = (height / 2) - (anime.height / 2);

			labelField.y = (height / 2) - ((labelField.textHeight + 4) / 2);
		}
	}
}

