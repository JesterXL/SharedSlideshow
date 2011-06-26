package com.jxl.shareslidesmobile.rl.services
{
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.jxl.shareslidesmobile.events.services.ReadSavedSlideshowsServiceEvent;
	import com.jxl.shareslidesmobile.rl.*;

	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	import org.robotlegs.mvcs.Actor;

	public class ReadSavedSlideshowsService extends Actor
	{
		private var file:File;
		private var fileList:Array;
		private var currentFile:File;
		private var slideshows:Array = [];
		private var currentStream:FileStream;

		public function ReadSavedSlideshowsService()
		{
		}

		public function readSavedSlideshows():void
		{
			currentFile = null;
			currentStream = null;
			slideshows = [];

			if(file == null)
			{
				file = File.userDirectory;
				file = file.resolvePath("slideshows");
				if(file.exists == false)
				{
					try
					{
						file.createDirectory();
					}
					catch(err:Error)
					{
						Debug.error("ReadSavedSlideshowsService::readSavedSlideshows, can't create director: " + err);
						return;
					}
				}
				file.addEventListener(FileListEvent.DIRECTORY_LISTING, onFilesListed);
			}
			file.getDirectoryListingAsync();
		}

		private function onFilesListed(event:FileListEvent):void
		{
			fileList = event.files;
			readNext();
		}

		private function readNext():void
		{
			if(currentFile == null)
			{
				if(fileList && fileList.length > 0)
				{
					currentFile = fileList.shift();
					processCurrent();
				}
				else
				{
					dispatch(new ReadSavedSlideshowsServiceEvent(ReadSavedSlideshowsServiceEvent.READ_SAVED_SLIDESHOWS_COMPLETE, slideshows))
				}
			}
		}

		private function processCurrent():void
		{
			if(currentFile)
			{
				if(currentStream == null)
				{
					currentStream = new FileStream();
					currentStream.addEventListener(Event.COMPLETE, onCurrentFileComplete);
					currentStream.addEventListener(IOErrorEvent.IO_ERROR, onCurrentFileError);
				}

				try
				{
					currentStream.openAsync(currentFile, FileMode.READ);
				}
				catch(err:Error)
				{
					Debug.error("ReadSavedSLideshowsService::processCurrent, err: " + err);
					readNext();
				}

			}
			else
			{
				readNext();
			}
		}

		private function onCurrentFileError(event:IOErrorEvent):void
		{
			Debug.error("ReadSavedSlideshowsService::onCurrentFileError: " + event.text);
			currentFile = null;
			readNext();
		}

		private function onCurrentFileComplete(event:Event):void
		{
			var slideshow:SlideshowVO;
			try
			{
				slideshow = currentStream.readObject() as SlideshowVO;
				if(slideshow)
				{
					slideshows.push(slideshow);
				}
			}
			catch(err:Error)
			{
				Debug.error("ReadSavedSlidehowsService::onCurrentFileComplete");
			}
			finally
			{
				currentFile = null;
				readNext();
			}
		}
	}
}
