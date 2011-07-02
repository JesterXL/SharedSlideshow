package com.jxl.shareslidesmobile.views.mainviews
{

	import com.bit101.components.Component;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.jxl.minimalcomps.DraggableList;
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.jxl.shareslidesmobile.controls.Alert;
	import com.jxl.shareslidesmobile.controls.ArrowButton;
	import com.jxl.shareslidesmobile.controls.Button;
	import com.jxl.shareslidesmobile.controls.HeaderBar;
	import com.jxl.shareslidesmobile.controls.HeaderField;
	import com.jxl.shareslidesmobile.controls.LabelField;
	import com.jxl.shareslidesmobile.controls.PlusButton;
	import com.jxl.shareslidesmobile.controls.SavedSlideshowItemRenderer;
	import com.jxl.shareslidesmobile.controls.SlideshowItem;
	import com.jxl.shareslidesmobile.controls.TextHeader;
	import com.jxl.shareslidesmobile.events.controller.StartSlideshowEvent;
	import com.jxl.shareslidesmobile.events.view.AlertEvent;
	import com.jxl.shareslidesmobile.events.view.ConfirmPasscodeViewEvent;
	import com.jxl.shareslidesmobile.events.view.NewSlideshowViewEvent;
	import com.jxl.shareslidesmobile.events.view.SavedSlideshowItemRendererEvent;
	import com.jxl.shareslidesmobile.events.view.StartSlideshowViewEvent;
	import com.jxl.shareslidesmobile.managers.HistoryManager;
	import com.jxl.shareslidesmobile.views.MobileView;
	import com.jxl.shareslidesmobile.views.mainviews.startslideshowviews.ConfirmPasscodeView;
	import com.jxl.shareslidesmobile.views.mainviews.startslideshowviews.NewSlideshowView;

	import flash.events.Event;

	import flash.events.MouseEvent;

	import mx.collections.ArrayCollection;

	import spark.components.View;

	public class StartSlideshowView extends MobileView
	{
		private static const STATE_MAIN:String 	= "main";
		private static const STATE_NEW:String 	= "new";
		private static const STATE_HOST:String 	= "host";
		private static const STATE_CONFIRM:String = "confirm";

		private var headerBar:HeaderBar;
		private var headerLabel:HeaderField;
		private var editButton:Button;
		private var plusButton:PlusButton;
		private var header:TextHeader;
		private var slideshowList:DraggableList;
		private var newSlideshowView:NewSlideshowView;
		private var deleteAlert:Alert;
		private var confirmAlert:Alert;
		private var slideshowView:SlideshowView;
		private var confirmView:ConfirmPasscodeView;

		private var _slideshows:ArrayCollection;
		private var slideshowsDirty:Boolean;
		private var editing:Boolean = false;
		private var slideshowToDelete:SlideshowVO;
		private var slideshowToStart:SlideshowVO;



		public function get slideshows():ArrayCollection
		{
			return _slideshows;
		}

		public function set slideshows(value:ArrayCollection):void
		{
			_slideshows = value;
			slideshowsDirty = true;
			invalidateProperties();
		}

		public function StartSlideshowView()
		{
			super();
		}

		public function onNewSlideshowCreated():void
		{
			setCurrentState(STATE_MAIN);
		}

		protected override function init():void
		{
			super.init();

			width = 480;
			height = 800;

			setCurrentState(STATE_MAIN);
		}

		protected override function addChildren():void
		{
			super.addChildren();

			headerBar = new HeaderBar(this);
			headerLabel = new HeaderField(this, "Slideshows");
			editButton = new Button(this, "Edit", onToggleEditSlideshows);
			plusButton = new PlusButton(this, onCreateNewSlideshow);

			header = new TextHeader();
			addChild(header);
			header.label = "Saved Slideshows";

			slideshowList = new DraggableList();
			addChild(slideshowList);
			slideshowList.itemRenderer = SavedSlideshowItemRenderer;
			slideshowList.addEventListener(SavedSlideshowItemRendererEvent.DELETE_SLIDESHOW, onDeleteSlideshow);
			slideshowList.addEventListener(SavedSlideshowItemRendererEvent.START_SLIDESHOW, onStartSlideshow);
			slideshowList.labelFunction =  function getUserLabel(value:SlideshowVO):String
			{
				if(value)
				{
					return value.name;
				}
				else
				{
					return "???";
				}
			};
		}

		protected override function commitProperties():void
		{
			super.commitProperties();

			if(slideshowsDirty)
			{
				slideshowsDirty = false;
				slideshowList.items = _slideshows;
			}
		}

		public override function draw():void
		{
			super.draw();

			headerBar.width = width;

			editButton.x = 8;
			editButton.y = headerBar.y + (headerBar.height / 2) - (editButton.height / 2);

			headerLabel.x = (width / 2) - ((headerLabel.textWidth + 4) / 2);
			headerLabel.y =  headerBar.y + (headerBar.height / 2) - (headerLabel.height / 2);

			plusButton.x = (width - plusButton.width - 8);
			plusButton.y = headerBar.y + (headerBar.height / 2) - (plusButton.height / 2);

			header.width = width;
			header.y = headerBar.y + headerBar.height;

			slideshowList.y = header.y + header.height;
			slideshowList.setSize(width,  height - slideshowList.y);

			if(newSlideshowView)
				newSlideshowView.setSize(width, height);

			if(slideshowView)
				slideshowView.setSize(width,  height);
		}

		private function onCreateNewSlideshow(event:MouseEvent):void
		{
			setCurrentState(STATE_NEW);
			HistoryManager.addHistory(this, onCancelNewSlideshow);
		}

		private function onCancelNewSlideshow(event:NewSlideshowViewEvent=null):void
		{
			setCurrentState(STATE_MAIN);
		}

		private function onToggleEditSlideshows(event:MouseEvent):void
		{
			if(slideshows == null || slideshows.length < 1)
				return;

			editing = !editing;
			var len:int = _slideshows.length;
			while(len--)
			{
				var slideshow:SlideshowVO = _slideshows[len] as SlideshowVO;
				slideshow.edit = editing;
				slideshows.itemUpdated(slideshow);
			}

			if(editing)
			{
				editButton.label = "Cancel";
			}
			else
			{
				editButton.label = "Edit";
			}
		}

		private function onDeleteSlideshow(event:SavedSlideshowItemRendererEvent):void
		{
			if(deleteAlert == null)
			{
				slideshowToDelete = event.slideshow;
				Alert.yesLabel = "Delete";
				deleteAlert = Alert.show("Delete slideshow?", "", Alert.CANCEL | Alert.YES, true, onConfirmDeleteSlideshow);
			}
		}

		private function onConfirmDeleteSlideshow(event:AlertEvent):void
		{
			deleteAlert = null;
			if(event.detail == Alert.YES)
			{
				var evt:StartSlideshowViewEvent = new StartSlideshowViewEvent(StartSlideshowViewEvent.DELETE_SLIDESHOW);
				evt.slideshow = slideshowToDelete;
				slideshowToDelete = null;
				dispatchEvent(evt);
			}
		}

		private function onStartSlideshow(event:SavedSlideshowItemRendererEvent):void
		{
			slideshowToStart = event.slideshow;
			if(slideshowToStart.hasPasscode())
			{
				setCurrentState(STATE_CONFIRM);
			}
			else
			{
				startSlideshow();
			}
			return;

			if(confirmAlert == null)
			{
				slideshowToStart = event.slideshow;
				Alert.yesLabel = "Start Slideshow";
				confirmAlert = Alert.show("Do you want to host & start the slideshow called '" + slideshowToStart.name + "'?", "", Alert.CANCEL | Alert.YES,  true, onConfirmStartSlideshow);
			}
		}

		private function onConfirmStartSlideshow(event:AlertEvent):void
		{
			confirmAlert = null;
			if(event.detail == Alert.YES)
			{
				startSlideshow();
			}
		}

		private function onSubmitPasscode(event:ConfirmPasscodeViewEvent):void
		{
			if(event.passcode == slideshowToStart.passcode)
			{
				startSlideshow();
			}
			else
			{
				Alert.okLabel = "OK";
				Alert.show("Passcode does not match.", "Error", Alert.OK);
			}
		}

		private function startSlideshow():void
		{
			HistoryManager.addHistory(this, onBackFromSlideshow);

			var evt:StartSlideshowViewEvent = new StartSlideshowViewEvent(StartSlideshowEvent.START_SLIDESHOW);
			evt.slideshow = slideshowToStart;
			slideshowToStart = null;
			dispatchEvent(evt);

			setCurrentState(STATE_HOST);
		}

		private function onBackFromSlideshow():void
		{
			setCurrentState(STATE_MAIN);
		}

		private function setCurrentState(state:String):void
		{
			if(state == STATE_MAIN && currentState == STATE_HOST)
			{
				try
				{
					throw new Error("asdf");
				}
				catch(err:Error)
				{
					Debug.debug(err.getStackTrace());
				}
			}
			currentState = state;
		}

		protected override function onEnterState(state:String):void
		{
			switch(state)
			{
				case STATE_MAIN:
					if(headerBar.parent == null)
						addChild(headerBar);

					if(headerLabel.parent == null)
						addChild(headerLabel);

					if(editButton.parent == null)
						addChild(editButton);

					if(plusButton.parent == null)
						addChild(plusButton);

					if(header.parent == null)
						addChild(header);

					if(slideshowList.parent == null)
						addChild(slideshowList);
				break;

				case STATE_NEW:
					if(newSlideshowView == null)
					{
						newSlideshowView = new NewSlideshowView(this);
						newSlideshowView.addEventListener(NewSlideshowViewEvent.CANCEL_CREATE_SLIDESHOW, onCancelNewSlideshow);
					}

					if(newSlideshowView.parent == null)
						addChild(newSlideshowView);

					transitionInView(newSlideshowView, TRANSITION_DIRECTION_TOP);
				break;

				case STATE_HOST:
					if(slideshowView == null)
					{
						slideshowView = new SlideshowView(this);
					}

					if(slideshowView.parent == null)
						addChild(slideshowView);

				transitionInView(slideshowView);
				break;

				case STATE_CONFIRM:
					if(confirmView == null)
					{
						confirmView = new ConfirmPasscodeView(this);
						confirmView.addEventListener(ConfirmPasscodeViewEvent.SUBMIT_PASSCODE, onSubmitPasscode);
					}

					if(confirmView.parent == null)
						addChild(confirmView);

					transitionInView(confirmView);
				break;
			}
			draw();
		}


		protected override function onExitState(oldState:String):void
		{
			switch(oldState)
			{
				case STATE_MAIN:
					if(headerBar.parent)
						removeChild(headerBar);

					if(headerLabel.parent)
						removeChild(headerLabel);

					if(editButton.parent)
						removeChild(editButton);

					if(plusButton.parent)
						removeChild(plusButton);

					if(header.parent)
						removeChild(header);

					if(slideshowList.parent)
						removeChild(slideshowList);

				break;

				case STATE_NEW:
					if(newSlideshowView && newSlideshowView.parent)
						transitionOutView(newSlideshowView, TRANSITION_DIRECTION_TOP);
				break;

				case STATE_HOST:
					if(slideshowView && slideshowView.parent)
						transitionOutView(slideshowView);

				break;

				case STATE_CONFIRM:
				     if(confirmView && confirmView.parent)
					 	transitionOutView(confirmView);
				break;
			}
		}

		protected override function transitionOutViewComplete(view:Component, direction:String = TRANSITION_DIRECTION_LEFT):void
		{
			super.transitionOutViewComplete(view, direction);

			if(view == confirmView)
				confirmView = null;

			if(view == slideshowView)
				slideshowView = null;
		}
	}
}

