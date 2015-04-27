package aisy.d_image
{
	import org.ais.event.TEvent;
	import org.aisy.display.USprite;
	import org.aisy.image.Image;

	public class D_Image extends USprite
	{
		public function D_Image()
		{
			init();
		}
		
		private function init():void
		{
			Image.isCrossDomain = true;
			var img:Image = new Image("http://img4.kuwo.cn/star/cafe/upload/87/53/1292926918787.jpg");
			img.setSize(658, 411);
			
			addChild(img);
			
			with (graphics) {
				beginFill(0xffffff, 0.5);
				drawRoundRect(0, 0, 658, 411, 20);
				endFill();
			}
			
			TEvent.trigger("UP_WINDOW_AIS", "SHOW", [this, Math.random(), 2, false]);
		}
	}
}