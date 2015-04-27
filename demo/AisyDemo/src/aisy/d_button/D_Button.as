package aisy.d_button
{
	import org.ais.event.TEvent;
	import org.aisy.button.Button;
	import org.aisy.display.USprite;

	public class D_Button extends USprite
	{
		public function D_Button()
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
			
			var btn:Button = new Button();
			btn.setSkinClassName("_AISY_BUTTON");
			btn.setText("按钮，文本可以不写");
			btn.setClick(__btnHandler);
			btn.x = (width - btn.width) * 0.5;
			btn.y = (height - btn.height) * 0.5;
			addChild(btn);
			
			TEvent.trigger("UP_WINDOW_AIS", "SHOW", [this, Math.random(), 2, false]);
		}
		
		private function __btnHandler():void
		{
			trace("CLICK");
		}
		
	}
}