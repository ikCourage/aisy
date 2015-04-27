package aisy.d_scroller
{
	import org.ais.event.TEvent;
	import org.aisy.listoy.ListoyEvent;
	import org.aisy.listoy.ListoyItem;
	import org.aisy.textview.TextView;

	internal class D_Item extends ListoyItem
	{
		public function D_Item(name:String, index:uint, data:*)
		{
			super(name, index, data);
			graphics.beginFill(0xff0000, 0.3);
			graphics.drawRoundRect(0, 0, 500, 70, 7);
			graphics.endFill();
			
			var tv:TextView = new TextView();
			tv.setText("ITEM_" + index);
			addChild(tv);
			TEvent.newTrigger(NAME + "ITEM", __triggerHandler);
		}
		
		protected function __triggerHandler(type:String, data:* = null):void
		{
			switch (type) {
				case ListoyEvent.ITEM_INSHOW:
					data(index);
					break;
				case ListoyEvent.ITEM_RESET:
					var i:uint = data[0](index, this);
					if (i !== index) {
						index = i;
						if (index < data[2]) {
							itemInfo = data[1][index];
							(getChildAt(0) as TextView).setText("ITEM_" + index);
						}
					}
					break;
			}
		}
	}
}