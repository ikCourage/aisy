package aisy.d_upwindow
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	import org.ais.event.TEvent;
	import org.aisy.display.USprite;
	import org.aisy.skin.AisySkin;
	import org.aisy.textview.TextView;

	public final class D_UpWindow extends USprite
	{
		private var NAME:String;
		private var bgMc:MovieClip;
		
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
			NAME = "" + getTimer();
			
			bgMc = new (getDefinitionByName(AisySkin.CONFIRM_SKIN) as Class)();
			addChild(bgMc);
			
			var _tv:TextView = new TextView();
			_tv.setText("其实这里的\n所有示例都是弹框...");
			_tv.x = (width - _tv.width) * 0.5;
			_tv.y = 60;
			addChild(_tv);
			
			__addEvent();
			
			if (TEvent.trigger("UP_WINDOW_AIS", "SHOW", [this, NAME, 2, false, true, 0, 0, 1, false]) === false) {
				clear();
			}
		}
		
		/**
		 * 
		 * 注册事件
		 * 
		 */
		private function __addEvent():void
		{
			bgMc.mc_btn.addEventListener(MouseEvent.CLICK, __mouseHandler);
			
			TEvent.newTrigger("UP_WINDOW_NEW", __upWindowHandler);
		}
		
		/**
		 * 
		 * 移除事件
		 * 
		 */
		private function __removeEvent():void
		{
			bgMc.mc_btn.removeEventListener(MouseEvent.CLICK, __mouseHandler);
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
			switch (e.target.name) {
				case "btn_ok":
					break;
			}
			TEvent.trigger("UP_WINDOW_NEW", "CLEAR", {"name": NAME});
		}
		
		/**
		 * 
		 * UpWindow 的侦听
		 * 
		 * @param type
		 * 
		 */
		private function __upWindowHandler(type:String, data:* = null):void
		{
			switch (type) {
				case "CLEAR":
					if (data.name !== NAME) return;
					clear();
					break;
				case "CLEAR_ALL":
					clear();
					break;
			}
			type = null;
			data = null;
		}
		
		/**
		 * 
		 * 清空
		 * 
		 */
		override public function clear():void
		{
			TEvent.removeTrigger("UP_WINDOW_NEW", __upWindowHandler);
			bgMc = null;
			NAME = null;
			super.clear();
		}
		
	}
}