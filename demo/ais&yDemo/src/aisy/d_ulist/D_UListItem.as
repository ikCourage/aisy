package aisy.d_ulist
{
	import flash.events.MouseEvent;
	
	import org.ais.event.TEvent;
	import org.aisy.button.Button;
	import org.aisy.listoy.ListoyItem;
	import org.aisy.ulist.UListEvent;
	
	internal class D_UListItem extends ListoyItem
	{
		private var _btn:Button;
		
		public function D_UListItem(name:String, index:uint, data:*)
		{
			super(name, index, data);
			init();
		}
		
		private function init():void
		{
			_btn = new Button();
			_btn.setClassName("ULIST_SKIN_ITEM");
			_btn.setText(itemInfo.name);
			if (itemInfo.width) {
				_btn.getSkin().width = itemInfo.width;
				_btn.getTextView().x = (itemInfo.width - _btn.getTextView().width) * 0.5;
			}
			addChild(_btn);
			_btn.setClick(__btnHandler);
		}
		
		private function __btnHandler(e:MouseEvent):void
		{
			switch (e.type) {
				case MouseEvent.CLICK:
					TEvent.trigger(NAME, UListEvent.RADIO_SELECT, itemInfo);
					break;
			}
		}
		
		override public function clear():void
		{
			_btn = null;
			super.clear();
		}
		
	}
}