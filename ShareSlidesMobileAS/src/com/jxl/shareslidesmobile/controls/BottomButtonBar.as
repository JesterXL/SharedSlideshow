package com.jxl.shareslidesmobile.controls
{
	import com.bit101.components.Component;
	import com.jxl.shareslidesmobile.events.view.BottomButtonBarEvent;

	import flash.desktop.Icon;

	import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;

	[Event(name="joinSlideshow", type="com.jxl.shareslidesmobile.events.view.BottomButtonBarEvent")]
	[Event(name="startSlideshow", type="com.jxl.shareslidesmobile.events.view.BottomButtonBarEvent")]
	[Event(name="transfer", type="com.jxl.shareslidesmobile.events.view.BottomButtonBarEvent")]
	[Event(name="changeLog", type="com.jxl.shareslidesmobile.events.view.BottomButtonBarEvent")]
	[Event(name="submitBug", type="com.jxl.shareslidesmobile.events.view.BottomButtonBarEvent")]
	public class BottomButtonBar extends Component
	{
		private var background:ButtonBarSymbol;
		private var joinButton:IconButton;
		private var startButton:IconButton;
		private var transferButton:IconButton;
		private var changeLogButton:IconButton;
		private var bugButton:IconButton;
		private var lastSelected:IconButton;
		private var dividersHolder:Sprite;
		
		public function BottomButtonBar(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		protected override function init():void
		{
			super.init();
			
			width 	= 480;
			height 	= 65;
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			background = new ButtonBarSymbol();
			addChild(background);

			dividersHolder = new Sprite();
			addChild(dividersHolder);

			joinButton = new IconButton();
			addChild(joinButton);
			joinButton.label = "Join Slideshow";
			joinButton.icon = IconJoinSymbol;
			joinButton.addEventListener(MouseEvent.CLICK, onButtonClick);

			startButton = new IconButton();
			addChild(startButton);
			startButton.label = "Start Slideshow";
			startButton.icon = IconStartSymbol;
			startButton.addEventListener(MouseEvent.CLICK, onButtonClick);

			transferButton = new IconButton();
			addChild(transferButton);
			transferButton.label = "Transfer";
			transferButton.icon = IconTransferSymbol;
			transferButton.addEventListener(MouseEvent.CLICK, onButtonClick);

			changeLogButton = new IconButton();
			addChild(changeLogButton);
			changeLogButton.icon = IconChangeLogSymbol;
			changeLogButton.label = "Change Log";
			changeLogButton.addEventListener(MouseEvent.CLICK, onButtonClick);

			bugButton = new IconButton();
			addChild(bugButton);
			bugButton.label = "Submit Bug";
			bugButton.icon = IconBugSymbol;
			bugButton.addEventListener(MouseEvent.CLICK, onButtonClick);

			dividersHolder.addChild(new ButtonBarDividerSymbol());
			dividersHolder.addChild(new ButtonBarDividerSymbol());
			dividersHolder.addChild(new ButtonBarDividerSymbol());
			dividersHolder.addChild(new ButtonBarDividerSymbol());
		}
		
		public override function draw():void
		{
			super.draw();
			
			background.width = width;

			const BUTTONS:int = 5;
			var buttonWidth:Number = width / BUTTONS;
			var difference:Number = Math.max((buttonWidth - joinButton.width) / 2, 0);
			if(buttonWidth > width)
				Debug.warn("BottomButtonBar::draw, dude, no room.");

			joinButton.width = startButton.width = transferButton.width = transferButton.width = changeLogButton.width = bugButton.width = buttonWidth;

			joinButton.move(difference, height - joinButton.height);
			startButton.move(joinButton.x + joinButton.width + difference, height - startButton.height);
			transferButton.move(startButton.x + startButton.width + difference, height - transferButton.height);
			changeLogButton.move(transferButton.x + transferButton.width + difference, height - changeLogButton.height);
			bugButton.move(changeLogButton.x + changeLogButton.width + difference, height - bugButton.height);

			var len:int = dividersHolder.numChildren;
			for(var index:int = 0; index < len; index++)
			{
				var divider:ButtonBarDividerSymbol = dividersHolder.getChildAt(index) as ButtonBarDividerSymbol;
				divider.x =  buttonWidth * (index + 1) - 1;
				divider.y = 13;
			}
		}

		private function onButtonClick(event:MouseEvent):void
		{
			if(lastSelected)
			{
				if(lastSelected != event.target)
				{
					lastSelected.selected = false;
				}
				else
				{
					lastSelected.selected = true;
				}
			}

			lastSelected = event.target as IconButton;

			switch(event.target)
			{
				case joinButton:
					dispatchEvent(new BottomButtonBarEvent(BottomButtonBarEvent.JOIN_SLIDESHOW));
					break;

				case startButton:
					dispatchEvent(new BottomButtonBarEvent(BottomButtonBarEvent.START_SLIDESHOW));
					break;

				case transferButton:
					dispatchEvent(new BottomButtonBarEvent(BottomButtonBarEvent.TRANSFER));
					break;

				case changeLogButton:
					dispatchEvent(new BottomButtonBarEvent(BottomButtonBarEvent.CHANGE_LOG));
					break;

				case bugButton:
					dispatchEvent(new BottomButtonBarEvent(BottomButtonBarEvent.SUBMIT_BUG));
					break;
			}
		}
	}
}