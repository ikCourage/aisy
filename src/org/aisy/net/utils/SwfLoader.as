package org.aisy.net.utils
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import org.aisy.autoclear.AisyAutoClear;
	import org.aisy.interfaces.IClear;

	/**
	 * 
	 * SWF Loader
	 * 
	 * @author viqu
	 * 
	 */
	public class SwfLoader implements IClear
	{
		/**
		 * Loader
		 */
		protected var __loader:Loader;
		/**
		 * 载入成功回调函数
		 */
		protected var __completeF:Function;
		/**
		 * IoError 回调函数
		 */
		protected var __ioErrorF:Function;
		/**
		 * 是否正在加载
		 */
		protected var __loading:Boolean;
		
		public function SwfLoader()
		{
		}
		
		/**
		 * 
		 * 加载 URL
		 * 
		 * @param url
		 * 
		 */
		public function load(request:Object, context:LoaderContext = null):void
		{
			init();
			__loader.load(request is String ? new URLRequest(request as String) : request as URLRequest, context);
			request = null;
			context = null;
		}
		
		/**
		 * 
		 * 从 ByteArray 对象中所存储的二进制数据中加载
		 * 
		 * @param bytes
		 * @param context
		 * 
		 */
		public function loadBytes(bytes:ByteArray, context:LoaderContext = null):void
		{
			init();
			__loader.loadBytes(bytes, context);
			bytes = null;
			context = null;
		}
		
		/**
		 * 
		 * 初始化
		 * 
		 */
		protected function init():void
		{
			__loading = true;
			__loader = new Loader();
			__loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __completeHandler);
			__loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, __ioErrorHandler);
		}
		
		/**
		 * 
		 * 载入成功 侦听
		 * 
		 * @param e
		 * 
		 */
		protected function __completeHandler(e:Event):void
		{
			__loading = false;
			if (null !== __completeF) {
				var len:uint = __completeF.length;
				if (len !== 0) {
					__completeF.apply(null, [__loader, e].slice(0, __completeF.length));
				}
				else {
					__loader.unload();
				}
			}
			else {
				__loader.unload();
			}
			e = null;
			clear();
		}
		
		/**
		 * 
		 * IoError 侦听
		 * 
		 * @param e
		 * 
		 */
		protected function __ioErrorHandler(e:IOErrorEvent):void
		{
			__loading = false;
			if (null !== __ioErrorF) {
				__ioErrorF.apply(null, [e].slice(0, __ioErrorF.length));
			}
			__loader.unload();
			e = null;
			clear();
		}
		
		/**
		 * 
		 * 载入成功回调
		 * 
		 * @param value
		 * 
		 */
		public function setComplete(value:Function):void
		{
			__completeF = value;
			value = null;
		}
		
		/**
		 * 
		 * IoError 回调
		 * 
		 * @param value
		 * 
		 */
		public function setIoError(value:Function):void
		{
			__ioErrorF = value;
			value = null;
		}
		
		/**
		 * 
		 * 清空
		 * 
		 */
		public function clear():void
		{
			AisyAutoClear.remove(this);
			if (null !== __loader) {
				__loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __completeHandler);
				__loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, __ioErrorHandler);
				if (__loading == true) __loader.close();
				__loader = null;
			}
			__loading = false;
			__completeF = null;
			__ioErrorF = null;
		}
		
	}
}