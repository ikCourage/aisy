package org.aisy.drag
{

	/**
	 * 
	 * 一个 UDrag 的单例
	 * 
	 * @author Viqu
	 * 
	 */
	public class DragManager extends UDrag
	{
		static protected var instance:DragManager;
		
		public function DragManager()
		{
		}
		
		override public function clear():void
		{
			super.clear();
			instance = null;
		}
		
		static public function getInstance():DragManager
		{
			return null === instance ? instance = new DragManager() : instance;
		}
		
	}
}