package org.aisy.net.utils
{
	public class URI
	{
		static protected const _relativeURLR:RegExp = /^\s*(https?|file|ftp)\s*\:/i;
		static protected const _canonicalizeURLR:RegExp = /((\s*\:(\s*[\\\/]){1,2})(\s*[\\\/]\s*)+)|((\s*[\\\/]\s*)+)/g;
		
		static public var RELATIVE_URL:String = "";
		static public var RELATIVE_URL_ENABLED:Boolean;
		
		public function URI()
		{
		}
		
		static public function relativeURL(url:*, relativeURL:String = null):*
		{
			if (RELATIVE_URL_ENABLED === true) {
				if (!relativeURL) relativeURL = RELATIVE_URL;
				if (relativeURL) {
					if (url is String) {
						if (!_relativeURLR.test(url)) {
							return canonicalizeURL(relativeURL + url);
						}
					}
					else if (!_relativeURLR.test(url.url)) {
						url.url = canonicalizeURL(relativeURL + url.url);
						return url;
					}
				}
			}
			return canonicalizeURL(url);
		}
		
		static public function getQuery(url:*):String
		{
			url = url is String ? url : url.url;
			var i:int = url.indexOf("?");
			if (i !== -1 && i < url.length - 1) {
				return url.substring(i + 1);
			}
			return null;
		}
		
		static public function getSuffix(url:*):String
		{
			url = url is String ? url : url.url;
			var q:uint = uint(url.indexOf("?"));
			var i:int = url.lastIndexOf(".", q);
			if (i !== -1 && i < url.length - 1) {
				return url.substring(i + 1, q).toLocaleLowerCase();
			}
			return null;
		}
		
		static public function getName(url:*):String
		{
			url = url is String ? url : url.url;
			var q:uint = uint(url.indexOf("?"));
			var i:int = url.lastIndexOf("/", q);
			if (i === -1) i = url.lastIndexOf("\\", q);
			return url.substring(i + 1, q);
		}
		
		static public function getPath(url:*):String
		{
			url = url is String ? url : url.url;
			var q:uint = uint(url.indexOf("?"));
			var i:int = url.lastIndexOf("/", q);
			if (i === -1) i = url.lastIndexOf("\\", q);
			return url.substring(0, i + 1);
		}
		
		static public function canonicalizeURL(url:*):*
		{
			if (url is String) {
				url = url.replace(_canonicalizeURLR, __canonicalizeURL);
			}
			else {
				url.url = url.url.replace(_canonicalizeURLR, __canonicalizeURL);
			}
			return url;
		}
		
		static protected function __canonicalizeURL(...parameters):String
		{
			return parameters[2] ? parameters[2].replace(/\s+/g, "") + "/" : "/";
		}
		
	}
}