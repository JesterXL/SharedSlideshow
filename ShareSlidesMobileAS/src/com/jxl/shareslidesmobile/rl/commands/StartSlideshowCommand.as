package com.jxl.shareslidesmobile.rl.commands
{
	import com.jxl.shareslidesmobile.events.controller.DeleteSlideshowEvent;
	import com.jxl.shareslidesmobile.events.controller.StartSlideshowEvent;
	import com.jxl.shareslidesmobile.rl.models.NetworkModel;
	import com.jxl.shareslidesmobile.rl.models.SlideshowModel;
	import com.jxl.shareslides.vo.SlideshowVO;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.robotlegs.mvcs.Command;
	
	public class StartSlideshowCommand extends AsyncCommand
	{
		[Inject]
		public var slideshowModel:SlideshowModel;
		
		[Inject]
		public var event:StartSlideshowEvent;
		
		[Inject]
		public var networkModel:NetworkModel;
		
		private var streams:Array;
		private var currentFileStream:Object;
		private var slideshow:SlideshowVO;
		
		public function StartSlideshowCommand()
		{
			super();
		}
		
		public override function execute():void
		{
			Debug.log("StartSlideshowCommand::execute");
			// delete first
			if(slideshowModel.slideshow)
			{
				var evt:DeleteSlideshowEvent 	= new DeleteSlideshowEvent(DeleteSlideshowEvent.DELETE_SLIDESHOW);
				evt.slideshow					= slideshowModel.slideshow;
				dispatch(evt);
			}

			if(event.slideshow == null)
			{
				slideshow				 	= new SlideshowVO();
				slideshow.name 				= event.name;
				slideshow.slides			= event.slides;
			}
			else
			{
				slideshow 					= event.slideshow;
			}
			slideshow.host					= true;
			
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
			Debug.log("StartSlideshowCommand::processNext");
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
			Debug.log("StartSlideshowCommand::processCurrent");
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
			Debug.error("StartSlideshowCommand::onFileStreamError: " + event.text);
			processNext();
		}
		
		private function onFileStreamComplete(event:Event):void
		{
			Debug.log("StartSlideshowCommand::onFileStreamComplete");
			var stream:FileStream 		= currentFileStream.stream as FileStream;
			stream.removeEventListener(IOErrorEvent.IO_ERROR, onFileStreamError);
			stream.removeEventListener(Event.COMPLETE, onFileStreamComplete);
			var file:File 				= currentFileStream.file as File;
			var bytes:ByteArray 		= new ByteArray();
			stream.readBytes(bytes);
			Debug.log("\tbytes.len: " + bytes.length + ", name: " + file.name);
			slideshow.slideBytes.push(bytes);
			currentFileStream = null;
			processNext();
		}
		
		private function onCompletedLoadingFiles():void
		{
			Debug.log("StartSlideshowCommand::onCompletedLoadingFiles");
			slideshowModel.slideshow 	= slideshow;
			slideshowModel.currentSlide = 0;
			slideshowModel.host 		= true;
			networkModel.localNetworkDiscovery.shareWithAll(slideshowModel.slideshow, slideshowModel.slideshow.name);
			finish();
		}
		
	}
}