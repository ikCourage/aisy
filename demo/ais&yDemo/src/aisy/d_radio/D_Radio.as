package aisy.d_radio
{
	import flash.utils.getTimer;
	
	import org.ais.event.TEvent;
	import org.aisy.display.USprite;
	import org.aisy.listoy.Listoy;

	public class D_Radio extends USprite
	{
		public function D_Radio()
		{
			init();
		}
		
		private function init():void
		{
			with (this.graphics) {
				beginFill(0xffffff, 0.5);
				drawRoundRect(0, 0, 420, 200, 20);
				endFill();
			}
			
			TEvent.trigger("UP_WINDOW_AIS", "SHOW", [this, getTimer(), 2, false]);
			
			var arr:Array = [];
			
			for (var i:int = 0; i < 12; i++) arr[arr.length] = "单选框 " + (i + 1);
			
			var _listoy:Listoy = new Listoy();
			_listoy.setRowColumn(3, 3);
			_listoy.x = _listoy.y = 20;
			
			_listoy.setItemRenderer(D_RadioItem);
			_listoy.setDataProvider(arr);
			_listoy.initializeView();
			
			this.addChild(_listoy);
		}
		
	}
}