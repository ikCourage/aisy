package org.aisy.scroller
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	import org.ais.system.Ais;
	import org.aisy.display.USprite;
	import org.aisy.skin.AisySkin;

	/**
	 * 
	 * 滚动条
	 * 
	 * @author Viqu
	 * 
	 */
	internal class ScrollBar extends USprite
	{
		/**
		 * 数据对象
		 */
		protected var iData:ScrollerData;
		/**
		 * 滚动条
		 */
		protected var _scrollSkin:DisplayObjectContainer;
		/**
		 * 滚动高度
		 */
		protected var _scrollHeight:Number;
		/**
		 * 布局方向
		 */
		protected var _layout:uint;
		
		public function ScrollBar(data:ScrollerData, layout:uint)
		{
			iData = data;
			_layout = layout;
			tabChildren = tabEnabled = false;
		}
		
		/**
		 * 
		 * 计算布局
		 * 
		 */
		protected function __layout():void
		{
			if (null === iData.mask || null === _scrollSkin) return;
			
			mouseChildren = mouseEnabled = !iData.position;
			
			_scrollSkin.rotation = 0;
			
			var _up:DisplayObject = _scrollSkin.getChildByName("up");
			var _down:DisplayObject = _scrollSkin.getChildByName("down");
			var _line:DisplayObjectContainer = _scrollSkin.getChildByName("line") as DisplayObjectContainer;
			var _linee:DisplayObject = _line.getChildByName("line");
			var _drag:Sprite = _line.getChildByName("drag") as Sprite;
			_up = _up !== null ? _up : _scrollSkin["up"];
			_down = _down !== null ? _down : _scrollSkin["down"];
			_line = _line !== null ? _line : _scrollSkin["line"];
			_linee = _linee !== null ? _linee : _line["line"];
			_drag = _drag !== null ? _drag : _line["drag"];
			
			var _y0:Number = _line.y;
			var _h0:Number = _line.y - _up.height;
			var _h1:Number = _down.y - _y0 - _line.height;
			
			var _length:String = _layout === 1 ? "height" : "width";
			var _dragY:Number = _drag.y;
			
			if (_scrollSkin.hasOwnProperty("setSize") === true) {
				_scrollSkin["setSize"](iData[_length]);
			}
			else {
				_drag.y = 0;
				_linee.height = (iData[_length] - _up.height - _down.height - _h0 - _h1);
				_down.y = _y0 + _linee.height + _h1;
			}
			if (iData.elastic === true) {
				var _dH:Number = _line.height * iData[_length] / iData.obj[_length];
				_drag.height = _dH < AisySkin.SCROLLER_DRAG_HEIGHT ? AisySkin.SCROLLER_DRAG_HEIGHT : _dH;
			}
			_scrollHeight = _line.height - _drag.height;
			if (_layout === 1) {
				if (iData.position === true) _scrollSkin.x = iData.width - _scrollSkin.width;
				else _scrollSkin.x = iData.width + iData.paddingH;
			}
			else {
				_scrollSkin.rotation = -90;
				if (iData.position === true) _scrollSkin.y = iData.height;
				else _scrollSkin.y = iData.height + _scrollSkin.height + iData.paddingV;
			}
			if (iData.isMouseDown === true) {
				_drag.y = _dragY;
				if (iData.position === true) {
					var _coor:String = _layout === 1 ? "y" : "x";
					var _rLength:Number = iData.obj[_length] - iData[_length];
					var _lengthP:Number = -_rLength / _scrollHeight;
					var p:Number = iData.obj[_coor];
					p = p > 0 ? 0 : p;
					p = p < -_rLength ? -_rLength : p;
					_drag.y = p / _lengthP;
				}
				else {
					Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __scrollHandler);
					Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_MOVE, __scrollHandler);
				}
			}
			else {
				if (iData.position === true) getDefinitionByName("com.greensock.TweenLite").to(this, 0.3, {alpha: 1, onComplete: __tweenCompleteHandler});
			}
		}
		
		/**
		 * 
		 * 计算滚动条位置
		 * 
		 * @param p
		 * @param type
		 * 
		 */
		public function layoutScroll(p:Number = 0, type:int = 0):void
		{
			var _length:String = _layout === 1 ? "height" : "width";
			var _rLength:Number = iData.obj[_length] - iData[_length];
			if (_rLength === 0) return;
			var _lengthP:Number = -_rLength / _scrollHeight;
			var _coor:String = _layout === 1 ? "y" : "x";
			var _delay:Number = iData.delay + iData.moveDelay;
			var _drag:Sprite = (_scrollSkin.getChildByName("line") as DisplayObjectContainer).getChildByName("drag") as Sprite;
			var d:* = {};
			p = p > 0 ? 0 : p;
			p = p < -_rLength ? -_rLength : p;
			var _dragY:Number = p / _lengthP;
			_dragY = _dragY < 0 ? 0 : _dragY;
			_dragY = _dragY > _scrollHeight ? _scrollHeight : _dragY;
			if (AisySkin.MOBILE === true && iData.position === true && type !== 2) {
				if (type === 0) {
					_dragY = iData.obj[_coor] / _lengthP;
					_dragY = _dragY < 0 ? 0 : _dragY;
					_dragY = _dragY > _scrollHeight ? _scrollHeight : _dragY;
				}
				else {
					d["onComplete"] = __tweenCompleteHandler;
					
					if (_dragY.toFixed(0) === _drag.y.toFixed(0)) _delay = 0;
				}
				d["y"] = _dragY;
				if (_delay >= 0.3) getDefinitionByName("com.greensock.TweenLite").to(this, 0.3, {alpha: 1});;
				getDefinitionByName("com.greensock.TweenLite").to(_drag, _delay, d);
			}
			else {
				if (type === 3) {
					iData.obj[_coor] = p;
				}
				else if (iData.delay <= 0) {
					_drag.y = _dragY;
					iData.obj[_coor] = p;
				}
				else {
					d[_coor] = p;
					getDefinitionByName("com.greensock.TweenLite").to(_drag, _delay, {y: _dragY, onComplete: iData.position === true ? __tweenCompleteHandler : null});
					getDefinitionByName("com.greensock.TweenLite").to(iData.obj, _delay, d);
				}
			}
			if (iData.position === true && type === 2) getDefinitionByName("com.greensock.TweenLite").to(this, 0.3, {alpha: 1, onComplete: _delay < 0.3 ? __tweenCompleteHandler : null});
		}
		
		/**
		 * 
		 * 缓动结束侦听
		 * 
		 */
		protected function __tweenCompleteHandler():void
		{
			getDefinitionByName("com.greensock.TweenLite").to(this, 0.5, {alpha: 0});
		}
		
		/**
		 * 
		 * 注册侦听
		 * 
		 */
		protected function __addEvent():void
		{
			parent.addEventListener(MouseEvent.MOUSE_WHEEL, __scrollHandler);
			
			if (iData.position === true) return;
			
			_scrollSkin.addEventListener(MouseEvent.MOUSE_DOWN, __scrollHandler);
		}
		
		/**
		 * 
		 * 移除侦听
		 * 
		 */
		protected function __removeEvent():void
		{
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __scrollHandler);
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __scrollHandler);
			
			if (null !== parent) parent.removeEventListener(MouseEvent.MOUSE_WHEEL, __scrollHandler);
			
			if (null !== _scrollSkin) {
				_scrollSkin.removeEventListener(MouseEvent.MOUSE_DOWN, __scrollHandler);
			}
		}
		
		/**
		 * 
		 * 竖向滚动条鼠标侦听
		 * 
		 * @param e
		 * 
		 */
		protected function __scrollHandler(e:MouseEvent):void {
			if (iData.enabled === false) return;
			iData.moveDelay = 0;
			var _coor:String = _layout === 1 ? "y" : "x";
			var _length:String = _layout === 1 ? "height" : "width";
			var _rLength:Number = iData.obj[_length] - iData[_length];
			var _lengthP:Number = -_rLength / _scrollHeight;
			var _line:DisplayObjectContainer = _scrollSkin.getChildByName("line") as DisplayObjectContainer;
			var _linee:DisplayObject = _line.getChildByName("line");
			var _drag:Sprite = _line.getChildByName("drag") as Sprite;
			var _y:Number;
			var _h:Number;
			switch (e.type) {
				case MouseEvent.MOUSE_DOWN:
					switch (e.target.name) {
						case "up":
							_y = _drag.y - iData.speed;
							_y = _y < 0 ? 0 : _y;
							layoutScroll(_y * _lengthP);
							break;
						case "down":
							_y = _drag.y + iData.speed;
							_y = _y > _scrollHeight ? _scrollHeight : _y;
							layoutScroll(_y * _lengthP);
							break;
						case "drag":
							if (iData.isMouseDown === false) {
								getDefinitionByName("com.greensock.TweenLite").killTweensOf(iData.obj);
								Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __scrollHandler);
								Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_MOVE, __scrollHandler);
								iData.startY = (_layout === 1 ? Ais.IMain.stage.mouseY : Ais.IMain.stage.mouseX) - _drag.y;
								iData.isMouseDown = true;
							}
							break;
						case "line":
							_y = e.localY * _linee.scaleY;
							_h = _drag.height * 0.5;
							_y -= _h;
							_y = _y > 0 ? (_y > _scrollHeight ? _scrollHeight : _y) : 0;
							iData.moveDelay = Math.abs(_y - _drag.y) / _scrollHeight;
							iData.moveDelay = iData.delay + iData.moveDelay > 0.77 ? 0.77 - iData.delay : iData.moveDelay;
							layoutScroll(_y * _lengthP);
							break;
					}
					break;
				case MouseEvent.MOUSE_UP:
					if (iData.isMouseDown === true) {
						Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __scrollHandler);
						Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __scrollHandler);
						iData.isMouseDown = false;
					}
					_y = _drag.y;
					_y = _scrollHeight - _y < 1 ? _scrollHeight : _y;
					layoutScroll(_y * _lengthP);
					break;
				case MouseEvent.MOUSE_WHEEL:
					if (e.delta === 0) return;
					if (_layout === 1 && e.shiftKey === true && iData.isShiftKey === true) return;
					else if (_layout === 2 && e.shiftKey === false && iData.isShiftKey === true) return;
					getDefinitionByName("com.greensock.TweenLite").killTweensOf(iData.obj);
					getDefinitionByName("com.greensock.TweenLite").killTweensOf(_drag);
					_h = iData.delta !== 0 ? (iData.delta * (e.delta > 0 ? 1 : -1)) : e.delta;
					_y = iData.obj[_coor] + _h;
					if (_y + _h > 0) _y = 0;
					else if (_y + iData.obj[_length] < iData[_length]) _y = iData[_length] - iData.obj[_length];
					iData.obj[_coor] = _y;
					_drag.y = _y / _lengthP;
					if (iData.position === true) getDefinitionByName("com.greensock.TweenLite").to(this, 0.3, {alpha: 1, onComplete: __tweenCompleteHandler});
					break;
				case MouseEvent.MOUSE_MOVE:
					_y = (_layout === 1 ? Ais.IMain.stage.mouseY : Ais.IMain.stage.mouseX) - iData.startY;
					_y = _y < 0 ? 0 : (_y > _scrollHeight ? _scrollHeight : _y);
					_drag.y = _y;
					iData.obj[_coor] = _y * _lengthP;
					break;
			}
			e = null;
		}
		
		/**
		 * 
		 * 设置皮肤 DisplayObjectContainer
		 * 
		 * @param value
		 * 
		 */
		public function setSkin(value:DisplayObjectContainer):void
		{
			if (null !== _scrollSkin) removeChild(_scrollSkin);
			_scrollSkin = value;
			addChild(_scrollSkin);
			var obj:* = {"mouseEnabled": false};
			try {
				var _up:DisplayObject = _scrollSkin.getChildByName("up");
				var _down:DisplayObject = _scrollSkin.getChildByName("down");
				var _line:DisplayObjectContainer = _scrollSkin.getChildByName("line") as DisplayObjectContainer;
				var _linee:DisplayObject = _line.getChildByName("line");
				var _drag:Sprite = _line.getChildByName("drag") as Sprite;
				_up = _up !== null ? _up : _scrollSkin["up"];
				_down = _down !== null ? _down : _scrollSkin["down"];
				_line = _line !== null ? _line : _scrollSkin["line"];
				_linee = _linee !== null ? _linee : _line["line"];
				_drag = _drag !== null ? _drag : _line["drag"];
				_linee["dynamic"] = obj;
				_drag["dynamic"] = obj;
				_up["dynamic"] = obj;
				_down["dynamic"] = obj;
			} catch (error:Error) {}
			
			obj = null;
			value = null;
		}
		
		/**
		 * 
		 * 更新显示
		 * 
		 */
		public function updateView():void
		{
			__removeEvent();
			__layout();
			__addEvent();
		}
		
		/**
		 * 
		 * 清空显示
		 * 
		 */
		public function clearView():void
		{
			__removeEvent();
			if (null !== parent) parent.removeChild(this);
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
			_scrollSkin = null;
			iData = null;
		}
		
	}
}