/**
 * Created by IntelliJ IDEA.
 * User: jesterxl
 * Date: 6/22/11
 * Time: 7:56 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.shareslides.events.model
{
	import flash.events.Event;

	public class SlideshowModelEvent extends Event
	{
		public static const SLIDESHOW_CREATED:String = "slideshowCreated";
		public static const CURRENT_SLIDE_CHANGED:String = "currentSlideChanged";
		public static const SLIDESHOW_CHANGED:String = "slideshowChanged";

		public function SlideshowModelEvent(type:String,  bubbles:Boolean = false, cancelable:Boolean = true)
		{
			super(type,  bubbles, cancelable);
		}
	}
}
