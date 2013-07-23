package org.aisy.drag
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		protected var _tempUS:USprite;
		/**
		 * 事件刷新定时器
		 */
		protected var _utimer:UTimer;
		/**
		 * 事件刷新时间
		 */
		protected var _delay:Number = 200;
		
		public function UDrag()
		{
		}
		
		/**
		 * 
		 * 开始拖动
		 * 
		 * @param us
		 * @param type
		 * @param parameters
		 * @return 
		 * 
		 */
		public function startDrag(us:USprite, type:String, ...parameters):USprite
		{
			stopDrag();
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
			_tempUS = new USprite();
			_tempUS.mouseChildren = _tempUS.mouseEnabled = false;
			_tempUS.x = r0.x + r1.x;
			_tempUS.y = r0.y + r1.y;
			var bm:Bitmap = new Bitmap(bmd0);
			_tempUS.addChild(bm);
			_tempUS.startDrag();
			Ais.IMain.stage.addChild(_tempUS);
			
			_tempUS.dynamic = {};
			_tempUS.dynamic["target"] = us;
			_tempUS.dynamic["type"] = type;
			_tempUS.dynamic["parameters"] = parameters;
			
			_utimer = new UTimer();
			_utimer.setDelay(_delay);
			_utimer.setTimer(__utimerHandler);
			_utimer.start();
			
			r0 = null;
			r1 = null;
			bmd0 = null;
			bm = null;
			us = null;
			type = null;
			parameters = null;
			
			return _tempUS;
		}
		
		/**
		 * 
		 * 结束拖动
		 * 
		 */
		public function stopDrag():void
		{
			if (null !== _utimer) {
				_utimer.clear();
				_utimer = null;
			}
			if (null !== _tempUS) {
				TEvent.trigger(_tempUS.dynamic.type, UDragEvent.DRAG_STOP, _tempUS);
				Bitmap(_tempUS.getChildAt(0)).bitmapData.dispose();
				_tempUS.clear();
				_tempUS = null;
			}
		}
		
		/**
		 * 
		 * 设置事件刷新时间
		 * 
		 * @param value
		 * 
		 */
		public function setDelay(value:Number):void
		{
			_delay = value;
		}
		
		/**
		 * 
		 * 返回事件刷新时间
		 * 
		 * @return 
		 * 
		 */
		public function getDelay():Number
		{
			return _delay;
		}
		
		/**
		 * 
		 * 事件刷新定时器的侦听
		 * 
		 */
		protected function __utimerHandler():void
		{
			TEvent.trigger(_tempUS.dynamic.type, UDragEvent.DRAG_MOVE, _tempUS);
		}
		
		/**
		 * 
		 * 清空
		 * 
		 */
		public function clear():void
		{
			AisyAutoClear.remove(this);
			stopDrag();
		}
		
	}
}