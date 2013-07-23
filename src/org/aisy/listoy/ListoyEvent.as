package org.aisy.listoy
{

	/**
	 * 
	 * Listoy 事件
	 * 静态字符串为 Type
	 * 含 @param data 的是接收参数
	 * 
	 * @author viqu
	 * 
	 */
	public class ListoyEvent
	{
		/**
		 * 上一页
		 */
		static public const PREVIOUS:String = "PREVIOUS";
		/**
		 * 下一页
		 */
		static public const NEXT:String = "NEXT";
		/**
		 * 上一页结束
		 */
		static public const PREVIOUS_END:String = "PREVIOUS_END";
		/**
		 * 下一页结束
		 */
		static public const NEXT_END:String = "NEXT_END";
		/**
		 * 
		 * 总页数
		 * @param data: uint
		 * 
		 */
		static public const TOTAL_PAGE:String = "TOTAL_PAGE";
		/**
		 * 
		 * 当前页数
		 * @param data: uint
		 * 
		 */
		static public const PAGE:String = "PAGE";
		/**
		 * 
		 * 由 ItemRenderer 抛出
		 * 获取对指定 Item 的操作
		 * @param data: *
		 * 
		 */
		static public const ITEM_EVENT:String = "ITEM_EVENT";
		/**
		 * 
		 * ItemRenderer 的可接收参数
		 * 显示区域的宽高
		 * @param data: Array[width:number, height:number]
		 * 
		 */
		static public const ITEM_GET_MASK:String = "ITEM_GET_MASK";
		/**
		 * 
		 * ItemRenderer 的可接收参数
		 * 判断是否在显示区域
		 * 
		 */
		static public const ITEM_INSHOW:String = "ITEM_INSHOW";
		/**
		 * 
		 * ItemRenderer 的可接收参数
		 * 移除 ItemRenderer
		 * 
		 */
		static public const ITEM_REMOVE:String = "ITEM_REMOVE";
		/**
		 * ItemRenderder 的可接收参数
		 * 重置 ItemRenderer
		 * 
		 */
		static public const ITEM_RESET:String = "ITEM_RESIET";
	}
}