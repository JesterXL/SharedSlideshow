package
{
	import com.jxl.shareslides.vo.SlideshowVO;
	import com.jxl.shareslidesmobile.controls.InputText;
	import com.jxl.shareslidesmobile.controls.ProgressBar;
	import com.jxl.shareslidesmobile.controls.UIGlobals;
	import com.jxl.shareslidesmobile.managers.HistoryManager;
	import com.jxl.shareslidesmobile.rl.MainContext;
	import com.jxl.shareslidesmobile.views.MainView;

	import flash.desktop.NativeApplication;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.system.Capabilities;
	
	public class ShareSlidesMobileAS extends Sprite
	{
		import flash.net.registerClassAlias;
		
		private var debug:Debug;
		private var mainView:MainView;
		private var mainContext:MainContext;
		
		public function ShareSlidesMobileAS()
		{
			super();
			init();
		}
		
		private function init():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(event:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 31;
			stage.addEventListener(Event.RESIZE, onResize);

			UIGlobals.stage = stage;

			this.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onError);

			debug = new Debug();
			addChild(debug);
			Debug.log("Debugger ready.");

			registerClassAlias("com.jxl.shareslides.vo.SlideshowVO", SlideshowVO);
			//initialViewNavigator.pushView(SetNameView);

			  /*
			var slideshow:SlideshowVO = new SlideshowVO();
			var result:Boolean = slideshow.encryptPasscode("abc");
			Debug.debug("result: " + result);
			var pass:String = slideshow.decryptPasscode("abc");
			Debug.debug("pass: " + pass);
			return;
			*/

			HistoryManager.initialize();

			mainView = new MainView();
			addChild(mainView);
			
			setChildIndex(debug, numChildren - 1);

			onResize();

			mainContext = new MainContext(this);
			
			Debug.log("os: " + Capabilities.os);
			Debug.log("playerType: " + Capabilities.playerType);
			Debug.log("version: " + Capabilities.version);
			Debug.log("debugger: " + Capabilities.isDebugger);

			this.addEventListener(Event.DEACTIVATE, onDeactivate);
		}



		private function onError(event:UncaughtErrorEvent):void
		{
			Debug.error("Error: " + event.error);
			try
			{
				throw new Error("asdf");
			}
			catch(err:Error)
			{
				var stack:String = err.getStackTrace();
				if(stack != null && stack != "")
					Debug.error(stack);
			}
		}

		private function onResize(event:Event=null):void
		{
			Debug.debug("w: " + stage.stageWidth + ", h: " + stage.stageHeight);
			if(mainView)
				mainView.setSize(stage.stageWidth, stage.stageHeight);
		}

		private function onDeactivate(event:Event):void
		{
			//NativeApplication.nativeApplication.exit();
		}
	}
}