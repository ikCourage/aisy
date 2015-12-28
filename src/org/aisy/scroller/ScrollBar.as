package org.aisy.scroller
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	import org.ais.system.Ais;
	import org.aisy.display.USprite;
	import org.aisy.interfaces.IClear;
	import org.aisy.skin.AisySkin;
	import org.aisy.utimer.UTimer;

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
		 * up down 按下后的延迟定时器
		 */
		protected var _utimer:UTimer;
		/**
		 * 显示和隐藏的定时器
		 */
		protected var _utimer2:UTimer;
		/**
		 * 滚动条
		 */
		protected var _scrollSkin:DisplayObjectContainer;
		/**
		 * 布局方向
		 */
		protected var _layout:uint;
		/**
		 * 滚动条和向上按钮间的距离
		 */
		protected var _upH:Number;
		/**
		 * 滚动条和向下按钮间的距离
		 */
		protected var _downH:Number;
		/**
		 * 鼠标是否按下
		 */
		protected var _isMouseDown:Boolean;
		protected var _isRollOver:Boolean;
		protected var _isShowing:Boolean;
		
		public function ScrollBar(data:ScrollerData, layout:uint)
		{
			iData = data;
			_layout = layout;
			tabChildren = tabEnabled = false;
		}
		
		/**
		 * 计算布局
		 */
		protected function __layout():void
		{
			if (null === iData.mask || null === _scrollSkin) return;
			mouseChildren = mouseEnabled = iData.mode === 2 ? false : true;
			_scrollSkin.rotation = _layout === 1 ? 0 : -90;
			var _up:DisplayObject = _scrollSkin["up"];
			var _down:DisplayObject = _scrollSkin["down"];
			var _line:DisplayObjectContainer = _scrollSkin["line"];
			var _linee:DisplayObject = _line["line"];
			var _drag:Sprite = _line["drag"] as Sprite;
			var _coor:String = _layout === 1 ? "y" : "x";
			var _length:String = _layout === 1 ? "height" : "width";
			var _dragY:Number = _drag.y;
			if (_scrollSkin.hasOwnProperty("setSize") === true) {
				var f:Function = _scrollSkin["setSize"];
				f.apply(null, [iData[_length], iData.mode].slice(0, f.length));
				f = null;
			}
			else {
				_drag.y = 0;
				_linee.height = (iData[_length] - _up.height - _down.height - _upH - _downH);
				_down.y = _line.y + _linee.height + _downH;
			}
			if (iData.elastic === true) {
				var _dMH:Number = _layout === 1 ? iData.dragMinSizeV: iData.dragMinSizeH;
				var _dH:Number = _linee.height * iData[_length] / iData.obj[_length];
				if (iData.obj[_coor] > 0) {
					_dH *= (1 - iData.obj[_coor] / iData[_length] / (_layout === 1 ? iData.overflowV : iData.overflowH));
				}
				else if (iData[_length] > iData.obj[_coor] + iData.obj[_length]) {
					_dH *= (1 - (iData[_length] - (iData.obj[_coor] + iData.obj[_length])) / iData[_length] / (_layout === 1 ? iData.overflowV : iData.overflowH));
				}
				_dMH = _dMH === -1 ? _drag.width : _dMH;
				_drag.height = _dH < _dMH ? _dMH : _dH;
			}
			var _dragY2:Number = _drag.y;
			_drag.y = 0;
			var _scrollHeight:Number = _line.height - _drag.height;
			_drag.y = _dragY2;
			if (_layout === 1) {
				if (iData.mode !== 0 && iData.mode !== 3) _scrollSkin.x = iData.width - _scrollSkin.width;
				else _scrollSkin.x = iData.width + iData.paddingH;
			}
			else {
				if (iData.mode !== 0 && iData.mode !== 3) _scrollSkin.y = iData.height;
				else _scrollSkin.y = iData.height + _scrollSkin.height + iData.paddingV;
			}
			if (iData.isMouseDown === true || _isShowing === true) {
				var _rLength:Number = iData[_length] - iData.obj[_length];
				var _lengthP:Number = _rLength / _scrollHeight;
				if (iData.mode === 2) {
					var p:Number = iData.obj[_coor];
					p = p > 0 ? 0 : p;
					p = p < _rLength ? _rLength : p;
					_drag.y = p / _lengthP;
					_isMouseDown = false;
				}
				else if (_isMouseDown === true) {
					_drag.y = _dragY;
					iData.obj[_coor] = _dragY * _lengthP;
					iData.startY = (_layout === 1 ? Ais.IMain.stage.mouseY : Ais.IMain.stage.mouseX) - _dragY;
					Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __scrollHandler);
					Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_MOVE, __scrollHandler);
				}
				else {
					iData.obj[_coor] = 0;
					if (iData.mode !== 0) getDefinitionByName(AisySkin.TWEEN_LITE).to(this, iData.scrollShowDuration, {alpha: 1, onComplete: __tweenCompleteHandler});
				}
			}
			else {
				if (iData.mode !== 0) getDefinitionByName(AisySkin.TWEEN_LITE).to(this, iData.scrollShowDuration, {alpha: 1, onComplete: __tweenCompleteHandler});
			}
		}
		
		/**
		 * 计算滚动条位置
		 * @param p
		 * @param type
		 * @param duration
		 */
		public function layoutScroll(p:Number = 0, type:int = 0, duration:Number = -1):void
		{
			if (null === iData) return;
			var _length:String = _layout === 1 ? "height" : "width";
			var _rLength:Number = iData[_length] - iData.obj[_length];
			if (_rLength === 0) return;
			var d:Object = {};
			var _drag:Sprite = _scrollSkin["line"]["drag"] as Sprite;
			var _scrollHeight:Number = _scrollSkin["line"].height - _drag.height;
			var _lengthP:Number = _rLength / _scrollHeight;
			var _coor:String = _layout === 1 ? "y" : "x";
			var _duration:Number = iData.scrollDuration + iData.moveDuration;
			if (_duration < 0) _duration = 0;
			p = p > 0 ? 0 : p;
			p = p < _rLength ? _rLength : p;
			var _dragY:Number = p / _lengthP;
			_dragY = _dragY < 0 ? 0 : _dragY;
			_dragY = _dragY > _scrollHeight ? _scrollHeight : _dragY;
			if ((AisySkin.MOBILE === true || iData.mobile === true) && iData.mode !== 0 && type !== 2) {
				if (type === 0) {
					_dragY = iData.obj[_coor] / _lengthP;
					_dragY = _dragY < 0 ? 0 : _dragY;
					_dragY = _dragY > _scrollHeight ? _scrollHeight : _dragY;
				}
				else {
					d["onComplete"] = __tweenCompleteHandler;
					if (_dragY.toFixed(0) === _drag.y.toFixed(0)) _duration = 0;
				}
				d["y"] = _dragY;
				if (_duration >= iData.scrollShowDuration) getDefinitionByName(AisySkin.TWEEN_LITE).to(this, iData.scrollShowDuration, {alpha: 1});;
				getDefinitionByName(AisySkin.TWEEN_LITE).to(_drag, duration !== -1 ? duration : _duration, d);
			}
			else {
				if (type === 3) {
					iData.obj[_coor] = p;
				}
				else if (iData.scrollDuration <= 0) {
					_drag.y = _dragY;
					iData.obj[_coor] = p;
				}
				else {
					d[_coor] = p;
					getDefinitionByName(AisySkin.TWEEN_LITE).to(_drag, duration !== -1 ? duration : _duration, {y: _dragY, onComplete: iData.mode !== 0 ? __tweenCompleteHandler : null});
					getDefinitionByName(AisySkin.TWEEN_LITE).to(iData.obj, duration !== -1 ? duration : _duration, d);
				}
			}
			if (iData.mode !== 0 && type === 2) getDefinitionByName(AisySkin.TWEEN_LITE).to(this, iData.scrollShowDuration, {alpha: 1, onComplete: _duration < iData.scrollShowDuration ? __tweenCompleteHandler : null});
		}
		
		/**
		 * 缓动结束侦听
		 */
		protected function __tweenCompleteHandler():void
		{
			if (_isRollOver === false && _isMouseDown === false && null !== iData) {
				if (null !== _utimer2) {
					_utimer2.clear();
					_utimer2 = null;
				}
				_utimer2 = new UTimer();
				_utimer2.setRepeatCount(1);
				_utimer2.setDelay(iData.scrollShowDuration * 1000);
				_utimer2.setComplete(__tweenCompleteHandler2);
				_utimer2.start();
			}
		}
		
		/**
		 * 缓动结束侦听
		 */
		protected function __tweenCompleteHandler2():void
		{
			if (null !== _utimer2) {
				_utimer2.clear();
				_utimer2 = null;
			}
			if (_isRollOver === false && _isMouseDown === false && null !== iData) {
				if (null !== _scrollSkin && _scrollSkin.hasOwnProperty("hide") === true) {
					var f:Function = _scrollSkin["hide"];
					f.apply(null, [iData.scrollHideDuration].slice(0, f.length));
					f = null;
				}
				getDefinitionByName(AisySkin.TWEEN_LITE).to(this, iData.scrollHideDuration, {alpha: 0});
			}
		}
		
		protected function __tweenUpdateHandler():void
		{
			var _drag:Sprite = _scrollSkin["line"]["drag"] as Sprite;
			var _scrollHeight:Number = _scrollSkin["line"].height - _drag.height;
			var _coor:String = _layout === 1 ? "y" : "x";
			var _length:String = _layout === 1 ? "height" : "width";
			var _rLength:Number = iData[_length] - iData.obj[_length];
			var _lengthP:Number = _rLength / _scrollHeight;
			iData.obj[_coor] = _drag.y * _lengthP;
		}
		
		protected function __initUTimer(p:Number, duration:Number):void
		{
			if (null !== _utimer) {
				_utimer.clear();
				_utimer = null;
			}
			_utimer = new UTimer();
			_utimer.setRepeatCount(1);
			_utimer.setDelay(iData.upDownDelay);
			_utimer.setComplete(function ():void
			{
				var _drag:Sprite = _scrollSkin["line"]["drag"] as Sprite;
				var _scrollHeight:Number = _scrollSkin["line"].height - _drag.height;
				var _length:String = _layout === 1 ? "height" : "width";
				var _rLength:Number = iData[_length] - iData.obj[_length];
				var _lengthP:Number = _rLength / _scrollHeight;
				getDefinitionByName(AisySkin.TWEEN_LITE).to(_drag, duration, {y: p / _lengthP, onUpdate: __tweenUpdateHandler});
				_utimer = null;
			});
			_utimer.start();
		}
		
		/**
		 * 注册侦听
		 */
		protected function __addEvent():void
		{
			if (null !== _scrollSkin) {
				if ((_layout === 1 ? iData.isScrollWheelV : iData.isScrollWheelH) === true) iData.scroller.addEventListener(MouseEvent.MOUSE_WHEEL, __scrollHandler);
				if (iData.mode === 1 || iData.mode === 3) _scrollSkin.addEventListener(MouseEvent.ROLL_OVER, __scrollHandler);
				_scrollSkin.addEventListener(MouseEvent.MOUSE_DOWN, __scrollHandler);
			}
		}
		
		/**
		 * 移除侦听
		 */
		protected function __removeEvent():void
		{
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __scrollHandler);
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __scrollHandler);
			if (null !== _scrollSkin) {
				iData.scroller.removeEventListener(MouseEvent.MOUSE_WHEEL, __scrollHandler);
				_scrollSkin.removeEventListener(MouseEvent.ROLL_OVER, __scrollHandler);
				_scrollSkin.removeEventListener(MouseEvent.ROLL_OUT, __scrollHandler);
				_scrollSkin.removeEventListener(MouseEvent.MOUSE_DOWN, __scrollHandler);
			}
			if (null !== _utimer) {
				_utimer.clear();
				_utimer = null;
			}
			if (null !== _utimer2) {
				_utimer2.clear();
				_utimer2 = null;
			}
		}
		
		/**
		 * 竖向滚动条鼠标侦听
		 * @param e
		 */
		protected function __scrollHandler(e:MouseEvent):void {
			if (iData.enabled === false) return;
			iData.moveDuration = 0;
			var _line:DisplayObjectContainer = _scrollSkin["line"];
			var _linee:DisplayObject = _line["line"];
			var _drag:Sprite = _line["drag"] as Sprite;
			var _scrollHeight:Number = _line.height - _drag.height;
			var _coor:String = _layout === 1 ? "y" : "x";
			var _length:String = _layout === 1 ? "height" : "width";
			var _rLength:Number = iData[_length] - iData.obj[_length];
			var _lengthP:Number = _rLength / _scrollHeight;
			var _y:Number;
			var _h:Number;
			switch (e.type) {
				case MouseEvent.MOUSE_MOVE:
					_y = (_layout === 1 ? Ais.IMain.stage.mouseY : Ais.IMain.stage.mouseX) - iData.startY;
					_y = _y < 0 ? 0 : (_y > _scrollHeight ? _scrollHeight : _y);
					_drag.y = _y;
					iData.obj[_coor] = _y * _lengthP;
					break;
				case MouseEvent.MOUSE_DOWN:
					switch (e.target.name) {
						case "up":
							if (_isMouseDown === false) {
								layoutScroll(iData.obj[_coor] + iData.speed);
								if (iData.upDownDuration !== 0 && (iData.upDownDuration > 0 || iData.speedDelay > 0)) {
									Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __scrollHandler);
									iData.isMouseDown = true;
									_isMouseDown = true;
									_y = 0;
									_h = Math.abs(iData.obj[_coor] - _y) / iData.speed * iData.speedDelay / 1000;
									_rLength = iData.upDownDuration * Math.abs((iData.obj[_coor] - _y) / _rLength);
									__initUTimer(_y, iData.upDownDuration > 0 ? _rLength : _h);
								}
							}
							break;
						case "down":
							if (_isMouseDown === false) {
								layoutScroll(iData.obj[_coor] - iData.speed);
								if (iData.upDownDuration !== 0 && (iData.upDownDuration > 0 || iData.speedDelay > 0)) {
									Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __scrollHandler);
									iData.isMouseDown = true;
									_isMouseDown = true;
									_y = _rLength;
									_h = Math.abs(iData.obj[_coor] - _y) / iData.speed * iData.speedDelay / 1000;
									_rLength = iData.upDownDuration * Math.abs((iData.obj[_coor] - _y) / _rLength);
									__initUTimer(_y, iData.upDownDuration > 0 ? _rLength : _h);
								}
							}
							break;
						case "drag":
							if (_isMouseDown === false) {
								getDefinitionByName(AisySkin.TWEEN_LITE).killTweensOf(_drag);
								getDefinitionByName(AisySkin.TWEEN_LITE).killTweensOf(iData.obj);
								Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __scrollHandler);
								Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_MOVE, __scrollHandler);
								iData.startY = (_layout === 1 ? Ais.IMain.stage.mouseY : Ais.IMain.stage.mouseX) - _drag.y;
								iData.isMouseDown = true;
								_isMouseDown = true;
							}
							break;
						case "line":
							if (_isMouseDown === false) {
								_y = e.localY * _linee.scaleY;
								_h = _drag.height * 0.5;
								_y -= _h;
								_y = _y > 0 ? (_y > _scrollHeight ? _scrollHeight : _y) : 0;
								_y *= _lengthP;
								layoutScroll(iData.obj[_coor] + (_y > iData.obj[_coor] ? iData.speed : -iData.speed));
								if (iData.upDownDuration > 0 || iData.speedDelay > 0) {
									Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __scrollHandler);
									iData.isMouseDown = true;
									_isMouseDown = true;
									_h = Math.abs(iData.obj[_coor] - _y) / iData.speed * iData.speedDelay / 1000;
									_rLength = iData.upDownDuration * Math.abs((iData.obj[_coor] - _y) / _rLength);
									__initUTimer(_y, iData.upDownDuration > 0 ? _rLength : _h);
								}
							}
							break;
					}
					break;
				case MouseEvent.MOUSE_UP:
					if (null !== _utimer) {
						_utimer.clear();
						_utimer = null;
					}
					getDefinitionByName(AisySkin.TWEEN_LITE).killTweensOf(_drag);
					if (_isMouseDown === true) {
						Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __scrollHandler);
						Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __scrollHandler);
						iData.isMouseDown = false;
						_isMouseDown = false;
					}
					if ((iData.mode === 1 || iData.mode === 3) && _isRollOver === false) {
						getDefinitionByName(AisySkin.TWEEN_LITE).to(this, iData.scrollShowDuration, {alpha: 1, onComplete: __tweenCompleteHandler});
					}
					break;
				case MouseEvent.MOUSE_WHEEL:
					if (iData.mode !== 0) {
						getDefinitionByName(AisySkin.TWEEN_LITE).to(this, iData.scrollShowDuration, {alpha: 1, onComplete: __tweenCompleteHandler});
					}
					if (e.delta === 0) return;
					if (_layout === 1 && e.shiftKey === true && iData.isShiftKey === true) return;
					else if (_layout === 2 && e.shiftKey === false && iData.isShiftKey === true) return;
					getDefinitionByName(AisySkin.TWEEN_LITE).killTweensOf(iData.obj);
					getDefinitionByName(AisySkin.TWEEN_LITE).killTweensOf(_drag);
					_h = iData.delta > 0 ? (iData.delta * (e.delta > 0 ? 1 : -1)) : (iData.delta !== 0 ? -iData.delta * e.delta : e.delta);
					_y = iData.obj[_coor] + _h;
					if (_y > 0) _y = 0;
					else if (_y + iData.obj[_length] < iData[_length]) _y = iData[_length] - iData.obj[_length];
					iData.obj[_coor] = _y;
					_drag.y = _y / _lengthP;
