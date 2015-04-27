package core
{
	import org.aisy.autoclear.AisyAutoClear;
	import org.aisy.checkbox.CheckBox;
	import org.aisy.listoy.ListoyItem;
	import org.aisy.textview.TextView;

	/**
	 * 
	 * Hey，通过继承 ListyItem 来简化对 NAME，index，itemInfo 的声明和清空
	 * 
	 * @author Viqu
	 * 
	 */
	public class CheckBoxItem extends ListoyItem
	{
		protected var _autoClear:AisyAutoClear;
		
		public function CheckBoxItem(name:String, index:uint, data:*)
		{
			super(name, index, data);
			init();
			name = null;
			data = null;
		}
		
		protected function init():void
		{
			_autoClear = AisyAutoClear.newAutoClear();
			var checkBox:CheckBox = new DEMO_CHECKBOX();
			checkBox.NAME = NAME + "CHECKBOX";
			checkBox.index = index;
			addChild(checkBox);
			
			var tv:TextView = new TextView();
			tv.setText("CheckBox " + index);
			tv.x = checkBox.width + 5;
			addChild(tv);
			
			checkBox.y = (height - checkBox.height) * 0.5;
			tv.y = (height - tv.height) * 0.5;
			
			checkBox = null;
			tv = null;
		}
		
		override public function clear():void
		{
			if (null !== _autoClear) {
				_autoClear.clear();
				_autoClear = null;
			}
			super.clear();
		}
		
	}
}