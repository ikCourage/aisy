package org.aisy.textview
{
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.aisy.display.USprite;
	import org.aisy.interfaces.IClear;
	import org.aisy.skin.AisySkin;

	/**
	 * 
	 * 可响应的文本
	 * 
	 * @author viqu
	 * 
	 */
	public class TextView extends USprite
	{
		/**
		 * TextField
		 */
		protected var _textField:TextField;
		/**
		 * TextFormat
		 */
		protected var _textFormat:TextFormat;
		/**
		 * 可点区域
		 */
		protected var _hitArea:USprite;
		
		public function TextView()
		{
		}
		
		/**
		 * 计算布局
		 */
		protected function __layout():void
		{
			getHitArea().graphics.clear();
			getHitArea().graphics.beginFill(0xFF0000, 0);
			getHitArea().graphics.drawRoundRect(0, 0, width, height, 0);
			getHitArea().graphics.endFill();
			scrollRect = null;
			
			if (null === getHitArea().parent) addChildAt(getHitArea(), numChildren);
		}
		
		/**
		 * 返回 TextField
		 * @return 
		 */
		public function getTextField():TextField
		{
			if (null === _textField) {
				_textField = new TextField();
				_textField.defaultTextFormat = getTextFormat();
				_textField.mouseEnabled = _textField.mouseWheelEnabled = _textField.tabEnabled = false;
				addChildAt(_textField, 0);
			}
			return _textField;
		}
		
		/**
		 * 返回 TextFormat
		 * @return 
		 */
		protected function getTextFormat():TextFormat
		{
			if (null === _textFormat) _textFormat = AisySkin.TEXT_FORMAT();
			return _textFormat;
		}
		
		/**
		 * 返回 可点区域
		 * @return 
		 */
		protected function getHitArea():USprite
		{
			if (null === _hitArea) _hitArea = new USprite();
			return _hitArea;
		}
		
		/**
		 * 设置默认 TextFormat
		 * @param beginIndex
		 * @param endIndex
		 */
		protected function __setDefaultFormat(format:TextFormat = null, beginIndex:int = -1, endIndex:int = -1):void
		{
			if (null === format) format = getTextFormat();
			if (beginIndex === -1 && endIndex === -1) {
				if (_textFormat !== format) _textFormat = format;
				getTextField().defaultTextFormat = format;
			}
			else getTextField().setTextFormat(format, beginIndex, endIndex);
			__layout();
			format = null;
		}
		
		/**
		 * 设置文本
		 * @param value
		 * @param width
		 */
		public function setText(value:String, width:Number = 0, height:Number = 0):void
		{
			if (getTextField().wordWrap !== false) getTextField().wordWrap = false;
			if (getTextField().autoSize !== TextFieldAutoSize.LEFT) getTextField().autoSize = TextFieldAutoSize.LEFT;
			getTextField().htmlText = value;
			if (width > 0 && this.width > width) {
				getTextField().wordWrap = true;
				getTextField().width = width;
			}
			if (height > 0 && this.height > height) {
				getTextField().autoSize = TextFieldAutoSize.NONE;
				getTextField().height = height;
			}
			__layout();
			value = null;
		}
		
		/**
		 * 设置字体
		 * @param value
		 */
		public function setFont(value:String):void
		{
			getTextFormat().font = value;
			__setDefaultFormat();
			value = null;
		}
		
		/**
		 * 设置颜色
		 * @param value
		 */
		public function setColor(value:uint):void
		{
			getTextFormat().color = value;
			__setDefaultFormat();
		}
		
		/**
		 * 设置字体大小
		 * @param value
		 */
		public function setFontSize(value:Number):void
		{
			getTextFormat().size = value;
			__setDefaultFormat();
		}
		
		/**
		 * 设置粗体
		 * @param value
		 */
		public function setBold(value:Boolean):void
		{
			getTextFormat().bold = value;
			__setDefaultFormat();
		}
		
		/**
		 * 设置斜体
		 * @param value
		 */
		public function setItalic(value:Boolean):void
		{
			getTextFormat().italic = value;
			__setDefaultFormat();
		}
		
		/**
		 * 设置下划线
		 * @param value
		 */
		public function setUnderLine(value:Boolean):void
		{
			getTextFormat().underline = value;
			__setDefaultFormat();
		}
		
		/**
		 * 设置 TextFormat
		 * @param format
		 * @param beginIndex
		 * @param endIndex
		 */
		public function setFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1):void
		{
			__setDefaultFormat(format, beginIndex, endIndex);
			format = null;
		}
		
		/**
		 * 根据 style 设置 TextFormat
		 * @param style
		 * @param value
		 */
		public function setFormatStyle(style:String, value:*):void
		{
			getTextFormat()[style] = value;
			__setDefaultFormat();
			style = null;
			value = null;
		}
		
		/**
		 * 设置可显示大小
		 * @param width
		 * @param useFormat
		 * @param ellipsis
		 * @return 
		 */
		public function setShowSize(width:Number = 0, height:Number = 0, useFormat:Boolean = false, ellipsis:String = "..."):Boolean
		{
			if (width <= 0) return false;
			if (_textField.wordWrap !== false) _textField.wordWrap = false;
			if (_textField.autoSize !== TextFieldAutoSize.LEFT) _textField.autoSize = TextFieldAutoSize.LEFT;
			if (_textField.width <= width) {
				_textField.width = Math.min(_textField.width, width);
				if (height > 0 && height < _textField.height) {
					_textField.height = height;
					scrollRect = new Rectangle(0, 0, _textField.width, height)
				}
				if (_textField.textWidth > width || (height > 0 && _textField.textHeight > height)) return true;
				return false;
			}
			var _text:String = _textField.text;
			var b:Boolean, i:uint = _text.length >> 1, j:Number;
			
			if (height > 0) {
				j = _textField.height;
				if (_textField.wordWrap !== true) _textField.wordWrap = true;
				_textField.width = width;
				if (j * 2 <= height && _textField.height > height) {
					while (true) {
						_textField.text = _text.slice(0, i) + ellipsis;
						if (useFormat === true) __setDefaultFormat();
						j = _textField.height;
						if (j === height) return true;
						else if (j < height) {
							i < 2 ? (i = 2) : (i += i >> 1);
							b = true;
						}
						else if (i < 2 || b === true) break;
						else if (b === false) i -= i >> 1;
					}
					
					while (i > 0) {
						i--;
						_textField.text = _text.slice(0, i) + ellipsis;
						if (useFormat === true) __setDefaultFormat();
						if (_textField.height <= height) break;
					}
					
					if (useFormat === false) __layout();
					
					if (this.height > height) scrollRect = new Rectangle(0, 0, width, height);
				}
			}
			if (b === false) {
				if (_textField.wordWrap !== false) _textField.wordWrap = false;
				while (true) {
					_textField.text = _text.slice(0, i) + ellipsis;
					if (useFormat === true) __setDefaultFormat();
					j = _textField.width;
					if (j === width) return true;
					else if (j < width) {
						i < 2 ? (i = 2) : (i += i >> 1);
						b = true;
					}
					else if (i < 2 || b === true) break;
					else if (b === false) i -= i >> 1;
				}
				
				while (i > 0) {
					i--;
					_textField.text = _text.slice(0, i) + ellipsis;
					if (useFormat === true) __setDefaultFormat();
					if (_textField.width <= width) break;
				}
				
				if (useFormat === false) __layout();
				
				if (this.width > width) scrollRect = new Rectangle(0, 0, width, height);
			}
			
			_text = null;
			ellipsis = null;
			
			return true;
		}
		
		/**
		 * 设置 是否可用
		 * @param value
		 */
		public function setEnabled(value:Boolean):void
		{
			mouseEnabled = mouseChildren = value;
		}
		
		/**
		 * 设置动态数据
		 * @param value
		 */
		override public function set dynamic(value:*):void
		{
			if (null !== _hitArea) _hitArea.dynamic = value;
			__dynamic = value;
			value = null;
		}
		
		/**
		 * 清空显示
		 */
		public function clearView():void
		{
			var i:uint = numChildren, obj:*;
			while (i) {
				i--;
				obj = getChildAt(i);
				if (obj is IClear) obj.clear();
				else removeChildAt(i);
			}
			obj = null;
			scrollRect = null;
			_textFormat = null;
			_textField = null;
			_hitArea = null;
		}
		
		/**
		 * 清空
		 */
		override public function clear():void
		{
			clearView();
			super.clear();
		}
		
	}
}