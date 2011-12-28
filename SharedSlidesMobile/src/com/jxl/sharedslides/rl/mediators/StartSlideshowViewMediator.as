package com.jxl.sharedslides.rl.mediators
{
	import com.jxl.sharedslides.rl.models.NetworkModel;
	import com.jxl.sharedslides.views.StartSlideshowView;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class StartSlideshowViewMediator extends Mediator
	{
		[Inject]
		public var view:StartSlideshowView;
		
		[Inject]
		public var model:NetworkModel;
		
		
		public function StartSlideshowViewMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			view.yourSlideshows = model.sharedObjects;
		}
	}
}