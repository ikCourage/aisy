package org.aisy.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.FontType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	/**
	 * 
	 * TextField 字体工具类
	 * 
	 * @author Viqu
	 * 
	 */
	public class FontUtil
	{
		static public var initialized:Boolean;
		static public var useEmbedFont:Boolean;
		static public var useEmbedDefaultFont:Boolean;
		static public var antiAliasType:String = AntiAliasType.NORMAL;
		static public var fontMap:Dictionary;
		static public var allFonts:Dictionary;
		static public var deviceFonts:Array;
		static public var embedFonts:Array;
		
		public function FontUtil()
		{
		}
		
		static public function initialize():void
		{
			var edf:String, arr:Array = Font.enumerateFonts(true), f:Font;;
			if (null !== embedFonts) edf = getEmbedDefaultFontName();
			initialized = true;
			allFonts = new Dictionary();
			deviceFonts = [];
			embedFonts = [];
			for (var i:uint = 0, j:uint = 0, k:uint = 0, l:uint = arr.length; i < l; i++) {
				f = arr[i];
				if (f.fontType === FontType.DEVICE) {
					deviceFonts[j] = f.fontName;
					j++;
				}
				else if (embedFonts.lastIndexOf(f.fontName) === -1) {
					embedFonts[k] = f.fontName;
					k++;
				}
				allFonts[f.fontName] = f;
			}
			if (null !== edf) setEmbedDefaultFontName(edf);
			edf = null;
			arr = null;
			f = null;
		}
		
		static public function setEmbedDefaultFontName(value:String):Boolean
		{
			var i:int = embedFonts.indexOf(value);
			if (i === -1) return false;
			embedFonts.splice(i, 1);
			embedFonts.unshift(value);
			value = null;
			return true;
		}
		
		static protected function getEmbedDefaultFontName():String
		{
			return embedFonts.length !== 0 ? embedFonts[0] : null;
		}
		
		static protected function getEmbedFontName(fontName:String, textField:TextField):String
		{
			if (null !== fontMap && fontMap[fontName]) fontName = fontMap[fontName];
			if (/\~$/.test(fontName) === true) {
				if (textField.embedFonts === true) return null;
			}
			else if (hasFontInDevice(fontName) === true) {
				textField.embedFonts = false;
				if (null === textField.styleSheet) {
					var df:TextFormat = textField.getTextFormat();
					if (null === df.font) df = textField.defaultTextFormat;
					df.font = fontName;
					textField.defaultTextFormat = df;
					textField = null;
					fontName = null;
					df = null;
				}
				return null;
			}
			else if (hasFontInEmbed(fontName) === true) fontName += "~";
			else if (useEmbedDefaultFont === true) fontName = getEmbedDefaultFontName();
			else return null;
			textField = null;
			return fontName;
		}
		
		static public function getFontName(v:Object, type:uint = 0, defaultFontName:String = "Microsoft YaHei"):String
		{
			for (var i:uint = 0, l:uint = v.length; i < l; i++) {
				if (allFonts.hasOwnProperty(v[i]) === true) {
					if (type === 0) return v[i];
					else if ((Font(allFonts[v[i]]).fontType === FontType.DEVICE ? 1 : 2) === type) return v[i];
				}
			}
			v = null;
			return defaultFontName;
		}
		
		static public function hasFontInAll(fontName:String):Boolean
		{
			return allFonts.hasOwnProperty(fontName);
		}
		
		static public function hasFontInDevice(fontName:String):Boolean
		{
			return deviceFonts.lastIndexOf(fontName) !== -1;
		}
		
		static public function hasFontInEmbed(fontName:String):Boolean
		{
			return embedFonts.lastIndexOf(fontName + "~") !== -1;
		}
		
		static public function embedFont(textField:TextField):void
		{
			var i:uint, fontName:String = "", defaultTextFormat:TextFormat, styleSheet:StyleSheet = textField.styleSheet;
			if (null !== styleSheet) {
				var len:uint = styleSheet.styleNames.length, n:String, obj:*;
				for (i = 0; i < len; i++) {
					n = styleSheet.styleNames[i];
					obj = styleSheet.getStyle(n);
					fontName = getEmbedFontName(obj["fontFamily"], textField);
					if (null === fontName) return;
					obj["fontFamily"] = fontName;
					styleSheet.setStyle(n, obj);
				}
				n = null;
				obj = null;
			}
			else {
				defaultTextFormat = textField.getTextFormat();
				if (null === defaultTextFormat.font) defaultTextFormat = textField.defaultTextFormat;
				fontName = getEmbedFontName(defaultTextFormat.font, textField);
				if (null === fontName) return;
				defaultTextFormat.font = fontName;
				textField.defaultTextFormat = defaultTextFormat;
			}
			var htmlText:String = textField.htmlText, cdataArr:Array = [];
			i = 0;
			htmlText = htmlText.replace(/(?:\<!\[CDATA\[.*?\]\]\>)/ig, function ():String
			{
				cdataArr[i] = arguments[0];
				return "<![CDATA[" + (i++) + "]]>";
			});
			htmlText = htmlText.replace(/(\<[^\>\<]+FACE\s*\=\s*[\'\"]*)([^\~\'\"]+)([\'\"]*[^\>\<]*\>)/ig, function ():String
			{
				while (null !== fontName) {
					fontName = getEmbedFontName(arguments[2], textField);
					return arguments[1] + fontName + arguments[3];
				}
				return "";
			});
			if (i !== 0) {
				i = 0;
				htmlText = htmlText.replace(/(?:\<!\[CDATA\[.*?\]\]\>)/ig, function ():String
				{
					return cdataArr[i++];
				});
			}
			if (!fontName) return;
			textField.htmlText = htmlText;
			textField.embedFonts = true;
			textField.antiAliasType = antiAliasType;
			if (null === styleSheet) {
				textField.defaultTextFormat = defaultTextFormat;
			}
			textField = null;
			fontName = null;
			htmlText = null;
			cdataArr = null;
			styleSheet = null;
			defaultTextFormat = null;
		}
		
		static public function useDefaultTextFormat(textField:TextField, fontName:String = "Verdana", textFormat:TextFormat = null):void
		{
			var fn:String = textField.defaultTextFormat.font;
			if (/\~$/.test(fn)) {
				var f:Font = allFonts[fn];
				if (null !== f) {
					if (f.hasGlyphs(textField.text.replace(/[\s\n\r\t]/g, "")) === false) {
						textField.embedFonts = false;
						if (null === textFormat) {
							textFormat = textField.defaultTextFormat;
							textFormat.font = fontName;
						}
						var htmlText:String = textField.htmlText;
						htmlText = htmlText.replace(/(\<[^\>\<]+FACE\s*\=\s*[\'\"]*)([^\'\"]+)([\'\"]*[^\>\<]*\>)/ig, function ():String
						{
							if (arguments[2] === fn) arguments[2] = fontName;
							return arguments[1] + arguments[2] + arguments[3];
						});
						textField.htmlText = htmlText;
						textField.defaultTextFormat = textFormat;
					}
				}
			}
		}
		
		static public function checkEmbedFont(container:DisplayObjectContainer):void
		{
			if (useEmbedFont === false) return;
			var i:uint, len:uint = container.numChildren;
			var obj:*;
			for (i = 0; i < len; i++) {
				obj = container.getChildAt(i);
				if (obj is DisplayObjectContainer) checkEmbedFont(obj);
				else if (obj is TextField) embedFont(obj);
			}
			obj = null;
			container = null;
		}
		
		static public function clear():void
		{
			initialized = false;
			useEmbedFont = false;
			useEmbedDefaultFont = false;
			antiAliasType = null;
			fontMap = null;
			allFonts = null;
			deviceFonts = null;
			embedFonts = null;
		}
		
	}
}