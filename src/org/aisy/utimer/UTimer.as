package org.aisy.utimer
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.ais.system.Memory;
	import org.aisy.autoclear.AisyAutoClear;
	import org.aisy.interfaces.IClear;

	/**
	 * 
	 * 计时器
	 * 
	 * @author viqu
	 * 
	 */
	public class UTimer implements IClear
	{
		/**
		 * 计时器
		 */
		protected var __timer:Timer;
		/**
		 * TimerEvent.TIMER_COMPLETE 回调函数
		 */
		protected var __completeF:Function;
		/**
		 * TimerEvent.TIMER 回调函数
		 */
		protected var __timerF:Function;
		
		public function UTimer()
		{
		}
		
		/**
		 * 返回 计时器 Timer
		 * @return 
		 */
		protected function getTimer():Timer
		{
			if (null === __timer) {
				__timer = new Timer(int.MAX_VALUE);
				__timer.addEventListener(TimerEvent.TIMER, __timerEventHandler);
				__timer.addEventListener(TimerEvent.TIMER_COMPLETE, __timerEventHandler);
			}
			return __timer;
		}
		
		/**
		 * 计时器 Timer 侦听
		 * @param e
		 */
		protected function __timerEventHandler(e:TimerEvent):void
		{
			var arr:Array = [e, this];
			switch (e.type) {
				case TimerEvent.TIMER:
					if (null !== __timerF) {
						__timerF.apply(null, arr.slice(0, __timerF.length));
					}
					break;
				case TimerEvent.TIMER_COMPLETE:
					if (null !== __completeF) {
						__completeF.apply(null, arr.slice(0, __completeF.length));
					}
					clear();
					break;
			}
			arr = null;
			e = null;
		}
		
		/**
		 * 	每当它完成 Timer.repeatCount 设置的请求数后调度
		 * @param value
		 */
		public function setComplete(value:Function):void
		{
			__completeF = value;
			value = null;
		}
		
		/**
		 * 每当 Timer 对象达到根据 Timer.delay 属性指定的间隔时调度
		 * @param value
		 */
		public function setTimer(value:Function):void
		{
			__timerF = value;
			value = null;
		}
		
		/**
		 * 计时器事件间的延迟（以毫秒为单位）
		 * @param value
		 */
		public function setDelay(value:Number):void
		{
			getTimer().delay = value;
		}
		
		/**
		 * 设置的计时器运行总次数
		 * @param value
		 */
		public function setRepeatCount(value:int):void
		{
			getTimer().repeatCount = value;
		}
		
		/**
		 * 计时器从 0 开始后触发的总次数
		 * @return 
		 */
		public function getCurrentCount():int
		{
			return getTimer().currentCount;
		}
		
		/**
		 * 计时器的当前状态；如果计时器正在运行，则为 true，否则为 false
		 * @return 
		 */
		public function getRunning():Boolean
		{
			return getTimer().running;
		}
		
		/**
		 * 返回 计时器事件间的延迟
		 * @return 
		 */
		public function getDelay():Number
		{
			return getTimer().delay;
		}
		
		/**
		 * 返回 计时器运行总次数
		 * @return 
		 */
		public function getRepeatCount():int
		{
			return getTimer().repeatCount;
		}
		
		/**
		 * 启动计时器
		 */
		public function start():void
		{
			getTimer().start();
		}
		
		/**
		 * 如果计时器正在运行，则停止计时器，并将 currentCount 属性设回为 0，这类似于秒表的重置按钮
		 */
		public function reset():void
		{
			getTimer().reset();
		}
		
		/**
		 * 停止计时器
		 */
		public function stop():void
		{
			getTimer().stop();
		}
		
		/**
		 * 清空
		 */
		public function clear():void
		{
			AisyAutoClear.remove(this);
			if (null !== __timer) {
				__timer.removeEventListener(TimerEvent.TIMER, __timerEventHandler);
				__timer.removeEventListener(TimerEvent.TIMER_COMPLETE, __timerEventHandler);
				
				__timer.stop();
				__timer = null;
			}
			
			__completeF = null;
			__timerF = null;
			
			Memory.clear();
		}
		
	}
}