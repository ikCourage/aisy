package org.aisy.drag
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.ais.event.TEvent;
	import org.ais.system.Ais;
	import org.aisy.autoclear.AisyAutoClear;
	import org.aisy.display.USprite;
	import org.aisy.interfaces.IClear;
	import org.aisy.utimer.UTimer;

	/**
	 * 
	 * 拖动管理类
	 * 
	 * @author Viqu
	 * 
	 */
	public class UDrag implements IClear
	{
		/**
		 * 当前拖动的容器
		 */
		protected var _drag:USprite;
		/**
		 * 移动事件刷新定时器
		 */
		protected var _utimer:UTimer;
		/**
		 * 移动事件刷新时间
		 */
		protected var _delay:Number = 0;
		/**
		 * 移动事件刷新模式
		 */
		protected var _mode:int = 1;
		/**
		 * 显示时布局函数
		 */
		protected var _showLayout:Function;
		/**
		 * 隐藏时布局函数
		 */
		protected var _hideLayout:Function;
		
		public function UDrag()
		{
		}
		
		/**
		 * 开始拖动
		 * @param us
		 * @param type
		 * @param parameters
		 * @return 
		 */
		public function startDrag(us:USprite, type:String, ...parameters):USprite
		{
			var r0:Rectangle = us.getBounds(Ais.IMain.stage);
			var r1:Rectangle = us.getBounds(us);
			var bmd0:BitmapData = new BitmapData(r1.width, r1.height, true, 0x00000000);
			bmd0.draw(us, new Matrix(1, 0, 0, 1, -r1.x, -r1.y));
			r1 = bmd0.getColorBoundsRect(0xFFFFFFFF, 0x00000000, false);
			if (r1.width !== 0 && r1.height !== 0) {
				var bmd1:BitmapData = new BitmapData(r1.width, r1.height, true, 0x00000000);
				bmd1.copyPixels(bmd0, r1, new Point(0, 0));
				bmd0.dispose();
				bmd0 = bmd1;
				bmd1 = null;
			}
			_drag = new USprite();
			_drag.mouseChildren = _drag.mouseEnabled = false;
			_drag.x = r0.x + r1.x;
			_drag.y = r0.y + r1.y;
			_drag.dynamic = {};
			_drag.dynamic["target"] = us;
			_drag.dynamic["type"] = type;
			_drag.dynamic["parameters"] = parameters;
			_drag.dynamic["x"] = _drag.x;
			_drag.dynamic["y"] = _drag.y;
			_drag.dynamic["_x"] = Ais.IMain.stage.mouseX - _drag.x;
			_drag.dynamic["_y"] = Ais.IMain.stage.mouseY - _drag.y;
			_drag.addChild(new Bitmap(bmd0));
			_drag.startDrag();
			Ais.IMain.stage.addChild(_drag);
			
			if (null !== _showLayout) {
				_showLayout(_drag);
				_showLayout = null;
			}
			
			if (_mode !== 0) {
				if (_mode === 1 || _delay === 0) {
					Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_MOVE, __stageHandler);
				}
				else {
					if (_mode === 3) {
						Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_MOVE, __stageHandler);
					}
					_utimer = new UTimer();
					_utimer.setDelay(_delay);
					_utimer.setTimer(__utimerHandler);
					_utimer.start();
				}
			}
			
			r0 = null;
			r1 = null;
			bmd0 = null;
			us = null;
			type = null;
			parameters = null;
			
			return _drag;
		}
		
		/**
		 * 结束拖动
		 */
		public function stopDrag():void
		{
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __stageHandler);
			if (null !== _utimer) {
				_utimer.clear();
				_utimer = null;
			}
			if (null !== _drag) {
				_drag.stopDrag();
				TEvent.trigger(_drag.dynamic.type, UDragEvent.DRAG_STOP, _drag);
				if (null === _hideLayout) {
					(_drag.getChildAt(0) as Bitmap).bitmapData.dispose();
					_drag.clear();
				}
				else {
					_hideLayout(_drag);
				}
				_drag = null;
			}
			_showLayout = null;
			_hideLayout = null;
		}
		
		/**
		 * 设置移动事件刷新模式
		 * @param value
		 */
		public function setMode(value:int):void
		{
			_mode = value;
		}
		
		/**
		 * 设置移动事件刷新时间
		 * @param value
		 */
		public function setDelay(value:Number):void
		{
			_delay = value;
		}
		
		/**
		 * 设置显示时布局函数
		 * @param value
		 */
		public function setShowLayout(value:Function):void
		{
			_showLayout = value;
		}
		
		/**
		 * 设置隐藏时布局函数
		 * @param value
		 */
		public function setHideLayout(value:Function):void
		{
			_hideLayout = value;
		}
		
		/**
		 * 返回移动事件刷新模式
		 * @return 
		 */
		public function getMode():int
		{
			return _mode;
		}
		
		/**
		 * 返回移动事件刷新时间
		 * @return 
		 */
		public function getDelay():Number
		{
			return _delay;
		}
		
		/**
		 * 返回当前拖动的容器
		 * @return 
		 */
		public function getDrag():USprite
		{
			return _drag;
		}
		
		/**
		 * 移动事件刷新定时器的侦听
		 */
		protected function __utimerHandler():void
		{
			if (null !== _drag) TEvent.trigger(_drag.dynamic.type, UDragEvent.DRAG_MOVE, _drag);
		}
		
		/**
		 * 舞台事件侦听
		 * @param e
		 */
		protected function __stageHandler(e:MouseEvent):void
		{
			if (null !== _drag) {
				_drag.x = Ais.IMain.stage.mouseX - _drag.dynamic["_x"];
				_drag.y = Ais.IMain.stage.mouseY - _drag.dynamic["_y"];
				__utimerHandler();
			}
		}
		
		/**
		 * 清空
		 */
		public function clear():void
		{
			AisyAutoClear.remove(this);
			stopDrag();
		}
		
	}
}