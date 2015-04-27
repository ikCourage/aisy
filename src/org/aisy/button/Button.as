package org.aisy.button
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	import org.ais.system.Ais;
	import org.aisy.display.USprite;
	import org.aisy.interfaces.IClear;
	import org.aisy.skin.AisySkin;
	import org.aisy.textview.TextView;

	/**
	 * 
	 * 按钮
	 * 
	 * @author viqu
	 * 
	 */
	public class Button extends USprite
	{
		/**
		 * 数据对象
		 */
		protected var iData:ButtonData;
		
		public function Button()
		{
			init();
		}
		
		/**
		 * 初始化
		 */
		protected function init():void
		{
			if (AisySkin.BUTTON_AUTO_SKIN === true) {
				setSkinClassName(AisySkin.BUTTON_SKIN);
			}
		}
		
		/**
		 * 计算布局
		 * @param width
		 * @param height
		 */
		protected function __layout(width:Number = 0, height:Number = 0):void
		{
			var w:Number = Math.max(getData().width, getData().textView.width);
			var h:Number = Math.max(getData().height, getData().textView.height);
			w = width !== 0 ? width : w;
			h = height !== 0 ? height : h;
//			w += 10;
//			h += 4;
			if (null !== getData().skin) {
				getData().skin.width = w;
				getData().skin.height = h;
			}
			if (null !== getData().textView) {
				getData().textView.x = (w - getData().textView.width) >> 1;
				getData().textView.y = (h - getData().textView.height) >> 1;
			}
		}
		
		/**
		 * 注册事件
		 */
		protected function __addEvent():void
		{
			addEventListener(MouseEvent.ROLL_OVER, __mouseHandler);
		}
		
		/**
		 * 移除事件
		 */
		protected function __removeEvent():void
		{
			if (getData().mouse !== 0) Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __stageHandler);
		}
		
		/**
		 * 鼠标事件侦听
		 * @param e
		 */
		protected function __mouseHandler(e:MouseEvent):void
		{
			if (null === iData) return;
			var arr:Array = [e];
			switch (e.type) {
				case MouseEvent.ROLL_OVER:
					removeEventListener(e.type, __mouseHandler);
					addEventListener(MouseEvent.ROLL_OUT, __mouseHandler);
					if (AisySkin.MOBILE === false && AisySkin.USE_MOUSEDOWN === true && e.buttonDown === true && getData().mouse === 0) {
						getData().mouse = 1;
						Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __stageHandler);
						return;
					}
					addEventListener(MouseEvent.MOUSE_DOWN, __mouseHandler);
					addEventListener(MouseEvent.CLICK, __mouseHandler);
					getData().skin.gotoAndStop(getData().selected === true ? 4 : (getData().mouse !== 0 ? 3 : 2));
					if (null !== getData().rollOverF) getData().rollOverF.apply(null, arr.slice(0, getData().rollOverF.length));
					break;
				case MouseEvent.ROLL_OUT:
					switch (getData().mouse) {
						case 1:
							getData().mouse = 0;
							Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __stageHandler);
							break;
						case 2:
							getData().mouse = 3;
							break;
					}
					removeEventListener(e.type, __mouseHandler);
					addEventListener(MouseEvent.ROLL_OVER, __mouseHandler);
					if (AisySkin.MOBILE === false && AisySkin.USE_MOUSEDOWN === true && e.buttonDown === true && getData().mouse < 2) return;
					removeEventListener(MouseEvent.MOUSE_DOWN, __mouseHandler);
					removeEventListener(MouseEvent.CLICK, __mouseHandler);
					getData().skin.gotoAndStop(getData().selected === true ? 4 : (getData().mouse !== 0 ? 2 : 1));
					if (null !== getData().rollOutF) getData().rollOutF.apply(null, arr.slice(0, getData().rollOutF.length));
					break;
				case MouseEvent.MOUSE_DOWN:
					getData().skin.gotoAndStop(getData().selected === true ? 4 : 3);
					__stageHandler(null);
					if (null !== getData().mouseDownF) getData().mouseDownF.apply(null, arr.slice(0, getData().mouseDownF.length));
					break;
				case MouseEvent.CLICK:
					getData().skin.gotoAndStop(getData().selected === true ? 4 : 2);
					if (null !== getData().clickF) getData().clickF.apply(null, arr.slice(0, getData().clickF.length));
					break;
			}
			arr = null;
			e = null;
		}
		
		protected function __stageHandler(e:MouseEvent):void
		{
			if (AisySkin.MOBILE === true || null === iData) return;
			if (getData().mouse === 1) {
				getData().mouse = 0;
				Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __stageHandler);
				__mouseHandler(new MouseEvent(MouseEvent.ROLL_OVER, e.bubbles, e.cancelable, mouseX, mouseY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, false, e.delta));
			}
			else {
				if (getData().mouse !== 0) {
					Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __stageHandler);
					if (getData().mouse !== 2) getData().skin.gotoAndStop(getData().selected === true ? 4 : 1);
				}
				else Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __stageHandler);
				getData().mouse = getData().mouse !== 0 ? 0 : 2;
			}
			e = null;
		}
		
		/**
		 * 返回 数据对象
		 * @return 
		 */
		protected function getData():ButtonData
		{
			return null === iData ? iData = new ButtonData() : iData;
		}
		
		/**
		 * 设置 皮肤 类名
		 * @param value
		 */
		public function setSkinClassName(value:String):void
		{
			setSkinClass(getDefinitionByName(value) as Class);
			value = null;
		}
		
		/**
		 * 设置 皮肤 类
		 * @param value
		 */
		public function setSkinClass(value:Class):void
		{
			setSkin(new value());
			value = null;
		}
		
		/**
		 * 设置 皮肤
		 * @param value
		 */
		public function setSkin(value:Object):void
		{
			if (null === getData().skin) __addEvent();
			else {
				if (getData().skin is IClear) IClear(getData().skin).clear();
				else removeChild(getData().skin as DisplayObject);
			}
			value.dynamic = {"mouseEnabled": false};
			getData().skin = value;
			getData().skin.gotoAndStop(getData().selected === true ? 4 : 1);
			addChildAt(getData().skin as DisplayObject, 0);
			getData().width = getData().skin.width;
			getData().height = getData().skin.height;
			value = null;
		}
		
		/**
		 * 设置 大小
		 * @param width
		 * @param height
		 */
		public function setSize(width:Number = 0, height:Number = 0):void
		{
			__layout(width, height);
		}
		
		/**
		 * 设置 是否可用
		 * @param value
		 */
		public function setEnabled(value:Boolean):void
		{
			mouseEnabled = mouseChildren = value;
			getData().skin.gotoAndStop(getData().selected === true ? 4 : 1);
		}
		
		/**
		 * 设置 是否选中
		 * @param value
		 */
		public function setSelected(value:Boolean):void
		{
			getData().selected = value;
			getData().skin.gotoAndStop(value === true ? 4 : 1);
		}
		
		/**
		 * 设置 显示文本
		 * @param value
		 */
		public function setText(value:String):void
		{
			getTextView().setText(value);
			getTextView().dynamic = {"mouseEnabled": false};
			addChildAt(getTextView(), numChildren);
			__layout();
		}
		
		/**
		 * 设置 ROLL_OVER 回调函数
		 * @param value
		 */
		public function setRollOver(value:Function):void
		{
			getData().rollOverF = value;
			value = null;
		}
		
		/**
		 * 设置 ROLL_OUT 回调函数
		 * @param value
		 */
		public function setRollOut(value:Function):void
		{
			getData().rollOutF = value;
			value = null;
		}
		
		/**
		 * 设置 MOUSE_DOWN 回调函数
		 * @param value
		 */
		public function setMouseDown(value:Function):void
		{
			getData().mouseDownF = value;
			value = null;
		}
		
		/**
		 * 设置 CLICK 回调函数
		 * @param value
		 */
		public function setClick(value:Function):void
		{
			getData().clickF = value;
			value = null;
		}
		
		/**
		 * 返回 显示文字 TextView
		 * @return 
		 */
		public function getTextView():TextView
		{
			if (null === getData().textView) getData().textView = new TextView();
			return getData().textView;
		}
		
		/**
		 * 返回 皮肤
		 * @return 
		 */
		public function getSkin():Object
		{
			return getData().skin;
		}
		
		/**
		 * 返回 是否选中
		 * @return 
		 */
		public function getSelected():Boolean
		{
			return getData().selected;
		}
		
		/**
		 * 清空
		 */
		override public function clear():void
		{
			__removeEvent();
			super.clear();
			if (null !== iData) {
				iData.clear();
				iData = null;
			}
		}
		
	}
}