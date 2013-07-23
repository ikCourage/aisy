package org.aisy.listoy
{
	import org.aisy.display.USprite;

	/**
	 * 
	 * Listoy Item
	 * 
	 * @author Viqu
	 * 
	 */
	public class ListoyItem extends USprite
	{
		/**
		 * 名称
		 */
		protected var NAME:String;
		/**
		 * item 数据
		 */
		protected var itemInfo:*;
		/**
		 * 索引
		 */
		protected var index:uint;
		
		public function ListoyItem(name:String, index:uint, data:*)
		{
			NAME = name;
			this.index = index;
			itemInfo = data;
			
			name = null;
			data = null;
		}
		
		/**
		 * 
		 * 清空
		 * 
		 */
		override public function clear():void
		{
			super.clear();
			itemInfo = null;
			NAME = null;
		}
		
	}
}