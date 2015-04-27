package org.aisy.textsystem
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.utils.getDefinitionByName;
	
	import org.ais.event.TEvent;
	import org.aisy.display.USprite;
	import org.aisy.skin.AisySkin;

	/**
	 * 
	 * 使用系统的文本框（如果系统不支持，使用 TextField）
	 * 
	 * @author Viqu
	 * 
	 */
	public class TextSystem extends USprite
	{
		static public const AUTOCAPITALIZE_ALL:String = "all";
		static public const AUTOCAPITALIZE_NONE:String = "none";
		static public const AUTOCAPITALIZE_SENTENCE:String = "sentence";
		static public const AUTOCAPITALIZE_WORD:String = "word";
		
		static public const RETURNKEYLABEL_DEFAULT:String = "default";
		static public const RETURNKEYLABEL_DONE:String = "done";
		static public const RETURNKEYLABEL_GO:String = "go";
		static public const RETURNKEYLABEL_NEXT:String = "next";
		static public const RETURNKEYLABEL_SEARCH:String = "search";
		
		static public const SOFTKEYBOARDTYPE_CONTACT:String = "contact";
		static public const SOFTKEYBOARDTYPE_DEFAULT:String = "default";
		static public const SOFTKEYBOARDTYPE_EMAIL:String = "email";
		static public const SOFTKEYBOARDTYPE_NUMBER:String = "number";
		static public const SOFTKEYBOARDTYPE_PUNCTUATION:String = "punctuation";
		static public const SOFTKEYBOARDTYPE_URL:String = "url";
		
		protected var _textField:*;
		/**
		 * TextFormat
		 */
		protected var _textFormat:TextFormat;
		protected var _placeHolder:USprite;
		protected var _placeHolderType:int;
		protected var _snapshot:Bitmap;
		protected var _lineMetric:TextLineMetrics;
		protected var _numberOfLines:int;
		protected var _width:int;
		protected var _height:int;
		protected var _autoRender:Boolean;
		protected var _autoHeight:Boolean;
		protected var _stage:Stage;
		
		public function TextSystem(numberOfLines:int = 1)
		{
			_numberOfLines = numberOfLines;
			_autoRender = true;
			
			TEvent.newTrigger("UP_WINDOW_AIS", __triggerHandler);
			
			addEventListener(Event.ADDED_TO_STAGE, __eventHandler);
		}
		
		/**
		 * 设置 TextField
		 * @param textField
		 */
		public function setTextField(textField:*):void
		{
			_textField = textField;
			
			textField = null;
		}
		
		/**
		 * 返回 TextField
		 * @return 
		 */
		public function getTextField():*
		{
			if (null == _textField) {
				var cls:Class;
				try {
					cls = getDefinitionByName("flash.text.StageText") as Class;
				}
				catch (error:Error) {}
				if (null !== cls) {
					_textField = new cls(new (getDefinitionByName("flash.text.StageTextInitOptions") as Class)(_numberOfLines > 1));
				}
				else {
					_textField = new TextField();
					_textField.type = TextFieldType.INPUT;
					_textField.defaultTextFormat = getTextFormat();
					_textField.multiline = (_numberOfLines > 1);
					addChild(_textField);
				}
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
		 * 设置默认 TextFormat
		 * @param beginIndex
		 * @param endIndex
		 */
		protected function __setDefaultFormat(format:TextFormat = null, beginIndex:int = -1, endIndex:int = -1):void
		{
			var t:* = getTextField();
			if (null === format) format = getTextFormat();
			if (beginIndex === -1 && endIndex === -1) {
				if (_textFormat !== format) _textFormat = format;
				t.defaultTextFormat = format;
			}
			else t.setTextFormat(format, beginIndex, endIndex);
			t.text = t.text;
			t = null;
			format = null;
		}
		
		public function setAutoRender(value:Boolean):void
		{
			_autoRender = value;
		}
		
		public function setAutoHeight(value:Boolean):void
		{
			_autoHeight = value;
		}
		
		/**
		 * 设置字体
		 * @param value
		 */
		public function setFont(value:String):void
		{
			if (getTextField() is TextField) {
				getTextFormat().font = value;
				__setDefaultFormat();
			}
			else {
				getTextField().fontFamily = value;
			}
			value = null;
		}
		
		/**
		 * 设置颜色
		 * @param value
		 */
		public function setColor(value:uint):void
		{
			if (getTextField() is TextField) {
				getTextFormat().color = value;
				__setDefaultFormat();
			}
			else {
				getTextField().color = value;
			}
		}
		
		/**
		 * 设置字体大小
		 * @param value
		 */
		public function setFontSize(value:Number):void
		{
			if (getTextField() is TextField) {
				getTextFormat().size = value;
				__setDefaultFormat();
			}
			else {
				getTextField().fontSize = value;
			}
		}
		
		/**
		 * 设置粗体
		 * @param value
		 */
		public function setBold(value:Boolean):void
		{
			if (getTextField() is TextField) {
				getTextFormat().bold = value;
				__setDefaultFormat();
			}
			else {
				getTextField().fontWeight = (value === true ? FontWeight.BOLD : FontWeight.NORMAL);
			}
		}
		
		/**
		 * 设置斜体
		 * @param value
		 */
		public function setItalic(value:Boolean):void
		{
			if (getTextField() is TextField) {
				getTextFormat().italic = value;
				__setDefaultFormat();
			}
			else {
				getTextField().fontPosture = (value === true ? FontPosture.ITALIC : FontPosture.NORMAL);
			}
		}
		
		public function setAlign(value:String):void
		{
			if (getTextField() is TextField) {
				getTextFormat().align = value;
				__setDefaultFormat();
			}
			else {
				getTextField().textAlign = value;
			}
		}
		
		/**
		 * 设置 TextFormat
		 * @param format
		 * @param beginIndex
		 * @param endIndex
		 */
		public function setFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1):void
		{
			if (getTextField() is TextField) {
				__setDefaultFormat(format, beginIndex, endIndex);
			}
			format = null;
		}
		
		/**
		 * 根据 style 设置 TextFormat
		 * @param style
		 * @param value
		 */
		public function setFormatStyle(style:String, value:*):void
		{
			if (getTextField() is TextField) {
				getTextFormat()[style] = value;
				__setDefaultFormat();
			}
			else if (getTextField().hasOwnProperty(style) === true) {
				getTextField()[style] = value;
			}
			style = null;
			value = null;
		}
		
		public function set text(value:String):void
		{
			getTextField().text = value;
		}
		
		public function get text():String
		{
			return getTextField().text;
		}
		
		public function setAutoCapitalize(value:String):void
		{
			if (!(getTextField() is TextField)) {
				getTextField().autoCapitalize = value;
			}
		}
		
		public function setAutoCorrect(value:Boolean):void
		{
			if (!(getTextField() is TextField)) {
				getTextField().autoCorrect = value;
			}
		}
		
		public function setDisplayAsPassword(value:Boolean):void
		{
			getTextField().displayAsPassword = value;
		}
		
		public function setEditable(value:Boolean):void
		{
			if (getTextField() is TextField) {
				getTextField().type = (value === true ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
				getTextField().selectable = value;
			}
			else {
				getTextField().editable = value;
			}
		}
		
		public function setLocale(value:String):void
		{
			if (!(getTextField() is TextField)) {
				getTextField().locale = value;
			}
		}
		
		public function setMaxChars(value:int):void
		{
			getTextField().maxChars = value;
		}
		
		public function setRestrict(value:String):void
		{
			getTextField().restrict = value;
		}
		
		public function setReturnKeyLabel(value:String):void
		{
			if (!(getTextField() is TextField)) {
				getTextField().returnKeyLabel = value;
			}
		}
		
		public function getSelectionBeginIndex():int
		{
			if (getTextField() is TextField) {
				return getTextField().selectionBeginIndex;
			}
			return getTextField().selectionAnchorIndex;
		}
		
		public function getSelectionEndIndex():int
		{
			if (getTextField() is TextField) {
				return getTextField().selectionEndIndex;
			}
			return getTextField().selectionActiveIndex;
		}
		
		public function setSoftKeyboardType(value:String):void
		{
			if (!(getTextField() is TextField)) {
				getTextField().softKeyboardType = value;
			}
		}
		
		public function getMultiline():Boolean
		{
			return getTextField().multiline;
		}
		
		public function assignFocus():void
		{
			if (getTextField() is TextField) {
				if (null !== stage) {
					stage.focus = getTextField();
				}
			}
			else {
				getTextField().assignFocus();
			}
		}
		
		public function setSelection(beginIndex:int, endIndex:int):void
		{
			if (getTextField() is TextField) {
				getTextField().setSelection(beginIndex, endIndex);
			}
			else {
				getTextField().selectRange(beginIndex, endIndex);
			}
		}
		
		public function getBitmapData(value:BitmapData = null):BitmapData
		{
			if (null === value) {
				var w:Number;
				var h:Number;
				if (getTextField() is TextField) {
					w = getTextField().width;
					h = getTextField().height;
				}
				else {
					w = getTextField().viewPort.width;
					h = getTextField().viewPort.height;
				}
				value = new BitmapData(w, h, true, 0x00000000);
			}
			if (getTextField() is TextField) {
				value.draw(getTextField());
			}
			else {
				getTextField().drawViewPortToBitmapData(value);
			}
			return value;
		}
		
		public function setPlaceHolder(value:USprite = null):void
		{
			getTextField().removeEventListener(Event.CHANGE, __textFieldHandler);
			getTextField().removeEventListener(FocusEvent.FOCUS_IN, __textFieldHandler);
			getTextField().removeEventListener(FocusEvent.FOCUS_OUT, __textFieldHandler);
			if (null !== _placeHolder && _placeHolder !== value) {
				_placeHolder.clear();
			}
			_placeHolder = value;
			if (null !== _placeHolder) {
				_placeHolder.mouseChildren = _placeHolder.mouseEnabled = false;
				if (_placeHolder.parent !== this && !text) {
					addChildAt(_placeHolder, 0);
				}
				else if (null !== _placeHolder.parent) {
					_placeHolder.parent.removeChild(_placeHolder);
				}
				getTextField().addEventListener(Event.CHANGE, __textFieldHandler);
				getTextField().addEventListener(FocusEvent.FOCUS_IN, __textFieldHandler);
				getTextField().addEventListener(FocusEvent.FOCUS_OUT, __textFieldHandler);
			}
		}
		
		public function getPlaceHolder():USprite
		{
			return _placeHolder;
		}
		
		public function setPlaceHolderType(value:int):void
		{
			_placeHolderType = value;
		}
		
		public function getPlaceHolderType():int
		{
			return _placeHolderType;
		}
		
		public function freeze():void
		{
			if (null !== stage) {
				stage.focus = null;
			}
			if (getTextField() is TextField) return;
			_snapshot = new Bitmap(getBitmapData());
			addChild(_snapshot);
			getTextField().stage = null;
		}
		
		public function unfreeze():void
		{
			if (getTextField() is TextField) return;
			if (null !== _snapshot) {
				removeChild(_snapshot);
				if (null !== _snapshot.bitmapData) {
					_snapshot.bitmapData.dispose();
					_snapshot.bitmapData = null;
				}
				_snapshot = null;
				getTextField().stage = stage;
			}
		}
		
		protected function render():void
		{
			if (null === stage || _autoRender === false) return;
			_lineMetric = null;
			calculateHeight();
			var r:Rectangle = getViewPortRectangle();
			if (getTextField() is TextField) {
				getTextField().width = r.width;
				getTextField().height = r.height;
			}
			else {
				getTextField().viewPort = r;
			}
		}
		
		protected function getViewPortRectangle():Rectangle
		{
			var p:Point = localToGlobal(new Point(0, 0));
			if (_autoHeight === false) return new Rectangle(p.x, p.y, width, height);
			var totalFontHeight:Number = getTotalFontHeight();
			var fontSize:Number;
			if (getTextField() is TextField) {
				fontSize = getTextField().defaultTextFormat.size;
			}
			else {
				fontSize = getTextField().fontSize;
			}
			return new Rectangle(p.x, p.y, width, int(Math.round((totalFontHeight + (totalFontHeight - fontSize)) * _numberOfLines)));
		}
		
		protected function calculateHeight():void
		{
			if (_autoHeight === true) {
				var totalFontHeight:Number = getTotalFontHeight();
				_height = int(totalFontHeight * _numberOfLines + 4);
			}
		}
		
		protected function getTotalFontHeight():Number
		{
			if (null !== _lineMetric) return (_lineMetric.ascent + _lineMetric.descent);
			var textField:TextField = new TextField();
			if (getTextField() is TextField) {
				textField.defaultTextFormat = getTextField().defaultTextFormat;
			}
			else {
				textField.defaultTextFormat = new TextFormat(getTextField().fontFamily, getTextField().fontSize, null, (getTextField().fontWeight == FontWeight.BOLD), (getTextField().fontPosture == FontPosture.ITALIC));
			}
			textField.text = "Q";
			_lineMetric = textField.getLineMetrics(0);
			textField = null;
			return (_lineMetric.ascent + _lineMetric.descent);
		}
		
		protected function __eventHandler(e:Event):void
		{
			switch (e.type) {
				case Event.ADDED_TO_STAGE:
					removeEventListener(e.type, __eventHandler);
					stage.addEventListener(Event.RESIZE, __eventHandler, false, int.MIN_VALUE);
					_stage = stage;
					if (!(getTextField() is TextField)) {
						getTextField().stage = stage;
					}
					render();
					break;
				case Event.RESIZE:
					render();
					break;
			}
		}
		
		protected function __textFieldHandler(e:Event):void
		{
			switch (e.type) {
				case Event.CHANGE:
					if (null !== _placeHolder && _placeHolderType === 1) {
						setPlaceHolder(_placeHolder);
					}
					break;
				case FocusEvent.FOCUS_IN:
				case FocusEvent.FOCUS_OUT:
					if (null !== _placeHolder && _placeHolderType === 0) {
						setPlaceHolder(_placeHolder);
					}
					break;
			}
		}
		
		protected function __triggerHandler(type:String, data:* = null):void
		{
			switch (type) {
				case "SHOW":
					freeze();
					break;
				case "CLEAR_ALL":
					unfreeze();
					break;
			}
		}
		
		override public function set visible(visible:Boolean):void
		{
			super.visible = visible;
			getTextField().visible = visible;
		}
		
		override public function set width(width:Number):void
		{
			_width = width;
			render();
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set height(height:Number):void
		{
			_height = height;
			render();
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set x(x:Number):void
		{
			super.x = x;
			render();
		}
		
		override public function set y(y:Number):void
		{
			super.y = y;
			render();
		}
		
		override public function clear():void
		{
			TEvent.removeTrigger("UP_WINDOW_AIS", __triggerHandler);
			if (null !== _stage) {
				_stage.removeEventListener(Event.RESIZE, __eventHandler);
			}
			if (!(_textField is TextField)) {
				_textField.dispose();
			}
			if (null !== _placeHolder) {
				_placeHolder.clear();
			}
			if (null !== _snapshot && null !== _snapshot.bitmapData) {
				_snapshot.bitmapData.dispose();
				_snapshot.bitmapData = null;
			}
			super.clear();
			_textField = null;
			_textFormat = null;
			_placeHolder = null;
			_snapshot = null;
			_lineMetric = null;
			_stage = null;
		}
		
	}
}