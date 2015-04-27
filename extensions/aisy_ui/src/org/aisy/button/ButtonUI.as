package org.aisy.button
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import org.ais.system.Ais;
	import org.aisy.autoclear.AisyAutoClear;

	public class ButtonUI extends Button
	{
		protected var _clear:Boolean;
		
		public function ButtonUI()
		{
			AisyAutoClear.put(this);
			tabChildren = false;
			buttonMode = true;
			if (numChildren !== 0) {
				if (!Ais.IMain) Ais.IMain = this;
				setSkin(getChildAt(numChildren - 1));
			}
			if (parent is MovieClip && (parent as MovieClip).totalFrames > 1) addEventListener(Event.REMOVED_FROM_STAGE, __uiEventHandler);
		}
		
		protected function __uiEventHandler(e:Event):void
		{
			_clear = true;
			clear();
			e = null;
		}
		
		public function set text(value:String):void
		{
			setText(value);
			value = null;
		}
		
		public function set enabled(value:Boolean):void
		{
			setEnabled(value);
		}
		
		public function set selected(value:Boolean):void
		{
			setSelected(value);
		}
		
		override public function setSkin(value:Object):void
		{
			if (null !== hitArea) hitArea = null;
			if (value.hasOwnProperty("hitA") === true) {
				value.mouseEnabled = value.mouseChildren = false;
				hitArea = value["hitA"];
			}
			super.setSkin(value);
			value = null;
		}
		
		override public function set width(value:Number):void
		{
			setSize(value);
		}
		
		override public function set height(value:Number):void
		{
			setSize(0, value);
		}
		
		override public function get parent():DisplayObjectContainer
		{
			return _clear === true ? null : super.parent;
		}
		
	}
}