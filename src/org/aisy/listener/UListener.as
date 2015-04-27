package org.aisy.listener
{
	import org.aisy.interfaces.IClear;

	/**
	 * 
	 * 侦听数据集合类
	 * 
	 * @author viqu
	 * 
	 */
	public class UListener implements IClear
	{
		/**
		 * 侦听数组
		 */
		protected var __listeners:Array;
		
		public function UListener()
		{
		}
		
		/**
		 * 返回侦听数组
		 * @return 
		 */
		public function getListeners():Array
		{
			return __listeners;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (null === __listeners) __listeners = [];
			var len:uint, listeners:Array = __listeners[type];
			if (null === listeners) {
				listeners = [];
				__listeners[type] = listeners;
			}
			else len = listeners.length;
			listeners[len] = [listener, useCapture];
			listeners = null;
			type = null;
			listener = null;
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (null === __listeners) return;
			var listeners:Array = __listeners[type];
			if (null !== listeners) {
				var i:uint, len:uint = listeners.length, v:Array;
				for (i = 0; i < len; i++) {
					v = listeners[i];
					if (v[1] === useCapture) if (v[0] === listener) {
						if (len === 1) delete __listeners[type];
						else listeners.splice(i, 1);
						break;
					}
				}
				listeners = null;
				v = null;
			}
			type = null;
			listener = null;
		}
		
		/**
		 * 清空侦听
		 * @param type
		 */
		public function clearEventListener(type:String = null):void
		{
			if (null === __listeners) return;
			if (null !== type) delete __listeners[type];
			else __listeners = null;
			type = null;
		}
		
		/**
		 * 清空
		 */
		public function clear():void
		{
			clearEventListener();
		}
		
	}
}