package org.aisy.autoclear
{
	import org.ais.system.Memory;
	import org.aisy.interfaces.IClear;

	/**
	 * 
	 * 自动管理 IClear
	 * 
	 * @author Viqu
	 * 
	 */
	public class AisyAutoClear implements IClear
	{
		/**
		 * AutoClear 集合
		 */
		static protected var autoClears:Vector.<AisyAutoClear>;
		/**
		 * 当前 AutoClear
		 */
		static protected var currentAutoClear:AisyAutoClear;
		/**
		 * IClear 集合
		 */
		protected var v:Vector.<IClear>;
		/**
		 * 是否正在清除
		 */
		protected var c:Boolean;
		
		public function AisyAutoClear()
		{
			if (null === autoClears) autoClears = new Vector.<AisyAutoClear>();
			autoClears[autoClears.length] = currentAutoClear = this;
		}
		
		/**
		 * 
		 * 添加一个 IClear
		 * 
		 * @param iclear
		 * 
		 */
		public function put(iclear:IClear):void
		{
			if (null === iclear) return;
			else if (null === v) v = new Vector.<IClear>();
			if (v.lastIndexOf(iclear) === -1) v[v.length] = iclear;
			iclear = null;
		}
		
		/**
		 * 
		 * 移除一个 IClear
		 * 
		 * @param iclear
		 * @return 
		 * 
		 */
		public function remove(iclear:IClear):Boolean
		{
			if (c === false && null !== v && null !== iclear) {
				var i:int = v.lastIndexOf(iclear);
				iclear = null;
				if (i !== -1) {
					v.splice(i, 1);
					Memory.clear();
					return true;
				}
			}
			iclear = null;
			return false;
		}
		
		/**
		 * 
		 * 是否包含一个 ICler
		 * 
		 * @param iclear
		 * @return 
		 * 
		 */
		public function has(iclear:IClear):Boolean
		{
			if (null !== v && null !== iclear) return v.lastIndexOf(iclear) !== -1;
			iclear = null;
			return false;
		}
		
		/**
		 * 
		 * 清除所有的 IClear
		 * 
		 */
		public function clear():void
		{
			if (null !== v) {
				c = true;
				for (var i:uint = 0, l:uint = v.length; i < l; i++) v[i].clear();
				v = null;
				c = false;
			}
			if (null !== currentAutoClear) {
				var j:int = autoClears.lastIndexOf(this);
				if (j !== -1) {
					if (j === 0) {
						autoClears = null;
						currentAutoClear = null;
					}
					else {
						autoClears.splice(j, 1);
						currentAutoClear = autoClears[autoClears.length - 1];
					}
				}
				AisyAutoClear.remove(this);
			}
			Memory.clear();
		}
		
		/**
		 * 
		 * 创建一个新的 AutoClear
		 * 
		 * @return 
		 * 
		 */
		static public function newAutoClear():AisyAutoClear
		{
			return new AisyAutoClear();
		}
		
		/**
		 * 
		 * 将 autoClear 设置为当前的 AutoClear
		 * 
		 * @param autoClear
		 * 
		 */
		static public function setCurrentAutoClear(autoClear:AisyAutoClear):void
		{
			if (null === autoClear) return;
			currentAutoClear = autoClear;
			var i:int = autoClears.lastIndexOf(currentAutoClear);
			if (i !== -1) autoClears.splice(i, 1);
			autoClears[autoClears.length] = currentAutoClear;
			autoClear = null;
		}
		
		/**
		 * 
		 * 返回当前的 AutoClear
		 * 
		 * @return 
		 * 
		 */
		static public function getCurrentAutoClear():AisyAutoClear
		{
			return currentAutoClear;
		}
		
		/**
		 * 
		 * 添加一个 IClear 到当前的 AutoClear 中
		 * 
		 * @param iclear
		 * 
		 */
		static public function put(iclear:IClear):void
		{
			if (null === iclear) return;
			else if (null === currentAutoClear) newAutoClear();
			currentAutoClear.put(iclear);
			iclear = null;
		}
		
		/**
		 * 
		 * 在全部 AutoClear 中移除一个 IClear
		 * 
		 * @param iclear
		 * @return 
		 * 
		 */
		static public function remove(iclear:IClear):Boolean
		{
			if (null !== iclear && null !== currentAutoClear) {
				var i:uint = autoClears.length;
				while (i > 0) {
					i--;
					if (autoClears[i].remove(iclear) === true) {
						iclear = null;
						return true;
					}
				}
			}
			iclear = null;
			return false;
		}
		
		/**
		 * 
		 * 在全部 AutoClear 中是否包含一个 IClear
		 * 
		 * @param iclear
		 * @return 
		 * 
		 */
		static public function has(iclear:IClear):Boolean
		{
			if (null !== iclear && null !== currentAutoClear) {
				var i:uint = autoClears.length;
				while (i > 0) {
					i--;
					if (autoClears[i].has(iclear) === true) {
						iclear = null;
						return true;
					}
				}
			}
			iclear = null;
			return false;
		}
		
		/**
		 * 
		 * 清除所有的 AutoClear
		 * 
		 */
		static public function clear():void
		{
			if (null === currentAutoClear) return;
			currentAutoClear = null;
			for (var i:uint = 0, l:uint = autoClears.length; i < l; i++) autoClears[i].clear();
			autoClears = null;
		}
		
	}
}