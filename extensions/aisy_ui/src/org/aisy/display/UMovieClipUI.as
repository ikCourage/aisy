package org.aisy.display
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import org.aisy.autoclear.AisyAutoClear;

	public dynamic class UMovieClipUI extends UMovieClip
	{
		protected var _clear:Boolean;
		
		public function UMovieClipUI()
		{
			AisyAutoClear.put(this);
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