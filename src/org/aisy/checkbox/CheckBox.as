package org.aisy.checkbox
{
	import flash.events.MouseEvent;
	
	import org.ais.event.TEvent;
	import org.aisy.button.Button;

	/**
	 * 
	 * 多选框组件
	 * 
	 * @author viqu
	 * 
	 */
	public class CheckBox extends Button
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
		
		public function CheckBox()
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
		 * MOUSE_DOWN 侦听
		 * 
		 */
		protected function mouseClickHandler(e:MouseEvent):void
		{
			if (_selected === false) {
				setClassName(_skinName + 1);
			}
			else {
				setClassName(_skinName + 0);
			}
			getSkin().gotoAndStop(2);
			_selected = !_selected;
			TEvent.trigger(NAME, "CHECKBOX", {"name": NAME, "index": index, "selected": _selected, "obj": this});
			e = null;
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
			_NAME = null === value ? "CHECKBOX" : value;
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