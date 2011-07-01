package com.jxl.shareslidesmobile.controls
{

	import com.bit101.components.Component;
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.jxl.shareslidesmobile.events.view.SlideshowItemRendererEvent;
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;

	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.html.script.Package;

	public class SlideshowItemRenderer extends DefaultDroidItemRenderer
	{
		private static const STATE_WAITING:String 		= "waiting";
		private static const STATE_NORMAL:String 		= "normal";
		private static const STATE_PROGRESS:String 		= "progress";
		private static const STATE_HOST:String 			= "host";

		private var _slideshow:SlideshowVO;
		private var slideshowDirty:Boolean = false;
		private var _progress:Number;
		private var progressDirty:Boolean = false;

		private var progressBar:ProgressBar;
		private var joinButton:Button;


		public function get progress():Number
		{
			return _progress;
		}

		public function set progress(value:Number):void
		{
			_progress = value;
			progressDirty = true;
			invalidateProperties();
		}

		public function get slideshow():SlideshowVO
		{
			return _slideshow;
		}

		public function set slideshow(value:SlideshowVO):void
		{
			_slideshow = value;
			slideshowDirty = true;
			invalidateProperties();
		}

		public override function set data(value:*):void
		{
			var om:ObjectMetadataVO;
			if(_data && _data is ObjectMetadataVO)
			{
				ObjectMetadataVO(_data).progressSignal.remove(onProgressChanged);
				ObjectMetadataVO(_data).completedSignal.remove(onCompleted);
			}

			super.data = value;

			if(value == null)
			{
				slideshow = null;
				currentState = "waiting";
				return;
			}

			if(value is ObjectMetadataVO)
			{
				om = value as ObjectMetadataVO;
				om.progressSignal.add(onProgressChanged);
				om.completedSignal.add(onCompleted);
				Debug.debug("om.isComplete: " + om.isComplete + ", om.progress: " + om.progress);

				if(om.isComplete == false || om.progress < 1)
				{
					slideshow = null;
					currentState = "progress";
					return;
				}
				else
				{
					slideshow = om.object as SlideshowVO;
					if(slideshow)
					{
						if(slideshow.host == false)
						{
							currentState = STATE_NORMAL;
						}
						else
						{
							currentState = STATE_HOST;
						}
						return;
					}
				}
			}
		}



		public function SlideshowItemRenderer()
		{
			super();
		}



		protected override function init():void
		{
			super.init();

			width = 100;
			height = 100;
		}

		protected override function addChildren():void
		{
			super.addChildren();

		}

		protected override function commitProperties():void
		{
			super.commitProperties();

			if(progressDirty)
			{
				progressDirty = false;
				progressBar.indeterminate = false;
				progressBar.progress = _progress;
			}

		}

		protected override function updateLabelFromData():void
		{
			if(data && data is ObjectMetadataVO)
			{
				labelField.text = String(data.info + ", state: " + currentState);
			}
			else
			{
				super.updateLabelFromData();
			}
		}

		public override function draw():void
		{
			super.draw();

			if(progressBar)
				 progressBar.move(width - progressBar.width - 8, (height / 2) - (progressBar.height / 2));

			if(joinButton)
				joinButton.move(width - joinButton.width - 8, (height / 2) - (joinButton.height / 2));
		}

		private function onJoin(event:MouseEvent):void
		{
			var evt:SlideshowItemRendererEvent 		= new SlideshowItemRendererEvent(SlideshowItemRendererEvent.JOIN);
			evt.slideshow 							= slideshow;
			dispatchEvent(evt);
		}
		               /*
		private function onDelete(event:MouseEvent):void
		{
			var evt:SlideshowItemRendererEvent 		= new SlideshowItemRendererEvent(SlideshowItemRendererEvent.DELETE_SLIDESHOW);
			evt.slideshow 							= data as SlideshowVO;
			dispatchEvent(evt);
		}
		*/

		private function onProgressChanged():void
		{
			if(currentState != STATE_PROGRESS)
				currentState = STATE_PROGRESS;

			if(_data && _data is ObjectMetadataVO)
				progress = ObjectMetadataVO(_data).progress;
		}

		private function onCompleted():void
		{
			if(_data && _data is ObjectMetadataVO)
			{
				var om:ObjectMetadataVO = _data as ObjectMetadataVO;
				slideshow = om.object as SlideshowVO;
				if(slideshow)
				{
					if(slideshow.host)
					{
						currentState = "host";
					}
					else
					{
						currentState = "normal";
					}
				}
			}
		}


		protected override function onEnterState(state:String):void
		{
			switch(state)
			{
				case STATE_WAITING:

				break;

				case STATE_NORMAL:
					if(joinButton == null)
						joinButton = new Button(this, "Join", onJoin);

					if(joinButton.parent == null)
						addChild(joinButton);
				break;

				case STATE_PROGRESS:
					if(progressBar == null)
						progressBar = new ProgressBar();

					if(progressBar)
						addChild(progressBar);

				break;

				case STATE_HOST:

				break;
			}
			draw();
		}

		protected override function onExitState(oldState:String):void
		{
			switch(oldState)
			{
				case STATE_WAITING:

				break;

				case STATE_NORMAL:
					 if(joinButton && joinButton.parent)
					 	removeChild(joinButton);
				break;

				case STATE_PROGRESS:
					if(progressBar && progressBar.parent)
						removeChild(progressBar);

				break;

				case STATE_HOST:

				break;
			}
		}

	}
}




