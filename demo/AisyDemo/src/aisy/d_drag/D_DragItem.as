package aisy.d_drag
{
	import flash.display.Shape;
	
	import org.ais.event.TEvent;
	import org.aisy.display.USprite;
	import org.aisy.drag.DragItem;
	import org.aisy.drag.IDrag;
	import org.aisy.drag.UDragEvent;
	import org.aisy.listoy.ListoyItem;
	import org.aisy.textview.TextView;

	internal class D_DragItem extends ListoyItem implements IDrag
	{
		private var _dragItem:DragItem;
		
		public function D_DragItem(name:String, index:uint, data:*)
		{
			super(name, index, data);
			init();
		}
		
		private function init():void
		{
			var us:USprite = new USprite();
			us.graphics.beginFill(0x000000, 0.3);
			us.graphics.drawRoundRect(0, 0, 100, 100, 20);
			us.graphics.endFill();
			
			var m:Shape = new Shape();
			m.graphics.beginFill(0xff0000, 0.3);
			m.graphics.drawRoundRect(0, 0, 50, 50, 20);
			m.graphics.endFill();
			us.mask = m;
			us.addChild(m);
			
			var t:TextView = new TextView();
			t.setText(String(index));
			us.addChild(t);
			
			var dragItem:DragItem = new DragItem(NAME + "ITEM", index, itemInfo);
			dragItem.addChild(us);
			setDragItem(dragItem);
			
			__addEvent();
		}
		
		private function __addEvent():void
		{
			TEvent.newTrigger(NAME + "ITEM", __triggerHandler);
		}
		
		private function __triggerHandler(type:String, data:* = null):void
		{
			switch (type) {
				case UDragEvent.DRAG_STOP:
					var ts:USprite = data;
					if (!ts.dynamic.drag && ts.dropTarget && contains(ts.dropTarget)) {
						ts.dynamic.drag = true;
						var us:DragItem = ts.dynamic.target;
						if (null !== _dragItem && _dragItem.parent === this) {
							if (us.parent is IDrag) {
								us.parent.addChild(_dragItem);
								IDrag(us.parent).setDragItem(_dragItem);
							}
						}
						else {
							if (us.parent is IDrag) {
								IDrag(us.parent).setDragItem(null);
							}
						}
						us.x = us.y = 0;
						addChild(us);
						setDragItem(us);
					}
					break;
			}
		}
		
		public function setDragItem(dragItem:DragItem):void
		{
			if (dragItem) {
				addChild(dragItem);
			}
			else {
				if (_dragItem && _dragItem.parent) _dragItem.parent.removeChild(_dragItem);
			}
			_dragItem = dragItem;
		}
		
		override public function get width():Number
		{
			return 50;
		}
		
		override public function get height():Number
		{
			return 50;
		}
		
		override public function clear():void
		{
			super.clear();
			_dragItem = null;
		}
		
	}
}