package org.aisy.radio
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import org.aisy.autoclear.AisyAutoClear;
	import org.aisy.interfaces.IClear;

	public class RadioUI extends Radio
	{
		protected var _clear:Boolean;
		protected var _background:Boolean;
		protected var _padding:Number = 0;
		
		public function RadioUI()
		{
			AisyAutoClear.put(this);
			tabChildren = false;
			if (numChildren !== 0) {
				var s:String = getQualifiedClassName(getChildAt(numChildren - 1));
				var obj:*;
				while (numChildren) {
					obj = getChildAt(0);
					if (obj is IClear) obj.clear();
					else removeChildAt(0);
				}
				setSkinName(s.substr(0, s.length - 1));
				s = null;
				obj = null;
			}
			if (parent is MovieClip && (parent as MovieClip).totalFrames > 1) addEventListener(Event.REMOVED_FROM_STAGE, __uiEventHandler);
		}
		
		protected function __uiEventHandler(e:Event):void
		{
			_clear = true;
			clear();
			e = null;
		}
		
		override protected function __layout(width:Number = 0, height:Number = 0):void
		{
			graphics.clear();
			var w:Number = Math.max(width, this.width);
			var h:Number = Math.max(height, this.height);
			var sx:Number = w / this.width;
			var sy:Number = h / this.height;
			getData().skin.width *= sx;
			getData().skin.height *= sy;
			getData().skin.y = (h - getData().skin.height) * 0.5;
			getTextView().width *= sx;
			getTextView().height *= sy;
			getData().textView.x = getData().skin.x + getData().skin.width + _padding;
			getData().textView.y = (h - getData().textView.height) * 0.5;
			if (_background === true) {
				graphics.beginFill(0x000000, 0);
				graphics.drawRect(0, 0, this.width, this.height);
				graphics.endFill();
			}
		}
		
		override public function setSkin(value:Object):void
		{
			var x:Number = 0, y:Number = 0, w:Number = 0, h:Number = 0;
			if (null !== getData().skin) {
				x = getData().skin.x;
				y = getData().skin.y;
				w = getData().skin.width;
				h = getData().skin.height;
			}
			if (null !== hitArea) hitArea = null;
			if (value.hasOwnProperty("hitA") === true) {
				value.mouseEnabled = value.mouseChildren = false;
				hitArea = value["hitA"];
			}
			super.setSkin(value);
			if (w !== 0) {
				value.x = x;
				value.y = y;
				value.width = w;
				value.height = h;
			}
			value = null;
		}
		
		public function set background(value:Boolean):void
		{
			_background = value;
		}
		
		public function set padding(value:Number):void
		{
			_padding = value;
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