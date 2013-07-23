package org.aisy.net.data
{
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	import org.aisy.autoclear.AisyAutoClear;
	import org.aisy.interfaces.IClear;
	import org.aisy.utils.AisyUtils;

	/**
	 * 
	 * 根据运行环境自动选择的 ByteArray
	 * 当 FileStream 可用时，使用 FileStream 以减少内存占用
	 * 当将此写入其他 ByteArray 时，请使用 toByteArray
	 * 
	 * @author Viqu
	 * 
	 */
	public class UByteArray extends ByteArray implements IClear
	{
		protected var _tmpFile:*;
		protected var _tmpFileStream:*;
		protected var _isDestop:Boolean;
		protected var _buffer:ByteArray;
		protected var _bufferMax:uint;

		/**
		 * 
		 * 0: 自动, 1: ByteArray, !1: 文件
		 * @param type
		 * 
		 */
		public function UByteArray(type:int = 0)
		{
			switch (type) {
				case 0:
					_isDestop = AisyUtils.isDestop;
					break;
				default:
					_isDestop = type === 1 ? false : true;
					break;
			}
			if (_isDestop === true) {
				_bufferMax = 1024 << 11;
			}
		}
		
		override public function get bytesAvailable():uint
		{
			return _isDestop === true ? getTmpFileStream().bytesAvailable + _buffer.bytesAvailable : super.bytesAvailable;
		}
		
		override public function clear():void
		{
			AisyAutoClear.remove(this);
			if (_isDestop === true) {
				if (null != _tmpFileStream) _tmpFileStream.close();
				if (null != _tmpFile) _tmpFile.cancel();
				FileTemp.clearByOwner(this);
				_tmpFile = null;
				_tmpFileStream = null;
				_buffer = null;
			}
			super.clear();
		}
		
		override public function compress(algorithm:String = "zlib"):void
		{
			_isDestop === true ? tmpFileOp("compress", algorithm) : super.compress(algorithm);
		}
		
		override public function deflate():void
		{
			_isDestop === true ? tmpFileOp("deflate") : super.deflate();
		}
		
		override public function get endian():String
		{
			return _isDestop === true ? tmpFileOp("endian") : super.endian;
		}
		
		override public function set endian(type:String):void
		{
			_isDestop === true ? tmpFileOp("endian", type) : super.endian = type;
		}
		
		override public function inflate():void
		{
			_isDestop === true ? tmpFileOp("inflate") : super.inflate();
		}
		
		override public function get length():uint
		{
			return _isDestop === true ? tmpFileOp("length") : super.length;
		}
		
		override public function set length(value:uint):void
		{
			_isDestop === true ? tmpFileOp("length", value) : super.length = value;
		}
		
		override public function get objectEncoding():uint
		{
			return _isDestop === true ? tmpFileOp("objectEncoding") : super.objectEncoding;
		}
		
		override public function set objectEncoding(version:uint):void
		{
			_isDestop === true ? tmpFileOp("objectEncoding", version) : super.objectEncoding = version;
		}
		
		override public function get position():uint
		{
			return _isDestop === true ? tmpFileOp("position") : super.position;
		}
		
		override public function set position(offset:uint):void
		{
			_isDestop === true ? tmpFileOp("position", offset) : super.position = offset;
		}
		
		override public function readBoolean():Boolean
		{
			return _isDestop === true ? tmpFileOp("readBoolean") : super.readBoolean();
		}
		
		override public function readByte():int
		{
			return _isDestop === true ? tmpFileOp("readByte") : super.readByte();
		}
		
		override public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void
		{
			_isDestop === true ? tmpFileOp("readBytes", bytes, offset, length) : super.readBytes(bytes, offset, length);
		}
		
		override public function readDouble():Number
		{
			return _isDestop === true ? tmpFileOp("readDouble") : super.readDouble();
		}
		
		override public function readFloat():Number
		{
			return _isDestop === true ? tmpFileOp("readFloat") : super.readFloat();
		}
		
		override public function readInt():int
		{
			return _isDestop === true ? tmpFileOp("readInt") : super.readInt();
		}
		
		override public function readMultiByte(length:uint, charSet:String):String
		{
			return _isDestop === true ? tmpFileOp("readMultiByte", length, charSet) : super.readMultiByte(length, charSet);
		}
		
		override public function readObject():*
		{
			return _isDestop === true ? tmpFileOp("readObject") : super.readObject();
		}
		
		override public function readShort():int
		{
			return _isDestop === true ? tmpFileOp("readShort") : super.readShort();
		}
		
		override public function readUTF():String
		{
			return _isDestop === true ? tmpFileOp("readUTF") : super.readUTF();
		}
		
		override public function readUTFBytes(length:uint):String
		{
			return _isDestop === true ? tmpFileOp("readUTFBytes", length) : super.readUTFBytes(length);
		}
		
		override public function readUnsignedByte():uint
		{
			return _isDestop === true ? tmpFileOp("readUnsignedByte") : super.readUnsignedByte();
		}
		
		override public function readUnsignedInt():uint
		{
			return _isDestop === true ? tmpFileOp("readUnsignedInt") : super.readUnsignedInt();
		}
		
		override public function readUnsignedShort():uint
		{
			return _isDestop === true ? tmpFileOp("readUnsignedShort") : super.readUnsignedShort();
		}
		
		override public function toString():String
		{
			return _isDestop === true ? tmpFileOp("toString") : super.toString();
		}
		
		override public function uncompress(algorithm:String="zlib"):void
		{
			_isDestop === true ? tmpFileOp("uncompress", algorithm) : super.uncompress(algorithm);
		}
		
		override public function writeBoolean(value:Boolean):void
		{
			_isDestop === true ? tmpFileOp("writeBoolean", value) : super.writeBoolean(value);
		}
		
		override public function writeByte(value:int):void
		{
			_isDestop === true ? tmpFileOp("writeByte", value) : super.writeByte(value);
		}
		
		override public function writeBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void
		{
			_isDestop === true ? tmpFileOp("writeBytes", bytes, offset, length) : super.writeBytes(bytes, offset, length);
		}
		
		override public function writeDouble(value:Number):void
		{
			_isDestop === true ? tmpFileOp("writeDouble", value) : super.writeDouble(value);
		}
		
		override public function writeFloat(value:Number):void
		{
			_isDestop === true ? tmpFileOp("writeFloat", value) : super.writeFloat(value);
		}
		
		override public function writeInt(value:int):void
		{
			_isDestop === true ? tmpFileOp("writeInt", value) : super.writeInt(value);
		}
		
		override public function writeMultiByte(value:String, charSet:String):void
		{
			_isDestop === true ? tmpFileOp("writeMultiByte", value, charSet) : super.writeMultiByte(value, charSet);
		}
		
		override public function writeObject(object:*):void
		{
			_isDestop === true ? tmpFileOp("writeObject", object) : super.writeObject(object);
		}
		
		override public function writeShort(value:int):void
		{
			_isDestop === true ? tmpFileOp("writeShort", value) : super.writeShort(value);
		}
		
		override public function writeUTF(value:String):void
		{
			_isDestop === true ? tmpFileOp("writeUTF", value) : super.writeUTF(value);
		}
		
		override public function writeUTFBytes(value:String):void
		{
			_isDestop === true ? tmpFileOp("writeUTFBytes", value) : super.writeUTFBytes(value);
		}
		
		override public function writeUnsignedInt(value:uint):void
		{
			_isDestop === true ? tmpFileOp("writeUnsignedInt", value) : super.writeUnsignedInt(value);
		}
		
		public function hasOwnProperty(V:* = null):Boolean
		{
			return _isDestop === true ? tmpFileOp("hasOwnProperty", V) : super.hasOwnProperty(V);
		}
		
		public function isPrototypeOf(V:* = null):Boolean
		{
			return _isDestop === true ? tmpFileOp("isPrototypeOf", V) : super.isPrototypeOf(V);
		}
		
		public function propertyIsEnumerable(V:* = null):Boolean
		{
			return _isDestop === true ? tmpFileOp("propertyIsEnumerable", V) : super.propertyIsEnumerable(V);
		}
		
		public function getBufferMax():uint
		{
			return _bufferMax;
		}
		
		public function setBufferMax(value:uint):void
		{
			_bufferMax = value;
		}
		
		public function toByteArray(offset:uint = 0, length:uint = 0):ByteArray
		{
			if (offset !== 0 || length !== 0 || _isDestop === true) {
				var tp:uint = position;
				var tb:ByteArray = new ByteArray();
				position = offset;
				readBytes(tb, 0, length);
				position = tp;
				return tb;
			}
			else {
				return this;
			}
		}
		
		protected function flushData():void
		{
			if (null == _tmpFileStream || _buffer.length === 0) return;
			getTmpFileStream().writeBytes(_buffer);
			_buffer.clear();
		}
		
		protected function tmpFileOp(op:String, ...parameters):*
		{
			switch (op) {
				case "writeBoolean":
				case "writeByte":
				case "writeBytes":
				case "writeDouble":
				case "writeFloat":
				case "writeInt":
				case "writeMultiByte":
				case "writeObject":
				case "writeShort":
				case "writeUTF":
				case "writeUTFBytes":
				case "writeUnsignedInt":
					if (null !== _buffer && _buffer.length < _bufferMax) {
						return _buffer[op].apply(null, parameters);
					}
					else {
						flushData();
					}
					break;
				case "readBoolean":
				case "readByte":
				case "readDouble":
				case "readFloat":
				case "readInt":
				case "readShort":
				case "readUnsignedByte":
				case "readUnsignedInt":
				case "readUnsignedShort":
					if (getTmpFileStream().bytesAvailable < 64) {
						flushData();
					}
					break;
				case "readBytes":
					if (getTmpFileStream().bytesAvailable === 0 || getTmpFileStream().bytesAvailable < parameters[2] || parameters[2] === 0) {
						flushData();
					}
					break;
				case "readMultiByte":
				case "readUTFBytes":
					if (getTmpFileStream().bytesAvailable < parameters[0]) {
						flushData();
					}
					break;
				case "readObject":
				case "readUTF":
					flushData();
					break;
				case "length":
					if (parameters.length !== 0) {
						flushData();
						if (null === _buffer) {
							_buffer = new ByteArray();
						}
						getTmpFileStream().position = 0;
						getTmpFileStream().readBytes(_buffer, 0, getTmpFileStream().bytesAvailable);
						_buffer.length = parameters[0];
						getTmpFileStream().close();
						_tmpFileStream.open(_tmpFile, getDefinitionByName("flash.filesystem.FileMode").WRITE);
						_tmpFileStream.writeBytes(_buffer);
						_tmpFileStream.close();
						_tmpFileStream.open(_tmpFile, getDefinitionByName("flash.filesystem.FileMode").UPDATE);
						getTmpFileStream().position = 0;
						_buffer.clear();
					}
					else {
						if (null == _tmpFile) return 0;
						return getTmpFileStream().position + getTmpFileStream().bytesAvailable + _buffer.length;
					}
					return null;
					break;
				case "position":
					if (parameters.length !== 0) {
						flushData();
						getTmpFileStream()[op] = parameters[0];
					}
					else {
						return getTmpFileStream()[op] + _buffer.position;;
					}
					return null;
					break;
				case "endia":
				case "objectEncoding":
					if (parameters.length !== 0) {
						flushData();
						getTmpFileStream()[op] = parameters[0];
					}
					else {
						return getTmpFileStream()[op];
					}
					return null;
					break;
			}
			return getTmpFileStream()[op].apply(null, parameters);
		}
		
		protected function getTmpFileStream():*
		{
			if (null === _buffer) _buffer = new ByteArray();
			if (null == _tmpFile) _tmpFile = FileTemp.createTempFile(this);
			if (null == _tmpFileStream) {
				_tmpFileStream = new (getDefinitionByName("flash.filesystem.FileStream") as Class)();
				_tmpFileStream.open(_tmpFile, getDefinitionByName("flash.filesystem.FileMode").UPDATE);
			}
			return _tmpFileStream;
		}
		
	}
}