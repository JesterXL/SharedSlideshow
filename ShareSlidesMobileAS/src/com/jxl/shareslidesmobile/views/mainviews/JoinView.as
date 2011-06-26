package com.jxl.shareslidesmobile.views.mainviews
{
	import com.bit101.components.Component;
	import com.jxl.minimalcomps.DraggableList;
	import com.jxl.shareslidesmobile.controls.DefaultDroidItemRenderer;
	import com.jxl.shareslidesmobile.controls.TextHeader;
	import com.jxl.shareslidesmobile.views.mainviews.joinviewclasses.SetNameView;
	import com.projectcocoon.p2p.vo.ClientVO;

	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;


	public class JoinView extends Component
	{

		private var slideshowHeader:TextHeader;
	    private var participantsHeader:TextHeader;
		private var slideshowsList:DraggableList;
		private var participantsList:DraggableList;
		private var setNameView:SetNameView;

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
		}

		protected override function addChildren():void
		{
			super.addChildren();

			slideshowHeader = new TextHeader();
			addChild(slideshowHeader);
			slideshowHeader.label = "Slideshows";

			slideshowsList = new DraggableList();
			addChild(slideshowsList);
			slideshowsList.itemRenderer = DefaultDroidItemRenderer;

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
		}
	}
}
