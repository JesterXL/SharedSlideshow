package com.jxl.shareslidesmobile.managers
{
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.Keyboard;

	public class HistoryManager
	{
		private static var histories:Array = [];

		public function HistoryManager()
		{
		}

		public static function initialize():void
		{
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		private static function onKeyDown(event:KeyboardEvent):void
		{
			if(Capabilities.isDebugger == false)
			{
				if(event.keyCode == Keyboard.BACK)
				{
					handleBack(event);
				}
			}
			else
			{
				if(event.keyCode == Keyboard.BACKSPACE)
				{
					handleBack(event);
				}
			}
		}

		public static function addHistory(scope:Object, callback:Function, arguments:Array=null):void
		{
			//if(scope is DisplayObject)
			//{
			//	DisplayObject(scope).addEventListener(Event.REMOVED_FROM_STAGE, onRemoveHistoriesForView, false, 0, true);
			//}
			histories.push(new HistoryVO(scope, callback, arguments));
		}

		private static function _removeHistory(history:HistoryVO):void
		{
			if(histories.indexOf(history) != -1)
			{
				histories.splice(histories.indexOf(history), 1);
			}
			else
			{
				throw new Error("Unknown HistoryVO.");
			}
		}

		private static function handleBack(event:KeyboardEvent):void
		{
			if(histories.length > 0)
			{
				event.preventDefault();
				back();
			}
		}

		public static function back():void
		{
			if(histories.length > 0)
			{
				var history:HistoryVO = histories.pop();
				history.execute();
			}
		}

		private static function removeHistories(object:Object):void
		{
			var len:int = histories.length;
			while(len--)
			{
				if(histories[len].scope == object)
				{
					histories.splice(len, 1);
				}
			}
		}

		private function onRemoveHistoriesForView(event:Event):void
		{
			removeHistories(event.target);
		}
	}
}
