package org.aisy.skin
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.aisy.display.USprite;

	/**
	 * 
	 * Aisy 皮肤
	 * 
	 * @author Viqu
	 * 
	 */
	public class AisySkin
	{
		
		static public var TWEEN_LITE:String = "com.greensock.TweenLite";
		
		static public var BUTTON_SKIN:String = "_AISY_BUTTON";
		static public var CHECKBOX_SKIN:String = "_AISY_CHECKBOX_SKIN_";
		static public var RADIO_SKIN:String = "_AISY_RADIO_SKIN_";
		static public var SCROLLER_SKIN:String = "_AISY_SCROLLER_SKIN";
		static public var IMAGE_SKIN:String = "_AISY_LOADING";
		
		static public var BUTTON_AUTO_SKIN:Boolean;
		static public var CHECKBOX_AUTO_SKIN:Boolean;
		static public var RADIO_AUTO_SKIN:Boolean;
		static public var SCROLLER_AUTO_SKIN:Boolean;
		static public var IMAGE_AUTO_SKIN:Boolean;
		
		static public var IMAGE_LOADING_MIN_SIZE:Number = 0;
		static public var IMAGE_LOADING_MAX_SIZE:Number = 70;
		/**
		 * [maskMode, showBg, isDrag, isLayout, color, alpha, closeAlpha, showClose]
		 */
		static public var UPWINDOWAIS_SHOW:Array = [0, true, true, true, 0x000000, 0.7, 1, true];
		static public var UPWINDOWAIS_VIEW:USprite;
		static public var UPWINDOWAIS_MASK:Function = __UPWINDOWAIS_MASK;
		static public var UPWINDOWAIS_MASK_TIME:Number = 500;
		static public var UPWINDOWAIS_MASK_COLOR:uint = 0x000000;
		static public var UPWINDOWAIS_MASK_COLOR_ALPHA:Number = 0.3;
		static public var UPWINDOWAIS_DRAG_SCALE:Number = 0.75;
		static public var UPWINDOWAIS_DRAG_MIN_WIDTH:Number = 99;
		static public var UPWINDOWAIS_DRAG_MIN_HEIGHT:Number = 99;
		
		static public var TIP_SKIN:Function = __TIP_SKIN;
		
		static public var TEXT_FORMAT:Function = __TEXT_FORMAT;
		
		static public var FONT_NAME:String = "Microsoft YaHei,微软雅黑,Arial,Verdana,_sans";
		static public var FONT_SIZE:Number = 14;
		
		static public var SCROLLER_DRAG_MIN_SIZE_H:Number = -1;
		static public var SCROLLER_DRAG_MIN_SIZE_V:Number = -1;
		static public var SCROLLER_OVERFLOW_H:Number = 0.3;
		static public var SCROLLER_OVERFLOW_V:Number = 0.3;
		static public var SCROLLER_AUTO_ALPHA:Boolean = true;
		static public var SCROLLER_MODE:int;
		
		static public var USE_MOUSEDOWN:Boolean = true;
		
		static public var MOBILE:Boolean;
		
		public function AisySkin()
		{
		}
		
		static protected function __UPWINDOWAIS_MASK():USprite
		{
			return new UpWindowMask();
		}
		
		/**
		 * tip 皮肤绘制函数
		 * @param e
		 * @param view
		 * @param tip
		 * @param parameters
		 */
		static protected function __TIP_SKIN(e:MouseEvent, view:USprite, tip:String, ...parameters):void
		{
			var obj:InteractiveObject = e.currentTarget as InteractiveObject;
			var layout:Boolean;
			switch (e.type) {
				case MouseEvent.ROLL_OVER:
					var textField:TextField = new TextField();
					textField.autoSize = TextFieldAutoSize.LEFT;
					textField.selectable = false;
					textField.defaultTextFormat = AisySkin.TEXT_FORMAT();
					textField.htmlText = tip;
					if (textField.width > 300) {
						textField.wordWrap = true;
						textField.width = 300;
					}
					view.graphics.clear();
					view.graphics.beginFill(0xFFFFFF, 0.9);
					view.graphics.drawRoundRect(0, 0, textField.width, textField.height, 5);
					view.graphics.endFill();
					view.addChild(textField);
					view.mouseChildren = view.mouseEnabled = false;
					layout = true;
					textField = null;
					break;
				case MouseEvent.MOUSE_MOVE:
					layout = true;
					break;
			}
			if (layout === true) {
				var p:int = 7;
				var x:int = e.stageX - (view.width >> 1);
				var y:int = e.stageY - view.height - p;
				if (x + view.width > obj.stage.stageWidth - p) {
					x = obj.stage.stageWidth - view.width - p;
				}
				else if (x < p) {
					x = p;
				}
				if (y < p) {
					y = e.stageY + p;
				}
				view.x = x;
				view.y = y;
			}
			obj = null;
			e = null;
			view = null;
			tip = null;
			parameters = null;
		}
		
		static protected function __TEXT_FORMAT():TextFormat
		{
			return new TextFormat(FONT_NAME, FONT_SIZE);
		}
		
	}
}
import flash.utils.getTimer;

import org.aisy.display.USprite;
import org.aisy.skin.AisySkin;
import org.aisy.utimer.UTimer;

internal class UpWindowMask extends USprite
{
	protected var _startTime:Number;
	protected var _alphaStart:Number;
	protected var _alphaChange:Number;
	protected var _utimer:UTimer;
	
	public function UpWindowMask()
	{
		with (graphics) {
			beginFill(AisySkin.UPWINDOWAIS_MASK_COLOR, AisySkin.UPWINDOWAIS_MASK_COLOR_ALPHA);
			drawRect(0, 0, 1, 1);
			endFill();
		}
		alpha = 0;
		tween(1);
	}
	
	protected function tween(alphaEnd:Number):void
	{
		_alphaStart = alpha;
		_alphaChange = alphaEnd - _alphaStart;
		_startTime = getTimer();
		if (null !== _utimer) _utimer.clear();
		_utimer = new UTimer();
		_utimer.setDelay(100 / 3);
		_utimer.setTimer(__utimerHandler);
		_utimer.start();
	}
	
	protected function __utimerHandler():void
	{
		var t:Number = getTimer() - _startTime;
		if (t < AisySkin.UPWINDOWAIS_MASK_TIME) {
			alpha = _alphaStart + _alphaChange * (1 - (t = 1 - (t / AisySkin.UPWINDOWAIS_MASK_TIME)) * t);
		}
		else {
			alpha = _alphaStart + _alphaChange;
			if (alpha === 0) super.clear();
			_utimer.clear();
			_utimer = null;
		}
	}
	
	override public function clear():void
	{
		tween(0);
	}
}