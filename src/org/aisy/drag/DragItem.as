package org.aisy.drag
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import org.ais.event.TEvent;
	import org.ais.system.Ais;
	import org.aisy.display.USprite;
	import org.aisy.listoy.ListoyItem;
	import org.aisy.utimer.UTimer;

	/**
	 * 
	 * 一个实现简单拖动的类
	 * 
	 * @author Viqu
	 * 
	 */
	public class DragItem extends ListoyItem
	{
		/**
		 * 延迟拖动定时器
		 */
		protected var _utimer:UTimer;
		/**
		 * 延迟拖动时间
		 */
		protected var _dragDelay:Number = 0;
		/**
		 * 拖动时的透明度
		 */
		protected var _alpha:Number = 0.7;
		/**
		 * 拖动对象的透明度
		 */
		protected var _alpha2:Number = 0.7;
		/**
		 * 拖动管理类
		 */
		protected var _udrag:UDrag;
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
		
		public function DragItem(name:String, index:uint, data:*)
		{
			super(name, index, data);
			__addEvent();
			name = null;
			data = null;
		}
		
		/**
		 * 注册事件
		 */
		protected function __addEvent():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseHandler);
		}
		
		/**
		 * 移除事件
		 */
		protected function __removeEvent():void
		{
			clearUTimer();
			
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
			
			TEvent.removeTrigger(NAME, __triggerHandler);
		}
		
		/**
		 * 鼠标事件侦听
		 * @param e
		 */
		protected function __mouseHandler(e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.MOUSE_DOWN:
					if (_dragDelay !== 0) Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
					Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
					clearUTimer(1);
					break;
				case MouseEvent.MOUSE_MOVE:
				case MouseEvent.MOUSE_UP:
					if (null !== _utimer) {
						clearUTimer();
						return;
					}
					_udrag.clear();
					__removeEvent();
					_udrag = null;
					break;
			}
			e = null;
		}
		
		/**
		 * 延迟拖动定时器侦听
		 */
		protected function __utimerHandler():void
		{
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
			clearUTimer();
			TEvent.newTrigger(NAME, __triggerHandler);
			if (null !== _udrag) _udrag.clear();
			_udrag = new UDrag();
			_udrag.setMode(_mode);
			_udrag.setDelay(_delay);
			_udrag.setShowLayout(null !== _showLayout ? _showLayout : __showLayout);
			_udrag.setHideLayout(null !== _hideLayout ? _hideLayout : __hideLayout);
			_udrag.startDrag(this, NAME).alpha = _alpha2;
		}
		
		/**
		 * 拖动事件侦听
		 * @param type
		 * @param data
		 */
		protected function __triggerHandler(type:String, data:* = null):void
		{
			switch (type) {
				case UDragEvent.DRAG_STOP:
					__removeEvent();
					break;
			}
			type = null;
			data = null;
		}
		
		/**
		 * 清除延迟定时器
		 * 0：清除，1：初始化
		 * @param type
		 */
		protected function clearUTimer(type:int = 0):void
		{
			if (null !== _utimer) {
				_utimer.clear();
				_utimer = null;
			}
			if (type) {
				if (_dragDelay === 0) {
					__utimerHandler();
					return;
				}
				_utimer = new UTimer();
				_utimer.setDelay(_dragDelay);
				_utimer.setRepeatCount(1);
				_utimer.setComplete(__utimerHandler);
				_utimer.start();
			}
		}
		
		protected function __showLayout(us:USprite):void
		{
			alpha = _alpha;
			us = null;
		}
		
		protected function __hideLayout(us:USprite):void
		{
			alpha = 1;
			(us.getChildAt(0) as Bitmap).bitmapData.dispose();
			us.clear();
			us = null;
		}
		
		/**
		 * 设置拖动时的透明度
		 * @param value
		 */
		public function setAlpha(value:Number):void
		{
			_alpha = value;
		}
		
		/**
		 * 设置拖动对象的透明度
		 * @param value
		 */
		public function setAlpha2(value:Number):void
		{
			_alpha2 = value;
		}
		
		/**
		 * 设置延迟拖动时间
		 * @param value
		 */
		public function setDragDelay(value:Number):void
		{
			_dragDelay = value;
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
		 * 返回索引
		 * @return 
		 */
		public function getIndex():uint
		{
			return index;
		}
		
		/**
		 * 返回标记数据
		 * @return 
		 */
		public function getItemInfo():*
		{
			return itemInfo;
		}
		
		/**
		 * 清空
		 */
		override public function clear():void
		{
			__removeEvent();
			if (null !== _udrag) {
				_udrag.clear();
				_udrag = null;
			}
			super.clear();
			_showLayout = null;
			_hideLayout = null;
		}
		
	}
}