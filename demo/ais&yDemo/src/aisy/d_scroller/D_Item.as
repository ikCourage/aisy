package aisy.d_scroller
{
	import org.aisy.listoy.ListoyItem;
	import org.aisy.textview.TextView;

	internal class D_Item extends ListoyItem
	{
		public function D_Item(name:String, index:uint, data:*)
		{
			super(name, index, data);
			this.graphics.beginFill(0xff0000, 0.3);
			this.graphics.drawRoundRect(0, 0, 500, 70, 7);
			this.graphics.endFill();
			
			var t:TextView = new TextView();
			t.setText("ITEM_" + index);
			this.addChild(t);
		}
	}
}