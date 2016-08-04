package org.aisy.net.data
{
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	import org.ais.system.Ais;
	import org.aisy.autoclear.AisyAutoClear;
	import org.aisy.interfaces.IClear;
	import org.aisy.utils.AisyUtil;

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
		protected var _lastTime:Number;
		protected var _data:Object;
		
		public function LocalData(name:String, localPath:String = null, secure:Boolean = false)
		{
			_isDestop = AisyUtil.isDestop;
			if (_isDestop === false) {
				_data = SharedObject.getLocal(name, localPath, secure);
			}
			else {
				_name = name;
				_localPath = localPath;
				if (null === localPath) {
					var nApp:Class = getDefinitionByName("flash.desktop.NativeApplication") as Class;
					var appName:String;
					if (nApp.nativeApplication.openedWindows.length === 0) {
						var xml:XML = nApp.nativeApplication.applicationDescriptor;
						var ns:Namespace = new Namespace(xml.namespace());
						appName = String(xml.ns::filename);
						xml = null;
						ns = null;
					}
					else {
						appName = nApp.nativeApplication.openedWindows[0].stage.loaderInfo.url;
						if (appName.indexOf("[[DYNAMIC]]") !== -1) {
							var k:int = Ais.IMain && Ais.IMain.hasOwnProperty("Swf") ? Ais.IMain.Swf.hasSwf("url", appName) : -1;
							if (k !== -1) appName = Ais.IMain.Swf.get(k, "__url");
							if (k === -1 || !appName) throw new Error("Cannot be used in loadBytes, or use outside imoon.");
						}
						appName = appName.replace(/^(file|app)\:/i, "").replace(/\?.*/g, "").replace(/^\s+|\s+$/, "").replace(/[\/\\]+/g, "/").replace(/\:/g, "%7C").replace(/\|/g, "%3A");
					}
					_localPath = (getDefinitionByName("flash.filesystem.File") as Class).applicationStorageDirectory.nativePath.replace(/\\/g, "/") + "/Aisy Data/.LocalData/" + appName + "/";
					nApp = null;
					appName = null;
				}
			}
			name = null;
			localPath = null;
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
			var f:* = new (getDefinitionByName("flash.filesystem.File") as Class)(_localPath + _name + ".iy");
			if (f.exists === true && f.modificationDate.getTime() !== _lastTime) {
				_lastTime = f.modificationDate.getTime();
				var fs:* = new (getDefinitionByName("flash.filesystem.FileStream") as Class)();
				fs.open(f, (getDefinitionByName("flash.filesystem.FileMode") as Class).READ);
				_data = fs.readObject();
				fs.close();
				fs = null;
			}
			if (null === _data) {
				_data = {};
			}
			f.cancel();
			f = null;
			return _data;
		}
		
		public function get size():uint
		{
			if (_isDestop === false) {
				return (_data as SharedObject).size;
			}
			var b:ByteArray = new ByteArray();
			b.writeObject(data);
			var l:uint = b.length;
			b.clear();
			b = null;
			return l;
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
			_lastTime = f.modificationDate.getTime();
			f.cancel();
			fs = null;
			f = null;
			return SharedObjectFlushStatus.FLUSHED;
		}
		
		public function close():void
		{
			if (_isDestop === false && null !== _data) {
				(_data as SharedObject).close();
			}
			_lastTime = 0;
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