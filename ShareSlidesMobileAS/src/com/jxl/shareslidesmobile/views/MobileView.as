package com.jxl.shareslidesmobile.views
{

	import com.bit101.components.Component;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;

	import flash.display.DisplayObjectContainer;

	import spark.components.View;


	public class MobileView extends Component
	{

		protected static const TRANSITION_SPEED:Number 			= .7;
		protected static const TRANSITION_DIRECTION_LEFT:String = "left";
		protected static const TRANSITION_DIRECTION_TOP:String = "top";

		public function MobileView(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos,  ypos);
		}

		protected function transitionInView(view:Component, direction:String=TRANSITION_DIRECTION_LEFT):void
		{
			switch(direction)
			{
				case TRANSITION_DIRECTION_LEFT:
					view.x = width + 1;
					TweenLite.to(view,  TRANSITION_SPEED, {x: 0, ease: Expo.easeOut, onComplete: transitionInViewComplete, onCompleteParams: [view, direction]});
				break;

				case TRANSITION_DIRECTION_TOP:
					view.y = height + 1;
					TweenLite.to(view,  TRANSITION_SPEED, {y: 0, ease: Expo.easeOut, onComplete: transitionInViewComplete, onCompleteParams: [view, direction]});
				break;
			}
			view.cacheAsBitmap = true;

		}

		protected function transitionInViewComplete(view:Component, direction:String = TRANSITION_DIRECTION_LEFT):void
		{
			view.cacheAsBitmap = false;
			view.move(0, 0);
		}

		protected function transitionOutView(view:Component, direction:String=TRANSITION_DIRECTION_LEFT):void
		{
			switch(direction)
			{
				case TRANSITION_DIRECTION_LEFT:
					TweenLite.to(view,  TRANSITION_SPEED, {x: -width - 1, ease: Expo.easeOut, onComplete: transitionOutViewComplete, onCompleteParams: [view, direction]});
				break;

				case TRANSITION_DIRECTION_TOP:
					TweenLite.to(view,  TRANSITION_SPEED, {y: height + 1, ease: Expo.easeOut, onComplete: transitionOutViewComplete, onCompleteParams: [view, direction]});
				break;
			}
			view.cacheAsBitmap = true;
		}

		protected function transitionOutViewComplete(view:Component, direction:String = TRANSITION_DIRECTION_LEFT):void
		{
			view.cacheAsBitmap = false;
			switch(direction)
			{
				case TRANSITION_DIRECTION_LEFT:
					view.x = -width - 1;
				break;

				case TRANSITION_DIRECTION_TOP:
					view.y = height + 1;
				break;
			}
			if(view.parent)
				view.parent.removeChild(view);
		}

	}
}

