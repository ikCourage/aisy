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
		/**
		 * Loader
		 */
		protected var __loader:Loader;
		/**
		 * 进度背景
		 */
		protected var __loading:DisplayObject;
		/**
		 * 是否载入成功
		 */
		protected var isLoaded:Boolean;
		/**
		 * 是否已清空
		 */
		protected var isClear:Boolean;
		/**
		 * 是否平滑
		 */
		protected var _smoothing:Boolean;
		/**
		 * 载入成功回调函数
		 */
		protected var __completeF:Function;
		/**
		 * IoError 回调函数
		 */
		protected var __ioErrorF:Function;
		/**
		 * 自定义宽度
		 */
		protected var _width:Number;
		/**
		 * 自定义高度
		 */
		protected var _height:Number;
		
		public function Image(request:Object = null, context:LoaderContext = null, loading:DisplayObject = null)
		{
			load(request, context, loading);
			request = null;
			context = null;
			loading = null;
		}
		
		/**
		 * 
		 * 加载图片
		 * 
		 * @param url
		 * @param loading
		 * 
		 */
		public function load(request:Object, context:LoaderContext = null, loading:DisplayObject = null):void
		{
			__loading = null;
			if (null === request) return;
			if (null === loading) {
				__loading = new (getDefinitionByName(AisySkin.IMAGE_SKIN) as Class)();
			}
			else {
				__loading = loading;
			}
			addChild(__loading);
			
			var swfLoader:SwfLoader = new SwfLoader();
			swfLoader.setComplete(completeHandler);
			swfLoader.setIoError(ioErrorHandler);
			swfLoader.load(request, context);
			
			swfLoader = null;
			request = null;
			context = null;
			loading = null;
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
			var swfLoader:SwfLoader = new SwfLoader();
			swfLoader.setComplete(completeHandler);
			swfLoader.setIoError(ioErrorHandler);
			swfLoader.loadBytes(bytes, context);
			swfLoader = null;
			bytes = null;
			context = null;
		}
		
		/**
		 * 
		 * 载入成功 侦听
		 * 
		 * @param loader
		 * 
		 */
		protected function completeHandler(loader:Loader, e:Event):void
		{
			if (isCrossDomain) {
				if (!loader.contentLoaderInfo.sameDomain) {
					var b:ByteArray = loader.contentLoaderInfo.bytes;
					loader.unload();
					loadBytes(b, new LoaderContext());
					b = null;
					loader = null;
					e = null;
					return;
				}
			}
			isLoaded = true;
			if (true === isClear) {
				loader.unload();
				loader = null;
				e = null;
				Memory.clear();
				return;
			}
			
			var obj:*;
			while (numChildren) {
				obj = getChildAt(0);
				if (obj is IClear) obj.clear();
				else removeChildAt(0);
			}
			obj = null;
			__loading = null;
			
			__loader = loader;
			addChild(__loader.content);
			
			__setSize();
			
			if (null !== __completeF) {
				__completeF.apply(null, [this, loader, e].slice(0, __completeF.length));
				__completeF = null;
				__ioErrorF = null;
			}
			
			loader = null;
			e = null;
		}
		
		/**
		 * 
		 * IoError 侦听
		 * 
		 * @param e
		 * 
		 */
		protected function ioErrorHandler(e:IOErrorEvent):void
		{
			if (null !== __ioErrorF) {
				__ioErrorF.apply(null, [e].slice(0, __ioErrorF.length));
			}
			e = null;
			clear();
			Memory.clear();
		}
		
		/**
		 * 
		 * 自适应大小
		 * 
		 */
		protected function __setSize():void
		{
			if (_smoothing === true) setSmoothing(true);
			
			var max:Number = 70;
			var i:uint, len:uint = numChildren;
			var obj:*;
			for (i = 0; i < len; i++) {
				obj = getChildAt(i);
				if (obj !== __loading) {
					obj.width = _width;
					obj.height = _height;
				}
			}
			obj = null;
			
			if (null === __loading) return;
			
			if (_width < max || _height < max) {
				max = Math.min(_width, _height);
			}
			
			__loading.width = __loading.height = max;
			__loading.x = (_width - max) * 0.5;
			__loading.y = (_height - max) * 0.5;
		}
		
		protected function getBitmap():Bitmap
		{
			if (null === __loader) return null;
			return (__loader.content is Bitmap ? __loader.content : DisplayObjectContainer(__loader.content).getChildAt(0)) as Bitmap;
		}
		
		/**
		 * 
		 * 设置坐标
		 * 
		 * @param x
		 * @param y
		 * 
		 */
		public function setXY(x:Number = 0, y:Number = 0):void
		{
			this.x = x;
			this.y = y;
		}
		
		/**
		 * 
		 * 设置大小
		 * 
		 * @param width
		 * @param height
		 * @param smoothing
		 * 
		 */
		public function setSize(width:Number = 0, height:Number = 0, smoothing:Boolean = false):void
		{
			_width = width;
			_height = height;
			_smoothing = smoothing;
			__setSize();
		}
		
		/**
		 * 
		 * 设置 是否平滑
		 * 
		 * @param smoothing
		 * 
		 */
		public function setSmoothing(smoothing:Boolean = false):void
		{
			_smoothing = smoothing;
			if (_smoothing === true && null !== __loader) {
				var bitmap:Bitmap = getBitmap();
				if (null !== bitmap) bitmap.smoothing = true;
				bitmap = null;
			}
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
			if (true === isLoaded) value.apply(null, [this, __loader].slice(0, value.length));
			else __completeF = value;
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
		override public function clear():void
		{
			isClear = true;
			if (null !== __loader) {
				var bitmap:Bitmap = getBitmap();
				if (null !== bitmap) bitmap.bitmapData.dispose();
				__loader.unload();
				__loader = null;
				bitmap = null;
			}
			
			__loading = null;
			__completeF = null;
			__ioErrorF = null;
			
			super.clear();
		}
		
	}
}