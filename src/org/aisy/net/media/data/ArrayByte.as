package org.aisy.net.media.data
{
	import org.aisy.autoclear.AisyAutoClear;
	import org.aisy.interfaces.IClear;
	import org.aisy.net.data.UByteArray;

	/**
	 * 
	 * UByteArray 的泛型数组
	 * 
	 * @author Viqu
	 * 
	 */
	public dynamic class ArrayByte extends Array implements IClear
	{
		public function ArrayByte()
		{
			
		}
		
		public function get(index:int):UByteArray
		{
			return this[index];
		}
		
		public function set(index:int, ubyte:UByteArray = null, type:int = 0):void
		{
			if (null === ubyte) ubyte = new UByteArray(type);
			if (this[index]) this[index].clear();
			this[index] = ubyte;
			ubyte = null;
		}
		
		public function clear():void
		{
			AisyAutoClear.remove(this);
			for each (var i:* in this) if (i) i.clear();
		}
	}
}