package org.aisy.utils
{
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

	/**
	 * 
	 * Aisy 工具类
	 * 
	 * @author Viqu
	 * 
	 */
	public class AisyUtils
	{
		/**
		 * 是否为桌面环境
		 */
		static protected var _isDestop:Boolean;
		if (true) {
			try {
				getDefinitionByName("flash.filesystem.File");
				_isDestop = true;
			} catch (error:Error) {}
		}
		
		public function AisyUtils()
		{
		}
		
		/**
		 * 
		 * 是否为桌面环境
		 * @return 
		 * 
		 */
		static public function get isDestop():Boolean
		{
			return _isDestop;
		}
		
		/**
		 * 
		 * 返回对象副本
		 * @param obj
		 * @return 
		 * 
		 */
		static public function cloneObjectByByteArray(obj:*):*
		{
			var b:ByteArray = new ByteArray();
			b.writeObject(obj);
			b.position = 0;
			obj = null;
			return b.readObject();
		}
		
	}
}