package org.aisy.net.utils
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
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
		 * 是否跨域
		 */
		static public var isCrossDomain:Boolean;
		protected var _isCrossDomain:Boolean;
		/**
		 * Loader
		 */
		protected var _loader:Loader;
		/**
		 * LoaderContext
		 */
		protected var _loaderContext:LoaderContext;
		/**
		 * 载入成功回调函数
		 */
		protected var _completeF:Function;
		/**
		 * IoError 回调函数
		 */
		protected var _ioErrorF:Function;
		/**
		 * 是否连接
		 */
		protected var _connected:Boolean;
		
		public function SwfLoader()
		{
		}
		
		/**
		 * 加载 URL
		 * @param request
		 * @param context
		 */
		public function load(request:Object, context:LoaderContext = null):void
		{
			init();
			if (isCrossDomain || _isCrossDomain) {
				if (null === context) {
					context = new LoaderContext(true);
				}
				else if (context.checkPolicyFile === false) {
					context.checkPolicyFile = true;
				}
			}
			_loaderContext = context;
			_loader.load(request is String ? new URLRequest(request as String) : request as URLRequest, context);
			request = null;
			context = null;
		}
		
		/**
		 * 从 ByteArray 对象中所存储的二进制数据中加载
		 * @param bytes
		 * @param context
		 */
		public function loadBytes(bytes:ByteArray, context:LoaderContext = null):void
		{
			init();
			_loaderContext = context;
			_loader.loadBytes(bytes, context);
			bytes = null;
			context = null;
		}
		
		/**
		 * 初始化
		 */
		protected function init():void
		{
			close();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, __ioErrorHandler);
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, __httpStatusHandler);
		}
		
		/**
		 * 载入成功 侦听
		 * @param e
		 */
		protected function __completeHandler(e:Event):void
		{
			if (isCrossDomain || _isCrossDomain) {
				if (!_loader.contentLoaderInfo.sameDomain) {
					var b:ByteArray = _loader.contentLoaderInfo.bytes;
					_loader.unload();
					_loader = null;
					if (null === _loaderContext) {
						_loaderContext = new LoaderContext();
					}
					else if (_loaderContext.checkPolicyFile === true) {
						_loaderContext.checkPolicyFile = false;
					}
					loadBytes(b, _loaderContext);
					b.clear();
					b = null;
					e = null;
					return;
				}
			}
			__completeHandler2(e);
			e = null;
		}
		
		protected function __completeHandler2(e:Event):void
		{
			_connected = false;
			if (null !== _completeF) {
				var len:uint = _completeF.length;
				if (len !== 0) {
					_completeF.apply(null, [_loader, e, this].slice(0, _completeF.length));
				}
				else {
					_loader.unload();
				}
			}
			else {
				_loader.unload();
			}
			clear();
			e = null;
		}
		
		/**
		 * IoError 侦听
		 * @param e
		 */
		protected function __ioErrorHandler(e:IOErrorEvent):void
		{
			_connected = false;
			if (null !== _ioErrorF) {
				_ioErrorF.apply(null, [e, this].slice(0, _ioErrorF.length));
			}
			_loader.unload();
			clear();
			e = null;
		}
		
		/**
		 * HttpStatus 侦听
		 * @param e
		 */
		protected function __httpStatusHandler(e:HTTPStatusEvent):void
		{
			e.currentTarget.removeEventListener(e.type, __httpStatusHandler);
			_connected = true;
			e = null;
		}
		
		/**
		 * 载入成功回调
		 * @param value
		 */
		public function setComplete(value:Function):void
		{
			_completeF = value;
			value = null;
		}
		
		/**
		 * IoError 回调
		 * @param value
		 */
		public function setIoError(value:Function):void
		{
			_ioErrorF = value;
			value = null;
		}
		
		/**
		 * 设置 是否跨域
		 * @param value
		 */
		public function setIsCrossDomain(value:Boolean):void
		{
			_isCrossDomain = value;
		}
		
		/**
		 * 返回 是否跨域
		 * @return 
		 */
		public function getIsCrossDomain():Boolean
		{
			return _isCrossDomain;
		}
		
		public function close():void
		{
			if (null !== _loader) {
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __completeHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, __ioErrorHandler);
				_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, __httpStatusHandler);
				if (_connected === true) _loader.close();
				_loader = null;
			}
			_loaderContext = null;
			_connected = false;
		}
		
		/**
		 * 清空
		 */
		public function clear():void
		{
			AisyAutoClear.remove(this);
			close();
			_completeF = null;
			_ioErrorF = null;
		}
		
	}
}