//					if (iData.mode !== 0) getDefinitionByName(AisySkin.TWEEN_LITE).to(this, iData.scrollShowDuration, {alpha: 1, onComplete: __tweenCompleteHandler});
					break;
				case MouseEvent.ROLL_OVER:
					if (iData.mode === 1 || iData.mode === 3) {
						_isRollOver = true;
						_scrollSkin.removeEventListener(e.type, __scrollHandler);
						_scrollSkin.addEventListener(MouseEvent.ROLL_OUT, __scrollHandler);
						if (_scrollSkin.hasOwnProperty("show") === true) {
							var f:Function = _scrollSkin["show"];
							f.apply(null, [iData.scrollShowDuration].slice(0, f.length));
							f = null;
						}
						getDefinitionByName(AisySkin.TWEEN_LITE).to(this, iData.scrollShowDuration, {alpha: 1});
					}
					break;
				case MouseEvent.ROLL_OUT:
					if (iData.mode === 1 || iData.mode === 3) {
						_isRollOver = false;
						_scrollSkin.removeEventListener(e.type, __scrollHandler);
						_scrollSkin.addEventListener(MouseEvent.ROLL_OVER, __scrollHandler);
						if (_isMouseDown === false) {
							getDefinitionByName(AisySkin.TWEEN_LITE).to(this, iData.scrollShowDuration, {alpha: 1, onComplete: __tweenCompleteHandler});
						}
					}
					break;
			}
			e = null;
		}
		
		/**
		 * 设置皮肤 DisplayObjectContainer
		 * @param value
		 */
		public function setSkin(value:DisplayObjectContainer):void
		{
			if (null !== _scrollSkin) {
				if (_scrollSkin is IClear) IClear(_scrollSkin).clear();
				else removeChild(_scrollSkin);
			}
			_scrollSkin = value;
			addChild(_scrollSkin);
			var _up:DisplayObject = _scrollSkin["up"];
			var _down:DisplayObject = _scrollSkin["down"];
			var _line:DisplayObjectContainer = _scrollSkin["line"];
			var _linee:DisplayObject = _line["line"];
			var _drag:Sprite = _line["drag"] as Sprite;
			var _y:Number = _line.y;
			_upH = _y - _up.height;
			_downH = _down.y - _y - _line.height;
			try {
				var obj:* = {"mouseEnabled": false};
				_linee["dynamic"] = obj;
				_drag["dynamic"] = obj;
				_up["dynamic"] = obj;
				_down["dynamic"] = obj;
				obj = null;
			} catch (error:Error) {}
			value = null;
		}
		
		override public function set alpha(value:Number):void
		{
			if (iData.mode === 3) return;
			super.alpha = value;
			if (null !== iData && iData.autoAlpha === true) {
				if (value === 0 && null !== parent) {
					parent.removeChild(this);
				}
				else if (null === parent && null !== iData.scroller && (_layout === 1 ? iData.isScrollV : iData.isScrollH) === true) {
					iData.scroller.addChild(this);
				}
			}
		}
		
		/**
		 * 更新显示
		 * @param b
		 */
		public function updateView(b:Boolean = false):void
		{
			_isShowing = b;
			if (_isShowing === false) {
				__removeEvent();
				__addEvent();
				_isMouseDown = false;
				_isRollOver = false;
			}
			__layout();
			_isShowing = false;
		}
		
		/**
		 * 清空显示
		 */
		public function clearView():void
		{
			__removeEvent();
			if (null !== parent) parent.removeChild(this);
		}
		
		/**
		 * 清空
		 */
		override public function clear():void
		{
			__removeEvent();
			if (null !== _scrollSkin) {
				if (_scrollSkin is IClear) (_scrollSkin as IClear).clear();
				else removeChild(_scrollSkin);
			}
			super.clear();
			_scrollSkin = null;
			iData = null;
		}
		
	}
}