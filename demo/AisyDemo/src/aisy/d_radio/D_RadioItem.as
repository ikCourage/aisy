package aisy.d_radio
{
	import org.aisy.listoy.ListoyItem;
	import org.aisy.radio.Radio;
	import org.aisy.skin.AisySkin;
	import org.aisy.textview.TextView;

	internal class D_RadioItem extends ListoyItem
	{
		public function D_RadioItem(name:String, index:uint, data:*)
		{
			super(name, index, data);
			init();
		}
		
		private function init():void
		{
			with (graphics) {
				beginFill(0xff000000, 0);
				drawRect(0, 0, 120, 30);
				endFill();
			}
			
			var radio:Radio = new Radio();
			radio.NAME = NAME + "RADIO";
			radio.index = index;
			radio.setSkinName(AisySkin.RADIO_SKIN);
			addChild(radio);
			
			var tv:TextView = new TextView();
			tv.setText(itemInfo);
			tv.x = radio.width + 7;
			addChild(tv);
		}
		
	}
}