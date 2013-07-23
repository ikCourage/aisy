package org.aisy.ulist
{
	import flash.geom.Rectangle;
	
	import org.aisy.display.USprite;
	import org.aisy.listoy.Listoy;
	import org.aisy.scroller.Scroller;

	/**
	 * 
	 * 下拉列表组件
	 * 
	 * @author Viqu
	 * 
	 */
	public class UList extends USprite
	{
		/**
		 * 名称
		 */
		public var NAME:String;
		/**
		 * 标题
		 */
		protected var _label:*;
		/**
		 * 列表
		 */
		protected var _listoy:Listoy;
		/**
		 * 滚动条
		 */
		protected var _scroller:Scroller;
		/**
		 * 列表 容器
		 */
		protected var _listGroup:USprite;
		/**
		 * 组件的数据属性	源自 Class UListData
		 */
		protected var iData:UListData;
		/**
		 * 是否显示列表
		 */
		public var isShow:Boolean;
		
		public function UList()
		{
			init();
		}
		
		/**
		 * 
		 * 初始化
		 * 
		 */
		protected function init():void
		{
			iData = new UListData();
		}
		
		/**
		 * 
		 * 开始进行组件实例化
		 * 在 setLabel，setListItem，setListData 后执行
		 * 
		 */
		public function initializeView():void
		{
			if (null === _listoy) {
				var l:Listoy = new Listoy();
				l.setPadding(0);
				l.setRowColumn(iData.listData.length, 1);
				l.setItemRenderer(iData.listItem);
				l.setDataProvider(iData.listData);
				setListoy(l);
				l = null;
				iData.listItem = null;
				iData.listData = null;
			}
			
			if (undefined === _label) {
				_label = new iData.labelClass(NAME, iData.labelData);
				addChild(_label);
				iData.labelClass = null;
				iData.labelData = null;
			}
			
			if (null !== _listGroup) _listGroup.clear();
			else _listGroup = new USprite();
			
			_listoy.initializeView();
			
			if (null === _scroller) {
				var s:Scroller = new Scroller();
				s.setSource(_listoy);
				setScroll(s);
				s = null;
			}
			_scroller.setSize(iData.scrollWidth, iData.scrollHeight);
			
			_listGroup.addChild(_scroller);
		}
		
		/**
		 * 
		 * 设置标题渲染类，数据
		 * 
		 * @param label
		 * @param data
		 * 
		 */
		public function setLabel(label:Class, data:*):void
		{
			setLabelClass(label);
			setLabelData(data);
			label = null;
			data = null;
		}
		
		/**
		 * 
		 * 设置标题渲染类
		 * 
		 * @param value
		 * 
		 */
		public function setLabelClass(value:Class):void
		{
			iData.labelClass = value;
			value = null;
		}
		
		/**
		 * 
		 * 设置标题渲染数据
		 * 
		 * @param value
		 * 
		 */
		public function setLabelData(value:*):void
		{
			iData.labelData = value;
			value = null;
		}
		
		/**
		 * 
		 * 设置 Listoy Item 渲染类
		 * 
		 * @param value
		 * 
		 */
		public function setListItem(value:Class):void
		{
			iData.listItem = value;
			value = null;
		}
		
		/**
		 * 
		 * 设置 Listoy 数据
		 * 
		 * @param value (Array or Vector)
		 * 
		 */
		public function setListData(value:*):void
		{
			iData.listData = value;
			value = null;
		}
		
		/**
		 * 
		 * 设置 Scrolloer 宽高
		 * 
		 * @param width
		 * @param height
		 * 
		 */
		public function setScrollSize(width:Number = 0, height:Number = 0):void
		{
			iData.scrollWidth = width;
			iData.scrollHeight = height;
		}
		
		/**
		 * 
		 * 设置 Scroller
		 * 
		 * @param value
		 * 
		 */
		public function setScroll(value:Scroller):void
		{
			_scroller = value;
			value = null;
		}
		
		/**
		 * 
		 * 设置 Listoy
		 * 
		 * @param value
		 * 
		 */
		public function setListoy(value:Listoy):void
		{
			if (null !== _listoy) _listoy.clear();
			_listoy = value;
			NAME = value.NAME;
			value = null;
		}
		
		/**
		 * 
		 * 返回 Listoy
		 * 
		 * @return 
		 * 
		 */
		public function getListoy():Listoy
		{
			return _listoy;
		}
		
		/**
		 * 
		 * 返回 Scroller
		 * 
		 * @return 
		 * 
		 */
		public function getScroll():Scroller
		{
			return _scroller;
		}
		
		/**
		 * 
		 * 返回列表容器
		 * 
		 * @return 
		 * 
		 */
		public function getGroup():USprite
		{
			return _listGroup;
		}
		
		/**
		 * 
		 * 显示列表
		 * 
		 */
		public function showList():void
		{
			isShow = !isShow;
			if (isShow === false) {
				stage.removeChild(_listGroup);
				return;
			}
			var _r:Rectangle = _label.getBounds(stage);
			_r = new Rectangle(_r.x, _r.y + _r.height, _scroller.width, _scroller.height);
			
			var _resize:Boolean;
			if (iData.scrollWidth !== _scroller.width || iData.scrollHeight !== _scroller.height) _resize = true;
			
			var _p:Number = 9;
			if (_r.width > stage.stageWidth - _p * 2) {
				_r.x = _p;
				_r.width = stage.stageWidth - _p * 2;
				_resize = true;
			}
			else if (_r.x < _p) {
				_r.x = _p;
			}
			else if (_r.x + _r.width > stage.stageWidth - _p) {
				_r.x = stage.stageWidth - _r.width - _p;
			}
			if (_r.height > stage.stageHeight - _p * 2) {
				_r.y = 9;
				_r.height = stage.stageHeight - 9 * 2;
				_resize = true;
			}
			else if (_r.y + _r.height > stage.stageHeight - _p) {
				_r.y = stage.stageHeight - _r.height - _p;
			}
			
			if (_resize === true) {
				var obj:*;
				var i:uint, len:uint = _listGroup.numChildren;
				for (i = 0; i < len; i++) {
					obj = _listGroup.getChildAt(i);
					if (obj is Scroller) {
						obj.setSize(_r.width, _r.height);
					}
					else {
						obj.width = _r.width;
						obj.height = _r.height;
					}
				}
			}
			
			_listGroup.x = _r.x;
			_listGroup.y = _r.y;
			
			stage.addChild(_listGroup);
		}
		
		/**
		 * 
		 * 隐藏列表
		 * 
		 */
		public function hideList():void
		{
			isShow = false;
			if (null !== _listGroup.parent) _listGroup.parent.removeChild(_listGroup);
		}
		
		/**
		 * 
		 * 全局侦听
		 * 
		 * @param type
		 * @param data
		 * 
		 */
		protected function __triggerHandler(type:String, data:* = null):void
		{
			switch (type) {
				case "SHOW":
					showList();
					break;
			}
			type = null;
			data = null;
		}
		
		/**
		 * 
		 * 清空
		 * 
		 */
		override public function clear():void
		{
			if (null !== _listoy) _listoy.clear();
			if (null !== _scroller) _scroller.clear();
			if (null !== _listGroup) _listGroup.clear();
			
			NAME = null;
			
			_label = null;
			_listoy = null;
			_scroller = null;
			_listGroup = null;
			
			iData.clear();
			iData = null;
			
			super.clear();
		}
		
	}
}