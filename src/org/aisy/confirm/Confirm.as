package org.aisy.confirm
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	import org.ais.event.TEvent;
	import org.aisy.display.USprite;
	import org.aisy.interfaces.IClear;
	import org.aisy.skin.AisySkin;

	/**
	 * 
	 * Confirm 弹出窗口
	 * 
	 * @author viqu
	 * 
	 */
	public final class Confirm extends USprite
	{
		static protected var instance:Confirm;
		/**
		 * 内容数组
		 */
		protected var __messages:Array;
		/**
		 * 背景
		 */
		protected var bgMc:MovieClip;
		
		public function Confirm()
		{
			init();
		}
		
		/**
		 * 
		 * 初始化
		 * 
		 */
		protected function init():void
		{
			__messages = [];
			TEvent.newTrigger("UP_WINDOW_NEW", __upWindowHandler);
		}
		
		/**
		 * 
		 * 注册事件
		 * 
		 */
		protected function __addEvent():void
		{
			bgMc.mc_btn.addEventListener(MouseEvent.CLICK, __mouseHandler);
		}
		
		/**
		 * 
		 * 移除事件
		 * 
		 */
		protected function __removeEvent():void
		{
			bgMc.mc_btn.removeEventListener(MouseEvent.CLICK, __mouseHandler);
		}
		
		/**
		 * 
		 * 显示 消息内容
		 * 
		 * @param content
		 * @param title
		 * 
		 */
		protected function __showMessage(content:String, title:String):void
		{
			clearView();
			
			var hp:Number = 30;
			
			var _y:Number = 30;
			
			var _TH:Number = 0;
			
			bgMc = new (getDefinitionByName(AisySkin.CONFIRM_SKIN) as Class)();
			
			addChild(bgMc);
			
			var _f:TextFormat = new TextFormat();
			_f.font = "微软雅黑";
			_f.color = 0xffffff;
			_f.size = 15;
			
			var cF:TextField = new TextField();
			cF.defaultTextFormat = _f;
			
			addChild(cF);
			
			cF.x = hp;
			cF.y = _y;
			
			cF.htmlText = content;
			cF.wordWrap = false;
			
			var _minW:Number = 200;
			var _maxW:Number = 390;
			var _w:Number = cF.textWidth + 5;
			_w = _w < _minW ? _minW : _w;
			_w = _w > _maxW ? _maxW : _w;
			
			cF.width = _w;
			cF.wordWrap = true;
			
			if (title) {
				_f.color = 0xff0000;
				
				var tF:TextField = new TextField();
				tF.defaultTextFormat = _f;
				tF.selectable = false;
				tF.autoSize = "left";
				
				tF.htmlText = title;
				tF.textColor = 0xFF0000;
				addChild(tF);
				
				tF.x = (_w - tF.textWidth) * 0.5 + hp;
				tF.y = _y;
				_y += tF.height + 10;
				
				tF = null;
			}
			
			var _minH:Number = 70;
			var _h:Number = cF.textHeight + 5;
			_h = _h < _minH ? _minH : _h;
			
			cF.width = cF.textWidth + 5;
			cF.height = cF.textHeight + 5;
			
			cF.y = _y + (_h - cF.textHeight) * 0.5;
			
			_TH += _y;
			_TH += _h + 15;
			
			_h = bgMc.height - bgMc.mc_btn.y;
			
			bgMc.mc_bg.width = _w + hp * 2;
			bgMc.mc_bg.height = _TH + _h;
			
			bgMc.mc_btn.x = (bgMc.width - bgMc.mc_btn.width) * 0.5;
			bgMc.mc_btn.y = bgMc.height - _h;
			
			__addEvent();
			
			cF.x = (bgMc.width - cF.width) * 0.5;
			
			cF = null;
			content = null;
			title = null;
			
			if (TEvent.trigger("UP_WINDOW_AIS", "SHOW", [this, "CONFIRM", 2, false, true, 0, 0, 1, false]) === false) {
				clear();
			}
		}
		
		/**
		 * 
		 * 鼠标侦听
		 * 
		 * @param e
		 * 
		 */
		protected function __mouseHandler(e:MouseEvent):void
		{
			var data:* = {"name": "CONFIRM"};
			switch (e.target.name) {
				case "btn_ok":
					data.confirm = true;
					break;
			}
			TEvent.trigger("UP_WINDOW_NEW", "CLEAR", data);
			data = null;
		}
		
		/**
		 * 
		 * UpWindow 的侦听
		 * 
		 * @param type
		 * 
		 */
		protected function __upWindowHandler(type:String, data:* = null):void
		{
			switch (type) {
				case "CLEAR":
					if (data.name !== "CONFIRM") return;
					var arr:Array;
					if (data.confirm) arr = [true];
					else arr = [false];
					arr = arr.concat(__messages[0][3]);
					if (__messages[0][2]) __messages[0][2].apply(null, arr.slice(0, __messages[0][2].length));
					arr = null;
					__messages.shift();
					if (__messages.length) __showMessage(__messages[0][1], __messages[0][0]);
					else clear();
					break;
				case "CLEAR_ALL":
					clear();
					break;
			}
			type = null;
			data = null;
		}
		
		/**
		 * 
		 * 显示窗口
		 * 
		 * @param content
		 * @param title
		 * 
		 */
		public function show(content:String, title:String = null, callback:Function = null, ...callbackParams):void
		{
			var len:uint = __messages.length;
			__messages[len] = [title, content, callback, callbackParams];
			if (len === 0) __showMessage(content, title);
			content = null;
			title = null;
			callback = null;
		}
		
		/**
		 * 
		 * 清空显示列表
		 * 
		 */
		protected function clearView():void
		{
			if (null !== bgMc) __removeEvent();
			var obj:*;
			while (numChildren) {
				obj = getChildAt(0);
				if (obj is IClear) obj.clear();
				else removeChildAt(0);
			}
			obj = null;
			
			bgMc = null;
		}
		
		/**
		 * 
		 * 清空
		 * 
		 */
		override public function clear():void
		{
			clearView();
			super.clear();
			__messages = null;
			instance = null;
			
			TEvent.removeTrigger("UP_WINDOW_NEW", __upWindowHandler);
		}
		
		static public function getInstance():Confirm
		{
			if (null === instance) instance = new Confirm();
			return instance;
		}
		
	}
}