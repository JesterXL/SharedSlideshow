package com.jxl.shareslidesmobile.rl.models
{
	import com.jxl.shareslidesmobile.events.model.SlideshowModelEvent;
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;

	import mx.collections.ArrayCollection;


	import org.robotlegs.mvcs.Actor;
	
	public class SlideshowModel extends Actor
	{
		private var _slideshow:SlideshowVO;
		private var _host:Boolean = false;
		private var _currentSlide:int;
		private var _slideshows:ArrayCollection;
		
		public function get slideshow():SlideshowVO { return _slideshow; }
		public function set slideshow(value:SlideshowVO):void
		{
			_slideshow = value;
			dispatch(new SlideshowModelEvent(SlideshowModelEvent.SLIDESHOW_CHANGED));
		}
		
		public function get host():Boolean { return _host; }
		public function set host(value:Boolean):void
		{
			_host = value;
			dispatch(new SlideshowModelEvent(SlideshowModelEvent.HOST_CHANGED));
		}
		
		public function get currentSlide():int { return _currentSlide; }
		public function set currentSlide(value:int):void
		{
			_currentSlide = value;
			dispatch(new SlideshowModelEvent(SlideshowModelEvent.CURRENT_SLIDE_CHANGED));
		}

		public function get slideshows():ArrayCollection { return _slideshows; }
		public function set slideshows(value:ArrayCollection):void
		{
			_slideshows = value;
			dispatch(new SlideshowModelEvent(SlideshowModelEvent.SLIDESHOWS_CHANGED));
		}
		
		public function containsSlideshow(name:String):Boolean
		{
			Debug.log("SlideshowModel::containsSlideshow, name: " + name);
			if(_slideshows == null)
				return false;
			
			if(_slideshows.length < 1)
				return false;
			
			var len:int = _slideshows.length;
			while(len--)
			{
				var om:ObjectMetadataVO = _slideshows[len] as ObjectMetadataVO;
				var slideshow:SlideshowVO = om.object as SlideshowVO;
				if(slideshow)
					Debug.log("\tslideshow.name: " + slideshow.name);
				
				if(slideshow && slideshow.name == name)
				{
					return true;
				}
			}
			return false;
		}
		
		public function containsObjectMetadata(info:String):Boolean
		{
			Debug.log("SlideshowModel::containsObjectMetadata, info: " + info);
			if(_slideshows == null)
				return false;
			
			if(_slideshows.length < 1)
				return false;
			
			var len:int = _slideshows.length;
			while(len--)
			{
				var om:ObjectMetadataVO = _slideshows[len] as ObjectMetadataVO;
				Debug.log("\tom.info: " + om.info);
				if(om.info == info)
				{
					return true;
				}
			}
			return false;
		}
		
	}
}