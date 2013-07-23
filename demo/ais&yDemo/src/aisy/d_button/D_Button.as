package aisy.d_button
{
	import flash.utils.getTimer;
	
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
			with (this.graphics) {
				beginFill(0xffffff, 0.5);
				drawRoundRect(0, 0, 420, 200, 20);
				endFill();
			}
			
			TEvent.trigger("UP_WINDOW_AIS", "SHOW", [this, getTimer(), 2, false]);
			
			var btn:Button = new Button();
			btn.setClassName("_AISY_BUTTON");
			
			btn.setText("按钮，文本可以不写");
			
			this.addChild(btn);
			
			btn.setClick(__btnHandler);
		}
		
		private function __btnHandler():void
		{
			trace("CLICK");
		}
		
	}
}