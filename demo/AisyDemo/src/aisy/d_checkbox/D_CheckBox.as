package aisy.d_checkbox
{
	import flash.events.MouseEvent;
	
	import org.ais.event.TEvent;
	import org.aisy.button.Button;
	import org.aisy.display.USprite;
	import org.aisy.listoy.Listoy;
	import org.aisy.listoy.ListoyEvent;

	public class D_CheckBox extends USprite
	{
		private var _listoy:Listoy;
		private var _checkArr:Array;
		
		public function D_CheckBox()
		{
			init();
		}
		
		private function init():void
		{
			with (graphics) {
				beginFill(0xffffff, 0.5);
				drawRoundRect(0, 0, 420, 200, 20);
				endFill();
			}
			
			TEvent.trigger("UP_WINDOW_AIS", "SHOW", [this, Math.random(), 2, false]);
			
			var arr:Array = [];
			
			for (var i:int = 0; i < 30; i++) arr[arr.length] = "多选框 " + (i + 1);
			
			_listoy = new Listoy();
			_listoy.setRowColumn(3, 3);
			_listoy.x = _listoy.y = 20;
			
			_listoy.setItemRenderer(D_CheckBoxItem);
			_listoy.setDataProvider(arr);
			_listoy.initializeView();
			
			addChild(_listoy);
			
			TEvent.newTrigger(_listoy.NAME, __triggerHandler);
			
			var btn:Button = newButton("上一页", "prev");
			btn.x = 50;
			btn.y = 150;
			
			btn = newButton("下一页", "next");
			btn.x = 150;
			btn.y = 150;
			
			btn = newButton("确定", "ok");
			btn.x = 250;
			btn.y = 150;
		}
		
		private function newButton(text:String, name:String):Button
		{
			var btn:Button = new Button();
			btn.setSkinClassName("_AISY_BUTTON");
			btn.setText(text);
			btn.name = name;
			addChild(btn);
			
			btn.setClick(__btnHandler);
			return btn;
		}
		
		private function __btnHandler(e:MouseEvent):void
		{
			switch (e.currentTarget.name) {
				case "prev":
					TEvent.trigger(_listoy.NAME, ListoyEvent.PREVIOUS);
					break;
				case "next":
					TEvent.trigger(_listoy.NAME, ListoyEvent.NEXT);
					break;
				case "ok":
					_checkArr = [];
					TEvent.trigger(_listoy.NAME + "ITEM", "CHECK");
					trace(_checkArr);
					break;
			}
			e = null;
		}
		
		private function __triggerHandler(type:String, data:* = null):void
		{
			switch (type) {
				case "CHECK":
					_checkArr[_checkArr.length] = data;
					break;
			}
		}
		
		override public function clear():void
		{
			_listoy = null;
			_checkArr = null;
			super.clear();
		}
		
	}
}