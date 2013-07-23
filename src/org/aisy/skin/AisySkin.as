package org.aisy.skin
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.aisy.display.USprite;
	import org.aisy.utils.FontUtil;

	/**
	 * 
	 * Aisy 皮肤
	 * 
	 * @author Viqu
	 * 
	 */
	public class AisySkin
	{
		
		static public var CHECKBOX_SKIN:String = "_AISY_CHECKBOX_SKIN_";
		static public var RADIO_SKIN:String = "_AISY_RADIO_SKIN_";
		static public var SCROLLER_SKIN:String = "_AISY_SCROLLER_SKIN";
		static public var IMAGE_SKIN:String = "_AISY_LOADING";
		static public var CONFIRM_SKIN:String = "_AISY_CONFIRM_SKIN";
		
		static public var UPWINDOWAIS_MASK:Function = __UPWINDOWAIS_MASK;
		
		static public var TIP_SKIN:Function = __TIP_SKIN;
		
		static public var TEXTFORMAT:Function = __TEXTFORMAT;
		
		static public var SCROLLER_DRAG_HEIGHT:Number = 12;
		static public var SCROLLER_POSITION:Boolean;
		
		static public var USE_MOUSEDOWN:Boolean = true;
		
		static public var MOBILE:Boolean;
		
		static protected var _fontName:String;
		
		public function AisySkin()
		{
		}
		
		static protected function __UPWINDOWAIS_MASK():USprite
		{
			var s:USprite = new USprite();
			with (s.graphics) {
				beginFill(0x000000, 0.3);
				drawRect(0, 0, 1, 1);
				endFill();
			}
			return s;
		}
		
		/**
		 * 
		 * tip 皮肤绘制函数
		 * 
		 * @param e
		 * @param group
		 * @param tip
		 * @param parameters
		 * 
		 */
		static protected function __TIP_SKIN(e:MouseEvent, group:USprite, tip:String, ...parameters):void
		{
			var obj:InteractiveObject = e.currentTarget as InteractiveObject;
			var _layout:Boolean;
			
			switch (e.type) {
				case MouseEvent.ROLL_OVER:
					var _textField:TextField = new TextField();
					_textField.autoSize = "left";
					_textField.selectable = false;
					_textField.defaultTextFormat = TEXTFORMAT();
					_textField.htmlText = tip;
					
					with (group.graphics) {
						clear();
						beginFill(0xFF0000, 0.3);
						drawRoundRect(0, 0, _textField.width, _textField.height, 5);
						endFill();
					}
					
					group.addChild(_textField);
					group.mouseChildren = group.mouseEnabled = false;
					_layout = true;
					
					_textField = null;
					break;
				case MouseEvent.MOUSE_MOVE:
					_layout = true;
					break;
			}
			
			if (_layout === true) {
				var p:Number = 7;
				var _x:Number = e.stageX - group.width * 0.5;
				var _y:Number = e.stageY - group.height - p;
				
				if (_x + group.width > obj.stage.stageWidth - p) {
					_x = obj.stage.stageWidth - group.width - p;
				}
				else if (_x < p) {
					_x = p;
				}
				if (_y < p) {
					_y = e.stageY + p;
				}
				group.x = _x;
				group.y = _y;
			}
			
			e = null;
			group = null;
			tip = null;
			parameters = null;
			obj = null;
		}
		
		static protected function __TEXTFORMAT():TextFormat
		{
			if (null === _fontName) {
				var v:Vector.<String> = Vector.<String>(["Microsoft YaHei", "微软雅黑", "Arial", "Verdana"]);
				if (FontUtil.initialized === false) FontUtil.initialize();
				_fontName = FontUtil.getFontName(v, 1);
				if (_fontName === v[1]) _fontName = v[0];
				v = null;
			}
			return new TextFormat(_fontName, 16);
		}
		
	}
}