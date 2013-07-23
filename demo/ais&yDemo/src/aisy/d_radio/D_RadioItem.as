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
			with (this.graphics) {
				beginFill(0xff000000, 0);
				drawRect(0, 0, 120, 30);
				endFill();
			}
			
			var _radio:Radio = new Radio();
			_radio.NAME = NAME + "RADIO";
			_radio.index = index;
			_radio.setSkinName(AisySkin.RADIO_SKIN);
			this.addChild(_radio);
			
			var tv:TextView = new TextView();
			tv.setText(itemInfo);
			tv.x = _radio.width + 7;
			this.addChild(tv);
		}
		
	}
}