/**
 * Created by IntelliJ IDEA.
 * User: jesterxl
 * Date: 6/22/11
 * Time: 7:52 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.shareslides.rl.models
{
	import com.jxl.shareslides.events.model.SlideshowModelEvent;
	import com.jxl.shareslides.services.ImagesToSlideshowService;
	import com.jxl.shareslides.vo.SlideshowVO;

	import org.robotlegs.mvcs.Actor;

	public class SlideshowModel extends Actor
	{
		private var slideshowService:ImagesToSlideshowService;

		public var builtSlidehow:SlideshowVO;

		private var _currentSlide:int;
		private var _slideshow:SlideshowVO;


		public function get slideshow():SlideshowVO
		{
			return _slideshow;
		}

		public function set slideshow(value:SlideshowVO):void
		{
			_slideshow = value;
			dispatch(new SlideshowModelEvent(SlideshowModelEvent.CURRENT_SLIDE_CHANGED));
		}

		public function get currentSlide():int
		{
			return _currentSlide;
		}

		public function set currentSlide(value:int):void
		{
			_currentSlide = value;
			dispatch(new SlideshowModelEvent(SlideshowModelEvent.CURRENT_SLIDE_CHANGED));
		}

		public function SlideshowModel()
		{
		}

		public function saveSlideshow(slideshowName:String,  slides:Array, passcode:String):void
		{
			Debug.log("SlideshowModel::saveSlideshow");
			if(slideshowService == null)
			{
				slideshowService = new ImagesToSlideshowService();
				slideshowService.conversionCompleteSignal.add(onSlideshowReady);
			}
			builtSlidehow = null;
			slideshowService.getSlideshow(slideshowName, slides, passcode);
		}

		private function onSlideshowReady():void
		{
			Debug.log("SlideshowModel::onSlideshowReady");
			builtSlidehow = slideshowService.slideshow;
			dispatch(new SlideshowModelEvent(SlideshowModelEvent.SLIDESHOW_CREATED))
		}
	}
}
