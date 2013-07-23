package aisy.d_ulist
{
	import flash.utils.getTimer;
	
	import org.ais.event.TEvent;
	import org.aisy.display.USprite;
	import org.aisy.ulist.UList;

	public class D_UList extends USprite
	{
		public function D_UList()
		{
			var list:UList = new UList();
			list.x = 100;
			
			var arr:Array = [];
			for (var i:int = 1; i < 10; i++) {
				arr.push({"name": "选项_" + i});
			}
			
			list.setLabel(D_UListLable, {"name": "下拉列表"});
			list.setListItem(D_UListItem);
			list.setListData(arr);
//			list.setScrollSize(100, 100);
			list.initializeView();
			
			list.getScroll().setSize(list.getListoy().width, list.getListoy().height);
			
			this.addChild(list);
			
			with (this.graphics) {
				beginFill(0xffffff, 0.5);
				drawRoundRect(0, 0, 300, 200, 20);
				endFill();
			}
			
			TEvent.trigger("UP_WINDOW_AIS", "SHOW", [this, getTimer(), 2, false]);
		}
	}
}