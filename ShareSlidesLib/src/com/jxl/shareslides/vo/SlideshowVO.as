package com.jxl.shareslides.vo
{
	[Bindable]
	public class SlideshowVO
	{
		public var name:String;
		public var slideBytes:Array = [];
		
		[Transient]
		public var slides:Array = [];
		
		[Transient]
		public var host:Boolean = false;
		
		
		public function SlideshowVO()
		{
		}
	}
}