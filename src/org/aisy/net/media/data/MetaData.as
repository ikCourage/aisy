package org.aisy.net.media.data
{
	public dynamic class MetaData
	{
		public var audiocodecid:uint;
		public var audiodatarate:Number;
		public var audiosamplerate:uint;
		public var audiosamplesize:uint;
		public var audiosize:uint;
		public var canSeekToEnd:Boolean;
		public var creator:String;
		public var datasize:uint;
		public var duration:Number;
		public var filesize:uint;
		public var framerate:Number;
		public var hasAudio:Boolean;
		public var hasKeyframes:Boolean;
		public var hasMetadata:Boolean;
		public var hasVideo:Boolean;
		public var height:Number;
		public var keyframes:Object;
		public var lastkeyframelocation:uint;
		public var lastkeyframetimestamp:Number;
		public var lasttimestamp:Number;
		public var length:uint;
		public var metadatacreator:String;
		public var stereo:Boolean;
		public var videocodecid:uint;
		public var videodatarate:Number;
		public var videosize:uint;
		public var width:Number;
		
		public function MetaData()
		{
		}
		
		public function setData(data:*):void
		{
			for (var i:String in data) {
				this[i] = data[i];
			}
			data = null;
		}
		
	}
}