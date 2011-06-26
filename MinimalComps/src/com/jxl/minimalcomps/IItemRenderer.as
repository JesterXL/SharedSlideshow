package com.jxl.minimalcomps
{
	import flash.events.IEventDispatcher;

	public interface IItemRenderer extends IEventDispatcher
	{
		function get data():*;
		function set data(value:*):void;

		function get labelFunction():Function;
		function set labelFunction(value:Function):void;
		
		function get height():Number;
		function set height(value:Number):void;
		
		function get width():Number;
		function set width(value:Number):void;
		
		function set y(value:Number):void;
	}
}