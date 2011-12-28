package com.jxl.shareslides.services
{
	import com.jxl.shareslides.vo.SlideshowVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;
	
	[Event(name="loadingFilesComplete", type="flash.events.Event")]
	public class ImagesToSlideshowService extends EventDispatcher
	{
		private static const MAX_WIDTH:Number = 640;
		private static const MAX_HEIGHT:Number = 480;
		
		public var slideshow:SlideshowVO;
		
		private var streams:Array;
		private var currentLoader:Object;
		private var png:PNGEncoder;
		
		public function ImagesToSlideshowService()
		{
			super();
		}
		
		public function getSlideshow(name:String, files:Array, passcode:String):void
		{
			Debug.log("ImagesToSlideshowService::getSlideshow");
			slideshow								 	= new SlideshowVO();
			slideshow.name 								= name;
			slideshow.slides							= files;
			slideshow.passcode							= passcode;
			
			if(png == null)
				png = new PNGEncoder();
			
			var len:int = slideshow.slides.length;
			streams = [];
			for(var index:int = 0; index < len; index++)
			{
				var file:File = slideshow.slides[index] as File;
				var loader:Loader = new Loader();
				streams.push({loader: loader, file: file});
			}
			processNext();
		}
		
		private function processNext():void
		{
			Debug.log("ImagesToSlideshowService::processNext");
			if(currentLoader == null)
			{
				if(streams && streams.length > 0)
				{
					currentLoader = streams.shift();
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
			if(currentLoader)
			{
				var loader:Loader = currentLoader.loader as Loader;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
				loader.load(new URLRequest(currentLoader.file.url));
			}
			else
			{
				processNext();
			}
		}
		
		private function onLoaderError(event:IOErrorEvent):void
		{
			Debug.error("ImagesToSlideshowService::onLoaderError: " + event);
			currentLoader = null;
			processNext();
		}
		
		private function onLoaderComplete(event:Event):void
		{
			Debug.log("ImagesToSlideshowService::onLoaderComplete");
			var loader:Loader				= currentLoader.loader as Loader;
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderComplete);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaderError);
			var bitmap:Bitmap 				= loader.content as Bitmap;
			var moddedBitmapData:BitmapData = bitmap.bitmapData;
			var aspect:Number;
			if(bitmap)
			{
				if(bitmap.bitmapData.width > MAX_WIDTH || bitmap.bitmapData.height > MAX_HEIGHT)
				{
					if(bitmap.bitmapData.width > bitmap.bitmapData.height)
					{
						aspect = bitmap.bitmapData.width / MAX_WIDTH;
						moddedBitmapData = scaleBitmap(bitmap, MAX_WIDTH, Math.round(bitmap.bitmapData.height * aspect));
					}
					else if(bitmap.bitmapData.height > bitmap.bitmapData.width)
					{
						aspect = bitmap.bitmapData.height / MAX_HEIGHT;
						moddedBitmapData = scaleBitmap(bitmap, Math.round(bitmap.bitmapData.width * aspect), MAX_HEIGHT);
					}
					else
					{
						moddedBitmapData = scaleBitmap(bitmap, MAX_WIDTH, MAX_HEIGHT);
					}
				}
				
				var bytes:ByteArray = png.encode(moddedBitmapData);
				slideshow.slideBytes.push(bytes);
			}
			
			loader.unloadAndStop();
			currentLoader = null;
			processNext();
		}
		
		private function scaleBitmap(source:DisplayObject, thumbWidth:Number, thumbHeight:Number):BitmapData
		{
			var mat:Matrix = new Matrix();
			mat.scale(thumbWidth / source.width, thumbHeight / source.height);
			var bitmapData:BitmapData = new BitmapData(thumbWidth, thumbHeight, false);
			bitmapData.draw(source, mat, null, null, null, true);
			return bitmapData;
		}
		
		private function onCompletedLoadingFiles():void
		{
			Debug.log("ImagesToSlideshowService::onCompletedLoadingFiles");
			dispatchEvent(new Event("loadingFilesComplete"));
		}
	}
}