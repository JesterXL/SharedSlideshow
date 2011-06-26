package com.jxl.shareslidesmobile.controls
{

	import assets.Styles;

	import com.bit101.components.Component;
	import com.jxl.shareslidesmobile.events.view.AlertEvent;

	import flash.desktop.NativeApplication;

	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.ContextMenu;

	use namespace jxlinternal;

	public class Alert extends Component
	{
		public static const YES:uint 			= 0x0001;
	    public static const NO:uint 			= 0x0002;
	    public static const OK:uint 			= 0x0004;
	    public static const CANCEL:uint			= 0x0008;

	    public static var yesLabel:String		= "Yes";
	    public static var noLabel:String		= "No";
	    public static var okLabel:String 		= "OK";
	    public static var cancelLabel:String 	= "Cancel";

		private var titleField:LabelField;
		private var messageText:TextField;
		private var background:MessageWindowBackgroundSymbol;
		private var curtain:Sprite;

		jxlinternal var allowedToClose:Boolean		= true;
		jxlinternal var buttonFlags:uint = OK;
		jxlinternal var closeHandler:Function;
		jxlinternal var modal:Boolean 		= false;

		private var _title:String = "";
		private var titleDirty:Boolean = false;
		private var _message:String = "";
		private var messageDirty:Boolean  = false;
		private var buttons:Vector.<Button> 	= new Vector.<Button>();
		private var buttonClicked:String;


		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
			titleDirty = true;
			invalidateProperties();
		}


		public function get message():String
		{
			return _message;
		}

		public function set message(value:String):void
		{
			_message = value;
			messageDirty = true;
			invalidateProperties();
		}

		public static function show(message:String = "",
		    							title:String = "",
		                                flags:uint = 0x4 /* Alert.OK */,
		                                modal:Boolean = true,
		                                closeHandler:Function = null):Alert
	    {
	        var alert:Alert = new Alert();

	        if (flags & Alert.OK ||
	            flags & Alert.CANCEL ||
	            flags & Alert.YES ||
	            flags & Alert.NO)
	        {
	            alert.jxlinternal::buttonFlags = flags;
	        }

	        alert.jxlinternal::closeHandler 	= closeHandler;
	        alert.message 						= message;
	        alert.title				 			= title;
	        alert.jxlinternal::modal 			= modal;

	        if(modal)
	        {
	        	alert.jxlinternal::allowedToClose = false;
	        }
			else
			{
				alert.jxlinternal::allowedToClose = true;
			}

	        if(modal)
				alert.jxlinternal::addCurtains();

			UIGlobals.stage.addChild(alert);

			alert.jxlinternal::createAlertChildren();

			//var s:Screen = Screen.mainScreen;
			//alert.move((s.bounds.width / 2) - (alert.width / 2), s.bounds.height / 4);
			alert.move((UIGlobals.stage.stageWidth / 2) - (alert.width / 2), (UIGlobals.stage.stageHeight / 4));

	        if (closeHandler != null)
	        {
	            alert.addEventListener(AlertEvent.ALERT_CLOSED, closeHandler);
	        }

	        return alert;
	    }

		public function Alert(parent:DisplayObjectContainer = null)
		{
			super(parent);
		}

		public function close():void
		{
			allowedToClose = true;
			if(modal)
				removeCurtains();

			if(parent)
				parent.removeChild(this);
		}

		protected override function init():void
		{
			super.init();

			width = 272;
			height = 129;
		}

		protected override function addChildren():void
		{
			super.addChildren();

			background = new MessageWindowBackgroundSymbol();
			addChild(background);

			titleField = new LabelField(this);

			messageText = new TextField();
			addChild(messageText);
			messageText.selectable = false;
			messageText.wordWrap = messageText.multiline = true;
			messageText.mouseEnabled = messageText.mouseWheelEnabled = false;
			messageText.tabEnabled = false;
			messageText.autoSize = TextFieldAutoSize.CENTER;
			messageText.defaultTextFormat = Styles.ALERT_MESSAGE;
			//messageText.border = true;
			//messageText.borderColor = 0x00FF00;

			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
		}

		protected override function commitProperties():void
		{
			super.commitProperties();

			if(titleDirty)
			{
				titleDirty = false;
				titleField.text = _title;
			}

			if(messageDirty)
			{
				messageDirty = false;
				messageText.text = _message;
			}
		}

		public override function draw():void
		{
			super.draw();

			background.width = width;
			background.height = height;

			titleField.x = (width / 2) - ((titleField.textWidth + 4) / 2);
			titleField.y = 8;
			titleField.width = width - 16;
			titleField.height = titleField.textHeight + 4;

			messageText.x = 8;
			messageText.y = titleField.y + titleField.textHeight + 4 + 8;
			messageText.width = width - 16;
			messageText.height = messageText.textHeight + 4;

			if(buttons.length < 1) return;

			const btn_space:Number = 10;
			var button:Button = buttons[buttons.length - 1];
			var btnTop:Number = height - 8 - button.height;
			var btnLeft: uint = (width / 2) - (((button.width * buttons.length) + (btn_space * (buttons.length - 1))) / 2);
			var len:int = buttons.length;
			for (var index:uint = 0; index < len; index++)
			{
				button = buttons[index] as Button;
				button.y = btnTop;
				button.x = btnLeft;
				btnLeft = btnLeft + button.width + btn_space;
			}
		}

		jxlinternal function addCurtains():void
		{
			if(curtain)
				return;

			curtain = new Sprite();
			curtain.name = "curtain";
			curtain.alpha = .7;
			curtain.x = 0;
			curtain.y = 0;
			curtain.graphics.clear();
			curtain.graphics.beginFill(0x000000);
			curtain.graphics.drawRect(0, 0, Screen.mainScreen.bounds.width, Screen.mainScreen.bounds.height);
			curtain.graphics.endFill();
			UIGlobals.stage.addEventListener(Event.RESIZE, resizeCurtain, false, 0, true);
			UIGlobals.stage.addChild(curtain);
		}

		jxlinternal function createAlertChildren():void
		{
			var button:Button;

			if (buttonFlags & Alert.CANCEL)
			{
				button = createButton(cancelLabel, "CANCEL");
			}

			if (buttonFlags & Alert.NO)
			{
				button = createButton(noLabel, "NO");
			}

			if (buttonFlags & Alert.YES)
			{
				button = createButton(yesLabel, "YES");
			}

			if (buttonFlags & Alert.OK)
			{
				button = createButton(okLabel, "OK");
			}
		}

		private function resizeCurtain(event:Event):void
		{
			curtain.width = UIGlobals.stage.width;
			curtain.height	= UIGlobals.stage.height;
		}

		private function removeCurtains():void
		{
			if(curtain && curtain.parent)
			{
				curtain.parent.removeChild(curtain);
				curtain = null;
			}
		}

		private function createButton(label:String, name:String):Button
		{
			var button:Button 	= new Button();
			addChild(button);
			button.label 			= label;
			button.name 			= name;
			button.width			= 80;
			button.addEventListener(MouseEvent.CLICK, onButtonClick);
			buttons.push(button);
			return button;
		}

		private function onButtonClick(event:MouseEvent):void
		{
			buttonClicked = Button(event.currentTarget).name;
			removeAlert(buttonClicked);
		}

		private function removeAlert(buttonPressed:String):void
		{
			var closeEvent:AlertEvent = new AlertEvent(AlertEvent.ALERT_CLOSED);
			if (buttonPressed == "YES")
				closeEvent.detail = AlertEvent.YES;
			else if (buttonPressed == "NO")
				closeEvent.detail = AlertEvent.NO;
			else if (buttonPressed == "OK")
				closeEvent.detail = AlertEvent.OK;
			else if (buttonPressed == "CANCEL")
				closeEvent.detail = AlertEvent.CANCEL;

			close();

			dispatchEvent(closeEvent);
		}
	}
}

