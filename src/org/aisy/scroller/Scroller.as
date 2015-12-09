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
			init();
		}
		
		/**
		 * 初始化
		 */
		protected function init():void
		{
			if (AisySkin.SCROLLER_AUTO_SKIN === true) {
				setSkinClassName(AisySkin.SCROLLER_SKIN);
			}
		}
		
		/**
		 * 返回 ScrollerData
		 * @return 
		 */
		protected function getData():ScrollerData
		{
			return null === iData ? iData = new ScrollerData() : iData;
		}
		
		/**
		 * 计算布局
		 */
		protected function __layout():void
		{
			if (null === getData().mask) return;
			getDefinitionByName(AisySkin.TWEEN_LITE).killTweensOf(getData().obj);
			getData().mask.width = getData().width;
			getData().mask.height = getData().height;
			
			graphics.clear();
			graphics.beginFill(0xFF0000, 0);
			graphics.drawRect(0, 0, getData().width, getData().height);
			graphics.endFill();
			
			getData().moveDuration = 0;
			
			if (getData().isMouseDown === false) {
				getData().obj.x = getData().obj.y = 0;
			}
			switch (getData().layout) {
				case 0:
					if (null !== getData().skinClass && null === getData().scrollH) setSkin(new (getData().skinClass)(), 2);
					else setSkin(null, 2);
					if (null !== getData().skinClass && null === getData().scrollV) setSkin(new (getData().skinClass)(), 1);
					else setSkin(null, 1);
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
				if (getData().isScrollH === false) getData().obj.x = 0;
				if (getData().isScrollV === false) getData().obj.y = 0;
				if ((AisySkin.MOBILE === true || getData().mobile === true) && getData().mode !== 0) {
					Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
					Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
				}
				else {
					getData().moveRect = null;
				}
			}
		}
		
		/**
		 * 注册侦听
		 */
		protected function __addEvent():void
		{
			if ((AisySkin.MOBILE === true || getData().mobile === true) && getData().mode !== 0) {
				getData().group.addEventListener(MouseEvent.MOUSE_DOWN, __mouseHandler);
			}
		}
		
		/**
		 * 移除侦听
		 */
		protected function __removeEvent():void
		{
			getData().group.removeEventListener(MouseEvent.MOUSE_DOWN, __mouseHandler);
			
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
			Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
		}
		
		/**
		 * 鼠标侦听
		 * @param e
		 */
		protected function __mouseHandler(e:MouseEvent):void
		{
			if (getData().enabled === false || (AisySkin.MOBILE === false && getData().mobile === false) || getData().mode === 0) return;
			switch (e.type) {
				case MouseEvent.MOUSE_DOWN:
					getData().isMouseDown = true;
					getData().moveDuration = 0;
					getData().moveX = 0;
					getData().moveY = 0;
					getData().startX = e.stageX;
					getData().startY = e.stageY;
					getData().mouseX = e.stageX - getData().obj.x;
					getData().mouseY = e.stageY - getData().obj.y;
					getDefinitionByName(AisySkin.TWEEN_LITE).killTweensOf(getData().obj);
					Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
					Ais.IMain.stage.addEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
					var _x:Number = getData().isScrollH === true ? width - getData().obj.width : 0;
					var _y:Number = getData().isScrollV === true ? height - getData().obj.height : 0;
					getData().moveRect = new Rectangle(_x, _y, 0, 0);
					break;
				case MouseEvent.MOUSE_MOVE:
					if (null === getData().moveMask) {
						getData().moveMask = new USprite();
						getData().moveMask.graphics.beginFill(0xFF0000, 0);
						getData().moveMask.graphics.drawRect(0, 0, width, height);
						getData().moveMask.graphics.endFill();
						addChild(getData().moveMask);
					}
					if (getData().isScrollH === true) {
						_x = Ais.IMain.stage.mouseX - getData().mouseX;
						if (_x < getData().moveRect.x) _x = getData().moveRect.x + (_x - getData().moveRect.x) * getData().overflowH;
						else if (_x > getData().moveRect.width) _x = getData().moveRect.width + (_x - getData().moveRect.width) * getData().overflowH;
						getData().obj.x = _x;
					}
					if (getData().isScrollV === true) {
						_y = Ais.IMain.stage.mouseY - getData().mouseY;
						if (_y < getData().moveRect.y) _y = getData().moveRect.y + (_y - getData().moveRect.y) * getData().overflowV;
						else if (_y > getData().moveRect.height) _y = getData().moveRect.height + (_y - getData().moveRect.height) * getData().overflowV;
						getData().obj.y = _y;
					}
					_x = Math.round(getData().startX - e.stageX) * getData().moveFactor;
					_y = Math.round(getData().startY - e.stageY) * getData().moveFactor;
					getData().moveX = _x !== 0 ? _x : getData().moveX;
					getData().moveY = _y !== 0 ? _y : getData().moveY;
					
					getData().startX = e.stageX;
					getData().startY = e.stageY;
					
					if (getData().isScrollH === true) {
						getData().scrollH.updateView(true);
						getData().scrollH.layoutScroll(0, 0, 0);
					}
					if (getData().isScrollV === true) {
						getData().scrollV.updateView(true);
						getData().scrollV.layoutScroll(0, 0, 0);
					}
					break;
				case MouseEvent.MOUSE_UP:
					Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_UP, __mouseHandler);
					Ais.IMain.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseHandler);
					getData().isMouseDown = false;
					getData().moveRect = null;
					
					if (null !== getData().moveMask) {
						getData().moveMask.clear();
						getData().moveMask = null;
					}
					
					getData().moveX = Math.abs(getData().moveX) > getData().moveDistance ? getData().moveX : 0;
					getData().moveY = Math.abs(getData().moveY) > getData().moveDistance ? getData().moveY : 0;
					_x = getData().isScrollH === true ? Math.abs(getData().moveX / width) : 0;
					_y = getData().isScrollV === true ? Math.abs(getData().moveY / height) : 0;
					getData().moveX = getData().obj.x - getData().moveX;
					getData().moveY = getData().obj.y - getData().moveY;
					_x = getData().moveX > 0 ? 0 : _x;
					_y = getData().moveY > 0 ? 0 : _y;
					_x = getData().moveX < getData().width - getData().obj.width ? 0 : _x;
					_y = getData().moveY < getData().height - getData().obj.height ? 0 : _y;
					getData().moveDuration = Math.max(_x, _y) * getData().moveDurationFactor;
					getData().moveDuration = getData().moveDuration > getData().moveDurationMax ? getData().moveDurationMax : getData().moveDuration;
					
					layoutScroll(getData().moveX, getData().moveY, 0, -1, 1);
					break;
			}
		}
		
		/**
		 * 设置 滚动对象
		 * @param value
		 * @param layout
		 * @param elastic
		 */
		public function setSource(value:Sprite, layout:uint = 0, elastic:Boolean = true):void
		{
			getData().layout = layout;
			getData().elastic = elastic;
			if (null !== getData().group) {
				getData().obj.mask = null;
				getData().mask = null;
				var i:uint = getData().group.numChildren, obj:*;
				while (i) {
					i--;
					obj = getData().group.getChildAt(i);
					if (obj is IClear) obj.clear();
					else removeChildAt(i);
				}
				obj = null;
			}
			else {
				getData().group = new USprite();
				addChildAt(getData().group, 0);
			}
			getData().obj = value;
			getData().group.addChild(value);
			
			getData().mask = new Shape();
			getData().mask.graphics.beginFill(0xFF0000, 0.3);
			getData().mask.graphics.drawRect(0, 0, 1, 1);
			getData().mask.graphics.endFill();
			getData().group.addChild(getData().mask);
			
			getData().group.mask = getData().mask;
			
//			__layout();
			
			value = null;
		}
		
		/**
		 * 返回 滚动对象
		 * @return 
		 */
		public function getSource():Sprite
		{
			return getData().obj;
		}
		
		/**
		 * 设置 皮肤 DisplayObjectContainer 类名
		 * @param value
		 */
		public function setSkinClassName(value:String):void
		{
			setSkinClass(getDefinitionByName(value) as Class);
			value = null;
		}
		
		/**
		 * 设置 皮肤 DisplayObjectContainer 类
		 * @param value
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
		 * 设置 皮肤 DisplayObjectContainer
		 * @param value
		 * @param layout
		 */
		public function setSkin(value:DisplayObjectContainer, layout:uint = 1):void
		{
			getData().scroller = this;
			if (layout === 1) {
				getData().isScrollV = true;
				if (getData().height < getData().obj.height) {
					if (null !== value && null === getData().scrollV) getData().scrollV = new ScrollBar(getData(), layout);
					if (null !== value) getData().scrollV.setSkin(value);
					if (null !== getData().scrollV) {
						addChild(getData().scrollV);
						getData().scrollV.updateView();
						getData().isShiftKey = true;
					}
					else {
						getData().isScrollV = false;
					}
				}
				else {
					getData().isScrollV = false;
					getData().isShiftKey = false;
					if (null === getData().scrollV) return;
					getData().scrollV.clearView();
				}
			}
			else {
				getData().isScrollH = true;
				if (getData().width < getData().obj.width) {
					if (null !== value && null === getData().scrollH) getData().scrollH = new ScrollBar(getData(), layout);
					if (null !== value) getData().scrollH.setSkin(value);
					if (null !== getData().scrollH) {
						addChild(getData().scrollH);
						getData().scrollH.updateView();
					}
					else {
						getData().isScrollH = false;
					}
				}
				else {
					getData().isScrollH = false;
					if (null === getData().scrollH) return;
					getData().scrollH.clearView();
				}
			}
			value = null;
		}
		
		/**
		 * 设置 布局样式
		 * 当 layout = 0 时，设置（横向、竖向）布局
		 * 当 layout = 1 时，设置（横向）布局
		 * 当 layout = 2 时，设置（竖向）布局
		 * @param layout
		 */
		public function setLayout(layout:uint = 0):void
		{
			getData().layout = layout;
		}
		
		/**
		 * 设置 内部缩进
		 * 当 layout = 0 时，设置（横向缩进、竖向缩进）
		 * 当 layout = 1 时，设置（横向缩进）
		 * 当 layout = 2 时，设置（竖向缩进）
		 * @param padding
		 * @param layout
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
		 * 设置 滑块最小尺寸
		 * 当 layout = 0 时，设置（横向尺寸、竖向尺寸）
		 * 当 layout = 1 时，设置（横向尺寸）
		 * 当 layout = 2 时，设置（竖向尺寸）
		 * @param value
		 * @param layout
		 */
		public function setDragMinSize(value:Number, layout:uint = 0):void
		{
			switch (layout) {
				case 0:
					getData().dragMinSizeH = value;
					getData().dragMinSizeV = value;
					break;
				case 1:
					getData().dragMinSizeH = value;
					break;
				case 2:
					getData().dragMinSizeV = value;
					break;
			}
		}
		
		/**
		 * 设置 滑动溢出比例
		 * 当 layout = 0 时，设置（横向比例、竖向比例）
		 * 当 layout = 1 时，设置（横向比例）
		 * 当 layout = 2 时，设置（竖向比例）
		 * @param value
		 * @param layout
		 */
		public function setOverflow(value:Number, layout:uint = 0):void
		{
			switch (layout) {
				case 0:
					getData().overflowH = value;
					getData().overflowV = value;
					break;
				case 1:
					getData().overflowH = value;
					break;
				case 2:
					getData().overflowV = value;
					break;
			}
		}
		
		/**
		 * 设置 手机模式
		 * @param value
		 */
		public function setMobile(value:Boolean):void
		{
			getData().mobile = value;
		}
		
		/**
		 * 设置 显示模式
		 * @param value
		 */
		public function setMode(value:int):void
		{
			getData().mode = value;
		}
		
		/**
		 * 设置 当 alpha 为 0 时，是否自动移除显示
		 * @param value
		 */
		public function setAutoAlpha(value:Boolean):void
		{
			getData().autoAlpha = value;
		}
		
		/**
		 * 设置 是否锁定
		 * @param value
		 */
		public function setLock(value:Boolean):void
		{
			getData().lock = value;
		}
		
		/**
		 * 设置 滚动条显示
		 * 当 layout = 0 时，设置（横向、竖向）显示
		 * 当 layout = 1 时，设置（横向）显示
		 * 当 layout = 2 时，设置（竖向）显示
		 * @param visible
		 * @param layout
		 */
		public function setScrollVisible(visible:Boolean, layout:uint = 0):void
		{
			switch (layout) {
				case 0:
					if (null !== getData().scrollH) getData().scrollH.visible = visible;
					if (null !== getData().scrollV) getData().scrollV.visible = visible;
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
		 * 设置 滚动条滚轮是否可用
		 * 当 layout = 0 时，设置（横向、竖向）
		 * 当 layout = 1 时，设置（横向）
		 * 当 layout = 2 时，设置（竖向）
		 * @param visible
		 * @param layout
		 */
		public function setScrollWheel(value:Boolean, layout:uint = 0):void
		{
			switch (layout) {
				case 0:
					getData().isScrollWheelH = value;
					getData().isScrollWheelV = value;
					break;
				case 1:
					getData().isScrollWheelV = value;
					break;
				case 2:
					getData().isScrollWheelH = value;
					break;
			}
		}
		
		/**
		 * 设置 是否可用
		 * @param value
		 */
		public function setEnabled(value:Boolean):void
		{
			getData().enabled = value;
			if (null !== getData().scrollH) getData().scrollH.visible = value;
			if (null !== getData().scrollV) getData().scrollV.visible = value;
		}
		
		/**
		 * 设置 up down 滚动速度
		 * @param value
		 */
		public function setSpeed(value:Number):void
		{
			getData().speed = value;
		}
		
		/**
		 * 设置 滚轮滚动速度
		 * @param value
		 */
		public function setDelta(value:Number):void
		{
			getData().delta = value;
		}
		
		/**
		 * 设置 滚动持续时间
		 * @param value
		 */
		public function setScrollDuration(value:Number):void
		{
			getData().scrollDuration = value;
		}
		
		/**
		 * 设置 up down 按下后延迟响应时间
		 * @param value
		 */
		public function setUpDownDelay(value:Number):void
		{
			getData().upDownDelay = value;
		}
		
		/**
		 * 设置 up down 按下后的滚动持续时间
		 * @param value
		 */
		public function setUpDownDuration(value:Number):void
		{
			getData().upDownDuration = value;
		}
		
		/**
		 * 设置 显示持续时间
		 * @param value
		 */
		public function setScrollShowDuration(value:Number):void
		{
			getData().scrollShowDuration = value;
		}
		
		/**
		 * 设置 隐藏持续时间
		 * @param value
		 */
		public function setScrollHideDuration(value:Number):void
		{
			getData().scrollHideDuration = value;
		}
		
		/**
		 * 设置 最大滑动持续时间
		 * @param value
		 */
		public function setMoveDurationMax(value:Number):void
		{
			getData().moveDurationMax = value;
		}
		
		/**
		 * 设置 滑动持续时间因子
		 * @param value
		 */
		public function setMoveDurationFactor(value:Number):void
		{
			getData().moveDurationFactor = value;
		}
		
		/**
		 * 设置 滑动因子
		 * @param value
		 */
		public function setMoveFactor(value:Number):void
		{
			getData().moveFactor = value;
		}
		
		/**
		 * 设置 滑动距离
		 * @param value
		 */
		public function setMoveDistance(value:Number):void
		{
			getData().moveDistance = value;
		}
		
		/**
		 * 设置 显示宽度，高度
		 * @param width
		 * @param height
		 */
		public function setSize(width:Number = 0, height:Number = 0):void
		{
			getData().width = width;
			getData().height = height;
			updateView();
		}
		
		/**
		 * 计算滚动条位置
		 * @param x
		 * @param y
		 * @param layout
		 * @param duration
		 * @param updateViewType
		 * @param type
		 */
		public function layoutScroll(x:Number = 0, y:Number = 0, layout:uint = 0, duration:Number = -1, updateViewType:int = 0, type:int = 1):void
		{
			duration = duration !== -1 ? duration : getData().scrollDuration + getData().moveDuration;
			var b:Boolean = updateViewType === 1 ? true : false;
			var _x:Number = getData().width - getData().obj.width;
			var _y:Number = getData().height - getData().obj.height;
			if (getData().lock === true) {
				x = getData().obj.x;
				y = getData().obj.y;
			}
			x = x > 0 ? 0 : x;
			y = y > 0 ? 0 : y;
			x = x < _x ? _x : x;
			y = y < _y ? _y : y;
			x = getData().isScrollH === true ? x : 0;
			y = getData().isScrollV === true ? y : 0;
			var f:Function = function ():void
			{
				x = getData().obj.x;
				y = getData().obj.y;
				switch (layout) {
					case 0:
						if (getData().isScrollH === true) if (updateViewType !== 0) getData().scrollH.updateView(b);
						if (getData().isScrollV === true) if (updateViewType !== 0) getData().scrollV.updateView(b);
						break;
					case 1:
						if (getData().isScrollV === true) if (updateViewType !== 0) getData().scrollV.updateView(b);
						break;
					case 2:
						if (getData().isScrollH === true) if (updateViewType !== 0) getData().scrollH.updateView(b);
						break;
				}
				getData().obj.x = x;
				getData().obj.y = y;
			};
			switch (layout) {
				case 0:
					if (getData().isScrollH === true) getData().scrollH.layoutScroll(x, type, duration);
					if (getData().isScrollV === true) getData().scrollV.layoutScroll(y, type, duration);
					break;
				case 1:
					if (getData().isScrollV === true) getData().scrollV.layoutScroll(y, type, duration);
					break;
				case 2:
					if (getData().isScrollH === true) getData().scrollH.layoutScroll(x, type, duration);
					break;
			}
			getDefinitionByName(AisySkin.TWEEN_LITE).to(getData().obj, duration, {x: x, y: y, onUpdate: f, onComplete: f});
			f = null;
		}
		
		public function getScrollH():ScrollBar
		{
			return getData().scrollH;
		}
		
		public function getScrollV():ScrollBar
		{
			return getData().scrollV;
		}
		
		/**
		 * 返回 手机模式
		 * @return 
		 */
		public function getMobile():Boolean
		{
			return getData().mobile;
		}
		
		/**
		 * 返回 显示模式
		 * @return 
		 */
		public function getMode():int
		{
			return getData().mode;
		}
		
		/**
		 * 返回 当 alpha 为 0 时，是否自动移除显示
		 * @return 
		 */
		public function getAutoAlpha():Boolean
		{
			return getData().autoAlpha;
		}
		
		/**
		 * 返回 是否锁定
		 * @return
		 */
		public function getLock():Boolean
		{
			return getData().lock;
		}
		
		/**
		 * 返回 是否可用
		 * @return 
		 */
		public function getEnabled():Boolean
		{
			return getData().enabled;
		}
		
		/**
		 * 返回 up down 滚动速度
		 * @return 
		 */
		public function getSpeed():Number
		{
			return getData().speed;
		}
		
		/**
		 * 返回 滚轮滚动速度
		 * @return 
		 */
		public function getDelta():Number
		{
			return getData().delta;
		}
		
		/**
		 * 返回 滚动持续时间
		 * @return 
		 */
		public function getScrollDuration():Number
		{
			return getData().scrollDuration;
		}
		
		/**
		 * 返回 up down 按下后延迟响应时间
		 * @return 
		 */
		public function getUpDownDelay():Number
		{
			return getData().upDownDelay;
		}
		
		/**
		 * 返回 up down 按下后的滚动持续时间
		 * @return 
		 */
		public function getUpDownDuration():Number
		{
			return getData().upDownDuration;
		}
		
		/**
		 * 返回 显示持续时间
		 * @return 
		 */
		public function getScrollShowDuration():Number
		{
			return getData().scrollShowDuration;
		}
		
		/**
		 * 返回 隐藏持续时间
		 * @return 
		 */
		public function getScrollHideDuration():Number
		{
			return getData().scrollHideDuration;
		}
		
		/**
		 * 返回 最大滑动持续时间
		 * @return 
		 */
		public function getMoveDurationMax():Number
		{
			return getData().moveDurationMax;
		}
		
		/**
		 * 返回 滑动持续时间因子
		 * @return 
		 */
		public function getMoveDurationFactor():Number
		{
			return getData().moveDurationFactor;
		}
		
		/**
		 * 返回 滑动因子
		 * @return 
		 */
		public function getMoveFactor():Number
		{
			return getData().moveFactor;
		}
		
		/**
		 * 返回 滑动距离
		 * @return 
		 */
		public function getMoveDistance():Number
		{
			return getData().moveDistance;
		}
		
		/**
		 * 更新显示
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
		 * 清空
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