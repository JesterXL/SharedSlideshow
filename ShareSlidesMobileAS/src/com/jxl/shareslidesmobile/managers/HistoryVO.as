package com.jxl.shareslidesmobile.managers
{
	public class HistoryVO
	{
		public var scope:Object;
		public var callback:Function;
		public var arguments:Array;

		public function HistoryVO(scope:Object, callback:Function,  arguments:Array = null)
		{
			this.scope = scope;
			this.callback = callback;
			this.arguments = arguments;
		}

		public function execute():void
		{
			try
			{
				callback.apply(scope, arguments);
			}
			catch(err:Error)
			{
				Debug.error("ViewHistoryVO::execute, err: " + err);
			}
		}
	}

}
