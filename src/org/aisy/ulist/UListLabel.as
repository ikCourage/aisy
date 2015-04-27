package org.aisy.ulist
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import org.ais.event.TEvent;
	import org.ais.system.Ais;
	import org.aisy.display.USprite;

	/**
	 * 
	 * UList 标题
	 * 
	 * @author Viqu
	 * 
	 */
	public class UListLabel extends USprite
	{
		/**
		 * 名称
		 */
		protected var NAME:String;
		/**
		 * 标题数据
		 */
		protected var iData:*;
		
		public function UListLabel(name:String, data:*)
		{
			NAME = name;
			iData = data;
			__addEvent();
			name = null;
			data = null;
		}
		
		/**
		 * 注册侦听
		 */
		private function __addEvent():void
		{
			addEventListener(MouseEvent.CLICK, __mouseHandler);
			TEvent.newTrigger(NAME, __triggerHandler);
		}
		
		/**
		 * 鼠标侦听
		 * @param e
		 */
		private function __mouseHandler(e:MouseEvent):void
		{
			iparent().showList();
			if (iparent().isShow === true) stage.addEventListener(MouseEvent.MOUSE_DOWN, __stageMouseHandler);
			e = null;
		}
		
		/**
		 * 舞台鼠标侦听
		 * @param e
		 */
		private function __stageMouseHandler(e:MouseEvent):void
		{
			var obj:DisplayObject = e.target as DisplayObject;
			if (iparent().getGroup().contains(obj) === true) {
				
			}
			else if (iparent().contains(obj) === true) {
				
			}
			else {
				hideList();
			}
			obj = null;
			e = null;
		}
		
		/**
		 * 隐藏列表
		 */
		private function hideList():void
		{
			if (null !== stage) stage.removeEventListener(MouseEvent.MOUSE_DOWN, __stageMouseHandler);
			iparent().hideList();
		}
		
		/**
		 * 父元件 UList
		 * @return 
		 */
		private function iparent():UList
		{
			return parent as UList;
		}
		
		/**
		 * 全局侦听
		 * @param type
		 * @param data
		 */
		protected function __triggerHandler(type:String, data:* = null):void
		{
			switch (type) {
				case UListEvent.RADIO_SELECT:
					hideList();
					break;
			}
			type = null;
			data = null;
		}
		
		/**
		 * 清空
		 */
		override public function clear():void
		{
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_DOWN, __stageMouseHandler);
			super.clear();
			iData = null;
			NAME = null;
		}
		
	}
}