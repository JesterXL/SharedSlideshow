package com.jxl.shareslidesmobile.views.mainviews
{

	import com.bit101.components.Component;
	import com.jxl.minimalcomps.ImageLoader;
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.jxl.shareslidesmobile.controls.Checkbox;
	import com.jxl.shareslidesmobile.controls.LabelField;
	import com.jxl.shareslidesmobile.events.view.SlideshowViewEvent;

	import flash.events.Event;

	import flash.events.TransformGestureEvent;

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
		public var syncCheckBox:Checkbox;

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

		public var slideBytes:ByteArray;

		public function SlideshowView()
		{
			super();
		}

		protected override function init():void
		{
			super.init();

			width = 480;
			height = 800;
		}

		protected override function addChildren():void
		{
			super.addChildren();

			/*
			<s:Image source="{slideBytes}"
			 gestureSwipe="onImageSwipe(event)"
			 width="100%" height="100%"/>


	<s:Label text="{(currentSlide + 1)} of {slideshow.slideBytes.length}" />

	<s:CheckBox id="syncCheckBox" label="Sync to Host" includeIn="slideshow" change="onSyncChange()" />
			*/

			imageLoader = new ImageLoader(this);
			imageLoader.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onImageSwipe);
			imageLoader.scaleContent = true;

			labelField = new LabelField();
			addChild(labelField);
			labelField.text = "--";

			syncCheckBox = new Checkbox(this);
			syncCheckBox.label = "Sync To Host";
			syncCheckBox.addEventListener(Event.CHANGE, onSyncChange);

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

				updateCurrentSlideBytes();
			}

			if(currentSlideDirty)
			{
				Debug.debug("\t_currentSlide: " + _currentSlide);
				currentSlideDirty = false;

				updateCurrentSlideBytes();
			}
		}

		public function setHost(host:Boolean):void
		{
			if(host)
			{
				currentState = "host";
			}
			else
			{
				currentState = "slideshow";
			}
		}

		private function onImageSwipe(event:TransformGestureEvent):void
		{
			if(currentState == "slideshow" && syncCheckBox.selected)
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

			slideBytes = _slideshow.slideBytes[_currentSlide] as ByteArray;
			/*
			Debug.debug("SlieshowView::updateCurrentSlideBytes");
			Debug.debug("\tcurrentSlide: " + currentSlide);
			Debug.debug("\tslideshow.slideBytes.length: " + slideshow.slideBytes.length);
			if(slideBytes)
				Debug.debug("\tslideBytes.length: " + slideBytes.length);
			*/
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
			if(state == STATE_SLIDESHOW)
			{
				if(syncCheckBox.parent == null)
					addChild(syncCheckBox);

				draw();
			}
		}

		protected override function onExitState(oldState:String):void
		{
			if(oldState == STATE_SLIDESHOW)
			{
				if(syncCheckBox.parent)
					removeChild(syncCheckBox);
			}
		}

	}
}

