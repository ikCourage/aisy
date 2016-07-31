package org.aisy.net.utils
{
	import flash.net.URLRequest;
	import flash.net.URLStream;
	
	import org.ais.system.Memory;
	import org.aisy.autoclear.AisyAutoClear;
	import org.aisy.interfaces.IClear;
	import org.aisy.listener.UListener;

	/**
	 * 
	 * Data Stream
	 * 
	 * @author viqu
	 * 
	 */
	public class DataStream extends URLStream implements IClear
	{
		/**
		 * 动态数据
		 */
		protected var __dynamic:*;
		/**
		 * 侦听数组
		 */
		protected var __uListener:UListener;
		
		public function DataStream()
		{
		}
		
		override public function load(request:URLRequest):void
		{
			super.load(URI.relativeURL(request) as URLRequest);
			request = null;
		}
		
		/**
		 * 设置动态数据
		 * @param value
		 */
		public function set dynamic(value:*):void
		{
			__dynamic = value;
			value = null;
		}
		
		/**
		 * 返回动态数据
		 * @return 
		 */
		public function get dynamic():*
		{
			return __dynamic;
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if (useWeakReference === false) {
				if (null === __uListener) __uListener = new UListener();
				__uListener.addEventListener(type, listener, useCapture);
			}
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			type = null;
			listener = null;
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (null !== __uListener) __uListener.removeEventListener(type, listener, useCapture);
			super.removeEventListener(type, listener, useCapture);
			type = null;
			listener = null;
		}
		
		/**
		 * 清空侦听
		 * @param type
		 */
		public function clearEventListener(type:String = null):void
		{
			if (null === __uListener) return;
			var i:uint, len:uint, j:String, listeners:Array, v:Array, ls:Array = __uListener.getListeners();
			if (null !== type) {
				listeners = ls[type];
				if (null !== listeners) {
					len = listeners.length;
					for (i = 0; i < len; i++) {
						v = listeners[i];
						super.removeEventListener(type, v[0], v[1]);
					}
					__uListener.clearEventListener(type);
				}
			}
			else {
				for (j in ls) {
					listeners = ls[j];
					len = listeners.length;
					for (i = 0; i < len; i++) {
						v = listeners[i];
						super.removeEventListener(j, v[0], v[1]);
					}
				}
				__uListener.clear();
				__uListener = null;
			}
			j = null;
			listeners = null;
			v = null;
			ls = null;
			type = null;
			Memory.clear();
		}
		
		override public function close():void
		{
			if (connected === true) super.close();
			Memory.clear();
		}
		
		/**
		 * 清空
		 */
		public function clear():void
		{
			AisyAutoClear.remove(this);
			close();
			clearEventListener();
			__dynamic = null;
		}
		
	}
}