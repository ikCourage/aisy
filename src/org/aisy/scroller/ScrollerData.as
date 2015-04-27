package org.aisy.scroller
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.aisy.display.USprite;
	import org.aisy.interfaces.IClear;
	import org.aisy.skin.AisySkin;

	/**
	 * 
	 * Scroller 的属性绑定
	 * 
	 * @author Viqu
	 * 
	 */
	internal class ScrollerData implements IClear
	{
		/**
		 * 滚动对象容器
		 */
		public var group:USprite;
		/**
		 * 适用于移动时的滑动遮罩
		 */
		public var moveMask:USprite;
		/**
		 * 滚动条自身
		 */
		public var scroller:Scroller;
		/**
		 * 横向滚动条
		 */
		public var scrollH:ScrollBar;
		/**
		 * 竖向滚动条
		 */
		public var scrollV:ScrollBar;
		/**
		 * 皮肤 DisplayObjectContainer 类
		 */
		public var skinClass:Class;
		/**
		 * 滚动对象
		 */
		public var obj:Sprite;
		/**
		 * 显示对象的遮罩
		 */
		public var mask:Shape;
		/**
		 * 可以拖动的区域
		 */
		public var moveRect:Rectangle;
		/**
		 * 布局方向
		 */
		public var layout:uint;
		/**
		 * 横向内缩进
		 */
		public var paddingH:Number = 0;
		/**
		 * 竖向内缩进
		 */
		public var paddingV:Number = 0;
		/**
		 * up down 滚动速度
		 */
		public var speed:Number = 50;
		/**
		 * up down 滚动速度延迟
		 */
		public var speedDelay:Number = 50;
		/**
		 * 滚轮滚动速度
		 */
		public var delta:Number = 0;
		/**
		 * 滚动持续时间
		 */
		public var scrollDuration:Number = 0.3;
		/**
		 * up down 按下后延迟响应时间
		 */
		public var upDownDelay:Number = 500;
		/**
		 * up down 按下后的整体持续时间
		 */
		public var upDownDuration:Number = -1;
		/**
		 * 显示持续时间
		 */
		public var scrollShowDuration:Number = 0.3;
		/**
		 * 隐藏持续时间
		 */
		public var scrollHideDuration:Number = 0.5;
		/**
		 * 显示宽度
		 */
		public var width:Number = 300;
		/**
		 * 显示高度
		 */
		public var height:Number = 200;
		/**
		 * 滑块最小尺寸
		 */
		public var dragMinSizeH:Number = AisySkin.SCROLLER_DRAG_MIN_SIZE_H;
		/**
		 * 滑块最小尺寸
		 */
		public var dragMinSizeV:Number = AisySkin.SCROLLER_DRAG_MIN_SIZE_V;
		/**
		 * 滑动起始坐标
		 */
		public var startX:Number;
		/**
		 * 滑动起始坐标
		 */
		public var startY:Number;
		/**
		 * 拖动起始坐标
		 */
		public var mouseX:Number;
		/**
		 * 拖动起始坐标
		 */
		public var mouseY:Number;
		/**
		 * 横向滑动偏移
		 */
		public var moveX:Number;
		/**
		 * 竖向滑动偏移
		 */
		public var moveY:Number;
		/**
		 * 滑动持续时间
		 */
		public var moveDuration:Number = 0;
		/**
		 * 最大滑动持续时间
		 */
		public var moveDurationMax:Number = 7;
		/**
		 * 滑动持续时间因子
		 */
		public var moveDurationFactor:Number = 1;
		/**
		 * 滑动因子
		 */
		public var moveFactor:Number = 2.7;
		/**
		 * 滑动距离 当滑动距离超出此距离时，才会认为在该方向上有滑动
		 */
		public var moveDistance:Number = 5;
		/**
		 * 滑动溢出比例
		 */
		public var overflowH:Number = AisySkin.SCROLLER_OVERFLOW_H;
		/**
		 * 滑动溢出比例
		 */
		public var overflowV:Number = AisySkin.SCROLLER_OVERFLOW_V;
		/**
		 * 是否可用
		 */
		public var enabled:Boolean = true;
		/**
		 * 滑块是否可拉伸
		 */
		public var elastic:Boolean;
		/**
		 * 手机模式
		 */
		public var mobile:Boolean;
		/**
		 * 显示模式
		 */
		public var mode:int = AisySkin.MOBILE ? 2 : AisySkin.SCROLLER_MODE;
		/**
		 * 横向滚动条是否可用
		 */
		public var isScrollH:Boolean;
		/**
		 * 竖向滚动条是否可用
		 */
		public var isScrollV:Boolean;
		/**
		 * 鼠标是否按下
		 */
		public var isMouseDown:Boolean;
		/**
		 * 是否区分 Shif
		 */
		public var isShiftKey:Boolean;
		/**
		 * 当 alpha 为 0 时，是否自动移除显示
		 */
		public var autoAlpha:Boolean = AisySkin.SCROLLER_AUTO_ALPHA;
		
		public function ScrollerData()
		{
		}
		
		/**
		 * 清空
		 */
		public function clear():void
		{
			if (null !== scrollH) scrollH.clear();
			if (null !== scrollV) scrollV.clear();
			if (null !== obj) if (obj is IClear) (obj as IClear).clear();
			if (null !== group) group.clear();
			if (null !== moveMask) moveMask.clear();
			moveRect = null;
			group = null;
			moveMask = null;
			skinClass = null;
			scrollH = null;
			scrollV = null;
			scroller = null;
			obj = null;
			mask = null;
		}
		
	}
}