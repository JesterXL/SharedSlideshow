package com.jxl.shareslidesmobile.views.mainviews
{

	import com.bit101.components.Component;
	import com.jxl.minimalcomps.ImageLoader;
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.jxl.shareslidesmobile.controls.Checkbox;
	import com.jxl.shareslidesmobile.controls.LabelField;
	import com.jxl.shareslidesmobile.events.view.SlideshowViewEvent;

	import flash.display.DisplayObjectContainer;

	import flash.events.Event;
	import flash.events.KeyboardEvent;

	import flash.events.TransformGestureEvent;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;

	import flash.utils.ByteArray;

	[Event(name="nextImage", type="com.jxl.shareslidesmobile.events.controller.StartSlideshowEvent")]
	[Event(name="previousImage", type="com.jxl.shareslidesmobile.events.controller.StartSlideshowEvent")]
	[Event(name="syncChange", type="com.jxl.shareslidesmobile.events.controller.StartSlideshowEvent")]
	public class SlideshowView extends Component
	{

		private static const STATE_SLIDESHOW:String 			= "slideshow";
		private static const STATE_HOST:String 					= "host";


		private var _slideshow:SlideshowVO;
		private var slideshowDirty:Boolean = false;
		private var _currentSlide:int;
		private var currentSlideDirty:Boolean = false;

		private var imageLoader:ImageLoader;
		private var labelField:LabelField;
		private var syncCheckBox:Checkbox;

		public function get sync():Boolean
		{
			if(syncCheckBox)
			{
				return syncCheckBox.selected;
			}
			else
			{
				return true;
			}
		}

		public function get currentSlide():int { return _currentSlide; }
		public function set currentSlide(value:int):void
		{
			_currentSlide = value;
			currentSlideDirty = true;
			invalidateProperties();
		}

		public function get slideshow():SlideshowVO { return _slideshow; }
		public function set slideshow(value:SlideshowVO):void
		{
			_slideshow = value;
			slideshowDirty = true;
			invalidateProperties();
		}

		public function SlideshowView(parent:DisplayObjectContainer = null)
		{
			super(parent);
		}

		protected override function init():void
		{
			super.init();

			width = 480;
			height = 800;

			currentState = STATE_SLIDESHOW;
			onAdded();
		}

		protected override function addChildren():void
		{
			super.addChildren();

			imageLoader = new ImageLoader(this);
			imageLoader.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onImageSwipe);
			imageLoader.scaleContent = true;




			labelField = new LabelField();
			addChild(labelField);
			labelField.text = "--";

			syncCheckBox = new Checkbox();
			syncCheckBox.label = "Sync To Host";
			syncCheckBox.selected = true;
			syncCheckBox.addEventListener(Event.CHANGE, onSyncChange);

		}

		private function onAdded(event:Event=null):void
		{
			Debug.debug("SlideshowView::onAdded");
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
		}

		private function onRemoved(event:Event):void
		{
			Debug.debug("SlideshowView::onRemoved");

		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			Debug.debug("SlideshowView::onKeyDown");
			if(stage == null)
				return;

			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					previousSlide();
				break;

				case Keyboard.RIGHT:
					nextSlide();
				break;
			}
		}

		protected override function commitProperties():void
		{
			Debug.debug("SlideshowView::commitProperties");
			super.commitProperties();

			if(slideshowDirty)
			{
				Debug.debug("\t_slideshow: " + _slideshow);
				slideshowDirty = true;
				if(_slideshow && isNaN(_currentSlide) || _currentSlide < 0)
				{
					_currentSlide = 0;
					currentSlideDirty = true;
				}

				if(slideshow && slideshow.host)
				{
					currentState = STATE_HOST;
				}
				else
				{
					currentState = STATE_SLIDESHOW;
				}

				updateCurrentSlideBytes();
			}

			if(currentSlideDirty)
			{
				Debug.debug("\t_currentSlide: " + _currentSlide);
				currentSlideDirty = false;

				updateCurrentSlideBytes();
			}
		}

		private function onImageSwipe(event:TransformGestureEvent):void
		{
			if(currentState == STATE_SLIDESHOW && syncCheckBox.selected)
				return;

			if(event.offsetX == 1)
			{
				nextSlide();
			}
			else if(event.offsetX == -1)
			{
				previousSlide();
			}
		}

		private function nextSlide():void
		{
			if(slideshow && slideshow.slideBytes && isNaN(currentSlide) == false && currentSlide + 1 < slideshow.slideBytes.length)
			{
				++currentSlide;
				updateCurrentSlideBytes();
				dispatchEvent(new SlideshowViewEvent(SlideshowViewEvent.NEXT_IMAGE));
			}
		}

		private function previousSlide():void
		{
			if(slideshow && slideshow.slideBytes && isNaN(currentSlide) == false && currentSlide - 1 > -1)
			{
				--currentSlide;
				updateCurrentSlideBytes();
				dispatchEvent(new SlideshowViewEvent(SlideshowViewEvent.PREVIOUS_IMAGE));
			}
		}

		private function updateCurrentSlideBytes():void
		{
			if(_slideshow == null || isNaN(_currentSlide))
				return;

			var slideBytes:ByteArray = _slideshow.slideBytes[_currentSlide] as ByteArray;
			/*
			Debug.debug("SlieshowView::updateCurrentSlideBytes");
			Debug.debug("\tcurrentSlide: " + currentSlide);
			Debug.debug("\tslideshow.slideBytes.length: " + slideshow.slideBytes.length);
			if(slideBytes)
				Debug.debug("\tslideBytes.length: " + slideBytes.length);
			*/
			imageLoader.source = slideBytes;
		}

		private function onSyncChange(event:Event):void
		{
			dispatchEvent(new SlideshowViewEvent(SlideshowViewEvent.SYNC_CHANGE));
		}

		public override function draw():void
		{
			super.draw();


			if(syncCheckBox && syncCheckBox.parent && currentState == STATE_SLIDESHOW)
			{
				syncCheckBox.y = height - (syncCheckBox.height + 4);
			}

			imageLoader.move(10, 10);
			if(currentState == STATE_SLIDESHOW)
			{
				imageLoader.setSize(width - 20, height - (syncCheckBox.height + 4) + (labelField.textHeight + 4) + 10);
			}
			else
			{
				imageLoader.setSize(width - 20, height - (labelField.textHeight + 4) + 10);
			}

			Debug.log("w: " + width + ", h: " + height  + ", imageLoader.width: " + imageLoader.width + ", imageLoader.heihgt : " + imageLoader.height);

			labelField.x = (width / 2) - ((labelField.textWidth + 4) / 2);
			labelField.y = imageLoader.y + imageLoader.height + 10;
		}

		protected override function onEnterState(state:String):void
		{
			switch(state)
			{
				case STATE_SLIDESHOW:
					if(syncCheckBox.parent == null)
						addChild(syncCheckBox);

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
				case STATE_SLIDESHOW:
					if(syncCheckBox.parent)
						removeChild(syncCheckBox);
				break;
			}
		}

	}
}

