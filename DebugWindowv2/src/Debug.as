package 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.core.UIComponent;
	
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.Label;
	import spark.components.ToggleButton;
	
	public class Debug extends UIComponent
	{
		private var debugTextField:TextField;
		
		private static var _inst:Debug;
		private static const SO_NAME:String = "DebugWindowPosition";
		private static const HEADER:String = "--------------------";
		private static const ERROR_COLOR:String = "#FF0000";
		private static const DEBUG_COLOR:String = "#0033FF";
		private static const INFO_COLOR:String = "#009966";
		private static const WARN_COLOR:String = "#FF9933";
		
		private static var backLog:Array = [];
		
		public static var debugging:Boolean = false;
		
		private var background:Sprite;
		private var autoScrollCheckBox:CheckBox;
		private var clearButton:Button;
		private var minMaxButton:ToggleButton;
		private var copyButton:Button;
		private var panelLabel:Label;
		
		private var dragging:Boolean = false;
		
		public function Debug()
		{
			super();
			
			
			
			width			= 540;
			height			= 400;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			this.mouseChildren = true;
			
			background = new Sprite();
			addChild(background);
			
			background.mouseChildren = false;
			background.buttonMode = background.useHandCursor = true;
			
			panelLabel = new Label();
			addChild(panelLabel);
			panelLabel.text = "Debug Window";
			panelLabel.setStyle("color", 0xFFFFFF);
			
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
			
			clearButton = new Button();
			addChild(clearButton);
			clearButton.label = "Clear";
			clearButton.addEventListener(MouseEvent.CLICK, onClear);
			
			copyButton = new Button();
			addChild(copyButton);
			copyButton.label = "Copy To Clipboard";
			copyButton.addEventListener(MouseEvent.CLICK, onCopy);
			
			minMaxButton = new ToggleButton();
			addChild(minMaxButton);
			minMaxButton.label = "-";
			minMaxButton.addEventListener(MouseEvent.CLICK, onMinMax);
			
			_inst = this;

			if(backLog)
			{
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
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			panelLabel.x = 4;
			
			minMaxButton.setActualSize(12, 12);
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
				autoScrollCheckBox.setActualSize(22, 22);
				
				copyButton.setActualSize(120, 22);
				clearButton.width = width - (width - autoScrollCheckBox.x) - 8 - copyButton.width;
				clearButton.setActualSize(clearButton.width, 22);
				copyButton.move(clearButton.x + clearButton.width + 4, clearButton.y);
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
				copyButton.visible = false;
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
			
			
		}
		
		private function onClear(event:MouseEvent):void
		{
			backLog 			= [];
			debugTextField.htmlText = "";
		}
		
		private function onCopy(event:MouseEvent):void
		{
			System.setClipboard(debugTextField.htmlText);
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
				
			invalidateDisplayList();
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
			write(o);
		}
		
		public function logHeader():void
		{
			if(debugging == false) return;
			trace(HEADER);
			write(HEADER + "\n");
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
			write(formatInfo(o));
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
			return "<font family='_sans' size='9' color='" + ERROR_COLOR + "'>" + o + "</font>";
		}
		
		private function formatDebug(o:*):String
		{
			return "<font family='_sans' size='9' color='" + DEBUG_COLOR + "'>" + o + "</font>";
		}
		
		private function formatInfo(o:*):String
		{
			return "<font family='_sans' size='9' color='" + INFO_COLOR + "'>" + o + "</font>";
		}
		
		private function formatWarn(o:*):String
		{
			return "<font family='_sans' size='9' color='" + WARN_COLOR + "'>" + o + "</font>";
		}
		
	}
}