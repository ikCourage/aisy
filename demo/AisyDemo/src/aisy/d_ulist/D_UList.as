package aisy.d_ulist
{
	import org.ais.event.TEvent;
	import org.aisy.display.USprite;
	import org.aisy.ulist.UList;

	public class D_UList extends USprite
	{
		public function D_UList()
		{
			with (graphics) {
				beginFill(0xffffff, 0.5);
				drawRoundRect(0, 0, 420, 200, 20);
				endFill();
			}
			
			var arr:Array = [];
			for (var i:int = 1; i < 10; i++) {
				arr.push({"label": "选项_" + i});
			}
			
			var list:UList = new UList();
			list.setLabel(D_UListLabel, {"label": "下拉列表"});
			list.setListItem(D_UListItem);
			list.setListData(arr);
//			list.setScrollSize(100, 100);
			list.initializeView();
			
			list.getScroll().setSize(list.getListoy().width, list.getListoy().height);
			
			list.x = (width - list.width) * 0.5;
			
			addChild(list);
			
			TEvent.trigger("UP_WINDOW_AIS", "SHOW", [this, Math.random(), 2, false]);
		}
	}
}