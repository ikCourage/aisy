package org.aisy.forme
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import org.aisy.display.USprite;

	/**
	 * 
	 * Form 表单
	 * 
	 * @author viqu
	 * 
	 */
	public class Forme extends USprite
	{
		/**
		 * tab 索引
		 */
		static public var TAB_INDEX:int;
		/**
		 * URLRequest
		 */
		protected var __urlRequest:URLRequest;
		/**
		 * URLLoader
		 */
		protected var __urlLoader:URLLoader;
		/**
		 * 是否正在加载
		 */
		protected var isLoading:Boolean;
		/**
		 * 是否可以提交
		 */
		protected var isEnabled:Boolean;
		/**
		 * 提交地址
		 */
		protected var action:String;
		/**
		 * 提交方法 （GET / POST）
		 */
		protected var method:String;
		/**
		 * hidden 数据数组
		 */
		protected var data:Array;
		/**
		 * submit 按钮 数据数组
		 */
		protected var sData:Array;
		/**
		 * input 数据数组
		 */
		protected var inputData:Array;
		/**
		 * 提交表单前处理函数（回调函数）
		 */
		protected var __submitF:Function;
		/**
		 * 提交表单中处理函数（URLLoader 回调函数）
		 */
		protected var __loaderF:Function;
		/**
		 * 表单数据的编码函数 (回调函数)
		 */
		protected var __encodeF:Function;
		
		public function Forme(action:String, method:String = "GET")
		{
			this.action = action;
			this.method = method;
			setFormData(action, method);
			init();
		}
		
		/**
		 * 
		 * 初始化
		 * 
		 */
		protected function init():void
		{
			setEncodeEvent();
			addEventListener(FocusEvent.FOCUS_IN, __eventHandler);
		}
		
		/**
		 * 
		 * 表单事件侦听
		 * 
		 * @param e
		 * 
		 */
		protected function __eventHandler(e:*):void
		{
			switch (e.type) {
				case FocusEvent.FOCUS_IN:
					removeEventListener(e.type, __eventHandler);
					addEventListener(FocusEvent.FOCUS_OUT, __eventHandler);
					addEventListener(KeyboardEvent.KEY_UP, __eventHandler);
					break;
				case FocusEvent.FOCUS_OUT:
					removeEventListener(e.type, __eventHandler);
					removeEventListener(KeyboardEvent.KEY_UP, __eventHandler);
					addEventListener(FocusEvent.FOCUS_IN, __eventHandler);
					break;
				case KeyboardEvent.KEY_UP:
					if (e.keyCode === 13) {
						setFormData(action, method);
						submitForme();
					}
					break;
				case MouseEvent.CLICK:
					setFormData(action, method);
					if (getSData()[e.currentTarget].data) setFormData(getSData()[e.currentTarget].data.action, getSData()[e.currentTarget].data.method);
					submitForme();
					break;
			}
			e = null;
		}
		
		/**
		 * 
		 * URLLoader 事件侦听
		 * 
		 * @param e
		 * 
		 */
		protected function __loaderEventHandler(e:*):void
		{
			if (null !== __loaderF) {
				var arr:Array = [e, getURLLoader(), this];
				__loaderF.apply(null, arr.slice(0, __loaderF.length));
				arr = null;
			}
			switch (e.type) {
				case Event.COMPLETE:
					isLoading = false;
					clearLoader();
					break;
				case IOErrorEvent.IO_ERROR:
					isLoading = false;
					clearLoader();
					break;
				case SecurityErrorEvent.SECURITY_ERROR:
					isLoading = false;
					clearLoader();
					break;
			}
			e = null;
		}
		
		/**
		 * 
		 * 返回 hidden 数据
		 * 
		 * @return 
		 * 
		 */
		protected function getData():Array
		{
			return null === data ? data = [] : data;
		}
		
		/**
		 * 
		 * 返回 submit 按钮 数据
		 * 
		 * @return 
		 * 
		 */
		protected function getSData():Array
		{
			return null === sData ? sData = [] : sData;
		}
		
		/**
		 * 
		 * 返回 input 数据
		 * 
		 * @return 
		 * 
		 */
		protected function getInputData():Array
		{
			if (null === inputData) inputData = [];
			return inputData;
		}
		
		/**
		 * 
		 * 返回 URLRequest
		 * 
		 * @return 
		 * 
		 */
		protected function getURLRequest():URLRequest
		{
			if (null === __urlRequest) __urlRequest = new URLRequest();
			return __urlRequest;
		}
		
		/**
		 * 
		 * 返回 URLLoader
		 * 
		 * @return 
		 * 
		 */
		protected function getURLLoader():URLLoader
		{
			if (null === __urlLoader) __urlLoader = new URLLoader();
			return __urlLoader;
		}
		
		/**
		 * 
		 * 清空 URLLoader
		 * 
		 */
		protected function clearLoader():void
		{
			if (null === __urlLoader) return;
			if (isLoading === true) getURLLoader().close();
			getURLLoader().removeEventListener(Event.COMPLETE, __loaderEventHandler);
			getURLLoader().removeEventListener(Event.OPEN, __loaderEventHandler);
			getURLLoader().removeEventListener(HTTPStatusEvent.HTTP_STATUS, __loaderEventHandler);
			getURLLoader().removeEventListener(IOErrorEvent.IO_ERROR, __loaderEventHandler);
			getURLLoader().removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __loaderEventHandler);
		}
		
		/**
		 * 
		 * 默认 表单数据的编码函数 (回调函数)
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		protected function encode(value:*):*
		{
			return value;
		}
		
		/**
		 * 
		 * 提交表单
		 * 
		 */
		public function submitForme():void
		{
			if (isLoading === true) {
				clearLoader();
			}
			
			isEnabled = true;
			
			if (null !== __submitF) {
				var arr:Array = [this];
				__submitF.apply(null, arr.slice(0, __submitF.length));
				arr = null;
			}
			
			if (isEnabled === false) return;
			
			getURLLoader().addEventListener(Event.COMPLETE, __loaderEventHandler);
			getURLLoader().addEventListener(Event.OPEN, __loaderEventHandler);
			getURLLoader().addEventListener(HTTPStatusEvent.HTTP_STATUS, __loaderEventHandler);
			getURLLoader().addEventListener(IOErrorEvent.IO_ERROR, __loaderEventHandler);
			getURLLoader().addEventListener(SecurityErrorEvent.SECURITY_ERROR, __loaderEventHandler);
			
			var _v:URLVariables = new URLVariables();
			for each (var i:* in getData()) {
				_v[i.name] = __encodeF(i.value);
			}
			
			for each (i in getInputData()) {
				_v[i.name] = __encodeF(i.obj.text);
			}
			
			getURLRequest().data = _v;
			
			getURLLoader().load(getURLRequest());
			
			isLoading = true;
			
			_v = null;
		}
		
		/**
		 * 
		 * 设置是否可以提交表单
		 * 
		 * @param value
		 * 
		 */
		public function setEnabled(value:Boolean):void
		{
			isEnabled = value;
		}
		
		/**
		 * 
		 * 设置表单属性
		 * 
		 * @param action
		 * @param method
		 * 
		 */
		public function setFormData(action:String, method:String = ""):void
		{
			if (method === "") method = this.method;
			getURLRequest().url = action;
			getURLRequest().method = method;
			
			action = null;
			method = null;
		}
		
		/**
		 * 
		 * 将显示元素添加到表单中
		 * 
		 * @param value
		 * 
		 */
		protected function addElement(value:InteractiveObject):void
		{
			var _p:Point = value.localToGlobal(new Point(0, 0));
			value.x = _p.x;
			value.y = _p.y;
			
			value.tabIndex = Forme.TAB_INDEX;
			Forme.TAB_INDEX++;
			addChild(value);
			
			_p = null;
			value = null;
		}
		
		/**
		 * 
		 * 添加 hidden 数据
		 * data 格式 {"name": "name", "value": "value"}
		 * 
		 * @param data
		 * 
		 */
		public function addHidden(name:String, value:*):void
		{
			getData()[getData().length] = {"name": name, "value": value};
			name = null;
			value = null;
		}
		
		/**
		 * 
		 * 添加 input 数据
		 * 
		 * @param value
		 * @param name
		 * 
		 */
		public function addInput(value:InteractiveObject, name:String = ""):void
		{
			if (name !== "") {
				getInputData()[getInputData().length] = {"obj": value, "name": name};
			}
			value.x -= 1.1;
			value.y -= 1.1;
			addElement(value);
			value = null;
			name = null;
		}
		
		/**
		 * 
		 * 添加 submit 按钮 数据
		 * data 格式 {"action": "action", "method": "GET"}
		 * 
		 * @param value
		 * @param data
		 * 
		 */
		public function addSubmit(value:InteractiveObject, data:* = null):void
		{
			if (null === data) getSData()[value] = {"obj": value};
			else getSData()[value] = {"obj": value, "data": data};
			addElement(value);
			value.addEventListener(MouseEvent.CLICK, __eventHandler);
			value = null;
			data = null;
		}
		
		/**
		 * 
		 * 设置 提交表单前处理函数（回调函数）
		 * 
		 * @param value
		 * 
		 */
		public function setSubmitEvent(value:Function):void
		{
			__submitF = value;
			value = null;
		}
		
		/**
		 * 
		 * 设置 提交表单中处理函数（URLLoader 回调函数）
		 * 
		 * @param value
		 * 
		 */
		public function setLoaderEvent(value:Function):void
		{
			__loaderF = value;
			value = null;
		}
		
		/**
		 * 
		 * 设置 表单数据的编码函数 (回调函数)
		 * 
		 * @param value
		 * 
		 */
		public function setEncodeEvent(value:Function = null):void
		{
			if (null === value) __encodeF = encode;
			else __encodeF = value;
			value = null;
		}
		
		/**
		 * 
		 * 移除 表单事件侦听
		 * 
		 */
		protected function removeEvent():void
		{
			removeEventListener(FocusEvent.FOCUS_IN, __eventHandler);
			removeEventListener(FocusEvent.FOCUS_OUT, __eventHandler);
			removeEventListener(KeyboardEvent.KEY_UP, __eventHandler);
			for each (var i:* in getSData()) {
				i.obj.removeEventListener(MouseEvent.CLICK, __eventHandler);
			}
		}
		
		/**
		 * 
		 * 清空
		 * 
		 */
		override public function clear():void
		{
			removeEvent();
			clearLoader();
			
			__urlRequest = null;
			__urlLoader = null;
			action = null;
			method = null;
			data = null;
			sData = null;
			inputData = null;
			__submitF = null;
			__loaderF = null;
			__encodeF = null;
			super.clear();
		}
		
	}
}