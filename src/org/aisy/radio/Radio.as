package org.aisy.radio
{
	import flash.events.MouseEvent;
	
	import org.ais.event.TEvent;
	import org.aisy.button.Button;

	/**
	 * 
	 * 单选框组件
	 * 
	 * @author viqu
	 * 
	 */
	public class Radio extends Button
	{
		/**
		 * 名字
		 */
		protected var _NAME:String;
		/**
		 * 皮肤类名
		 */
		protected var _skinName:String;
		/**
		 * 索引
		 */
		protected var _index:uint;
		/**
		 * 是否选中
		 */
		protected var _selected:Boolean;
		
		public function Radio()
		{
			init();
		}
		
		/**
		 * 
		 * 初始化
		 * 
		 */
		protected function init():void
		{
			addEventListener(MouseEvent.CLICK, mouseClickHandler);
		}
		
		/**
		 * 
		 * MOUSE_CLICK 侦听
		 * 
		 */
		protected function mouseClickHandler(e:MouseEvent):void
		{
			if (_selected === true) return;
			setClassName(_skinName + 1);
			getSkin().gotoAndStop(2);
			_selected = true;
			TEvent.trigger(NAME, "RADIO", {"name": NAME, "index": index, "selected": _selected, "obj": this});
			e = null;
		}
		
		/**
		 * 
		 * 全局侦听
		 * 
		 * @param type
		 * @param data
		 * 
		 */
		protected function __triggerHandler(type:String, data:* = null):void
		{
			switch (type) {
				case "RADIO":
					if (NAME !== data.name) return;
					if (_selected === true && this !== data.obj) {
						setClassName(_skinName + 0);
						_selected = false;
					}
					break;
			}
			type = null;
			data = null;
		}
		
		/**
		 * 
		 * 设置皮肤 （类名）
		 * 
		 * @param value
		 * 
		 */
		public function setSkinName(value:String):void
		{
			_skinName = value;
			setClassName(value + 0);
			value = null;
		}
		
		/**
		 * 
		 * 设置 是否选中
		 * 
		 * @param value
		 * 
		 */
		override public function setSelected(value:Boolean):void
		{
			_selected = !value;
			mouseClickHandler(null);
		}
		
		/**
		 * 
		 * 返回 是否选中
		 * 
		 * @return 
		 * 
		 */
		override public function getSelected():Boolean
		{
			return _selected;
		}
		
		/**
		 * 
		 * 设置名字
		 * 
		 * @param value
		 * 
		 */
		public function set NAME(value:String):void
		{
			if (null !== _NAME) TEvent.clearTrigger(_NAME);
			_NAME = null === value ? "RADIO" : value;
			TEvent.newTrigger(_NAME, __triggerHandler);
			value = null;
		}
		
		/**
		 * 
		 * 返回名字
		 * 
		 * @return 
		 * 
		 */
		public function get NAME():String
		{
			if (null === _NAME) NAME = null;
			return _NAME;
		}
		
		/**
		 * 
		 * 设置索引
		 * 
		 * @param value
		 * 
		 */
		public function set index(value:uint):void
		{
			_index = value;
		}
		
		/**
		 * 
		 * 返回索引
		 * 
		 * @return 
		 * 
		 */
		public function get index():uint
		{
			return _index;
		}
		
		/**
		 * 
		 * 清空
		 * 
		 */
		override public function clear():void
		{
			super.clear();
			_skinName = null;
			if (null !== _NAME) {
				TEvent.clearTrigger(_NAME);
				_NAME = null;
			}
		}
		
	}
}