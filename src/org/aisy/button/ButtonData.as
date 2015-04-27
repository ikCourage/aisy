package  org.aisy.button
{
	import org.aisy.interfaces.IClear;
	import org.aisy.textview.TextView;

	/**
	 * 
	 * 按钮 数据
	 * 
	 * @author viqu
	 * 
	 */
	internal class ButtonData implements IClear
	{
		/**
		 * 按钮 皮肤
		 */
		public var skin:Object;
		/**
		 * 按钮 显示文字 TextView
		 */
		public var textView:TextView;
		/**
		 * ROLL_OVER 回调函数
		 */
		public var rollOverF:Function;
		/**
		 * ROLL_OUT 回调函数
		 */
		public var rollOutF:Function;
		/**
		 * MOUSE_DOWN 回调函数
		 */
		public var mouseDownF:Function;
		/**
		 * CLICK 回调函数
		 */
		public var clickF:Function;
		/**
		 * 宽度
		 */
		public var width:Number;
		/**
		 * 高度
		 */
		public var height:Number;
		/**
		 * 是否选中
		 */
		public var selected:Boolean;
		/**
		 * 鼠标状态
		 * 0: 默认
		 * 1: 外部按下，当前移上
		 * 2: 按下
		 * 3: 按下移出
		 */
		public var mouse:uint;
		
		public function ButtonData()
		{
		}
		
		/**
		 * 清空
		 */
		public function clear():void
		{
			skin = null;
			textView = null;
			rollOverF = null;
			rollOutF = null;
			mouseDownF = null;
			clickF = null;
		}
		
	}
}