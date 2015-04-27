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
	import org.aisy.skin.AisySkin;

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
		 * 可以移动的区域
		 */
		protected var _moveRect:Rectangle;
		/**
		 * 宽度
		 */
		protected var _width:Number;
		/**
		 * 高度
		 */
		protected var _height:Number;
		/**
		 * 拖动起始坐标
		 */
		protected var _mouseX:Number;
		/**
		 * 拖动起始坐标
		 */
		protected var _mouseY:Number;
		/**
		 * 是否可以移动
		 */
		protected var _isDrag:Boolean;
		/**
		 * 是否自动布局
		 */
		protected var _isLayout:Boolean;
		/**
		 * 鼠标是否按下
		 */
		protected var _isMouseDown:Boolean;
		
		public function UpWindow(num:uint, obj:DisplayObject, name:String, maskMode:uint = 0, showBg:Boolean = true, isDrag:Boolean = true, isLayout:Boolean = true, color:uint = 0x000000, alpha:Number = 0.7, closeAlpha:Number = 1, showClose:Boolean = true):void
		{
			NAME = name;
			MASK_MODE = maskMode;
			this.name = num.toString();
			_isDrag = isDrag;
			_isLayout = isLayout;
			init(obj, showBg, color, alpha, closeAlpha, showClose);
			obj = null;
			name = null;
		}
		
		/**
		 * 初始化
		 * @param obj
		 * @param showBg
		 * @param color
		 * @param alpha
		 * @param closeAlpha
		 * @param showClose
		 */
		protected function init(obj:DisplayObject, showBg:Boolean, color:uint, alpha:Number, closeAlpha:Number, showClose:Boolean):void
		{
			width = obj.width;
			height = obj.height;
			if (showBg === true) {
				_bg = new Shape();
				_bg.graphics.beginFill(color, alpha);
				_bg.graphics.drawRoundRect(0, 0, obj.width + 20, obj.height + 20, 10, 10);
				_bg.graphics.endFill();
				addChild(_bg);
				obj.x = 10;
				obj.y = 10;
				width += 20;
				height += 20;
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
//				obj.y = 10;
			}
			__addEvent();
			__layout();
			obj = null;
		}
		
		/**
		 * 注册事件
		 */
		protected function __addEvent():void
		{
			if (_isDrag === true) addEventListener(MouseEvent.MOUSE_DOWN, __mouseHandler);
			if (null !== _closeBtn) _closeBtn.addEventListener(MouseEvent.CLICK, __closeBtnHandler);
			TEvent.newTrigger("UP_WINDOW_NEW", __triggerHandler);
		}
		
		/**
		 * 移除事件
		 */
		protected function __removeEvent():void
		{
			if (null !== _closeBtn) _closeBtn.removeEventListener(MouseEvent.CLICK, __closeBtnHandler);
			if (_isMouseDown === true) {
				Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
				Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
			}
			TEvent.removeTrigger("UP_WINDOW_NEW", __triggerHandler);
		}
		
		/**
		 * 计算布局
		 */
		protected function __layout():void
		{
			if (null !== _closeBtn) {
				var obj:DisplayObject = getChildAt(null === _bg ? 0 : 1);
				_closeBtn.x = obj.x + obj.width - 5;
				_closeBtn.y = obj.y - 7;
				obj = null;
			}
			if (_isLayout === true) {
				x = (Ais.IMain.stage.stageWidth - width) >> 1;
				y = (Ais.IMain.stage.stageHeight - height) >> 1;
			}
		}
		
		/**
		 * 绘制关闭按钮
		 * @param color
		 * @param alpha
		 * @return 
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
		 * 关闭按钮 侦听
		 * @param e
		 */
		protected function __closeBtnHandler(e:MouseEvent):void
		{
			TEvent.trigger("UP_WINDOW_NEW", "CLEAR", {"name": NAME});
		}
		
		/**
		 * 鼠标事件 侦听
		 * @param e
		 */
		protected function __mouseHandler(e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.MOUSE_MOVE:
					if (_isMouseDown === true) {
						var _x:Number = Ais.IMain.stage.mouseX - _mouseX, _y:Number = Ais.IMain.stage.mouseY - _mouseY;
						if (_x < _moveRect.x) _x = _moveRect.x;
						else if (_x > _moveRect.width) _x = _moveRect.width;
						if (_y < _moveRect.y) _y = _moveRect.y;
						else if (_y > _moveRect.height) _y = _moveRect.height;
						x = _x;
						y = _y;
					}
					break;
				case MouseEvent.MOUSE_DOWN:
					if (parent.getChildAt(parent.numChildren - 1) !== this) {
						parent.setChildIndex(this, parent.numChildren - 1);
						TEvent.trigger("UP_WINDOW_NEW", "TOP", {"name": NAME});
					}
					if (e.target is SimpleButton || e.target is TextField) return;
					if (e.target.hasOwnProperty("tabEnabled") === true && e.target.tabEnabled === true) return;
					if (e.target.hasOwnProperty("dynamic") === true && e.target.dynamic && e.target.dynamic.hasOwnProperty("mouseEnabled") === true && e.target.dynamic.mouseEnabled === false) return;
					if (_isMouseDown === false) {
						var w:Number = width;
						var h:Number = height;
						var pw:Number = w * AisySkin.UPWINDOWAIS_DRAG_SCALE;
						var ph:Number = h * AisySkin.UPWINDOWAIS_DRAG_SCALE;
//						w = w > AisySkin.UPWINDOWAIS_DRAG_MIN_WIDTH ? AisySkin.UPWINDOWAIS_DRAG_MIN_WIDTH : w * AisySkin.UPWINDOWAIS_DRAG_SCALE;
//						h = h > AisySkin.UPWINDOWAIS_DRAG_MIN_HEIGHT ? AisySkin.UPWINDOWAIS_DRAG_MIN_HEIGHT : h * AisySkin.UPWINDOWAIS_DRAG_SCALE;
//						pw = pw < w ? w : pw;
//						ph = ph < h ? h : ph;
						pw = pw > AisySkin.UPWINDOWAIS_DRAG_MIN_WIDTH ? (w - AisySkin.UPWINDOWAIS_DRAG_MIN_WIDTH) : pw;
						ph = ph > AisySkin.UPWINDOWAIS_DRAG_MIN_HEIGHT ? (h - AisySkin.UPWINDOWAIS_DRAG_MIN_HEIGHT) : ph;
						_isMouseDown = true;
						_mouseX = e.stageX - x;
						_mouseY = e.stageY - y;
						_moveRect = new Rectangle(-pw, -ph, Ais.IMain.stage.stageWidth - width + pw, Ais.IMain.stage.stageHeight - height + ph);
						removeEventListener(MouseEvent.MOUSE_DOWN, __mouseHandler);
						Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
						Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
					}
					break;
				case MouseEvent.MOUSE_UP:
					if (_isMouseDown === true) {
						_isMouseDown = false;
						Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
						Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
						addEventListener(MouseEvent.MOUSE_DOWN, __mouseHandler);
						_moveRect = null;
					}
					break;
			}
			e = null;
		}
		
		/**
		 * 全局侦听
		 * @param type
		 * @param data
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
//				case "TOP":
//					break;
				case "RESET_INAME":
					var i:uint = parseInt(name);
					if (i > data) name = (--i).toString();
					break;
			}
			type = null;
			data = null;
		}
		
		/**
		 * 设置 宽度
		 * @param value
		 */
		override public function set width(value:Number):void
		{
			_width = value;
		}
		
		/**
		 * 设置 高度
		 * @param value
		 */
		override public function set height(value:Number):void
		{
			_height = value;
		}
		
		/**
		 * 返回 宽度
		 * @return 
		 */
		override public function get width():Number
		{
			if (_isLayout === false && numChildren !== 0) {
				return getChildAt(null === _bg ? 0 : 1).width;
			}
			return _width;
		}
		
		/**
		 * 返回 高度
		 * @return 
		 */
		override public function get height():Number
		{
			if (_isLayout === false && numChildren !== 0) {
				return getChildAt(null === _bg ? 0 : 1).height;
			}
			return _height;
		}
		
		/**
		 * 清空
		 */
		override public function clear():void
		{
			__removeEvent();
			super.clear();
			_moveRect = null;
			_bg = null;
			_closeBtn = null;
			NAME = null;
		}
		
	}
}