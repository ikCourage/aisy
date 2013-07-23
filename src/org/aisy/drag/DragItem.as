package org.aisy.drag
{
	import flash.events.MouseEvent;
	
	import org.ais.event.TEvent;
	import org.ais.system.Ais;
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
		 * 延迟时间
		 */
		protected var _delay:Number;
		
		public function DragItem(name:String, index:uint, data:*)
		{
			super(name, index, data);
			_delay = 0;
			__addEvent();
			name = null;
			data = null;
		}
		
		/**
		 * 
		 * 注册事件
		 * 
		 */
		protected function __addEvent():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseHandler);
		}
		
		/**
		 * 
		 * 移除事件
		 * 
		 */
		protected function __removeEvent():void
		{
			clearUTimer();
			
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
			
			TEvent.removeTrigger(NAME, __triggerHandler);
		}
		
		/**
		 * 
		 * 鼠标事件侦听
		 * 
		 * @param e
		 * 
		 */
		protected function __mouseHandler(e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.MOUSE_DOWN:
					if (_delay !== 0) Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
					Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
					clearUTimer(1);
					break;
				case MouseEvent.MOUSE_MOVE:
				case MouseEvent.MOUSE_UP:
					if (null !== _utimer) {
						clearUTimer();
						return;
					}
					alpha = 1;
					DragManager.getInstance().stopDrag();
					__removeEvent();
					break;
			}
			e = null;
		}
		
		/**
		 * 
		 * 延迟拖动定时器侦听
		 * 
		 */
		protected function __utimerHandler():void
		{
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
			clearUTimer();
			TEvent.newTrigger(NAME, __triggerHandler);
			alpha = 0.7;
			DragManager.getInstance().startDrag(this, NAME).alpha = 0.7;
		}
		
		/**
		 * 
		 * 拖动事件侦听
		 * 
		 * @param type
		 * @param data
		 * 
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
		 * 
		 * 清除延迟定时器
		 * 0：清除，1：初始化
		 * 
		 * @param type
		 */
		protected function clearUTimer(type:int = 0):void
		{
			if (null !== _utimer) {
				_utimer.clear();
				_utimer = null;
			}
			if (type) {
				if (_delay === 0) {
					__utimerHandler();
					return;
				}
				_utimer = new UTimer();
				_utimer.setDelay(_delay);
				_utimer.setRepeatCount(1);
				_utimer.setComplete(__utimerHandler);
				_utimer.start();
			}
		}
		
		/**
		 * 
		 * 设置延迟时间
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
		 * 返回标记数据
		 * 
		 * @return 
		 * 
		 */
		public function getItemInfo():*
		{
			return itemInfo;
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
		}
		
	}
}