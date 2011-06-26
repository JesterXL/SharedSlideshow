/**
 * @author Michael Ritchie
 * @blog http://www.thanksmister.com
 * @twitter Thanksmister
 * Copyright (c) 2011
 * 
 * Custom list event, can be modified to add any event or payload you wish. 
 * */
package com.jxl.minimalcomps.events
{
	import com.jxl.minimalcomps.ITouchListItemRenderer;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class ListItemEvent extends Event
	{
		public static const ITEM_SELECTED:String = "itemSelected";
		public static const ITEM_PRESS:String = "itemPressed";
		
		public var renderer:ITouchListItemRenderer;
		
		public function ListItemEvent(type:String, renderer:ITouchListItemRenderer, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.renderer = renderer;
		}
	}
}