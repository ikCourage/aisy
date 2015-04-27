package org.aisy.textsystem
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	import org.aisy.autoclear.AisyAutoClear;
	import org.aisy.display.USprite;

	public class TextSystemUI extends TextSystem
	{
		protected var _clear:Boolean;
		
		public function TextSystemUI()
		{
			super();
			AisyAutoClear.put(this);
			setAutoRender(false);
			if (numChildren !== 0) {
				setTextField(getChildAt(0) as TextField);
				if (numChildren > 1) {
					var us:USprite = new USprite();
					us.addChild(getChildAt(1));
					setPlaceHolder(us);
					us = null;
				}
			}
			if (parent is MovieClip && (parent as MovieClip).totalFrames > 1) addEventListener(Event.REMOVED_FROM_STAGE, __uiEventHandler);
		}
		
		protected function __uiEventHandler(e:Event):void
		{
			_clear = true;
			clear();
			e = null;
		}
		
		override public function get parent():DisplayObjectContainer
		{
			return _clear === true ? null : super.parent;
		}
		
	}
}