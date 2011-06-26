package com.jxl.shareslidesmobile.rl.models
{

	import com.jxl.shareslidesmobile.events.model.SavedSlideshowModelEvent;

	import mx.collections.ArrayCollection;

	import org.robotlegs.mvcs.Actor;

	public class SavedSlideshowsModel extends Actor
	{

		private var _slideshows:ArrayCollection;


		public function get slideshows():ArrayCollection
		{
			return _slideshows;
		}

		public function set slideshows(value:ArrayCollection):void
		{
			_slideshows = value;
			dispatch(new SavedSlideshowModelEvent(SavedSlideshowModelEvent.SLIDESHOWS_CHANGED));
		}

		public function SavedSlideshowsModel()
		{
			super();
		}





	}
}

