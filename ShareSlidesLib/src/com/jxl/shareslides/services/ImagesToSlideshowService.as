package com.jxl.shareslides.services
{
	import com.jxl.shareslides.vo.SlideshowVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.osflash.signals.Signal;
	
	public class ImagesToSlideshowService extends EventDispatcher
	{
		
		public var slideshow:SlideshowVO;
		
		public var conversionCompleteSignal:Signal = new Signal();
		
		private var streams:Array;
		private var currentFileStream:Object;
		
		public function ImagesToSlideshowService()
		{
			super();
		}
		
		public function getSlideshow(name:String, files:Array):void
		{
			Debug.log("ImagesToSlideshowService::getSlideshow");
			slideshow								 	= new SlideshowVO();
			slideshow.name 								= name;
			slideshow.slides							= files;
			
			var len:int = slideshow.slides.length;
			streams = [];
			for(var index:int = 0; index < len; index++)
			{
				var file:File = slideshow.slides[index] as File;
				var stream:FileStream = new FileStream();
				streams.push({stream: stream, file: file});
			}
			processNext();
		}
		
		private function processNext():void
		{
			Debug.log("ImagesToSlideshowService::processNext");
			if(currentFileStream == null)
			{
				if(streams && streams.length > 0)
				{
					currentFileStream = streams.shift();
					processCurrent();
				}
				else
				{
					onCompletedLoadingFiles();
				}
			}
		}
		
		private function processCurrent():void
		{
			Debug.log("ImagesToSlideshowService::processCurrent");
			if(currentFileStream)
			{
				var stream:FileStream = currentFileStream.stream as FileStream;
				stream.addEventListener(IOErrorEvent.IO_ERROR, onFileStreamError);
				stream.addEventListener(Event.COMPLETE, onFileStreamComplete);
				stream.openAsync(currentFileStream.file, FileMode.READ);
			}
			else
			{
				processNext();
			}
		}
		
		private function onFileStreamError(event:IOErrorEvent):void
		{
			Debug.error("ImagesToSlideshowService::onFileStreamError: " + event);
			currentFileStream = null;
			processNext();
		}
		
		private function onFileStreamComplete(event:Event):void
		{
			Debug.log("ImagesToSlideshowService::onFileStreamComplete");
			var stream:FileStream 		= currentFileStream.stream as FileStream;
			stream.removeEventListener(IOErrorEvent.IO_ERROR, onFileStreamError);
			stream.removeEventListener(Event.COMPLETE, onFileStreamComplete);
			var file:File 				= currentFileStream.file as File;
			var bytes:ByteArray 		= new ByteArray();
			stream.readBytes(bytes);
			slideshow.slideBytes.push(bytes);
			currentFileStream = null;
			processNext();
		}
		
		private function onCompletedLoadingFiles():void
		{
			Debug.log("ImagesToSlideshowService::onCompletedLoadingFiles");
			this.conversionCompleteSignal.dispatch();
		}
	}
}