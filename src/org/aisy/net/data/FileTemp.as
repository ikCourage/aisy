package org.aisy.net.data
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 * 
	 * 临时文件
	 * 
	 * @author Viqu
	 * 
	 */
	public class FileTemp
	{
		static protected var _fileTemp:Dictionary = new Dictionary(true);
		
		public function FileTemp()
		{
		}
		
		static public function getFileTemp():Dictionary
		{
			return _fileTemp;
		}
		
		/**
		 * 
		 * 添加一个元素
		 * 当 e == null 时，添加一个 Dictionary
		 * 
		 * @param e
		 * @param owner
		 * @param src
		 * @return 
		 * 
		 */
		static public function addElement(e:*, owner:*, src:Dictionary = null):*
		{
			if (null === src) src = _fileTemp;
			if (null == src[owner]) {
				src[owner] = new Dictionary(true);
				src[owner]["length"] = 0;
			}
			if (null !== e) {
				src[owner][src[owner]["length"]] = e;
				src[owner]["length"]++;
				e = null;
			}
			return src[owner];
		}
		
		static public function createTempDirectory(owner:*, src:Dictionary = null):*
		{
			var f:* = getDefinitionByName("flash.filesystem.File").createTempDirectory();
			addElement(f, owner, src);
			owner = null;
			src = null;
			return f;
		}
		
		static public function createTempFile(owner:*, src:Dictionary = null):*
		{
			var f:* = getDefinitionByName("flash.filesystem.File").createTempFile();
			addElement(f, owner, src);
			owner = null;
			src = null;
			return f;
		}
		
		static protected function __fileHandler(e:Event):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			e.currentTarget.cancel();
			e = null;
		}
		
		static protected function __deleteFile(file:*):void
		{
			if (file.exists === true) {
				file.addEventListener(Event.COMPLETE, __fileHandler);
				file.isDirectory === true ? file.deleteDirectoryAsync(true) : file.deleteFileAsync();
			}
			file = null;
		}
		
		static public function deleteFile(file:*, owner:*, src:Dictionary = null):void
		{
			if (null === src) src = _fileTemp;
			if (null == src[owner]) return;
			for (var i:* in src[owner]) {
				if (src[owner][i] === file) {
					__deleteFile(file);
					delete src[owner][i];
					break;
				}
			}
			file = null;
			owner = null;
			src = null;
		}
		
		static public function clearByOwner(owner:*, src:Dictionary = null):void
		{
			if (null === src) src = _fileTemp;
			if (null == src[owner]) return;
			for (var i:* in src[owner]) {
				if (src[owner][i] is Dictionary) {
					clearByOwner(i, src[owner]);
				}
				else if (src[owner][i] is (getDefinitionByName("flash.filesystem.File") as Class)) {
					__deleteFile(src[owner][i]);
				}
			}
			delete src[owner];
			owner = null;
			src = null;
		}
		
		static public function clear():void
		{
			for (var i:* in _fileTemp) {
				clearByOwner(i);
			}
			_fileTemp = new Dictionary(true);
		}
		
	}
}