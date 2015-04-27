package org.aisy.ulist
{
	import org.aisy.interfaces.IClear;

	/**
	 * 
	 * UList 的属性绑定
	 * 
	 * @author viqu
	 * 
	 */
	internal class UListData implements IClear
	{
		/**
		 * 标题渲染类
		 */
		public var labelClass:Class;
		/**
		 * Listoy Item 渲染类
		 */
		public var listItem:Class;
		/**
		 * Listoy 数据 <Array or Vector>
		 */
		public var listData:*;
		/**
		 * 标题数据
		 */
		public var labelData:*;
		
//		public var selectedArr:Array;
		
		/**
		 * Scroller 宽度
		 */
		public var scrollWidth:Number = 100;
		/**
		 * Scroller 高度
		 */
		public var scrollHeight:Number = 100;
		
		public function UListData()
		{
		}
		
		/**
		 * 清空
		 */
		public function clear():void
		{
			labelClass = null;
			listItem = null;
			listData = null;
//			selectedArr = null;
			labelData = null;
		}
		
	}
}