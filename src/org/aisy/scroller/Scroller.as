package org.aisy.scroller
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	import org.ais.system.Ais;
	import org.aisy.display.USprite;
	import org.aisy.interfaces.IClear;
	import org.aisy.skin.AisySkin;

	/**
	 * 
	 * 滚动条组件
	 * 
	 * @author Viqu
	 * 
	 */
	public class Scroller extends USprite
	{
		/**
		 * 数据对象
		 */
		protected var iData:ScrollerData;
		
		public function Scroller()
		{
		}
		
		/**
		 * 
		 * 返回 ScrollerData
		 * 
		 * @return 
		 * 
		 */
		protected function getData():ScrollerData
		{
			return null === iData ? iData = new ScrollerData() : iData;
		}
		
		/**
		 * 
		 * 计算布局
		 * 
		 */
		protected function __layout():void
		{
			if (null === getData().mask) return;
			getData().mask.width = getData().width;
			getData().mask.height = getData().height;
			
			graphics.clear();
			graphics.beginFill(0xff0000, 0);
			graphics.drawRect(0, 0, getData().width, getData().height);
			graphics.endFill();
			
			getData().moveDelay = 0;
			
			switch (getData().layout) {
				case 0:
					if (null !== getData().skinClass && null === getData().scrollV) setSkin(new (getData().skinClass)(), 1);
					else setSkin(null, 1);
					if (null !== getData().skinClass && null === getData().scrollH) setSkin(new (getData().skinClass)(), 2);
					else setSkin(null, 2);
					break;
				case 1:
					if (null !== getData().skinClass && null === getData().scrollV) setSkin(new (getData().skinClass)(), 1);
					else setSkin(null, 1);
					break;
				case 2:
					if (null !== getData().skinClass && null === getData().scrollH) setSkin(new (getData().skinClass)(), 2);
					else setSkin(null, 2);
					break;
			}
			if (getData().isMouseDown === true) {
				if (getData().isScrollV === true) {
					var _y:Number = -getData().obj.height + getData().height;
					if (getData().obj.y < _y) {
						getData().obj.y = _y;
					}
				}
				else {
					getData().obj.y = 0;
				}
				if (getData().isScrollH === true) {
					var _x:Number = -getData().obj.width + getData().width;
					if (getData().obj.x < _x) {
						getData().obj.x = _x;
					}
				}
				else {
					getData().obj.x = 0;
				}
				if (AisySkin.MOBILE === true && getData().position === true) {
					var _sX:Number = getData().startX;
					var _sY:Number = getData().startY;
					__mouseHandler(new MouseEvent(MouseEvent.MOUSE_DOWN));
					getData().startX = _sX;
					getData().startY = _sY;
				}
			}
			else {
				getData().obj.x = getData().obj.y = 0;
			}
		}
		
		/**
		 * 
		 * 注册侦听
		 * 
		 */
		protected function __addEvent():void
		{
			if (AisySkin.MOBILE === true && getData().position === true) {
				addEventListener(MouseEvent.MOUSE_DOWN, __mouseHandler);
			}
		}
		
		/**
		 * 
		 * 移除侦听
		 * 
		 */
		protected function __removeEvent():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, __mouseHandler);
			
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
		}
		
		/**
		 * 
		 * 鼠标侦听
		 * 
		 * @param e
		 * 
		 */
		protected function __mouseHandler(e:MouseEvent):void
		{
			if (getData().enabled === false || AisySkin.MOBILE === false || getData().position === false) return;
			switch (e.type) {
				case MouseEvent.MOUSE_DOWN:
					getData().isMouseDown = true;
					getData().moveDelay = 0;
					getData().moveX = 0;
					getData().moveY = 0;
					getData().startX = e.stageX;
					getData().startY = e.stageY;
					getDefinitionByName("com.greensock.TweenLite").killTweensOf(getData().obj);
					Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
					Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
					var _pw:Number = getData().isScrollH === true ? getData().obj.width : 0;
					var _ph:Number = getData().isScrollV === true ? getData().obj.height : 0;
					var _w:Number = getData().isScrollH === true ? width : 0;
					var _h:Number = getData().isScrollV === true ? height : 0;
					getData().obj.startDrag(false, new Rectangle(-_pw, -_ph, _pw + _w, _ph + _h));
					break;
				case MouseEvent.MOUSE_MOVE:
					if (null === getData().moveMask) {
						getData().moveMask = new USprite();
						getData().moveMask.graphics.beginFill(0xff0000, 0);
						getData().moveMask.graphics.drawRect(0, 0, width, height);
						getData().moveMask.graphics.endFill();
						addChild(getData().moveMask);
					}
					var _mX:Number = Math.round(getData().startX - e.stageX) * getData().moveFactor;
					var _mY:Number = Math.round(getData().startY - e.stageY) * getData().moveFactor;
					getData().moveX = _mX !== 0 ? _mX : getData().moveX;
					getData().moveY = _mY !== 0 ? _mY : getData().moveY;
					
					getData().moveDelay = Math.max(Math.abs(getData().moveX), Math.abs(getData().moveY)) / height;
					
					getData().startX = e.stageX;
					getData().startY = e.stageY;
					
					if (null !== getData().scrollV) getData().scrollV.layoutScroll();
					if (null !== getData().scrollH) getData().scrollH.layoutScroll();
					break;
				case MouseEvent.MOUSE_UP:
					Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
					Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
					getData().isMouseDown = false;
					getData().obj.stopDrag();
					
					if (null !== getData().moveMask) {
						getData().moveMask.clear();
						getData().moveMask = null;
					}
					
					getData().moveX = Math.abs(getData().moveX) > getData().moveFactor * 2 ? getData().moveX : 0;
					getData().moveY = Math.abs(getData().moveY) > getData().moveFactor * 2 ? getData().moveY : 0;
					
					layoutScroll(getData().obj.x - getData().moveX, getData().obj.y - getData().moveY, 0);
					break;
			}
		}
		
		/**
		 * 
		 * 设置滚动对象
		 * 
		 * @param value
		 * @param layout
		 * @param elastic
		 * 
		 */
		public function setSource(value:Sprite, layout:uint = 0, elastic:Boolean = true):void
		{
			getData().layout = layout;
			getData().elastic = elastic;
			if (null !== getData().group) {
				getData().obj.mask = null;
				getData().mask = null;
				var obj:*;
				while (getData().group.numChildren) {
					obj = getData().group.getChildAt(0);
					if (obj is IClear) obj.clear();
					else getData().group.removeChildAt(0);
				}
				obj = null;
			}
			else {
				getData().group = new USprite();
				addChild(getData().group);
			}
			getData().obj = value;
			getData().group.addChild(value);
			
			getData().mask = new Shape();
			getData().mask.graphics.beginFill(0xff0000, 0.3);
			getData().mask.graphics.drawRect(0, 0, 1, 1);
			getData().mask.graphics.endFill();
			getData().group.addChild(getData().mask);
			
			value.mask = getData().mask;
			
			value = null;
		}
		
		/**
		 * 
		 * 返回滚动对象
		 * 
		 * @return 
		 * 
		 */
		public function getSource():Sprite
		{
			return getData().obj;
		}
		
		/**
		 * 
		 * 设置皮肤 DisplayObjectContainer 类名
		 * 
		 * @param value
		 * 
		 */
		public function setSkinClassName(value:String):void
		{
			setSkinClass(getDefinitionByName(value) as Class);
			value = null;
		}
		
		/**
		 * 
		 * 设置皮肤 DisplayObjectContainer 类
		 * 
		 * @param value
		 * 
		 */
		public function setSkinClass(value:Class):void
		{
			getData().skinClass = value;
			if (null !== getData().obj) {
				switch (getData().layout) {
					case 0:
						setSkin(null !== value ? new value() : null, 1);
						setSkin(null !== value ? new value() : null, 2);
						break;
					case 1:
						setSkin(null !== value ? new value() : null, 1);
						break;
					case 2:
						setSkin(null !== value ? new value() : null, 2);
						break;
				}
			}
			value = null;
		}
		
		/**
		 * 
		 * 设置皮肤 DisplayObjectContainer
		 * 
		 * @param value
		 * @param layout
		 * 
		 */
		public function setSkin(value:DisplayObjectContainer, layout:uint = 1):void
		{
			if (layout === 1) {
				getData().isScrollV = false;
				if (getData().height < getData().obj.height) {
					if (null !== value && null === getData().scrollV) getData().scrollV = new ScrollBar(getData(), layout);
					if (null !== value) getData().scrollV.setSkin(value);
					if (null !== getData().scrollV) {
						addChild(getData().scrollV);
						getData().scrollV.updateView();
						getData().isShiftKey = true;
						getData().isScrollV = true;
					}
				}
				else {
					if (null === getData().scrollV) return;
					getData().scrollV.clearView();
					getData().isShiftKey = false;
				}
			}
			else {
				getData().isScrollH = false;
				if (getData().width < getData().obj.width) {
					if (null !== value && null === getData().scrollH) getData().scrollH = new ScrollBar(getData(), layout);
					if (null !== value) getData().scrollH.setSkin(value);
					if (null !== getData().scrollH) {
						addChild(getData().scrollH);
						getData().scrollH.updateView();
						getData().isScrollH = true;
					}
				}
				else {
					if (null === getData().scrollH) return;
					getData().scrollH.clearView();
				}
			}
			value = null;
		}
		
		/**
		 * 
		 * 设置 布局样式
		 * 当 layout = 0 时，设置（横向、竖向）布局
		 * 当 layout = 1 时，设置（横向）布局
		 * 当 layout = 2 时，设置（竖向）布局
		 * 
		 * @param layout
		 * 
		 */
		public function setLayout(layout:uint = 0):void
		{
			getData().layout = layout;
		}
		
		/**
		 * 
		 * 设置 内部缩进
		 * 当 layout = 0 时，设置（横向缩进、竖向缩进）
		 * 当 layout = 1 时，设置（横向缩进）
		 * 当 layout = 2 时，设置（竖向缩进）
		 * 
		 * @param padding
		 * @param layout
		 * 
		 */
		public function setPadding(padding:Number, layout:uint = 0):void
		{
			switch (layout) {
				case 0:
					getData().paddingH = padding;
					getData().paddingV = padding;
					break;
				case 1:
					getData().paddingH = padding;
					break;
				case 2:
					getData().paddingV = padding;
					break;
			}
		}
		
		/**
		 * 
		 * 设置是否绝对定位
		 * 
		 * @param value
		 * 
		 */
		public function setPosition(value:Boolean):void
		{
			getData().position = value;
		}
		
		/**
		 * 
		 * 设置滚动条显示
		 * 当 layout = 0 时，设置（横向、竖向）显示
		 * 当 layout = 1 时，设置（横向）显示
		 * 当 layout = 2 时，设置（竖向）显示
		 * 
		 * @param visible
		 * @param layout
		 * 
		 */
		public function setScrollVisible(visible:Boolean, layout:uint = 0):void
		{
			switch (layout) {
				case 0:
					if (null !== getData().scrollV) getData().scrollV.visible = visible;
					if (null !== getData().scrollH) getData().scrollH.visible = visible;
					break;
				case 1:
					if (null !== getData().scrollV) getData().scrollV.visible = visible;
					break;
				case 2:
					if (null !== getData().scrollH) getData().scrollH.visible = visible;
					break;
			}
		}
		
		/**
		 * 
		 * 设置是否可用
		 * 
		 * @param value
		 * 
		 */
		public function setEnabled(value:Boolean):void
		{
			getData().enabled = value;
			if (null !== getData().scrollV) getData().scrollV.visible = value;
			if (null !== getData().scrollH) getData().scrollH.visible = value;
		}
		
		/**
		 * 
		 * 设置按钮滚动速度
		 * 
		 * @param value
		 * 
		 */
		public function setSpeed(value:Number):void
		{
			getData().speed = value;
		}
		
		/**
		 * 
		 * 设置滚轮滚动速度
		 * 
		 * @param value
		 * 
		 */
		public function setDelta(value:Number):void
		{
			getData().delta = value;
		}
		
		/**
		 * 
		 * 设置滚动延迟
		 * 
		 * @param value
		 * 
		 */
		public function setDelay(value:Number):void
		{
			getData().delay = value;
		}
		
		/**
		 * 
		 * 设置滑动因子
		 * 
		 * @param value
		 * 
		 */
		public function setMoveFactor(value:Number):void
		{
			getData().moveFactor = value;
		}
		
		/**
		 * 
		 * 设置显示宽度，高度
		 * 
		 * @param width
		 * @param height
		 * 
		 */
		public function setSize(width:Number = 0, height:Number = 0):void
		{
			getData().width = width;
			getData().height = height;
			updateView();
		}
		
		/**
		 * 
		 * 计算滚动条位置
		 * 
		 * @param x
		 * @param y
		 * @param layout
		 * 
		 */
		public function layoutScroll(x:Number = 0, y:Number = 0, layout:uint = 0):void
		{
			var _x:Number = -getData().obj.width + getData().width;
			var _y:Number = -getData().obj.height + getData().height;
			x = x > 0 ? 0 : x;
			y = y > 0 ? 0 : y;
			x = x < _x ? _x : x;
			y = y < _y ? _y : y;
			x = getData().isScrollH === true ? x : 0;
			y = getData().isScrollV === true ? y : 0;
			switch (layout) {
				case 0:
					if (null !== getData().scrollV) getData().scrollV.layoutScroll(y, 1);
					if (null !== getData().scrollH) getData().scrollH.layoutScroll(x, 1);
					break;
				case 1:
					if (null !== getData().scrollV) getData().scrollV.layoutScroll(y, 1);
					break;
				case 2:
					if (null !== getData().scrollH) getData().scrollH.layoutScroll(x, 1);
					break;
			}
			getDefinitionByName("com.greensock.TweenLite").to(getData().obj, getData().delay + getData().moveDelay, {"x": x, "y": y});
		}
		
		/**
		 * 
		 * 返回是否可用
		 * @return 
		 * 
		 */
		public function getEnabled():Boolean
		{
			return getData().enabled;
		}
		
		/**
		 * 
		 * 更新显示
		 * 
		 */
		public function updateView():void
		{
			__removeEvent();
			__layout();
			__addEvent();
		}
		
		override public function get width():Number
		{
			return getData().width > getData().obj.width ? getData().obj.width : getData().width;
		}
		
		override public function get height():Number
		{
			return getData().height > getData().obj.height ? getData().obj.height : getData().height;
		}
		
		/**
		 * 
		 * 清空
		 * 
		 */
		override public function clear():void
		{
			__removeEvent();
			if (null !== iData) {
				iData.clear();
				iData = null;
			}
			super.clear();
		}
		
	}
}