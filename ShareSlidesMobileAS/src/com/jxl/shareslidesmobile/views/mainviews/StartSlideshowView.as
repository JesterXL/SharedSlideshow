package com.jxl.shareslidesmobile.views.mainviews
{

	import com.bit101.components.Component;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.jxl.minimalcomps.DraggableList;
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.jxl.shareslidesmobile.controls.ArrowButton;
	import com.jxl.shareslidesmobile.controls.HeaderBar;
	import com.jxl.shareslidesmobile.controls.HeaderField;
	import com.jxl.shareslidesmobile.controls.LabelField;
	import com.jxl.shareslidesmobile.controls.PlusButton;
	import com.jxl.shareslidesmobile.controls.SavedSlideshowItemRenderer;
	import com.jxl.shareslidesmobile.controls.TextHeader;
	import com.jxl.shareslidesmobile.events.view.NewSlideshowViewEvent;
	import com.jxl.shareslidesmobile.events.view.SavedSlideshowItemRendererEvent;
	import com.jxl.shareslidesmobile.managers.HistoryManager;
	import com.jxl.shareslidesmobile.views.MobileView;
	import com.jxl.shareslidesmobile.views.mainviews.startslideshowviews.NewSlideshowView;

	import flash.events.MouseEvent;

	import mx.collections.ArrayCollection;

	public class StartSlideshowView extends MobileView
	{
		private static const STATE_MAIN:String = "main";
		private static const STATE_NEW:String = "new";

		private var headerBar:HeaderBar;
		private var headerLabel:HeaderField;
		private var plusButton:PlusButton;
		private var header:TextHeader;
		private var slideshowList:DraggableList;
		private var newSlideshowView:NewSlideshowView;

		private var _slideshows:ArrayCollection;
		private var slideshowsDirty:Boolean;



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
			currentState = STATE_MAIN;
		}

		protected override function init():void
		{
			super.init();

			width = 480;
			height = 800;

			currentState = STATE_MAIN;
		}

		protected override function addChildren():void
		{
			super.addChildren();

			headerBar = new HeaderBar(this);
			headerLabel = new HeaderField(this, "Slideshows");
			plusButton = new PlusButton(this, onCreateNewSlideshow);

			header = new TextHeader();
			addChild(header);
			header.label = "Saved Slideshows";

			slideshowList = new DraggableList();
			addChild(slideshowList);
			slideshowList.itemRenderer = SavedSlideshowItemRenderer;
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

			headerLabel.x = 8;
			headerLabel.y =  headerBar.y + (headerBar.height / 2) - (headerLabel.height / 2);

			plusButton.x = (width - plusButton.width - 8);
			plusButton.y = headerBar.y + (headerBar.height / 2) - (plusButton.height / 2);

			header.width = width;
			header.y = headerBar.y + headerBar.height;

			slideshowList.y = header.y + header.height;
			slideshowList.setSize(width,  height - slideshowList.y);

			if(newSlideshowView)
				newSlideshowView.setSize(width, height);
		}

		private function onCreateNewSlideshow(event:MouseEvent):void
		{
			currentState = STATE_NEW;
			HistoryManager.addHistory(this, onCancelNewSlideshow);
		}

		private function onCancelNewSlideshow(event:NewSlideshowViewEvent=null):void
		{
			currentState = STATE_MAIN;
		}



		protected override function onEnterState(state:String):void
		{
			switch(state)
			{
				case STATE_MAIN:

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
			}
			draw();
		}

		protected override function onExitState(oldState:String):void
		{
			switch(oldState)
			{
				case STATE_MAIN:

				break;

				case STATE_NEW:
					if(newSlideshowView && newSlideshowView.parent)
						transitionOutView(newSlideshowView, TRANSITION_DIRECTION_TOP);
				break;
			}
		}
	}
}

