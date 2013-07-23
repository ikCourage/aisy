package org.aisy.scroller
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
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
		 * 布局方向
		 */
		public var layout:uint;
		/**
		 * 滚动对象
		 */
		public var obj:Sprite;
		/**
		 * 显示对象的遮罩
		 */
		public var mask:Shape;
		/**
		 * 横向内缩进
		 */
		public var paddingH:Number = 1;
		/**
		 * 竖向内缩进
		 */
		public var paddingV:Number = 1;
		/**
		 * 按钮滚动速度
		 */
		public var speed:Number = 9;
		/**
		 * 滚轮滚动速度
		 */
		public var delta:Number = 0;
		/**
		 * 滚动延迟
		 */
		public var delay:Number = 0.3;
		/**
		 * 显示宽度
		 */
		public var width:Number = 300;
		/**
		 * 显示高度
		 */
		public var height:Number = 200;
		/**
		 * 滑动起始坐标
		 */
		public var startX:Number;
		/**
		 * 滑动起始坐标
		 */
		public var startY:Number;
		/**
		 * 横向滑动偏移
		 */
		public var moveX:Number;
		/**
		 * 竖向滑动偏移
		 */
		public var moveY:Number;
		/**
		 * 滑动延迟时间
		 */
		public var moveDelay:Number = 0;
		/**
		 * 滑动因子
		 */
		public var moveFactor:Number = 2.7;
		/**
		 * 是否可用
		 */
		public var enabled:Boolean = true;
		/**
		 * 滑块是否可拉伸
		 */
		public var elastic:Boolean;
		/**
		 * 设置是否绝对定位
		 */
		public var position:Boolean = AisySkin.MOBILE ? AisySkin.MOBILE : AisySkin.SCROLLER_POSITION;
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
		
		public function ScrollerData()
		{
		}
		
		/**
		 * 
		 * 清空
		 * 
		 */
		public function clear():void
		{
			if (null !== scrollH) scrollH.clear();
			if (null !== scrollV) scrollV.clear();
			if (null !== obj) if (obj is IClear) (obj as IClear).clear();
			if (null !== group) group.clear();
			if (null !== moveMask) moveMask.clear();
			group = null;
			moveMask = null;
			skinClass = null;
			scrollH = null;
			scrollV = null;
			obj = null;
			mask = null;
		}
		
	}
}