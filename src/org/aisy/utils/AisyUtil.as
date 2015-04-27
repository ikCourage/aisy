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
	public class AisyUtil
	{
		/**
		 * 是否为桌面环境
		 */
		static public var isDestop:Boolean;
		try {
			getDefinitionByName("flash.filesystem.File");
			isDestop = true;
		} catch (error:Error) {}
		
		public function AisyUtil()
		{
		}
		
		/**
		 * 返回对象副本
		 * @param obj
		 * @return 
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