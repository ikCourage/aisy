package core
{
	import org.aisy.autoclear.AisyAutoClear;
	import org.aisy.listoy.ListoyItem;
	import org.aisy.radio.Radio;
	import org.aisy.textview.TextView;

	/**
	 * 
	 * 通过继承 ListyItem 来简化对 NAME，index，itemInfo 的声明和清空
	 * 
	 * @author Viqu
	 * 
	 */
	public class RadioItem extends ListoyItem
	{
		protected var _autoClear:AisyAutoClear;
		
		public function RadioItem(name:String, index:uint, data:*)
		{
			super(name, index, data);
			init();
			name = null;
			data = null;
		}
		
		protected function init():void
		{
			_autoClear = AisyAutoClear.newAutoClear();
			var radio:Radio = new DEMO_RADIO();
			radio.NAME = NAME + "RADIO";
			radio.index = index;
			addChild(radio);
			
			var tv:TextView = new TextView();
			tv.setText("Radio " + index);
			tv.x = radio.width + 5;
			addChild(tv);
			
			radio.y = (height - radio.height) * 0.5;
			tv.y = (height - tv.height) * 0.5;
			
			radio = null;
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