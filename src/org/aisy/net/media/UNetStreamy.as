package org.aisy.net.media
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.net.NetConnection;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import org.ais.event.TEvent;
	import org.ais.system.Memory;
	import org.aisy.net.data.UByteArray;
	import org.aisy.net.media.data.ArrayByte;
	import org.aisy.net.media.data.MetaData;
	import org.aisy.net.utils.DataStream;

	/**
	 * 
	 * 扩展 UNetStream
	 * 
	 * @author viqu
	 * 
	 */
	public class UNetStreamy extends UNetStream
	{
		/**
		 * 名字
		 */
		public var NAME:String;
		/**
		 * 是否是普通播放
		 */
		public var isNormal:Boolean;
		/**
		 * 是否每次只有一个流
		 */
		public var isOne:Boolean;
		/**
		 * 是否自动加载
		 */
		public var isAutoLoad:Boolean = true;
		/**
		 * 当前数据索引
		 */
		public var index:uint;
		/**
		 * 拖放索引
		 */
		protected var _seekIndex:uint;
		/**
		 * 数据流
		 */
		protected var _dStream:DataStream;
		/**
		 * 文件地址
		 */
		protected var _URLRequest:URLRequest;
		/**
		 * 字节数组
		 */
		protected var _arrayByte:ArrayByte;
		/**
		 * 文件头数组
		 */
		protected var _fileHeadArr:ArrayByte;
		/**
		 * 元数据
		 */
		protected var _metaData:MetaData;
		/**
		 * 关键点数组
		 */
		protected var _seekPointArr:Array;
		/**
		 * 关键时间数组
		 */
		protected var _timePointArr:Array;
		/**
		 * client 侦听数组
		 */
		protected var _clientListeners:Array;
		/**
		 * 数据流侦听数据
		 */
		protected var _streamListeners:Array;
		/**
		 * 检查 URL 回调函数
		 */
		protected var _checkURLF:Function;
		/**
		 * 当前文件索引
		 */
		protected var _curFPindex:uint;
		/**
		 * 当前文件点
		 */
		protected var _curFPosition:uint;
		/**
		 * 当前播放点开始时间
		 */
		protected var _curFTime:Number = 0;
		/**
		 * 缓冲时间
		 */
		protected var _bufferTime:Number = 0;
		/**
		 * 拖放（时间、百分比等）
		 */
		protected var _seekTime:Number = 0;
		/**
		 * 拖放类型
		 */
		protected var _seekType:int;
		/**
		 * 当前数据是否加载完成
		 */
		protected var _isLoaded:Boolean;
		/**
		 * 是否读取过文件头
		 */
		protected var _isReadHeader:Boolean;
		/**
		 * 将要合并的数据索引
		 */
		protected var _mergeIndex:uint;
		/**
		 * 头文件字节数
		 */
		protected var _headerByteInt:uint;
		/**
		 * 文件字节差值
		 */
		protected var _tSize:uint;
		
		public function UNetStreamy(connection:NetConnection, peerID:String = "connectToFMS")
		{
			NAME = getTimer() + "" + Math.random();
			super(connection, peerID);
			init();
			connection = null;
			peerID = null;
		}
		
		/**
		 * 
		 * 初始化
		 * 
		 */
		protected function init():void
		{
			_clientListeners = [];
			_streamListeners = [];
			
			setCheckURL();
			
			client = {};
			client.onCuePoint = onCuePoint;
			client.onImageData = onImageData;
			client.onMetaData = onMetaData;
			client.onPlayStatus = onPlayStatus;
			client.onSeekPoint = onSeekPoint;
			client.onTextData = onTextData;
			
			addEventListener(NetStatusEvent.NET_STATUS, __netStatusHandler);
		}
		
		protected function onCuePoint(data:*):void
		{
			if (_clientListeners["onCuePoint"]) _clientListeners["onCuePoint"].apply(null, [data]);
			TEvent.trigger(NAME, "ON_CUEPOINT", data);
			data = null;
		}
		
		protected function onImageData(data:*):void
		{
			if (_clientListeners["onImageData"]) _clientListeners["onImageData"].apply(null, [data]);
			TEvent.trigger(NAME, "ON_IMAGEDATA", data);
			data = null;
		}
		
		protected function onMetaData(data:*):void
		{
			var m:MetaData = new MetaData();
			m.setData(data);
			if (null === _metaData || null !== m.keyframes) {
				_metaData = m;
				if (_clientListeners["onMetaData"]) _clientListeners["onMetaData"].apply(null, [data]);
				TEvent.trigger(NAME, "ON_METADATA", data);
			}
			m = null;
			data = null;
		}
		
		protected function onPlayStatus(data:*):void
		{
			if (_clientListeners["onPlayStatus"]) _clientListeners["onPlayStatus"].apply(null, [data]);
			TEvent.trigger(NAME, "ON_PLAYSTATUS", data);
			data = null;
		}
		
		protected function onSeekPoint(t:Number, p:Number):void
		{
			var len:uint = _seekPointArr[index].length;
			len = len > 2 ? 2 : len;
			_seekPointArr[index][len] = p + _curFPosition;
			if (_clientListeners["onSeekPoint"]) _clientListeners["onSeekPoint"].apply(null, [t, p]);
			TEvent.trigger(NAME, "ON_SEEKPOINT", [t, p]);
		}
		
		protected function onTextData(data:*):void
		{
			data = null;
		}
		
		protected function __netStatusHandler(e:NetStatusEvent):void
		{
			switch (e.info.code) {
				case "NetStream.Play.Stop":
					break;
				case "NetStream.Seek.Notify":
					super.bufferTime = 0;
					if (_seekType === 0) return;
					else {
						appendBytesAction("endSequence");
						appendBytesAction("resetSeek");
						if (_seekType === 1) __seekByPoint();
						else if (_seekType === 2) __seekByPoint2();
						if (isAutoLoad === true) __autoLoad();
					}
					break;
				case "NetStream.Buffer.Empty":
					super.bufferTime = 0;
					__autoLoad();
					if (_metaData && _seekPointArr[index] && _arrayByte && _arrayByte.get(index)) {
						if (_metaData.filesize <= _seekPointArr[index][0] + _arrayByte.get(index).length) {
							dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code: "NetStream.Play.Stop", level: "status"}));
							return;
						}
					}
					break;
				case "NetStream.Buffer.Full":
					super.bufferTime = _bufferTime;
					break;
			}
			e = null;
		}
		
		/**
		 * 
		 * 自动加载数据
		 * 
		 */
		protected function __autoLoad():void
		{
			if (_isLoaded === true) {
				if (!_metaData || !_seekPointArr[index] || !_arrayByte || !_arrayByte.get(index)) return;
				if (_metaData.filesize > _seekPointArr[index][0] + _arrayByte.get(index).length) {
					var i:int = _metaData.keyframes.filepositions.lastIndexOf(_seekPointArr[index][2]) + 1;
					var p:uint = _metaData.keyframes.filepositions[i];
					if (p) {
						_tSize = _metaData.filesize - p;
						_isReadHeader = false;
						__searchIndex(p);
						load2(_checkURLF(_URLRequest, 1, p));
					}
				}
			}
		}
		
		/**
		 * 
		 * 当前流加载进度
		 * @param e
		 * 
		 */
		protected function __dStreamProgress0(e:ProgressEvent):void
		{
			var ubLen:uint;
			var bLen:uint;
			var cfp:uint;
			var rLen:uint;
			var b:ByteArray = new ByteArray();
			var b1:ByteArray = new ByteArray();
			while (null !== _dStream && _dStream.bytesAvailable) {
				while (_dStream.bytesAvailable) {
					b.clear();
					_dStream.readBytes(b, 0, _dStream.bytesAvailable);
					
					if (_mergeIndex !== 0) {
						cfp = _seekPointArr[index][0];
						ubLen = _arrayByte.get(index).length;
						bLen = b.length;
						if (ubLen + bLen + cfp >= _seekPointArr[_mergeIndex][0]) {
							_isLoaded = true;
							clearStream();
							cutByte(_mergeIndex);
							rLen = 0;
							if ((_seekPointArr[_mergeIndex][0] - cfp - ubLen) > 0) {
								rLen = _seekPointArr[_mergeIndex][0] - cfp - ubLen;
							}
							if (rLen > bLen) rLen = 0;
							b1.clear();
							b1.writeBytes(b, 0, rLen);
							
							ubLen = _arrayByte.get(_mergeIndex).length;
							rLen = 1024 << 12;
							_arrayByte.get(_mergeIndex).position = 0;
							do {
								rLen = rLen > ubLen ? ubLen : rLen;
								_arrayByte.get(_mergeIndex).readBytes(b1, b1.position, rLen);
								
								_arrayByte.get(index).writeBytes(b1);
								
								if (index === _seekIndex) appendBytes(b1);
								b1.clear();
								ubLen -= rLen;
							} while (ubLen > 0);
							
							__deleteByte(_mergeIndex);
							
							b1.clear();
							
							if (isAutoLoad === true) __autoLoad();
							break;
						}
					}
					
					_arrayByte.get(index).writeBytes(b);
					if (index === _seekIndex) appendBytes(b);
				}
			}
			if (null !== e) {
				if (_streamListeners[e.type]) _streamListeners[e.type](this);
			}
			b1.clear();
			b.clear();
			b1 = null;
			b = null;
			e = null;
		}
		
		/**
		 * 
		 * 当前流加载进度（计算文件头）（临时）
		 * @param e
		 * 
		 */
		protected function __dStreamProgress1(e:ProgressEvent):void
		{
			var _bt:uint = e.bytesTotal;
			var b:ByteArray = new ByteArray();
			_headerByteInt = _bt - _tSize;
			while (null !== _dStream && _dStream.bytesAvailable >= _headerByteInt) {
				_isReadHeader = true;
				b.clear();
				_dStream.readBytes(b, 0, _headerByteInt);
				_fileHeadArr.get(index).writeBytes(b);
				_dStream.removeEventListener(ProgressEvent.PROGRESS, __dStreamProgress1);
				_dStream.addEventListener(ProgressEvent.PROGRESS, __dStreamProgress0);
				break;
			}
			if (null !== e) {
				if (_streamListeners[e.type]) _streamListeners[e.type](this);
			}
			b.clear();
			b = null;
			e = null;
		}
		
		/**
		 * 
		 * 当前流加载完成
		 * @param e
		 * 
		 */
		protected function __dStreamComplete(e:Event):void
		{
			__dStreamProgress0(null);
			if (_streamListeners[e.type]) _streamListeners[e.type](this);
			_isLoaded = true;
			clearStream();
			e = null;
		}
		
		/**
		 * 
		 * 当前流加载错误
		 * @param e
		 * 
		 */
		protected function __dStreamIOError(e:IOErrorEvent):void
		{
			if (_streamListeners[e.type]) _streamListeners[e.type](this, e);
			_isLoaded = true;
			clearStream();
			e = null;
		}
		
		/**
		 * 
		 * 根据关键点播放已缓存流
		 * 
		 */
		protected function __seekByPoint():void
		{
			if (!_seekPointArr[_seekIndex]) return;
			if (_seekPointArr[_seekIndex].length < 3) return;
			
			cutByte(_seekIndex);
			
			var arr:Array;
			var start:int = _metaData.keyframes.filepositions.lastIndexOf(_seekPointArr[_seekIndex][1]);
			var end:int = _metaData.keyframes.filepositions.lastIndexOf(_seekPointArr[_seekIndex][2]) + 0;
			arr = _metaData.keyframes.filepositions.slice(start, end);
			
			_curFPindex = Math.floor(_seekTime * arr.length);
			_curFPindex = _curFPindex < arr.length ? _curFPindex : arr.length - 1;
			
			_curFPosition = arr[_curFPindex];
			var _cfp:uint = arr[_curFPindex] - _seekPointArr[_seekIndex][0];
			
			_curFTime = _metaData.keyframes.times[start + _curFPindex];
			
			_curFPindex = _metaData.keyframes.filepositions.lastIndexOf(_curFPosition) - 1;
			
			var tp:uint = _arrayByte.get(_seekIndex).position;
			_arrayByte.get(_seekIndex).position = _cfp;
			
			var b:ByteArray = new ByteArray();
			var len:uint = _arrayByte.get(_seekIndex).bytesAvailable;
			var rLen:uint = 1024 << 12;
			while (len > 0) {
				rLen = rLen > len ? len : rLen;
				_arrayByte.get(_seekIndex).readBytes(b, 0, rLen);
				appendBytes(b);
				b.clear();
				len -= rLen;
			}
			
			_arrayByte.get(_seekIndex).position = tp;
			
			b.clear();
			b = null;
			arr = null;
		}
		
		/**
		 * 
		 * 根据关键点加载播放流
		 * 
		 */
		protected function __seekByPoint2():void
		{
			_curFPindex = Math.floor(_seekTime * _metaData.keyframes.filepositions.length);
			_curFPindex = _curFPindex < _metaData.keyframes.filepositions.length ? _curFPindex : _metaData.keyframes.filepositions.length - 1;
			
			var _cfp:uint = _metaData.keyframes.filepositions[_curFPindex];
			
			var i:uint, len:uint = _seekPointArr.length, arr:Array;
			for (i = 0; i < len; i++) {
				arr = _seekPointArr[i];
				if (_cfp >= arr[0] && _cfp <= arr[2]) {
					seekIndex = i;
					index = _seekIndex;
					_seekTime = 0.7;
					__seekByPoint();
					arr = null;
					return;
				}
			}
			
			if (_curFPindex) {
				_curFPosition = _cfp;
				_curFTime = _metaData.keyframes.times[_curFPindex];
				
				_tSize = _metaData.filesize - _cfp;
				
				__searchIndex(_curFPosition);
				_isReadHeader = false;
				load(_checkURLF(_URLRequest, 1, _curFPosition));
			}
			
			arr = null;
		}
		
		/**
		 * 
		 * 加载数据
		 * @param request
		 * 
		 */
		protected function load2(request:Object):void
		{
			_isLoaded = false;
			
			_seekIndex = index;
			
			_fileHeadArr.set(index, new UByteArray(1));
			
			clearStream();
			
			_dStream = new DataStream();
			if (_isReadHeader === true) {
				_dStream.addEventListener(ProgressEvent.PROGRESS, __dStreamProgress0);
			}
			else {
				_dStream.addEventListener(ProgressEvent.PROGRESS, __dStreamProgress1);
			}
			_dStream.addEventListener(Event.COMPLETE, __dStreamComplete);
			_dStream.addEventListener(IOErrorEvent.IO_ERROR, __dStreamIOError);
			
			_dStream.load(_checkURLF(request, 0, 0) as URLRequest);
			
			request = null;
			Memory.clear();
		}
		
		/**
		 * 
		 * 拖放加载回调处理函数
		 * @param request
		 * @param p
		 * @return 
		 * 
		 */
		protected function __checkURLF(request:Object, type:int = 0, p:uint = 0):URLRequest
		{
			var r:URLRequest;
			if (request is String) r = new URLRequest(request as String);
			else r = request as URLRequest;
			if (type === 1) r.url += "?start=" + p;
			request = null;
			return r;
		}
		
		/**
		 * 
		 * 搜索将要合并的数据索引
		 * @param v
		 * 
		 */
		protected function __searchIndex(v:Number):void
		{
			_mergeIndex = 0;
			var i:uint, j:uint, len:uint = _seekPointArr.length, a:Array, arr:Array = [];
			for (i = 0; i < len; i++) {
				a = _seekPointArr[i];
				if (v < a[0]) {
					arr[j] = [i, a[0]];
					j++;
				}
			}
			
			arr.sortOn([1], Array.NUMERIC);
			if (arr.length !== 0) {
				_mergeIndex = parseInt(arr[0][0]);
			}
			a = null;
			arr = null;
		}
		
		/**
		 * 
		 * 删除索引为 i 的所有数据
		 * @param i
		 * 
		 */
		protected function __deleteByte(i:uint):void
		{
			TEvent.trigger(NAME, "DELETE_INDEX", i);
			_mergeIndex = 0;
			_arrayByte.get(i).clear();
			_fileHeadArr.get(i).clear();
			delete _arrayByte[i];
			delete _fileHeadArr[i];
			delete _seekPointArr[i];
			delete _timePointArr[i];
			Memory.clear();
		}
		
		/**
		 * 
		 * 清空所有数据
		 * 
		 */
		protected function clearData():void
		{
			if (null !== _arrayByte) _arrayByte.clear();
			if (null !== _fileHeadArr) _fileHeadArr.clear();
			_arrayByte = null;
			_fileHeadArr = null;
			_metaData = null;
			_seekPointArr = null;
			_timePointArr = null;
			_URLRequest = null;
		}
		
		override public function set bufferTime(bufferTime:Number):void
		{
			_bufferTime = bufferTime;
			super.bufferTime = bufferTime;
		}
		
		/**
		 * 
		 * 返回当前 URLRequest
		 * @return 
		 * 
		 */
		public function getURLRequest():URLRequest
		{
			return _URLRequest;
		}
		
		/**
		 * 
		 * 返回当前播放时间
		 * @return 
		 * 
		 */
		public function getTime():Number
		{
			return super.time + _curFTime;
		}
		
		/**
		 * 
		 * 返回当前数据加载进度
		 * @return 
		 * 
		 */
		public function getBytesLoaded():uint
		{
			if (isNormal === true) return bytesLoaded;
			return _arrayByte.get(index).length;
		}
		
		/**
		 * 
		 * 返回当前数据大小
		 * @return 
		 * 
		 */
		public function getBytesTotal():uint
		{
			if (isNormal === true) return bytesTotal;
			var t:uint;
			if (null !== _metaData && _metaData.filesize !== 0) {
				t = _metaData.filesize - _seekPointArr[index][0];
			}
			return t;
		}
		
		/**
		 * 
		 * 返回当前数据加载进度（百分比）
		 * @return 
		 * 
		 */
		public function getLoadProgress():Number
		{
			var t:Number = 0;
			if (getBytesLoaded() <= getBytesTotal() && getBytesTotal() !== 0) {
				t = getBytesLoaded() / getBytesTotal();
				t = t > 1 ? 1 : t;
			}
			return t;
		}
		
		/**
		 * 
		 * 返回当前播放进度（百分比）
		 * @return 
		 * 
		 */
		public function getPlayProgress():Number
		{
			var t:Number = 0;
			if (null !== _metaData && _metaData.duration !== 0) {
				t = getTime() / _metaData.duration;
				t = t > 1 ? 1 : t;
			}
			return t;
		}
		
		/**
		 * 
		 * 返回字节数据数组
		 * @return 
		 * 
		 */
		public function getArrayByte():ArrayByte
		{
			return _arrayByte;
		}
		
		/**
		 * 
		 * 返回完整字节数据数组
		 * 当 sort = false 时返回未排序数组
		 * 当 sort = true 时返回排序数组
		 * @param sort
		 * @return 
		 * 
		 */
		public function getArrayByteFull(sort:Boolean = false):Array
		{
			var _bA:Array = [];
			if (sort === false) {
				for (var i:* in _arrayByte) {
					_bA[i] = [];
					_bA[i][0] = i;
					_bA[i][1] = new ByteArray();
					_bA[i][1].writeBytes(_fileHeadArr.get(i).toByteArray());
					_bA[i][1].writeBytes(_arrayByte.get(i).toByteArray());
				}
			}
			else {
				var _iArr:Array = [];
				
				for (i in _seekPointArr) {
					_iArr[_iArr.length] = [i, _seekPointArr[i][0]];
				}
				
				_iArr.sortOn(1, Array.NUMERIC);
				
				for (i in _iArr) {
					_bA[i] = [];
					_bA[i][0] = _iArr[i][0];
					_bA[i][1] = new ByteArray();
					_bA[i][1].writeBytes(_fileHeadArr.get(_iArr[i][0]).toByteArray());
					_bA[i][1].writeBytes(_arrayByte.get(_iArr[i][0]).toByteArray());
				}
				
				_iArr = null;
			}
			return _bA;
		}
		
		/**
		 * 
		 * 返回文件头数组
		 * @return 
		 * 
		 */
		public function getFileHeadArr():ArrayByte
		{
			return _fileHeadArr;
		}
		
		/**
		 * 
		 * 返回元数据
		 * @return 
		 * 
		 */
		public function getMetaData():MetaData
		{
			return _metaData;
		}
		
		/**
		 * 
		 * 返回每个数据的关键点数组
		 * @return 
		 * 
		 */
		public function getSeekPointArr():Array
		{
			return _seekPointArr;
		}
		
		/**
		 * 
		 * 返回每个数据的关键时间数组
		 * @return 
		 * 
		 */
		public function getTimePointArr():Array
		{
			return _timePointArr;
		}
		
		/**
		 * 
		 * 设置拖放索引
		 * @param value
		 * 
		 */
		public function set seekIndex(value:uint):void
		{
			if (null === _metaData) return;
			if (!_metaData.hasKeyframes) return;
			_seekIndex = value;
			if (_isLoaded === false) {
				_isLoaded = true;
				clearStream();
				var i:uint, j:uint, len:uint = _seekPointArr.length, a:Array, arr:Array = [];
				for (i = 0; i < len; i++) {
					a = _seekPointArr[i];
					if (a) {
						if (a.length < 3) {
							arr[j] = i;
							j++;
						}
					}
				}
				for (i = 0; i < j; i++) {
					__deleteByte(i);
				}
				a = null;
				arr = null;
			}
		}
		
		/**
		 * 
		 * 拖放流
		 * 当 type = 0 时，同 seek
		 * 当 type = 1 时，拖放已缓存数据
		 * 当 type = 2 时，根据关键点加载数据
		 * @param offset
		 * @param type
		 * 
		 */
		public function seekByPoint(offset:Number, type:int = 1):void
		{
			index = _seekIndex;
			_seekType = type;
			if (type === 0) super.seek(offset);
			else {
				if (null === _metaData) return;
				if (!_metaData.hasKeyframes) return;
				if (type === 1) {
					if (!_seekPointArr[_seekIndex]) return;
					if (_seekPointArr[_seekIndex].length < 3) return;
				}
				_seekTime = Math.abs(offset);
				super.seek(0);
			}
		}
		
		/**
		 * 
		 * 设置当前播放点开始时间
		 * @param value
		 * 
		 */
		public function setCurrentFTime(value:Number):void
		{
			_curFTime = value;
		}
		
		/**
		 * 
		 * 设置检查 URL 回调函数
		 * @param value
		 * 
		 */
		public function setCheckURL(value:Function = null):void
		{
			if (null === value) _checkURLF = __checkURLF;
			else _checkURLF = value;
			value = null;
		}
		
		/**
		 * 
		 * 添加 client 侦听
		 * @param type
		 * @param listener
		 * 
		 */
		public function addClientEvent(type:String, listener:Function):void
		{
			_clientListeners[type] = listener;
			type = null;
			listener = null;
		}
		
		/**
		 * 
		 * 添加流侦听
		 * @param type
		 * @param listener
		 * 
		 */
		public function addStreamEvent(type:String, listener:Function):void
		{
			_streamListeners[type] = listener;
			type = null;
			listener = null;
		}
		
		/**
		 * 
		 * 裁剪数据
		 * @param i
		 * 
		 */
		public function cutByte(i:uint):void
		{
			if (!_seekPointArr[i]) return;
			
			var len:uint;
			var uByteLen:uint = _arrayByte.get(i).length;
			if (_seekPointArr[i][0] + uByteLen < _metaData.filesize) {
				if (_seekPointArr[i][2]) {
					len = _seekPointArr[i][2] - _seekPointArr[i][0];
					var start:int = _metaData.keyframes.filepositions.lastIndexOf(_seekPointArr[i][2]) + 1;
					if (start !== 0 && start !== _metaData.keyframes.filepositions.length) {
						var len2:uint = _metaData.keyframes.filepositions[start] - _seekPointArr[i][0];
						if (uByteLen === len2) {
							return;
						}
						else if (uByteLen > len2) {
							len = len2;
						}
					}
				}
			}
			if (len === 0 || len >= uByteLen) return;
			var ub:UByteArray = new UByteArray();
			var b:ByteArray = new ByteArray();
			
			var rLen:uint = 1024 << 12;
			_arrayByte.get(i).position = 0;
			while (len > 0) {
				rLen = rLen > len ? len : rLen;
				_arrayByte.get(i).readBytes(b, 0, rLen);
				ub.writeBytes(b);
				b.clear();
				len -= rLen;
			}
			_arrayByte.get(i).clear();
			_arrayByte.set(i, ub);
			
			b.clear();
			b = null;
		}
		
		/**
		 * 
		 * 加载数据
		 * @param request
		 * 
		 */
		public function load(request:Object):void
		{
			cutByte(index);
			
			if (isOne === true) {
				index = 0;
				_isReadHeader = true;
				super.close();
				super.play(null);
				appendBytesAction("endSequence");
				appendBytesAction("resetBegin");
			}
			else {
				index = _arrayByte.length;
			}
			if (index === 0) {
				_tSize = 0;
				_curFPosition = 0;
				_curFTime = 0;
			}
			_seekIndex = index;
			_arrayByte.set(index, new UByteArray());
			_seekPointArr[index] = [_curFPosition];
			_timePointArr[index] = _curFTime;
			
			TEvent.trigger(NAME, "NEW_STREAM", this);
			
			super.bufferTime = 0;
			
			load2(request);
			
			request = null;
		}
		
		override public function play(...parameters):void
		{
			TEvent.trigger(NAME, "CLEAR_PROGRESS_ALL");
			clearData();
			_arrayByte = new ArrayByte();
			_fileHeadArr = new ArrayByte();
			_seekPointArr = [];
			_timePointArr = [];
			_URLRequest = new URLRequest(parameters[0] as String);
			index = 0;
			_seekIndex = 0;
			_mergeIndex = 0;
			_curFPindex = 0;
			_curFPosition = 0;
			_tSize = 0;
			_curFTime = 0;
			_isReadHeader = true;
			super.play.apply(null, parameters);
			parameters = null;
		}
		
		/**
		 * 
		 * 加载播放数据
		 * @param request
		 * 
		 */
		public function playURL(request:Object):void
		{
			super.close();
			play(null);
			if (request is String) _URLRequest = new URLRequest(request as String);
			else _URLRequest = request as URLRequest;
			appendBytesAction("endSequence");
			appendBytesAction("resetBegin");
			load(_URLRequest);
			request = null;
		}
		
		/**
		 * 
		 * 清空流
		 * 
		 */
		public function clearStream():void
		{
			if (null !== _dStream) _dStream.clear();
			if (null !== _streamListeners && _streamListeners["CLEAR_STREAM"]) _streamListeners["CLEAR_STREAM"](this);
			_dStream = null;
			Memory.clear();
		}
		
		/**
		 * 
		 * 清空
		 * 
		 */
		override public function clear():void
		{
			clearStream();
			clearData();
			TEvent.clearTrigger(NAME);
			_clientListeners = null;
			_streamListeners = null;
			_checkURLF = null;
			NAME = null;
			super.clear();
			Memory.clear();
		}
		
	}
}