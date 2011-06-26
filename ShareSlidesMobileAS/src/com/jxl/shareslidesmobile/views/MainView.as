package com.jxl.shareslidesmobile.views
{
	import com.bit101.components.Component;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.jxl.shareslidesmobile.controls.BottomButtonBar;
	import com.jxl.shareslidesmobile.events.view.BottomButtonBarEvent;
	import com.jxl.shareslidesmobile.views.mainviews.JoinView;
	import com.jxl.shareslidesmobile.views.mainviews.SlideshowView;
	import com.jxl.shareslidesmobile.views.mainviews.StartSlideshowView;

	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.text.Font;

	public class MainView extends MobileView
	{
		private static const STATE_JOIN:String 					= "join";
		private static const STATE_START:String 				= "start";
		private static const STATE_TRANSFER:String 				= "transfer";
		private static const STATE_CHANGE_LOG:String 			= "changeLog";
		private static const STATE_SUBMIT_BUG:String 			= "submitBug";

		private var background:BackgroundSymbol;
		private var bottomButtonBar:BottomButtonBar;

		private var joinView:JoinView;
		private var startSlideshowView:StartSlideshowView;
		
		public function MainView(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

		protected override function init():void
		{
			super.init();

			width 	= 480;
			height 	= 800;

			currentState = STATE_JOIN;

			addEventListener(MouseEvent.CLICK, onClicked);

			var fonts:Array = Font.enumerateFonts();
			var len:int = fonts.length;
			for(var index:int = 0; index < len; index++)
			{
				var font:Font = fonts[index] as Font;
				Debug.log("name: " + font.fontName + ", style: " + font.fontStyle + ", type: " + font.fontType)
			}
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			background = new BackgroundSymbol();
			addChild(background);

			bottomButtonBar = new BottomButtonBar();
			addChild(bottomButtonBar);
			bottomButtonBar.addEventListener(BottomButtonBarEvent.JOIN_SLIDESHOW, onButtonBarClicked);
			bottomButtonBar.addEventListener(BottomButtonBarEvent.START_SLIDESHOW, onButtonBarClicked);
			bottomButtonBar.addEventListener(BottomButtonBarEvent.TRANSFER, onButtonBarClicked);
			bottomButtonBar.addEventListener(BottomButtonBarEvent.CHANGE_LOG, onButtonBarClicked);
			bottomButtonBar.addEventListener(BottomButtonBarEvent.SUBMIT_BUG, onButtonBarClicked);
		}

		public override function draw():void
		{
			super.draw();

			bottomButtonBar.y = height - bottomButtonBar.height;
			bottomButtonBar.width = width;

			if(joinView)
				joinView.setSize(width, height - bottomButtonBar.height);

			if(startSlideshowView)
				startSlideshowView.setSize(width,  height - bottomButtonBar.height);

			setChildIndex(bottomButtonBar, numChildren - 1);
		}

		private function onButtonBarClicked(event:BottomButtonBarEvent):void
		{
			switch(event.type)
			{
				case BottomButtonBarEvent.JOIN_SLIDESHOW:
					currentState = STATE_JOIN;
					break;

				case BottomButtonBarEvent.START_SLIDESHOW:
					currentState = STATE_START;
					break;

				case BottomButtonBarEvent.TRANSFER:
					currentState = STATE_TRANSFER;
					break;

				case BottomButtonBarEvent.CHANGE_LOG:
					currentState = STATE_CHANGE_LOG;
					break;

				case BottomButtonBarEvent.SUBMIT_BUG:
					currentState = STATE_SUBMIT_BUG;
					break;
			}
		}

		protected override function onEnterState(state:String):void
		{
			switch(state)
			{
				case STATE_JOIN:
					if(joinView == null)
					{
						joinView = new JoinView();
					}
					if(joinView.parent == null)
						addChild(joinView);

					transitionInView(joinView);
					break;

				case STATE_START:
					if(startSlideshowView == null)
						startSlideshowView = new StartSlideshowView();

					if(startSlideshowView.parent == null)
						addChild(startSlideshowView);

					transitionInView(startSlideshowView);
					break;

				case STATE_TRANSFER:

					break;

				case STATE_CHANGE_LOG:

					break;

				case STATE_SUBMIT_BUG:

					break;
			}
			draw();
		}

		protected override function onExitState(oldState:String):void
		{
			switch(oldState)
			{
				case STATE_JOIN:
					transitionOutView(joinView);
					break;

				case STATE_START:
					transitionOutView(startSlideshowView);
					break;

				case STATE_TRANSFER:

					break;

				case STATE_CHANGE_LOG:

					break;

				case STATE_SUBMIT_BUG:

					break;
			}
		}

		private function onClicked(event:MouseEvent):void
		{
			//Debug.log(event.target.name);
		}
	}
}



/*
import com.jxl.shareslidesmobile.events.view.CreateSlideshowViewEvent;
import com.jxl.shareslidesmobile.events.view.SlideshowItemRendererEvent;
import com.jxl.shareslidesmobile.events.view.MainViewEvent;

import mx.collections.ArrayCollection;

[Bindable]
public var slideshows:ArrayCollection;

private function onCreateSlideshow():void
{
	currentState = "create";
}

private function onCancelCreateSlideshow():void
{
	currentState = "main";
}

private function onSlideshowCreated(event:CreateSlideshowViewEvent):void
{
	currentState = "slideshow";
}

private function onJoinSlideshow(event:SlideshowItemRendererEvent):void
{
	currentState = "slideshow";
}

*/