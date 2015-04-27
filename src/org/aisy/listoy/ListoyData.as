package org.aisy.listoy
{
	import flash.display.Shape;
	
	import org.aisy.display.USprite;
	import org.aisy.interfaces.IClear;

	/**
	 * 
	 * Listoy 的属性绑定
	 * 
	 * @author viqu
	 * 
	 */
	internal class ListoyData implements IClear
	{
		/**
		 * item 的容器
		 */
		public var group:USprite;
		/**
		 * group 的遮罩
		 */
		public var mask:Shape;
		/**
		 * 行数
		 */
		public var row:uint = 2;
		/**
		 * 列数
		 */
		public var column:uint = 3;
		/**
		 * 竖向总行数
		 */
		public var rowTotal:uint;
		/**
		 * 横向总列数
		 */
		public var columnTotal:uint;
		/**
		 * 当前所显示行数索引
		 */
		public var curRow:uint;
		/**
		 * 当前所显示列数索引
		 */
		public var curColumn:uint;
		/**
		 * 横向外缩进
		 */
		public var marginH:Number = 0;
		/**
		 * 竖向外缩进
		 */
		public var marginV:Number = 0;
		/**
		 * 横向内缩进
		 */
		public var paddingH:Number = 7;
		/**
		 * 竖向内缩进
		 */
		public var paddingV:Number = 7;
		/**
		 * 横向移动偏移量
		 */
		public var movePositionH:Number = 3;
		/**
		 * 竖向移动偏移量
		 */
		public var movePositionV:Number = 2;
		/**
		 * 每行的宽度
		 */
		public var moveWidth:Number;
		/**
		 * 每列的高度
		 */
		public var moveHeight:Number;
		/**
		 * 显示区域的宽度
		 */
		public var maskWidth:Number;
		/**
		 * 显示区域的高度
		 */
		public var maskHeight:Number;
		/**
		 * itemRenderer 自定义渲染器（Class or Function）
		 */
		public var itemRenderer:Object;
		/**
		 * dataProvider 将要显示的元素数组 (Array or Vector)
		 */
		public var dataProvider:Object;
		/**
		 * 设置（横 / 竖）排版
		 */
		public var layout:uint = ListoyEnum.LAYOUT_HORIZONTAL;
		/**
		 * 设置渲染方式
		 */
		public var mode:uint = ListoyEnum.MODE_ALL;
		/**
		 * 总页数
		 */
		public var totalPage:uint;
		/**
		 * 当前页数
		 */
		public var curPage:uint;
		/**
		 * 设置翻页持续时间
		 */
		public var duration:Number = 0.8;
		/**
		 * 是否有背景
		 */
		public var background:Boolean;
		
		public function ListoyData()
		{
		}
		
		/**
		 * 清空
		 */
		public function clear():void
		{
			totalPage = curPage = rowTotal = columnTotal = curRow = curColumn = moveWidth = moveHeight = maskWidth = maskHeight = 0;
			if (null !== group) {
				group.clear();
				group = null;
			}
			if (null !== mask) {
				if (null !== mask.parent) mask.parent.removeChild(mask);
				mask = null;
			}
			itemRenderer = null;
			dataProvider = null;
		}
		
	}
}