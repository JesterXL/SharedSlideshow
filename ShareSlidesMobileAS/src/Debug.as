package  {
	import com.bit101.components.CheckBox;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Debug extends Component
	{
		private var debugTextField:TextField;
		
		private static var _inst:Debug;
		private static const SO_NAME:String = "DebugWindowPosition";
		private static const HEADER:String = "--------------------";
		private static const ERROR_COLOR:String = "#FF0000";
		private static const WARN_COLOR:String = "#FF9900";
		private static const DEBUG_COLOR:String = "#0033FF";
		private static const INFO_COLOR:String = "#009966";
		private static const LOG_COLOR:String = "#000000";
		private static const FONT_SIZE:Number = 11;
		
		private static var backLog:Array = [];
		
		public static var debugging:Boolean = true;
		
		private var background:Sprite;
		private var autoScrollCheckBox:CheckBox;
		private var clearButton:PushButton;
		private var minMaxButton:PushButton;
		private var panelLabel:Label;
		
		private var dragging:Boolean = false;
		
		public function Debug()
		{
			super();
			
			_inst = this;
			
			var len:int = backLog.length;
			for(var index:uint = 0; index < len; index++)
			{
				var obj:Object = backLog[index];
				if(obj.message)
				{
					obj.func.call(obj, obj.message);
				}
				else
				{
					obj.func.call();
				}
			}
			
			backLog = null;
		}
		
		protected override function init():void
		{
			super.init();
			
			width			= 540;
			height			= 400;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			this.mouseChildren = true;
			
			background = new Sprite();
			addChild(background);
			
			background.mouseChildren = false;
			background.buttonMode = background.useHandCursor = true;
			
			panelLabel = new Label();
			addChild(panelLabel);
			panelLabel.text = "Debug Window";
			panelLabel.textField.textColor = 0xFFFFFF;
			
			debugTextField 				= new TextField();
			addChild(debugTextField);
			debugTextField.multiline 	= true;
			debugTextField.wordWrap 	= true;
			debugTextField.width		= 320;
			debugTextField.height		= 200;
			debugTextField.border 		= true;
			debugTextField.borderColor	= 0x666666;
			debugTextField.selectable   = true;
			//debugTextField.background 	= true;
			//debugTextField.backgroundColor	= 0xFFFFFF;
			var fmt:TextFormat = debugTextField.defaultTextFormat;
			fmt.font = "_sans";
			fmt.size = 9;
			debugTextField.defaultTextFormat = fmt;
			
			autoScrollCheckBox = new CheckBox();
			addChild(autoScrollCheckBox);
			autoScrollCheckBox.label = "Auto-Scroll";
			autoScrollCheckBox.selected = true;
			
			clearButton = new PushButton();
			addChild(clearButton);
			clearButton.label = "Clear";
			clearButton.addEventListener(MouseEvent.CLICK, onClear);
			
			minMaxButton = new PushButton();
			addChild(minMaxButton);
			minMaxButton.label = "-";
			minMaxButton.toggle = true;
			minMaxButton.selected = false;
			minMaxButton.addEventListener(MouseEvent.CLICK, onMinMax);
			
			
		}
		
		public override function draw():void
		{
			super.draw();
			
			panelLabel.x = 4;
			
			minMaxButton.setSize(12, 12);
			minMaxButton.move(width - (minMaxButton.width + 4), 2);
			
			var g:Graphics = background.graphics;
			g.clear();
			
			if(minMaxButton.selected == false)
			{
				debugTextField.visible = true;
				clearButton.visible = true;
				autoScrollCheckBox.visible = true;
				clearButton.visible = true;
				
				g.beginFill(0x333333, .9);
				g.drawRoundRect(0, 0, width, height, 6, 6);
				
				
				debugTextField.width = width - 8;
				debugTextField.height = height - clearButton.height - 24;
				debugTextField.x = 4;
				debugTextField.y = 16;
				
				g.beginFill(0xFFFFFF, .7);
				g.moveTo(debugTextField.x, debugTextField.y);
				g.drawRect(debugTextField.x, debugTextField.y, debugTextField.width, debugTextField.height);
				//g.drawRect(debugTextField.x, debugTextField.y, debugTextField.width, debugTextField.height);
				g.endFill();
				
				clearButton.x = 4;
				clearButton.y = height - (clearButton.height + 4);
				
				autoScrollCheckBox.x = width - (autoScrollCheckBox.width + 4);
				autoScrollCheckBox.y = clearButton.y;
				autoScrollCheckBox.setSize(22, 22);
				
				clearButton.width = width - (width - autoScrollCheckBox.x) - 8;
				clearButton.setSize(clearButton.width, 22);
				
				
				
			}
			else
			{
				g.beginFill(0x333333, .5);
				g.drawRoundRect(0, 0, width, 16, 6, 6);
				g.endFill();
				
				debugTextField.visible = false;
				clearButton.visible = false;
				autoScrollCheckBox.visible = false;
				clearButton.visible = false;
			}
		}
		
		private function scrollIt():void
		{
			if(this.autoScrollCheckBox.selected)
			{
				debugTextField.scrollV = debugTextField.maxScrollV;
			}
		}
		
		
		private function onAdded(event:Event):void
		{
			try
			{
				var so:SharedObject = SharedObject.getLocal(Debug.SO_NAME);
				if(so != null)
				{
					if(so.data.pos != null)
					{
						if(so.data.pos.x != undefined && so.data.pos.y != undefined)
						{
							move(so.data.pos.x, so.data.pos.y);
						}
					}
				}
			}
			catch(err:Error)
			{
			}
			
			if(Capabilities.version.toLowerCase().indexOf("and") != -1)
			{
				this.mouseChildren = false;
				this.buttonMode = true;
				this.useHandCursor = true;
				this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownDevice);
				this.addEventListener(MouseEvent.MOUSE_UP, onMouseUpDevice);
			}
			else
			{
				background.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				background.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}
		
		private function onClear(event:MouseEvent):void
		{
			backLog 			= [];
			debugTextField.htmlText = "";
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			if(dragging == false)
			{
				dragging = true;
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
				this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				this.startDrag(false);
			}
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			event.updateAfterEvent();
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			if(dragging)
			{
				dragging = false;
				this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				stopDrag();
				event.updateAfterEvent();
				
				var so:SharedObject = SharedObject.getLocal(Debug.SO_NAME);
				so.data.pos = {x: x, y: y};
			}
		}
		
		private function onMouseDownDevice(event:MouseEvent):void
		{
			if(dragging == false)
			{
				dragging = true;
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpDevice, false, 0, true);
				this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				this.startDrag(false);
			}
		}
		
		private function onMouseUpDevice(event:MouseEvent):void
		{
			if(dragging)
			{
				dragging = false;
				this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpDevice);
				stopDrag();
				event.updateAfterEvent();
				
				var so:SharedObject = SharedObject.getLocal(Debug.SO_NAME);
				so.data.pos = {x: x, y: y};
			}
		}
		
		private function onMinMax(event:MouseEvent):void
		{
			if(minMaxButton.selected)
			{
				minMaxButton.label = "+";
			}
			else
			{
				minMaxButton.label = "-";
			}
				
			draw();
		}
		
		
		// -- instance methods --
		private function write(o:*):void
		{
			debugTextField.htmlText += o + "\n";
			scrollIt();
		}
		
		
		public function log(o:*):void
		{
			if(debugging == false) return;
			trace(o);
			//debugTextField.appendText(o + "\n");
			write(formatLog(o));
		}
		
		public function logHeader():void
		{
			if(debugging == false) return;
			trace(HEADER);
			write(formatLog(HEADER));
		}
		
		public function debug(o:*):void
		{
			if(debugging == false) return;
			trace(o);
			write(formatDebug(o));
		}
		
		public function debugHeader():void
		{
			if(debugging == false) return;
			trace(HEADER);
			write(formatDebug(HEADER));
		}
		
		public function info(o:*):void
		{
			if(debugging == false) return;
			trace(o);
			write(formatInfo(o));
		}
		
		public function infoHeader():void
		{
			if(debugging == false) return;
			trace(HEADER);
			write(formatInfo(HEADER));
		}

		public function warn(o:*):void
		{
			if(debugging == false) return;
			trace(o);
			write(formatWarn(o));
		}

		public function warnHeader():void
		{
			if(debugging == false) return;
			trace(HEADER);
			write(formatWarn(HEADER));
		}
		
		public function error(o:*):void
		{
			if(debugging == false) return;
			trace(o);
			write(formatError(o));
		}
		
		public function errorHeader():void
		{
			if(debugging == false) return;
			trace(HEADER);
			write(formatError(HEADER));
		}
		
		// -- static methods --
		public static function log(o:*):void
		{
			if(debugging == false) return;
			if(_inst)
			{
				_inst.log(o);
			}
			else
			{
				trace(o);
				backLog.push({func: log, message: o});
			}
		}
		
		public static function logHeader():void	
		{
			if(debugging == false) return;
			if(_inst)
			{
				_inst.logHeader();
			}
			else
			{
				trace(HEADER);
				backLog.push({func: logHeader});
			}
		}
		
		public static function debug(o:*):void
		{
			if(debugging == false) return;
			if(_inst)
			{
				_inst.debug(o);
			}
			else
			{
				trace(o);
				backLog.push({func: debug, message: o});
			}
		}
		
		public static function debugHeader():void	
		{
			if(debugging == false) return;
			if(_inst)
			{
				_inst.debugHeader();
			}
			else
			{
				trace(HEADER);
				backLog.push({func: debugHeader});
			}
		}
		
		public static function info(o:*):void
		{
			if(debugging == false) return;
			if(_inst)
			{
				_inst.info(o);
			}
			else
			{
				trace(o);
				backLog.push({func: info, message: o});
			}
		}
		
		public static function infoHeader():void	
		{
			if(debugging == false) return;
			if(_inst)
			{
				_inst.infoHeader();
			}
			else
			{
				trace(HEADER);
				backLog.push({func: infoHeader});
			}
		}

		public static function warn(o:*):void
		{
			if(debugging == false) return;
			if(_inst)
			{
				_inst.warn(o);
			}
			else
			{
				trace(o);
				backLog.push({func: warn, message: o});
			}
		}

		public static function warnHeader():void
		{
			if(debugging == false) return;
			if(_inst)
			{
				_inst.warnHeader();
			}
			else
			{
				trace(HEADER);
				backLog.push({func: warnHeader});
			}
		}
		
		public static function error(o:*):void
		{
			if(debugging == false) return;
			if(_inst)
			{
				_inst.error(o);
			}
			else
			{
				trace(o);
				backLog.push({func: error, message: o});
			}
		}
		
		public static function errorHeader():void	
		{
			if(debugging == false) return;
			if(_inst)
			{
				_inst.errorHeader();
			}
			else
			{
				trace(HEADER);
				backLog.push({func: errorHeader});
			}
		}
		
		// -- formatters --
		private function formatError(o:*):String
		{
			return "<font family='_sans' size='" + FONT_SIZE + "' color='" + ERROR_COLOR + "'>" + o + "</font>";
		}

		private function formatWarn(o:*):String
		{
			return "<font family='_sans' size='" + FONT_SIZE + "' color='" + WARN_COLOR + "'>" + o + "</font>";
		}
		
		private function formatDebug(o:*):String
		{
			return "<font family='_sans' size='" + FONT_SIZE + "' color='" + DEBUG_COLOR + "'>" + o + "</font>";
		}
		
		private function formatInfo(o:*):String
		{
			return "<font family='_sans' size='" + FONT_SIZE + "' color='" + INFO_COLOR + "'>" + o + "</font>";
		}

		private function formatLog(o:*):String
		{
			return "<font family='_sans' size='" + FONT_SIZE + "' color='" + LOG_COLOR + "'>" + o + "</font>";
		}
		
		
	}
}