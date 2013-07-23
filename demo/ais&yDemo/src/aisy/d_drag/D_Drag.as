package aisy.d_drag
{
	import flash.utils.getTimer;
	
	import org.ais.event.TEvent;
	import org.aisy.display.USprite;
	import org.aisy.drag.DragManager;
	import org.aisy.listoy.Listoy;

	public class D_Drag extends USprite
	{
		public function D_Drag()
		{
			init();
		}
		
		private function init():void
		{
			with (this.graphics) {
				beginFill(0xffffff, 0.5);
				drawRoundRect(0, 0, 700, 500, 20);
				endFill();
			}
			
			var arr:Array = [];
			arr.length = 9;
			var listoy:Listoy = new Listoy();
			listoy.setRowColumn(3, 3);
			listoy.setItemRenderer(D_DragItem);
			listoy.setDataProvider(arr);
			listoy.initializeView();
			listoy.x = 60;
			listoy.y = 100;
			addChild(listoy);
			
			TEvent.newTrigger(listoy.NAME + "ITEM", function (type:String, data:* = null):void
			{
				TEvent.trigger(listoy.NAME + "ITEM", type, data);
			});
			
			arr.length = 18;
			
			listoy = new Listoy();
			listoy.setRowColumn(3, arr.length / 3);
			listoy.setItemRenderer(D_DragItem2);
			listoy.setDataProvider(arr);
			listoy.initializeView();
			listoy.x = 300;
			listoy.y = 100;
			addChild(listoy);
			
			DragManager.getInstance().setDelay(100);
			
			TEvent.trigger("UP_WINDOW_AIS", "SHOW", [this, getTimer(), 2, false, false]);
		}
		
	}
}