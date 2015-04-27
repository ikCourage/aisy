package aisy.d_upwindow
{
	import flash.events.MouseEvent;
	
	import org.ais.event.TEvent;
	import org.aisy.button.Button;
	import org.aisy.display.USprite;
	import org.aisy.skin.AisySkin;

	public final class D_UpWindow extends USprite
	{
		private var NAME:String;
		
		public function D_UpWindow()
		{
			init();
		}
		
		/**
		 * 
		 * 初始化
		 * 
		 */
		private function init():void
		{
			NAME = Math.random().toString();
			
			with (graphics) {
				beginFill(0xffffff, 0.5);
				drawRoundRect(0, 0, 420, 200, 20);
				endFill();
			}
			
			var btn:Button = new Button();
			btn.setSkinClassName(AisySkin.BUTTON_SKIN);
			btn.setText("其实这里的所有示例都是弹框");
			btn.setClick(__mouseHandler);
			btn.x = (width - btn.width) * 0.5;
			btn.y = (height - btn.height) * 0.5;
			addChild(btn);
			
			TEvent.trigger("UP_WINDOW_AIS", "SHOW", [this, NAME, 2, false, true, true, 0x000000, 0.7, 1, false]);
		}
		
		/**
		 * 
		 * 鼠标侦听
		 * 
		 * @param e
		 * 
		 */
		private function __mouseHandler(e:MouseEvent):void
		{
			TEvent.trigger("UP_WINDOW_NEW", "CLEAR", {"name": NAME});
		}
		
		/**
		 * 
		 * 清空
		 * 
		 */
		override public function clear():void
		{
			super.clear();
			NAME = null;
		}
		
	}
}