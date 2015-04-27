package org.aisy.image
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	import org.ais.system.Memory;
	import org.aisy.display.USprite;
	import org.aisy.interfaces.IClear;
	import org.aisy.net.utils.SwfLoader;
	import org.aisy.skin.AisySkin;

	/**
	 * 
	 * 图片
	 * 
	 * @author viqu
	 * 
	 */
	public class Image extends USprite
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
		 * SwfLoader
		 */
		protected var _swfLoader:SwfLoader;
		/**
		 * 进度背景
		 */
		protected var _loading:DisplayObject;
		/**
		 * 载入成功回调函数
		 */
		protected var _completeF:Function;
		/**
		 * IoError 回调函数
		 */
		protected var _ioErrorF:Function;
		/**
		 * 是否载入成功
		 */
		protected var _isLoaded:Boolean;
		/**
		 * 是否已清空
		 */
		protected var _isClear:Boolean;
		/**
		 * 是否平滑
		 */
		protected var _smoothing:Boolean;
		/**
		 * 自定义宽度
		 */
		protected var _width:Number = 0;
		/**
		 * 自定义高度
		 */
		protected var _height:Number = 0;
		/**
		 * loading 的最小尺寸
		 */
		protected var _loadingMinSize:Number = AisySkin.IMAGE_LOADING_MIN_SIZE;
		/**
		 * loading 的最大尺寸
		 */
		protected var _loadingMaxSize:Number = AisySkin.IMAGE_LOADING_MAX_SIZE;
		
		public function Image(request:Object = null, context:LoaderContext = null, loading:DisplayObject = null)
		{
			load(request, context, loading);
			request = null;
			context = null;
			loading = null;
		}
		
		/**
		 * 加载图片
		 * @param request
		 * @param context
		 * @param loading
		 */
		public function load(request:Object, context:LoaderContext = null, loading:DisplayObject = null):void
		{
			_isClear = false;
			_isLoaded = false;
			if (null === request) return;
			initLoading(loading);
			if (null !== _swfLoader) _swfLoader.clear();
			_swfLoader = new SwfLoader();
			_swfLoader.setIsCrossDomain(isCrossDomain || _isCrossDomain);
			_swfLoader.setComplete(__completeHandler);
			_swfLoader.setIoError(__ioErrorHandler);
			_swfLoader.load(request, context);
			request = null;
			context = null;
			loading = null;
		}
		
		/**
		 * 从 ByteArray 对象中所存储的二进制数据中加载
		 * @param bytes
		 * @param context
		 * @param loading
		 */
		public function loadBytes(bytes:ByteArray, context:LoaderContext = null, loading:DisplayObject = null):void
		{
			_isClear = false;
			_isLoaded = false;
			initLoading(loading);
			if (null !== _swfLoader) _swfLoader.clear();
			_swfLoader = new SwfLoader();
			_swfLoader.setIsCrossDomain(isCrossDomain || _isCrossDomain);
			_swfLoader.setComplete(__completeHandler);
			_swfLoader.setIoError(__ioErrorHandler);
			_swfLoader.loadBytes(bytes, context);
			bytes = null;
			context = null;
			loading = null;
		}
		
		/**
		 * 载入成功 侦听
		 * @param loader
		 * @param e
		 */
		protected function __completeHandler(loader:Loader, e:Event):void
		{
			_swfLoader = null;
			__completeHandler2(loader, e);
			loader = null;
			e = null;
		}
		
		protected function __completeHandler2(loader:Loader, e:Event):void
		{
			_isLoaded = true;
			if (_isClear === true) {
				loader.unload();
				loader = null;
				e = null;
				Memory.clear();
				return;
			}
			clearView();
			_loader = loader;
			var bitmap:Bitmap = (_loader.content is Bitmap ? _loader.content : DisplayObjectContainer(_loader.content).numChildren !== 0 ? DisplayObjectContainer(_loader.content).getChildAt(0) : null) as Bitmap;
			addChildAt(null !== bitmap ? bitmap : _loader.content, 0);
			_loader.unload();
			__setSize();
			if (null !== _completeF) _completeF.apply(null, [this, e, _loader].slice(0, _completeF.length));
			_completeF = null;
			_ioErrorF = null;
			bitmap = null;
			loader = null;
			e = null;
		}
		
		/**
		 * IoError 侦听
		 * @param e
		 */
		protected function __ioErrorHandler(e:IOErrorEvent):void
		{
			_swfLoader = null;
			if (null !== _ioErrorF) {
				_ioErrorF.apply(null, [this, e].slice(0, _ioErrorF.length));
			}
			clear();
			Memory.clear();
			e = null;
		}
		
		/**
		 * 初始化 loading
		 * @param loading
		 */
		protected function initLoading(loading:DisplayObject):void
		{
			clearView();
			if (AisySkin.IMAGE_AUTO_SKIN === true && null === loading) {
				_loading = new (getDefinitionByName(AisySkin.IMAGE_SKIN) as Class)();
			}
			else {
				_loading = loading;
			}
			if (null !== _loading) {
				addChild(_loading);
				__setSize();
			}
			loading = null;
		}
		
		/**
		 * 自适应大小
		 */
		protected function __setSize():void
		{
			var len:uint = numChildren;
			if (len === 0) return;
			setSmoothing(_smoothing);
			var obj:DisplayObject = getChildAt(0);
			var w:Number = _width !== 0 ? _width : obj.width;
			var h:Number = _height !== 0 ? _height : obj.height;
			for (var i:uint = 0; i < len; i++) {
				obj = getChildAt(i);
				if (obj !== _loading) {
					obj.width = w;
					obj.height = h;
				}
			}
			if (null !== _loading) {
				var loadingSize:Number = Math.max(Math.min(w, h), _loadingMinSize);
				loadingSize = Math.min(loadingSize, _loadingMaxSize);
				_loading.width = _loading.height = loadingSize;
				_loading.x = w > loadingSize ? (w - loadingSize) >> 1 : 0;
				_loading.y = h > loadingSize ? (h - loadingSize) >> 1 : 0;
			}
			obj = null;
		}
		
		/**
		 * 设置坐标
		 * @param x
		 * @param y
		 */
		public function setXY(x:Number = 0, y:Number = 0):void
		{
			this.x = x;
			this.y = y;
		}
		
		/**
		 * 设置大小
		 * @param width
		 * @param height
		 * @param smoothing
		 */
		public function setSize(width:Number = 0, height:Number = 0, smoothing:Boolean = false):void
		{
			_width = width;
			_height = height;
			_smoothing = smoothing;
			__setSize();
		}
		
		/**
		 * 设置 loading 的最大尺寸
		 * @param value
		 */
		public function setLoadingMinSize(value:Number):void
		{
			_loadingMinSize = value;
		}
		
		/**
		 * 设置 loading 的最大尺寸
		 * @param value
		 */
		public function setLoadingMaxSize(value:Number):void
		{
			_loadingMaxSize = value;
		}
		
		/**
		 * 设置 是否平滑
		 * @param smoothing
		 */
		public function setSmoothing(value:Boolean = false):void
		{
			_smoothing = value;
			var bitmap:Bitmap = getBitmap();
			if (null !== bitmap) {
				bitmap.smoothing = _smoothing;
				bitmap = null;
			}
		}
		
		/**
		 * 载入成功回调
		 * @param value
		 */
		public function setComplete(value:Function):void
		{
			if (true === _isLoaded) {
				if (null !== value) {
					value.apply(null, [this, null, _loader].slice(0, value.length));
				}
				_completeF = null;
				_ioErrorF = null;
			}
			else _completeF = value;
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
		
		/**
		 * 返回 Bitmap
		 * @return
		 */
		public function getBitmap():Bitmap
		{
			if (numChildren === 0) return null;
			return getChildAt(0) as Bitmap;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			__setSize();
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			__setSize();
		}
		
		/**
		 * 清空显示
		 */
		public function clearView():void
		{
			var i:uint = numChildren, obj:*;
			while (i) {
				i--;
				obj = getChildAt(i);
				if (obj is IClear) obj.clear();
				else removeChildAt(i);
			}
			obj = null;
			_loading = null;
		}
		
		/**
		 * 清空
		 */
		override public function clear():void
		{
			_isClear = true;
			_width = _height = 0;
			if (null !== _swfLoader) {
				_swfLoader.clear();
				_swfLoader = null;
			}
			super.clear();
			_loader = null;
			_loading = null;
			_completeF = null;
			_ioErrorF = null;
		}
		
	}
}