package aisy.d_checkbox
{
	import org.ais.event.TEvent;
	import org.aisy.checkbox.CheckBox;
	import org.aisy.listoy.ListoyItem;
	import org.aisy.skin.AisySkin;
	import org.aisy.textview.TextView;

	internal class D_CheckBoxItem extends ListoyItem
	{
		private var _checkBox:CheckBox;
		
		public function D_CheckBoxItem(name:String, index:uint, data:*)
		{
			super(name, index, data);
			init();
		}
		
		private function init():void
		{
			with (this.graphics) {
				beginFill(0xff0000, 0);
				drawRect(0, 0, 120, 30);
				endFill();
			}
			
			_checkBox = new CheckBox();
			_checkBox.NAME = NAME + "CHECKBOX";
			_checkBox.index = index;
			_checkBox.setSkinName(AisySkin.CHECKBOX_SKIN);
			this.addChild(_checkBox);
			
			var tv:TextView = new TextView();
			tv.setText(itemInfo);
			tv.x = _checkBox.width + 7;
			this.addChild(tv);
			
			TEvent.newTrigger(NAME + "ITEM", __triggerHandler);
		}
		
		private function __triggerHandler(type:String, data:* = null):void
		{
			switch (type) {
				case "CHECK":
					if (_checkBox.getSelected() === true) TEvent.trigger(NAME, type, index);
					break;
			}
		}
		
		override public function clear():void
		{
			_checkBox = null;
			super.clear();
		}
		
	}
}