package org.aisy.upwindow
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import org.ais.event.TEvent;
	import org.ais.system.Ais;
	import org.aisy.display.USprite;

	/**
	 * 
	 * 弹出窗口组件（实体类）
	 * 
	 * @author viqu
	 * 
	 */
	internal class UpWindow extends USprite
	{
		/**
		 * 窗口名字
		 */
		public var NAME:String;
		/**
		 * 遮罩模式
		 */
		public var MASK_MODE:uint;
		/**
		 * 可拖动区域背景
		 */
		protected var _bg:Shape;
		/**
		 * 关闭按钮
		 */
		protected var _closeBtn:SimpleButton;
		/**
		 * 宽度
		 */
		protected var _width:Number;
		/**
		 * 高度
		 */
		protected var _height:Number;
		/**
		 * 是否可以移动
		 */
		protected var _isDrag:Boolean;
		/**
		 * 鼠标是否按下
		 */
		protected var _isMouseDown:Boolean;
		
		public function UpWindow(num:uint, obj:DisplayObject, name:String, maskMode:uint = 0, showBg:Boolean = true, isDrag:Boolean = true, color:uint = 0x000000, alpha:Number = 0.7, closeAlpha:Number = 1, showClose:Boolean = true):void
		{
			NAME = name;
			MASK_MODE = maskMode;
			this.name = num.toString();
			_isDrag = isDrag;
			
			init(obj, showBg, color, alpha, closeAlpha, showClose);
			
			obj = null;
			name = null;
		}
		
		/**
		 * 
		 * 初始化
		 * 
		 * @param obj
		 * @param showBg
		 * @param color
		 * @param alpha
		 * @param closeAlpha
		 * @param showClose
		 * 
		 */
		protected function init(obj:DisplayObject, showBg:Boolean, color:uint, alpha:Number, closeAlpha:Number, showClose:Boolean):void
		{
			_width = obj.width;
			_height = obj.height;
			
			if (showBg === true) {
				_bg = new Shape();
				_bg.graphics.beginFill(color, alpha);
				_bg.graphics.drawRoundRect(0, 0, obj.width + 20, obj.height + 20, 10, 10);
				_bg.graphics.endFill();
				addChild(_bg);
				
				obj.x = 10;
				obj.y = 10;
				
				_width += 20;
				_height += 20;
			}
			
			addChild(obj);
			
			if (showClose === true) {
				_closeBtn = new SimpleButton();
				_closeBtn.upState = drawCloseBtn(0x666666);
				_closeBtn.overState = drawCloseBtn(0x990000);
				_closeBtn.downState = drawCloseBtn(0x000000);
				_closeBtn.hitTestState = drawCloseBtn(0x000000);
				_closeBtn.useHandCursor = false;
				_closeBtn.alpha = closeAlpha;
				addChild(_closeBtn);
			}
			
			__addEvent();
			__layout();
			
			obj = null;
		}
		
		/**
		 * 
		 * 注册事件
		 * 
		 */
		protected function __addEvent():void
		{
			if (_isDrag === true) addEventListener(MouseEvent.MOUSE_DOWN, __mouseHandler);
			if (null !== _closeBtn) _closeBtn.addEventListener(MouseEvent.CLICK, __closeBtnHandler);
			
			TEvent.newTrigger("UP_WINDOW_NEW", __triggerHandler);
		}
		
		/**
		 * 
		 * 移除事件
		 * 
		 */
		protected function __removeEvent():void
		{
			if (null !== _closeBtn) _closeBtn.removeEventListener(MouseEvent.CLICK, __closeBtnHandler);
			
			TEvent.removeTrigger("UP_WINDOW_NEW", __triggerHandler);
		}
		
		/**
		 * 
		 * 计算布局
		 * 
		 */
		protected function __layout():void
		{
			if (null !== _closeBtn) {
				var obj:DisplayObject = getChildAt(_bg === null ? 0 : 1);
				_closeBtn.x = obj.x + obj.width - 5;
				_closeBtn.y = obj.y - 7;
				obj = null;
			}
			
			x = (Ais.IMain.stage.stageWidth - width) * 0.5;
			y = (Ais.IMain.stage.stageHeight - height) * 0.5;
		}
		
		/**
		 * 
		 * 绘制关闭按钮
		 * 
		 * @param color
		 * @param alpha
		 * @return 
		 * 
		 */
		protected function drawCloseBtn(color:uint, alpha:Number = 1):Shape
		{
			var s:Shape = new Shape();
			s.graphics.beginFill(color, alpha);
			s.graphics.drawCircle(5.8, 5.8, 6);
			s.graphics.endFill();
			s.graphics.lineStyle(0, 0xFFFFFF);
			s.graphics.moveTo(2.5, 2.5);
			s.graphics.lineTo(9, 9);
			s.graphics.moveTo(9, 2.5);
			s.graphics.lineTo(2.5, 9);
			s.graphics.endFill();
			return s;
		}
		
		/**
		 * 
		 * 关闭按钮 侦听
		 * 
		 * @param e
		 * 
		 */
		protected function __closeBtnHandler(e:MouseEvent):void
		{
			TEvent.trigger("UP_WINDOW_NEW", "CLEAR", {"name": NAME});
		}
		
		/**
		 * 
		 * 鼠标事件 侦听
		 * 
		 * @param e
		 * 
		 */
		protected function __mouseHandler(e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.MOUSE_DOWN:
					if (parent.getChildAt(parent.numChildren - 1) !== this) {
						parent.setChildIndex(this, parent.numChildren - 1);
						TEvent.trigger("UP_WINDOW_NEW", "TOP", {"name": NAME});
					}
					if (e.target is SimpleButton || e.target is TextField) return;
					if (e.target.hasOwnProperty("tabEnabled") === true && e.target.tabEnabled === true) return;
					if (e.target.hasOwnProperty("dynamic") === true && e.target.dynamic && e.target.dynamic.hasOwnProperty("mouseEnabled") === true && e.target.dynamic.mouseEnabled === false) return;
					if (_isMouseDown === false) {
						var _w:Number = width;
						var _h:Number = height;
						var _p:Number = 0.75;
						var _pw:Number = _w * _p;
						var _ph:Number = _h * _p;
						_pw = _pw > 99 ? (_w - 99) : _pw;
						_ph = _ph > 99 ? (_h - 99) : _ph;
						Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
						startDrag(false, new Rectangle(-_pw, -_ph, Ais.IMain.stage.stageWidth - width + _pw * 2, Ais.IMain.stage.stageHeight - height + _ph * 2));
						_isMouseDown = true;
					}
					break;
				case MouseEvent.MOUSE_UP:
					if (_isMouseDown === true) {
						stopDrag();
						Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
						_isMouseDown = false;
					}
					break;
			}
			e = null;
		}
		
		/**
		 * 
		 * 全局侦听
		 * 
		 * @param type
		 * @param data
		 * 
		 */
		protected function __triggerHandler(type:String, data:* = null):void
		{
			switch (type) {
				case "CLEAR":
					if (NAME === data.name) {
						TEvent.trigger("UP_WINDOW_AIS", "CLEAR", this);
						clear();
					}
					break;
				case "RESIZE":
					if (NAME === data.name) __layout();
					break;
				case "RESIZE_ALL":
					__layout();
					break;
				case "RESET_INAME":
					var i:uint = parseInt(name);
					if (i > data) name = (--i).toString();
					break;
			}
			type = null;
			data = null;
		}
		
		/**
		 * 
		 * 返回 宽度
		 * 
		 * @return 
		 * 
		 */
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 * 
		 * 返回 高度
		 * 
		 * @return 
		 * 
		 */
		override public function get height():Number
		{
			return _height;
		}
		
		/**
		 * 
		 * 清空
		 * 
		 */
		override public function clear():void
		{
			__removeEvent();
			super.clear();
			_bg = null;
			_closeBtn = null;
			NAME = null;
		}
		
	}
}