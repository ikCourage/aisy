package org.aisy.textview
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import org.aisy.autoclear.AisyAutoClear;

	public class TextViewUI extends TextView
	{
		protected var _clear:Boolean;
		protected var _isEllipsis:Boolean;
		protected var _layout:uint;
		protected var _showWidth:Number;
		protected var _showHeight:Number;
		
		public function TextViewUI()
		{
			_showWidth = 0;
			AisyAutoClear.put(this);
			tabChildren = false;
			if (numChildren !== 0) {
				_textField = getChildAt(0) as TextField;
				_textField.mouseEnabled = _textField.mouseWheelEnabled = false;
				_textFormat = _textField.defaultTextFormat;
				_showWidth = _textField.width * scaleX;
				_showHeight = _textField.height * scaleY;
				_textField.scaleY *= scaleY;
				scaleX = scaleY = 1;
				_textField.autoSize = TextFieldAutoSize.LEFT;
				if (setShowSize(_showWidth, _showHeight) === false) __layout();
			}
			if (parent is MovieClip && (parent as MovieClip).totalFrames > 1) addEventListener(Event.REMOVED_FROM_STAGE, __uiEventHandler);
		}
		
		protected function __uiEventHandler(e:Event):void
		{
			_clear = true;
			clear();
			e = null;
		}
		
		override public function setShowSize(width:Number = 0, height:Number = 0, useFormat:Boolean = false, ellipsis:String = "..."):Boolean
		{
			return _isEllipsis = super.setShowSize(width, height, useFormat, ellipsis);
		}
		
		public function setLayout(value:uint = 0):void
		{
			_layout = value;
			if (null !== _textField) {
				switch (_layout) {
					case 0:
					case 1:
						__layout();
						_hitArea.x = _textField.x = 0;
						break;
					case 2:
						_layout = 3;
						__layout();
						_hitArea.x = _textField.x = width - _textField.width;
						_layout = 2;
						break;
					case 3:
						__layout();
						_hitArea.x = 0;
						_textField.x = width - _textField.width;
						break;
					case 4:
						_layout = 5;
						__layout();
						_hitArea.x = _textField.x = (width - _textField.width) * 0.5;
						_layout = 4;
						scrollRect = new Rectangle(0, scrollRect.y, _hitArea.x + width, height);
						break;
					case 5:
						__layout();
						_hitArea.x = 0;
						_textField.x = (width - _textField.width) * 0.5;
						break;
				}
			}
		}
		
		public function set text(value:String):void
		{
			setText(value, _showWidth, _showHeight);
			if (setShowSize(_showWidth, _showHeight) === false) __layout();
		}
		
		public function set enabled(value:Boolean):void
		{
			setEnabled(value);
		}
		
		override public function set width(value:Number):void
		{
			_showWidth = value;
			if (setShowSize(_showWidth, _showHeight) === false) __layout();
		}
		
		override public function set height(value:Number):void
		{
			_showHeight = value;
			if (setShowSize(_showWidth, _showHeight) === false) __layout();
		}
		
		override public function get width():Number
		{
			switch (_layout) {
				case 0:
				case 2:
				case 4:
					return null === _textField ? 0 : _textField.width;
					break;
			}
			return super.width > _showWidth ? super.width : _showWidth;
		}
		
		override public function get height():Number
		{
			switch (_layout) {
				case 0:
				case 2:
				case 4:
					return null === _textField ? 0 : _textField.height;
					break;
			}
			return super.height > _showHeight ? super.height : _showHeight;
		}
		
		public function get showWidth():Number
		{
			return _showWidth;
		}
		
		public function get showHeight():Number
		{
			return _showHeight;
		}
		
		override public function get parent():DisplayObjectContainer
		{
			return _clear === true ? null : super.parent;
		}
		
	}
}