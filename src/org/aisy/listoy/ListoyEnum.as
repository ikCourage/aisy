package org.aisy.listoy
{

	/**
	 * 
	 * Listoy 常量
	 * 
	 * @author Viqu
	 * 
	 */
	public class ListoyEnum
	{
		/**
		 * 横向排版
		 */
		static public const LAYOUT_HORIZONTAL:uint = 0;
		/**
		 * 竖向排版
		 */
		static public const LAYOUT_VERTICAL:uint = 1;
		/**
		 * 渲染全部
		 */
		static public const MODE_ALL:uint = 0;
		/**
		 * 渲染一页（可能会多渲染一页，但只显示一页。当 item 多时可以使用这个，但翻页快时可能不平滑）
		 */
		static public const MODE_PAGE:uint = 1;
		/**
		 * 适用于滚动条（只渲染可见 item，即：row * column）
		 */
		static public const MODE_SHOW:uint = 2;
	}
}