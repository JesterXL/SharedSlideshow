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

		public function SlideshowModel()
		{
		}

		public function saveSlideshow(slideshowName:String,  slides:Array):void
		{
			Debug.log("SlideshowModel::saveSlideshow");
			if(slideshowService == null)
			{
				slideshowService = new ImagesToSlideshowService();
				slideshowService.conversionCompleteSignal.add(onSlideshowReady);
			}
			builtSlidehow = null;
			slideshowService.getSlideshow(slideshowName, slides);
		}

		private function onSlideshowReady():void
		{
			Debug.log("SlideshowModel::onSlideshowReady");
			builtSlidehow = slideshowService.slideshow;
			dispatch(new SlideshowModelEvent(SlideshowModelEvent.SLIDESHOW_CREATED))
		}
	}
}
