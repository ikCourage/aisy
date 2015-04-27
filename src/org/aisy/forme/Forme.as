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
	import flash.ui.Keyboard;
	
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
		protected var _urlRequest:URLRequest;
		/**
		 * URLLoader
		 */
		protected var _urlLoader:URLLoader;
		/**
		 * 是否正在加载
		 */
		protected var _isLoading:Boolean;
		/**
		 * 是否可以提交
		 */
		protected var _isEnabled:Boolean;
		/**
		 * 提交地址
		 */
		protected var _action:String;
		/**
		 * 提交方法 （GET / POST）
		 */
		protected var _method:String;
		/**
		 * hidden 数据数组
		 */
		protected var _hiddenData:Array;
		/**
		 * submit 按钮 数据数组
		 */
		protected var _submitData:Array;
		/**
		 * input 数据数组
		 */
		protected var _inputData:Array;
		/**
		 * 提交表单前处理函数（回调函数）
		 */
		protected var _submitF:Function;
		/**
		 * 提交表单中处理函数（URLLoader 回调函数）
		 */
		protected var _loaderF:Function;
		/**
		 * 表单数据的编码函数 (回调函数)
		 */
		protected var _encodeF:Function;
		
		public function Forme(action:String, method:String = "GET")
		{
			_action = action;
			_method = method;
			setFormData(action, method);
			init();
		}
		
		/**
		 * 初始化
		 */
		protected function init():void
		{
			setEncode();
			addEventListener(FocusEvent.FOCUS_IN, __eventHandler);
		}
		
		/**
		 * 表单事件侦听
		 * @param e
		 */
		protected function __eventHandler(e:Event):void
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
					if ((e as KeyboardEvent).keyCode === Keyboard.ENTER) {
						setFormData(_action, _method);
						submitForme();
					}
					break;
				case MouseEvent.CLICK:
					if (getSubmitData()[e.currentTarget.name].data) setFormData(getSubmitData()[e.currentTarget.name].data.action, getSubmitData()[e.currentTarget.name].data.method);
					else setFormData(_action, _method);
					submitForme();
					break;
			}
			e = null;
		}
		
		/**
		 * URLLoader 事件侦听
		 * @param e
		 */
		protected function __loaderEventHandler(e:Event):void
		{
			if (null !== _loaderF) {
				var arr:Array = [e, getURLLoader(), this];
				_loaderF.apply(null, arr.slice(0, _loaderF.length));
				arr = null;
			}
			switch (e.type) {
				case Event.COMPLETE:
					_isLoading = false;
					clearLoader();
					break;
				case IOErrorEvent.IO_ERROR:
					_isLoading = false;
					clearLoader();
					break;
				case SecurityErrorEvent.SECURITY_ERROR:
					_isLoading = false;
					clearLoader();
					break;
			}
			e = null;
		}
		
		/**
		 * 返回 hidden 数据
		 * @return 
		 */
		protected function getHiddenData():Array
		{
			return null === _hiddenData ? _hiddenData = [] : _hiddenData;
		}
		
		/**
		 * 返回 submit 按钮 数据
		 * @return 
		 */
		protected function getSubmitData():Array
		{
			return null === _submitData ? _submitData = [] : _submitData;
		}
		
		/**
		 * 返回 input 数据
		 * @return 
		 */
		protected function getInputData():Array
		{
			if (null === _inputData) _inputData = [];
			return _inputData;
		}
		
		/**
		 * 返回 URLRequest
		 * @return 
		 */
		protected function getURLRequest():URLRequest
		{
			if (null === _urlRequest) _urlRequest = new URLRequest();
			return _urlRequest;
		}
		
		/**
		 * 返回 URLLoader
		 * @return 
		 */
		protected function getURLLoader():URLLoader
		{
			if (null === _urlLoader) _urlLoader = new URLLoader();
			return _urlLoader;
		}
		
		/**
		 * 清空 URLLoader
		 */
		protected function clearLoader():void
		{
			if (null === _urlLoader) return;
			if (_isLoading === true) getURLLoader().close();
			getURLLoader().removeEventListener(Event.COMPLETE, __loaderEventHandler);
			getURLLoader().removeEventListener(Event.OPEN, __loaderEventHandler);
			getURLLoader().removeEventListener(HTTPStatusEvent.HTTP_STATUS, __loaderEventHandler);
			getURLLoader().removeEventListener(IOErrorEvent.IO_ERROR, __loaderEventHandler);
			getURLLoader().removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __loaderEventHandler);
		}
		
		/**
		 * 默认 表单数据的编码函数 (回调函数)
		 * @param value
		 * @return 
		 */
		protected function encode(value:*):*
		{
			return value;
		}
		
		/**
		 * 提交表单
		 */
		public function submitForme():void
		{
			clearLoader();
			_isEnabled = true;
			if (null !== _submitF) {
				var arr:Array = [this];
				_submitF.apply(null, arr.slice(0, _submitF.length));
				arr = null;
			}
			if (_isEnabled === false) return;
			getURLLoader().addEventListener(Event.COMPLETE, __loaderEventHandler);
			getURLLoader().addEventListener(Event.OPEN, __loaderEventHandler);
			getURLLoader().addEventListener(HTTPStatusEvent.HTTP_STATUS, __loaderEventHandler);
			getURLLoader().addEventListener(IOErrorEvent.IO_ERROR, __loaderEventHandler);
			getURLLoader().addEventListener(SecurityErrorEvent.SECURITY_ERROR, __loaderEventHandler);
			var v:URLVariables = new URLVariables();
			for each (var i:* in getHiddenData()) {
				v[i.name] = _encodeF(i.value);
			}
			for each (i in getInputData()) {
				v[i.name] = _encodeF(i.obj.text);
			}
			getURLRequest().data = v;
			getURLLoader().load(getURLRequest());
			_isLoading = true;
			v = null;
		}
		
		/**
		 * 设置是否可以提交表单
		 * @param value
		 */
		public function setEnabled(value:Boolean):void
		{
			_isEnabled = value;
		}
		
		/**
		 * 设置表单属性
		 * @param action
		 * @param method
		 */
		public function setFormData(action:String, method:String = null):void
		{
			getURLRequest().url = action ? action : _action;
			getURLRequest().method = method ? method : _method;
			action = null;
			method = null;
		}
		
		/**
		 * 将显示元素添加到表单中
		 * @param value
		 */
		protected function addElement(value:InteractiveObject):void
		{
			var p:Point = value.localToGlobal(new Point(0, 0));
			value.x = p.x;
			value.y = p.y;
			value.tabIndex = Forme.TAB_INDEX;
			Forme.TAB_INDEX++;
			addChild(value);
			p = null;
			value = null;
		}
		
		/**
		 * 添加 hidden 数据
		 * data 格式 {"name": "name", "value": "value"}
		 * @param data
		 */
		public function addHidden(name:String, value:*):void
		{
			getHiddenData()[getHiddenData().length] = {"name": name, "value": value};
			name = null;
			value = null;
		}
		
		/**
		 * 添加 input 数据
		 * @param value
		 * @param name
		 */
		public function addInput(value:InteractiveObject, name:String = ""):void
		{
			if (name) {
				getInputData()[getInputData().length] = {"obj": value, "name": name};
			}
			value.x -= 1.1;
			value.y -= 1.1;
			addElement(value);
			value = null;
			name = null;
		}
		
		/**
		 * 添加 submit 按钮 数据
		 * data 格式 {"action": "action", "method": "GET"}
		 * @param value
		 * @param data
		 */
		public function addSubmit(value:InteractiveObject, data:* = null):void
		{
			if (null === data) getSubmitData()[value.name] = {"obj": value};
			else getSubmitData()[value.name] = {"obj": value, "data": data};
			addElement(value);
			value.addEventListener(MouseEvent.CLICK, __eventHandler);
			value = null;
			data = null;
		}
		
		/**
		 * 设置 提交表单前处理函数（回调函数）
		 * @param value
		 */
		public function setSubmit(value:Function):void
		{
			_submitF = value;
			value = null;
		}
		
		/**
		 * 设置 提交表单中处理函数（URLLoader 回调函数）
		 * @param value
		 */
		public function setLoader(value:Function):void
		{
			_loaderF = value;
			value = null;
		}
		
		/**
		 * 设置 表单数据的编码函数 (回调函数)
		 * @param value
		 */
		public function setEncode(value:Function = null):void
		{
			if (null === value) _encodeF = encode;
			else _encodeF = value;
			value = null;
		}
		
		/**
		 * 移除 表单事件侦听
		 */
		protected function __removeEvent():void
		{
			removeEventListener(FocusEvent.FOCUS_IN, __eventHandler);
			removeEventListener(FocusEvent.FOCUS_OUT, __eventHandler);
			removeEventListener(KeyboardEvent.KEY_UP, __eventHandler);
			for each (var i:* in getSubmitData()) {
				i.obj.removeEventListener(MouseEvent.CLICK, __eventHandler);
			}
		}
		
		/**
		 * 清空
		 */
		override public function clear():void
		{
			__removeEvent();
			clearLoader();
			super.clear();
			_urlRequest = null;
			_urlLoader = null;
			_action = null;
			_method = null;
			_hiddenData = null;
			_submitData = null;
			_inputData = null;
			_submitF = null;
			_loaderF = null;
			_encodeF = null;
		}
		
	}
}