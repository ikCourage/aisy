package aisy.d_drag
{
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	
	import org.ais.event.TEvent;
	import org.aisy.display.USprite;
	import org.aisy.drag.DragItem;
	import org.aisy.drag.IDrag;
	import org.aisy.drag.UDragEvent;
	import org.aisy.listoy.ListoyItem;

	internal class D_DragItem2 extends ListoyItem implements IDrag
	{
		private var _dragItem:DragItem;
		
		public function D_DragItem2(name:String, index:uint, data:*)
		{
			super(name, index, data);
			init();
		}
		
		private function init():void
		{
			graphics.beginFill(0x000000, 0.3);
			graphics.drawRoundRect(0, 0, 100, 100, 20);
			graphics.endFill();
			
			var m:Shape = new Shape();
			m.graphics.beginFill(0xff0000, 0.3);
			m.graphics.drawRoundRect(0, 0, 50, 50, 20);
			m.graphics.endFill();
			mask = m;
			addChild(m);
			
			__addEvent();
		}
		
		private function __addEvent():void
		{
			TEvent.newTrigger(NAME + "ITEM", __triggerHandler);
		}
		
		public function setDragItem(dragItem:DragItem):void
		{
			_dragItem = dragItem;
		}
		
		private function __triggerHandler(type:String, data:* = null):void
		{
			switch (type) {
				case UDragEvent.DRAG_MOVE:
					var ct:ColorTransform = new ColorTransform();
					ct.color = 0x000000;
					var ts:USprite = data;
					if (ts.dropTarget && contains(ts.dropTarget)) {
						ct.color = 0xff0000;
					}
					transform.colorTransform = ct;
					break;
				case UDragEvent.DRAG_STOP:
					ts = data;
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
					ct = new ColorTransform();
					ct.color = 0x000000;
					transform.colorTransform = ct;
					break;
			}
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