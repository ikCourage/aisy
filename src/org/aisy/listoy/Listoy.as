package org.aisy.listoy
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.utils.getDefinitionByName;
	
	import org.ais.event.TEvent;
	import org.aisy.display.USprite;

	/**
	 * 
	 * 列表组件，名称必须唯一
	 * 
	 * @author viqu
	 * 
	 */
	public class Listoy extends USprite
	{
		/**
		 * 组件名称，作为抛出事件的引用
		 */
		protected var _NAME:String;
		/**
		 * 数据对象
		 */
		protected var iData:ListoyData;
		
		public function Listoy()
		{
		}
		
		protected function getData():ListoyData
		{
			return null === iData ? iData = new ListoyData() : iData;
		}
		
		/**
		 * 
		 * 计算布局
		 * 
		 */
		protected function __layout():void
		{
			switch (getData().layout) {
				case ListoyEnum.LAYOUT_HORIZONTAL:
					iData.totalPage = Math.ceil(iData.columnTotal / iData.column);
					break;
				case ListoyEnum.LAYOUT_VERTICAL:
					iData.totalPage = Math.ceil(iData.rowTotal / iData.row);
					break;
			}
			iData.group.x = iData.group.y = 0;
			
			iData.moveWidth = (iData.maskWidth + iData.paddingH - iData.marginH) / iData.column;
			iData.moveHeight = (iData.maskHeight + iData.paddingV - iData.marginV) / iData.row;
			
			iData.itemRenderer = null;
			iData.dataProvider = null;
			
			if (iData.background === true) {
				graphics.beginFill(0x000000, 0);
				graphics.drawRect(0, 0, iData.maskWidth, iData.maskHeight);
				graphics.endFill();
			}
			
//			计算总页数
			TEvent.trigger(NAME, ListoyEvent.TOTAL_PAGE, iData.totalPage);
		}
		
		/**
		 * 
		 * 设置 显示行数、列数
		 * @param row
		 * @param column
		 * 
		 */
		public function setRowColumn(row:uint, column:uint):void
		{
			getData().row = row;
			iData.column = column;
			
			iData.movePositionH = column;
			iData.movePositionV = row;
		}
		
		/**
		 * 
		 * 设置 布局样式
		 * @param layout
		 * 
		 */
		public function setLayout(layout:uint):void
		{
			getData().layout = layout;
		}
		
		/**
		 * 
		 * 设置 外部缩进
		 * @param margin
		 * @param layout
		 * 当 layout = 0 时，设置（横向缩进、竖向缩进）
		 * 当 layout = 1 时，设置（横向缩进）
		 * 当 layout = 2 时，设置（竖向缩进）
		 * 
		 */
		public function setMargin(margin:Number, layout:uint = 0):void
		{
			switch (layout) {
				case 0:
					getData().marginH = margin;
					getData().marginV = margin;
					break;
				case 1:
					getData().marginH = margin;
					break;
				case 2:
					getData().marginV = margin;
					break;
			}
		}
		
		/**
		 * 
		 * 设置 内部缩进
		 * @param padding
		 * @param layout
		 * 当 layout = 0 时，设置（横向缩进、竖向缩进）
		 * 当 layout = 1 时，设置（横向缩进）
		 * 当 layout = 2 时，设置（竖向缩进）
		 * 
		 */
		public function setPadding(padding:Number, layout:uint = 0):void
		{
			switch (layout) {
				case 0:
					getData().paddingH = padding;
					getData().paddingV = padding;
					break;
				case 1:
					getData().paddingH = padding;
					break;
				case 2:
					getData().paddingV = padding;
					break;
			}
		}
		
		/**
		 * 
		 * 设置 移动偏移量
		 * @param position
		 * @param layout
		 * 当 layout = 0 时，设置（横向、竖向）移动偏移量
		 * 当 layout = 1 时，设置（横向移动偏移量）
		 * 当 layout = 2 时，设置（竖向移动偏移量）
		 * 
		 */
		public function setMovePosition(position:Number, layout:uint = 0):void
		{
			switch (layout) {
				case 0:
					getData().movePositionH = position;
					getData().movePositionV = position;
					break;
				case 1:
					getData().movePositionH = position;
					break;
				case 2:
					getData().movePositionV = position;
					break;
			}
		}
		
		/**
		 * 
		 * 设置 翻页延迟
		 * @param delay
		 * 
		 */
		public function setDelay(delay:Number):void
		{
			getData().delay = delay;
		}
		
		/**
		 * 
		 * 设置是否有背景
		 * @param background
		 * 
		 */
		public function setBackground(background:Boolean):void
		{
			getData().background = background;
		}
		
		/**
		 * 
		 * 设置 自定义项目渲染器
		 * @param itemRenderer
		 * 
		 */
		public function setItemRenderer(itemRenderer:Class):void
		{
			getData().itemRenderer = itemRenderer;
			itemRenderer = null;
		}
		
		/**
		 * 
		 * 设置 数据集
		 * @param dataProvider (Array or Vector)
		 * 
		 */
		public function setDataProvider(dataProvider:*):void
		{
			getData().dataProvider = dataProvider;
			dataProvider = null;
		}
		
		/**
		 * 
		 * 设置 偏移量
		 * @param value
		 * @param data
		 * 
		 */
		public function setCurrentPosition(value:uint, data:Object = null):void
		{
			if (null === data) data = {};
			getDefinitionByName("com.greensock.TweenLite").killTweensOf(getData().group);
//			当前页数
			var _p:uint;
//			当前所处最大边界值
			var _mv:uint;
			switch (iData.layout) {
				case ListoyEnum.LAYOUT_HORIZONTAL:
					_mv = (iData.columnTotal - iData.column) < 0 ? 0 : (iData.columnTotal - iData.column);
					iData.curColumn = value > _mv ? _mv : value;
					
					if (iData.curColumn === 0) {
						TEvent.trigger(NAME, ListoyEvent.PREVIOUS_END);
					}
					else if (iData.columnTotal - iData.curColumn <= iData.column) {
						iData.curColumn = (iData.columnTotal - iData.column) < 0 ? 0 : iData.curColumn;
						TEvent.trigger(NAME, ListoyEvent.NEXT_END);
					}
					
					_p = Math.ceil(iData.curColumn / iData.column);
					
					data.x = -iData.curColumn * iData.moveWidth;
					getDefinitionByName("com.greensock.TweenLite").to(iData.group, iData.delay, data);
					break;
				case ListoyEnum.LAYOUT_VERTICAL:
					_mv = (iData.rowTotal - iData.row) < 0 ? 0 : (iData.rowTotal - iData.row);
					iData.curRow = value > _mv ? _mv : value;
					
					if (iData.curRow === 0) {
						TEvent.trigger(NAME, ListoyEvent.PREVIOUS_END);
					}
					else if (iData.rowTotal - iData.curRow <= iData.row) {
						iData.curRow = (iData.rowTotal - iData.row) < 0 ? 0 : iData.curRow;
						TEvent.trigger(NAME, ListoyEvent.NEXT_END);
					}
					
					_p = Math.ceil(iData.curRow / iData.row);
					
					data.y = -iData.curRow * iData.moveHeight;
					getDefinitionByName("com.greensock.TweenLite").to(iData.group, iData.delay, data);
					break;
			}
			data = null;
			TEvent.trigger(NAME, ListoyEvent.PAGE, _p);
		}
		
		/**
		 * 
		 * 返回 翻页延迟
		 * @return 
		 * 
		 */
		public function getDelay():Number
		{
			return getData().delay;
		}
		
		/**
		 * 
		 * 返回 偏移量
		 * @return 
		 * 
		 */
		public function getCurrentPosition():uint
		{
			switch (getData().layout) {
				case ListoyEnum.LAYOUT_HORIZONTAL:
					return iData.curColumn;
					break;
				case ListoyEnum.LAYOUT_VERTICAL:
					return iData.curRow;
					break;
			}
			return 0;
		}
		
		/**
		 * 
		 * 返回 偏移量最大值
		 * @return 
		 * 
		 */
		public function getMaxPosition():uint
		{
			switch (getData().layout) {
				case ListoyEnum.LAYOUT_HORIZONTAL:
					return iData.columnTotal;
					break;
				case ListoyEnum.LAYOUT_VERTICAL:
					return iData.rowTotal;
					break;
			}
			return 0;
		}
		
		/**
		 * 
		 * 返回 显示宽度
		 * @return 
		 * 
		 */
		public function getWidth():Number
		{
			return getData().maskWidth;
		}
		
		/**
		 * 
		 * 返回 显示高度
		 * @return 
		 * 
		 */
		public function getHeight():Number
		{
			return getData().maskHeight;
		}
		
		/**
		 * 
		 * 清空显示 Item
		 * 以便重置 Listoy
		 * 
		 */
		public function clearItem():void
		{
			if (null === iData || null === iData.group) return;
			iData.clear();
			graphics.clear();
			if (null !== _NAME) TEvent.clearTrigger(_NAME + "ITEM");
		}
		
		/**
		 * 
		 * 清空显示对象及侦听
		 * 
		 */
		override public function clear():void
		{
			super.clear();
			if (null !== iData) {
				if (null !== iData.group) {
					iData.clear();
					graphics.clear();
				}
				iData = null;
			}
			if (null !== _NAME) {
				TEvent.clearTrigger(_NAME + "ITEM");
				TEvent.clearTrigger(_NAME);
				_NAME = null;
			}
		}
		
		/**
		 * 
		 * 设置组件名称
		 * @param value
		 * 
		 */
		public function set NAME(value:String):void
		{
			if (null !== _NAME) TEvent.clearTrigger(_NAME);
			_NAME = null === value ? Math.random().toString() : value;
			TEvent.newTrigger(_NAME, __triggerHandler);
			value = null;
		}
		
		/**
		 * 
		 * 返回组件名称
		 * @return 
		 * 
		 */
		public function get NAME():String
		{
			if (null === _NAME) NAME = null;
			return _NAME;
		}
		
		/**
		 * 
		 * 开始进行组件实例化
		 * 在 setItemRenderer，setdataProvider 后执行
		 * 
		 */
		public function initializeView():void
		{
			if (null === _NAME) NAME = null;
			if (null === getData().group) iData.group = new USprite();
			iData.rowTotal = 1;
			iData.columnTotal = 0;
			
			iData.curRow = iData.curColumn = 0;
			
			var len:uint = iData.dataProvider.length;
			var index:uint = 0;
			var x:Number = iData.marginH;
			var y:Number = iData.marginV;
			var _x:Number = iData.marginH;
			var _y:Number = iData.marginV;
			var w:Number = 0;
			var h:Number = 0;
			
			var obj:DisplayObject;
			
			var row:uint = iData.row;
			var column:uint = iData.column;
			
			while(index < len) {
				for (var i:uint = 0; i < row; i++) {
					for (var j:uint = 0; j < column; j++) {
//						创建 item
						obj = (new (iData.itemRenderer)(NAME, index, iData.dataProvider[index]));
						
						obj.x = x;
						obj.y = y;
						x += obj.width + iData.paddingH + iData.marginH;
						w = Math.max(w, obj.width);
						h = Math.max(h, obj.height);
						
						iData.group.addChild(obj);
						
						if (y === iData.marginV) {
							iData.columnTotal++;
						}
						
						if (index >= len - 1) {
							if (null === iData.group.parent) {
								addChildAt(iData.group, 0);
							}
							if (row * column >= len) {
								iData.maskWidth = iData.group.width + iData.marginH * 2;
								iData.maskHeight = iData.group.height + iData.marginV * 2;
							}
							else {
								iData.maskWidth = column * w + (column - 1) * iData.paddingH + (column + 1) * iData.marginH;
								iData.maskHeight = row * h + (row - 1) * iData.paddingV + (row + 1) * iData.marginV;
								
								if (null === iData.mask) {
									iData.mask = new Shape();
									iData.mask.visible = false;
									iData.group.mask = iData.mask;
								}
								iData.mask.graphics.clear();
								iData.mask.graphics.beginFill(0xff0000, 0.3);
								iData.mask.graphics.drawRect(0, 0, iData.maskWidth, iData.maskHeight);
								iData.mask.graphics.endFill();
								if (null === iData.mask.parent) {
									addChildAt(iData.mask, numChildren);
								}
							}
							__layout();
							obj = null;
							return;
						}
						
						index++;
					}
					
					switch (iData.layout) {
						case ListoyEnum.LAYOUT_HORIZONTAL:
							y += obj.height + iData.paddingV + iData.marginV;
							if (i === row - 1) {
								_x = x;
								y = iData.paddingV;
								y = iData.marginV;
							}
							x = _x;
							break;
						case ListoyEnum.LAYOUT_VERTICAL:
							x = iData.paddingH;
							x = iData.marginH;
							y += obj.height + iData.paddingV + iData.marginV;
							iData.rowTotal++;
							break;
					}
				}
			}
		}
		
		/**
		 * 
		 * 翻页事件
		 * @param type
		 * @param data
		 * 
		 */
		protected function __triggerHandler(type:String, data:* = null):void
		{
			if (getData().totalPage < 2) return;
			if (type !== ListoyEvent.PREVIOUS && type !== ListoyEvent.NEXT) return;
			if (null === data) data = {};
			var _pv:uint;
			switch (type) {
				case ListoyEvent.PREVIOUS:
					switch (iData.layout) {
						case ListoyEnum.LAYOUT_HORIZONTAL:
							_pv = (iData.curColumn - iData.movePositionH) < 0 ? 0 : (iData.curColumn - iData.movePositionH);
							break;
						case ListoyEnum.LAYOUT_VERTICAL:
							_pv = (iData.curRow - iData.movePositionV) < 0 ? 0 : (iData.curRow - iData.movePositionV);
							break;
					}
					break;
				case ListoyEvent.NEXT:
					switch (iData.layout) {
						case ListoyEnum.LAYOUT_HORIZONTAL:
							_pv = iData.curColumn + iData.movePositionH;
							break;
						case ListoyEnum.LAYOUT_VERTICAL:
							_pv = iData.curRow + iData.movePositionV;
							break;
					}
					break;
			}
			setCurrentPosition(_pv, data);
			type = null;
			data = null;
		}
		
	}
}