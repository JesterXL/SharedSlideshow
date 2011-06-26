package com.jxl.shareslidesmobile.rl.services
{
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.jxl.shareslidesmobile.events.services.SaveSlideshowServiceEvent;

	import flash.events.Event;
	import flash.events.IOErrorEvent;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	import org.robotlegs.mvcs.Actor;

	public class SaveSlideshowService extends Actor
	{
		private var file:File;
		private var stream:FileStream;
		private var slideshow:SlideshowVO;

		public function SaveSlideshowService()
		{
		}

		public function saveSlideshow(slideshow:SlideshowVO):void
		{
			this.slideshow = slideshow;

			if(file == null)
			{
				file = File.userDirectory;
				file = file.resolvePath("slideshows");
			}

			if(file.exists == false)
			{
				try
				{
					file.createDirectory();
				}
				catch(err:Error)
				{
					Debug.error("SaveSlideshowService::saveSlideshow, can't create director: " + err);
					return;
				}
			}

			file = file.resolvePath(slideshow.name + ".sli");

			if(stream == null)
			{
				stream = new FileStream();
				stream.addEventListener(Event.COMPLETE, onFileOpenComplete);
				stream.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			}

			try
			{
				stream.openAsync(file,  FileMode.WRITE);
			}
			catch(err:Error)
			{
				Debug.error("SaveSlideshowService::saveSlideshow, openAsync error: " + err);
			}
		}

		private function onIOError(event:IOErrorEvent):void
		{
			Debug.error("SaveSlideshowService::onIOError: " + event.text);
		}

		private function onFileOpenComplete(event:Event):void
		{
			try
			{
				stream.writeObject(slideshow);
				stream.close();
				dispatch(new SaveSlideshowServiceEvent(SaveSlideshowServiceEvent.SLIDESSHOW_SAVED));
			}
			catch(err:Error)
			{
				Debug.error("SaveSlideshowService::onFileOpenComplete, err: " + err);
			}
		}
	}
}
