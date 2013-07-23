package org.aisy.net.data
{
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.getDefinitionByName;
	
	import org.aisy.autoclear.AisyAutoClear;
	import org.aisy.interfaces.IClear;
	import org.aisy.utils.AisyUtils;

	/**
	 * 
	 * 本地数据
	 * 只用做本地存储数据时建议使用
	 * 
	 * @author Viqu
	 * 
	 */
	public class LocalData implements IClear
	{
		protected var _isDestop:Boolean;
		protected var _name:String;
		protected var _localPath:String;
		protected var _data:Object;
		
		public function LocalData(name:String, localPath:String = null, secure:Boolean = false)
		{
			_isDestop = AisyUtils.isDestop;
			if (_isDestop === false) {
				_data = SharedObject.getLocal(name, localPath, secure);
			}
			else {
				_name = name;
				_localPath = localPath;
				if (null === localPath) {
					var nApp:Class = getDefinitionByName("flash.desktop.NativeApplication") as Class;
					var xml:XML = nApp.nativeApplication.applicationDescriptor;
					var ns:Namespace = new Namespace(xml.namespace());
					var arr:Array = (getDefinitionByName("flash.filesystem.File") as Class).applicationStorageDirectory.nativePath.split(/[\\\/]/);
					_localPath = "file:///" + arr.slice(0, arr.length - 2).join("/") + "/" + String(xml.ns::filename).replace(/\_/, "-") + "/Aisy Data/.LocalData/" + nApp.nativeApplication.openedWindows[0].stage.loaderInfo.url.replace(/^app\:/ig, "") + "/";
					deleteEmptyDirectory();
					nApp = null;
					xml = null;
					ns = null;
					arr = null;
				}
			}
			name = null;
			localPath = null;
		}
		
		protected function deleteEmptyDirectory():void
		{
			var fCls:Class = getDefinitionByName("flash.filesystem.File") as Class;
			var f:* = fCls.applicationStorageDirectory;
			while (null !== f && f.exists === true) {
				if (f.getDirectoryListing().length !== 0) {
					f.cancel();
					break;
				}
				f.deleteDirectory();
				f.cancel();
				f = new fCls(f.nativePath.replace(/[^\\\/]*$/, ""));
			}
			f = null;
			fCls = null;
		}
		
		public function get isLocal():Boolean
		{
			return _isDestop;
		}
		
		public function get data():Object
		{
			if (_isDestop === false) {
				return (_data as SharedObject).data;
			}
			if (null === _data) {
				_data = {};
				var f:* = new (getDefinitionByName("flash.filesystem.File") as Class)(_localPath + _name + ".iy");
				if (f.exists === true) {
					var fs:* = new (getDefinitionByName("flash.filesystem.FileStream") as Class)();
					fs.open(f, (getDefinitionByName("flash.filesystem.FileMode") as Class).READ);
					_data = fs.readObject();
					fs.close();
					fs = null;
				}
				f.cancel();
				f = null;
			}
			return _data;
		}
		
		public function flush(minDiskSpace:int = 0):String
		{
			if (_isDestop === false) {
				return (_data as SharedObject).flush(minDiskSpace);
			}
			var f:* = new (getDefinitionByName("flash.filesystem.File") as Class)(_localPath + _name + ".iy");
			var fs:* = new (getDefinitionByName("flash.filesystem.FileStream") as Class)();
			fs.open(f, (getDefinitionByName("flash.filesystem.FileMode") as Class).WRITE);
			fs.writeObject(_data);
			fs.close();
			f.cancel();
			fs = null;
			f = null;
			_data = null;
			return SharedObjectFlushStatus.FLUSHED;
		}
		
		public function close():void
		{
			if (_isDestop === false && null !== _data) {
				(_data as SharedObject).close();
			}
			_name = null;
			_localPath = null;
			_data = null;
		}
		
		public function clear():void
		{
			AisyAutoClear.remove(this);
			if (_isDestop === false) {
				(_data as SharedObject).clear();
				_data = null;
			}
			else {
				var f:* = new (getDefinitionByName("flash.filesystem.File") as Class)(_localPath + _name + ".iy");
				if (f.exists === true) {
					f.deleteFile();
				}
				f.cancel();
				f = f.parent;
				while (null !== f && f.exists === true) {
					if (f.getDirectoryListing().length !== 0) {
						f.cancel();
						break;
					}
					f.deleteDirectory();
					f.cancel();
					f = f.parent;
				}
				f = null;
			}
			close();
		}
		
		static public function getLocal(name:String, localPath:String = null, secure:Boolean = false):LocalData
		{
			return new LocalData(name, localPath, secure);
		}
		
	}
}