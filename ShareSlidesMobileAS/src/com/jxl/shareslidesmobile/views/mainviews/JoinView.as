package com.jxl.shareslidesmobile.views.mainviews
{
	import com.bit101.components.Component;
	import com.jxl.minimalcomps.DraggableList;
	import com.jxl.shareslidesmobile.controls.DefaultDroidItemRenderer;
	import com.jxl.shareslidesmobile.controls.SlideshowItemRenderer;
	import com.jxl.shareslidesmobile.controls.TextHeader;
	import com.jxl.shareslidesmobile.events.view.SlideshowItemRendererEvent;
	import com.jxl.shareslidesmobile.managers.HistoryManager;
	import com.jxl.shareslidesmobile.views.MobileView;
	import com.jxl.shareslidesmobile.views.mainviews.joinviewclasses.SetNameView;
	import com.projectcocoon.p2p.vo.ClientVO;

	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;


	public class JoinView extends MobileView
	{

		private static const STATE_JOIN:String = "join";
		private static const STATE_SLIDESHOW:String = "slideshow";

		private var slideshowHeader:TextHeader;
	    private var participantsHeader:TextHeader;
		private var slideshowsList:DraggableList;
		private var participantsList:DraggableList;
		private var setNameView:SetNameView;
		private var slideshowView:SlideshowView;

		private var _slideshows:ArrayCollection;
		private var slideshowsDirty:Boolean = false;
		private var _clients:ArrayCollection;
		private var clientsDirty:Boolean = false;


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


		public function get clients():ArrayCollection
		{
			return _clients;
		}

		public function set clients(value:ArrayCollection):void
		{
			_clients = value;
			clientsDirty = true;
			invalidateProperties();
		}

		public function JoinView()
		{
		}

		protected override function init():void
		{
			super.init();

			width = 480;
			height = 735;

			currentState = STATE_JOIN;
		}

		protected override function addChildren():void
		{
			super.addChildren();

			slideshowHeader = new TextHeader();
			addChild(slideshowHeader);
			slideshowHeader.label = "Slideshows";

			slideshowsList = new DraggableList();
			addChild(slideshowsList);
			slideshowsList.itemRenderer = SlideshowItemRenderer;
			slideshowsList.addEventListener(SlideshowItemRendererEvent.JOIN, onJoin);

			participantsHeader = new TextHeader();
			addChild(participantsHeader);
			participantsHeader.label = "Connected Participants";

			participantsList = new DraggableList();
			addChild(participantsList);
			participantsList.itemRenderer = DefaultDroidItemRenderer;
			participantsList.labelFunction =  function getUserLabel(value:ClientVO):String
			{
				if (value.isLocal)
				{
					if(value.clientName == null || value.clientName == "")
					{
						return "(You)";
					}
					else
					{
						return value.clientName + " (You)";
					}
				}

				return value.clientName;
			};


			setNameView = new SetNameView();
			addChild(setNameView);
		}

		protected override function commitProperties():void
		{
			super.commitProperties();

			if(slideshowsDirty)
			{
				slideshowsDirty = false;
				slideshowsList.items = _slideshows;
			}

			if(clientsDirty)
			{
				clientsDirty = false;
				participantsList.items = _clients;
			}

		}

		public override function draw():void
		{
			super.draw();

			const MARGIN:Number = 8;

			slideshowHeader.width = width;

			slideshowsList.y = slideshowHeader.y + slideshowHeader.height;
			slideshowsList.width = width;
			slideshowsList.height = (height - slideshowHeader.height - participantsHeader.height - setNameView.height - (MARGIN * 2)) / 2;

			participantsHeader.width = width;
			participantsHeader.y = slideshowsList.y + slideshowsList.height;

			participantsList.y = participantsHeader.y + participantsHeader.height;
			participantsList.width = width;
			participantsList.height = slideshowsList.height;

			setNameView.x = (width / 2) - (setNameView.width / 2);
			setNameView.y = participantsList.y + participantsList.height + MARGIN;

			if(slideshowView)
				slideshowView.setSize(width,  height);
		}

		private function onJoin(event:SlideshowItemRendererEvent):void
		{
			HistoryManager.addHistory(this, onBackFromSlideshow);
			currentState = STATE_SLIDESHOW;
		}

		private function onBackFromSlideshow():void
		{
			currentState = STATE_JOIN;
		}

		protected override function onEnterState(state:String):void
		{
			switch(state)
			{
				case STATE_JOIN:
					safeAddChildren(slideshowHeader, participantsHeader, slideshowsList, participantsList, setNameView, slideshowView);

				break;

				case STATE_SLIDESHOW:
					if(slideshowView == null)
						slideshowView = new SlideshowView(this);

					if(slideshowView.parent == null)
						addChild(slideshowView);

					transitionInView(slideshowView);
				break;
			}
			draw();
		}

		protected override function onExitState(oldState:String):void
		{
			switch(oldState)
			{
				case STATE_JOIN:
				   safeRemoveChildren(slideshowHeader, participantsHeader, slideshowsList, participantsList, setNameView, slideshowView);
				break;

				case STATE_SLIDESHOW:
				    if(slideshowView && slideshowView.parent)
						transitionOutView(slideshowView);
				break;
			}
		}

	}
}
