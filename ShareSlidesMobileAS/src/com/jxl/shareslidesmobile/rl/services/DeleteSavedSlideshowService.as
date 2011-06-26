package com.jxl.shareslidesmobile.rl.services
{
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.jxl.shareslidesmobile.events.services.DeleteSavedSlideshowServiceEvent;

	import flash.events.FileListEvent;

	import flash.filesystem.File;

	import org.robotlegs.mvcs.Actor;

	public class DeleteSavedSlideshowService extends Actor
	{
		public function DeleteSavedSlideshowService()
		{
		}

		public function deleteSavedSlideshow(slideshow:SlideshowVO):void
		{
			var file:File = File.userDirectory;
			file = file.resolvePath("slideshows/" + slideshow.name + ".sli");
			if(file.exists)
			{
				try
				{
					file.deleteFile();
					dispatch(new DeleteSavedSlideshowServiceEvent(DeleteSavedSlideshowServiceEvent.SLIDESHOW_FILE_DELETED));
				}
				catch(err:Error)
				{
					Debug.error("ReadSavedSlideshowsService::readSavedSlideshows, can't create director: " + err);
					return;
				}
			}
		}
	}
}
