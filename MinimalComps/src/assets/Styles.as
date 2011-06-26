package assets
{
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GradientBevelFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import mx.effects.Blur;

	import spark.filters.GradientFilter;

	public class Styles
	{

		public static const BUTTON_BAR_LABEL:TextFormat 			= new TextFormat("Droid Sans", 11, 0xFFFFFF, false);
		public static const TEXT_HEADER_LABEL:TextFormat 			= new TextFormat("Droid Sans", 14, 0xFFFFFF, true);
		public static const FORM_INPUT:TextFormat 					= new TextFormat("Droid Sans", 18, 0x000000, false);
		public static const BUTTON_LABEL:TextFormat 				= new TextFormat("Droid Sans", 18, 0xFFFFFF, false);
		public static const LABEL_FIELD:TextFormat 					= new TextFormat("Droid Sans", 18, 0xCCCCCC, false);
		public static const HEADER_LABEL:TextFormat 				= new TextFormat("Droid Sans", 21, 0xFFFFFF, true);
		public static const HEADER_LABEL_FILTERS:Array				= [new DropShadowFilter(1, 120, 0x000000, .29, 0, 0),
				                                                        new BevelFilter(2, 120, 0xFFFFFF, .75, 0x000000, .75, 0,  0,  1, 1, "outer"),
																		new GradientBevelFilter(1, 90, [0xFFFFFF], [.11], [255], 0, 0, 1)

		];
		public static const ALERT_MESSAGE:TextFormat 				= new TextFormat("Droid Sans", 14, 0xFFFFFF, false, null, null, null, null, TextFormatAlign.CENTER);

		public static const LOGIN_TITLE:TextFormat					= new TextFormat("Myriad Pro", 21, 0x333333, false);
		public static const FORM_TITLE:TextFormat 					= new TextFormat("Lucida Grande", 24, 0x333333);
		public static const FORM_LABEL:TextFormat 					= new TextFormat("Lucida Grande", 16, 0x333333, false);

        public static const FORM_PROMPT:TextFormat 					= new TextFormat("Lucida Grande", 16, 0x999999, false);
		public static const PUSH_BUTTON_LABEL:TextFormat 			= new TextFormat("Lucida Grande", 21, 0x333333, false);
		public static const PUSH_BUTTON_SELECTED_LABEL:TextFormat	= new TextFormat("Lucida Grande", 21, 0x0066CC, false);
		public static const CHECKBOX_LABEL:TextFormat 				= new TextFormat("Lucida Grande", 16, 0x333333, false);
		public static const LINK_BUTTON_TEXT:TextFormat 			= new TextFormat("Lucida Grande", 16, 0xCCCCCC, false, false, true);
		public static const TAB_TEXT_SELECTED:TextFormat 			= new TextFormat("Lucida Grande", 18, 0xFB5400, false);
		public static const APP_TITLE:TextFormat 					= new TextFormat("Lucida Grande", 16, 0x0066CC, false);
        public static const SONG_TITLE:TextFormat                   = new TextFormat("Lucida Grande", 18, 0x005ACE, false);
		public static const SONG_TIME:TextFormat                    = new TextFormat("Lucida Grande", 14, 0x333333, false);
		public static const MENU_TEXT:TextFormat                    = new TextFormat("Lucida Grande", 14, 0x333333, false);
		public static const CHANGE_LOG:TextFormat                    = new TextFormat("sans", 14, 0x333333, false);
		
        private static var inited:Boolean                           = classConstruct();

		public function Styles()
		{
		}

        private static function classConstruct():Boolean
        {
            SONG_TIME.letterSpacing = -2;
            return true;
        }
	}
}