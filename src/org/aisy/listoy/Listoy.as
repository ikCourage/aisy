package org.aisy.listoy
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.utils.getDefinitionByName;
	
	import org.ais.event.TEvent;
	import org.aisy.display.USprite;
	import org.aisy.skin.AisySkin;

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
		 * 计算布局
		 */
		protected function __layout():void
		{
			iData.group.x = iData.group.y = 0;
			if (iData.mode !== ListoyEnum.MODE_SHOW) {
				iData.curPage = 1;
				iData.totalPage = iData.dataProvider.length === 0 ? 1 : Math.ceil(iData.dataProvider.length / (iData.row * iData.column));
				iData.moveWidth = (iData.maskWidth + iData.paddingH - iData.marginH) / iData.column;
				iData.moveHeight = (iData.maskHeight + iData.paddingV - iData.marginV) / iData.row;
				if (iData.background === true) {
					graphics.beginFill(0x000000, 0);
					graphics.drawRect(0, 0, iData.maskWidth, iData.maskHeight);
					graphics.endFill();
				}
			}
			switch (iData.mode) {
				case ListoyEnum.MODE_PAGE:
					break;
				case ListoyEnum.MODE_SHOW:
					if (null !== iData.group && iData.group.numChildren !== 0) {
						var len:uint = iData.dataProvider.length;
						var obj:DisplayObject = iData.group.getChildAt(0);
						iData.moveWidth = obj.width + iData.marginH + iData.paddingH;
						iData.moveHeight = obj.height + iData.marginV + iData.paddingV;
						if (iData.column === 1) {
							iData.maskHeight = iData.marginV * 2 + iData.moveHeight * (len - 1) + obj.height;
						}
						else {
							iData.maskWidth = iData.marginH * 2 + iData.moveWidth * (len - 1) + obj.width;
						}
						iData.curPage = 0;
						iData.itemRenderer = null;
						obj = null;
					}
					break;
				default:
					iData.itemRenderer = null;
					iData.dataProvider = null;
					break;
			}
		}
		
		/**
		 * 当 mode = 2 时，
		 * 通过 (ListoyEvent.ITEM_INSHOW, function(index:uint)) 
		 * 和 (ListoyEvent.ITEM_RESET, [function(index:uint, item:ListoyItem), dataProvider, dataProvider.length]) 来重用 item
		 */
		protected function __scroll():void
		{
			var s:uint, l:Number;
			if (iData.column === 1) {
				if (iData.row >= iData.dataProvider.length) return;
				l = -(y + iData.marginV);
				if (l > 0) {
					s = l / iData.moveHeight;
					if (s > 0 && l % iData.moveHeight === 0) {
						s--;
					}
				}
			}
			else {
				if (iData.column >= iData.dataProvider.length) return;
				l = -(x + iData.marginH);
				if (l > 0) {
					s = l / iData.moveWidth;
					if (s > 0 && l % iData.moveWidth === 0) {
						s--;
					}
				}
			}
			if (s === iData.curPage) return;
			var i:uint, j:uint, e:uint = s + iData.row * iData.column - 1;
			var v:Array = [];
			var f:Function = function (index:uint):void
			{
				if (index < s || index > e) {
					v[j++] = index;
				}
				else if (index > i) {
					i = index;
				}
			};
			TEvent.trigger(NAME + "ITEM", ListoyEvent.ITEM_INSHOW, f);
			i = s > iData.curPage ? i + 1 : s;
			i = i > s ? i : s;
			iData.curPage = s;
			f = function (index:uint, obj:DisplayObject):uint
			{
				if (v.indexOf(index) !== -1) {
					index = i++;
					if (iData.column === 1) {
						obj.y = iData.marginV + iData.moveHeight * index;
					}
					else {
						obj.x = iData.marginH + iData.moveWidth * index;
					}
				}
				return index;
			};
			TEvent.trigger(NAME + "ITEM", ListoyEvent.ITEM_RESET, [f, iData.dataProvider, iData.dataProvider.length]);
			v = null;
			f = null;
		}
		
		/**
		 * 翻页事件
		 * @param type
		 * @param data
		 */
		protected function __triggerHandler(type:String, data:* = null):void
		{
			if ((type !== ListoyEvent.PREVIOUS && type !== ListoyEvent.NEXT) || null === iData || (iData.mode === ListoyEnum.MODE_ALL && iData.totalPage < 2) || iData.mode === ListoyEnum.MODE_SHOW) return;
			if (null === data) data = {};
			switch (type) {
				case ListoyEvent.PREVIOUS:
					setCurrentPage(iData.curPage < 3 ? 1 : iData.curPage - 1, data);
					break;
				case ListoyEvent.NEXT:
					setCurrentPage(iData.curPage + 1, data);
					break;
			}
			type = null;
			data = null;
		}
		
		/**
		 * 设置组件名称
		 * @param value
		 */
		public function set NAME(value:String):void
		{
			if (null !== _NAME) {
				TEvent.clearTrigger(_NAME + "ITEM");
				TEvent.clearTrigger(_NAME);
			}
			_NAME = null === value ? Math.random().toString() : value;
			TEvent.newTrigger(_NAME, __triggerHandler);
			value = null;
		}
		
		/**
		 * 返回组件名称
		 * @return 
		 */
		public function get NAME():String
		{
			if (null === _NAME) NAME = null;
			return _NAME;
		}
		
		/**
		 * 设置 显示行数、列数
		 * @param row
		 * @param column
		 */
		public function setRowColumn(row:uint, column:uint):void
		{
			getData().row = row;
			iData.column = column;
			
			iData.movePositionH = column;
			iData.movePositionV = row;
		}
		
		/**
		 * 当 mode = 2 时，
		 * 通过 item 的大小和显示区域的大小来计算并设置 row 和 column
		 * 当 layout = 0 时，row = 1
		 * 当 layout = 1 时，column = 1
		 * @param itemSize
		 * @param viewSize
		 * @param layout
		 * @return 
		 */
		public function setRowColumn2(itemSize:Number, viewSize:Number, layout:uint = 1):uint
		{
			viewSize -= layout === ListoyEnum.LAYOUT_VERTICAL ? getData().marginV : getData().marginH;
			itemSize += layout === ListoyEnum.LAYOUT_VERTICAL ? iData.marginV + iData.paddingV : iData.marginH + iData.paddingH;
			var i:uint = Math.ceil(viewSize / itemSize) + 1;
			layout === ListoyEnum.LAYOUT_VERTICAL ? setRowColumn(i, 1) : setRowColumn(1, i);
			return i;
		}
		
		/**
		 * 设置 渲染方式
		 * @param value
		 */
		public function setMode(mode:uint = 0):void
		{
			getData().mode = mode;
		}
		
		/**
		 * 设置 布局样式
		 * @param layout
		 */
		public function setLayout(layout:uint):void
		{
			getData().layout = layout;
		}
		
		/**
		 * 设置 外部缩进
		 * @param margin
		 * @param layout
		 * 当 layout = 0 时，设置（横向缩进、竖向缩进）
		 * 当 layout = 1 时，设置（横向缩进）
		 * 当 layout = 2 时，设置（竖向缩进）
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
		 * 设置 内部缩进
		 * @param padding
		 * @param layout
		 * 当 layout = 0 时，设置（横向缩进、竖向缩进）
		 * 当 layout = 1 时，设置（横向缩进）
		 * 当 layout = 2 时，设置（竖向缩进）
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
		 * 设置 移动偏移量
		 * @param position
		 * @param layout
		 * 当 layout = 0 时，设置（横向、竖向）移动偏移量
		 * 当 layout = 1 时，设置（横向移动偏移量）
		 * 当 layout = 2 时，设置（竖向移动偏移量）
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
		 * 设置 翻页持续时间
		 * @param duration
		 */
		public function setDuration(duration:Number):void
		{
			getData().duration = duration;
		}
		
		/**
		 * 设置是否有背景
		 * @param background
		 */
		public function setBackground(background:Boolean):void
		{
			getData().background = background;
		}
		
		/**
		 * 设置 自定义项目渲染器
		 * @param itemRenderer （Class or Function）
		 */
		public function setItemRenderer(itemRenderer:Object):void
		{
			getData().itemRenderer = itemRenderer;
			itemRenderer = null;
		}
		
		/**
		 * 设置 数据集
		 * @param dataProvider (Array or Vector)
		 */
		public function setDataProvider(dataProvider:Object):void
		{
			getData().dataProvider = dataProvider;
			switch (iData.mode) {
				case ListoyEnum.MODE_SHOW:
					if (null !== iData.group && iData.group.numChildren !== 0) {
						var len:uint = iData.dataProvider.length;
						var obj:DisplayObject = iData.group.getChildAt(0);
						if (iData.column === 1) {
							iData.maskHeight = iData.marginV * 2 + iData.moveHeight * (len - 1) + obj.height;
						}
						else {
							iData.maskWidth = iData.marginH * 2 + iData.moveWidth * (len - 1) + obj.width;
						}
						obj = null;
					}
					break;
			}
			dataProvider = null;
		}
		
		/**
		 * 设置 偏移量
		 * @param position
		 * @param data
		 */
		public function setCurrentPosition(position:uint, data:Object = null):void
		{
			if (null === data) data = {};
			getDefinitionByName(AisySkin.TWEEN_LITE).killTweensOf(getData().group);
//			当前所处最大边界值
			var m:uint;
			switch (iData.layout) {
				case ListoyEnum.LAYOUT_HORIZONTAL:
					m = iData.columnTotal < iData.column ? 0 : (iData.columnTotal - iData.column);
					iData.curColumn = position > m ? m : position;
					if (iData.curColumn === 0) {
						TEvent.trigger(NAME, ListoyEvent.PREVIOUS_END);
					}
					else if (iData.columnTotal <= iData.column + iData.curColumn) {
						iData.curColumn = iData.columnTotal < iData.column ? 0 : iData.curColumn;
						TEvent.trigger(NAME, ListoyEvent.NEXT_END);
					}
					iData.curPage = Math.ceil(iData.curColumn / iData.column) + 1;
					data.x = -iData.curColumn * iData.moveWidth;
					getDefinitionByName(AisySkin.TWEEN_LITE).to(iData.group, iData.duration, data);
					break;
				case ListoyEnum.LAYOUT_VERTICAL:
					m = iData.rowTotal < iData.row ? 0 : (iData.rowTotal - iData.row);
					iData.curRow = position > m ? m : position;
					if (iData.curRow === 0) {
						TEvent.trigger(NAME, ListoyEvent.PREVIOUS_END);
					}
					else if (iData.rowTotal <= iData.row + iData.curRow) {
						iData.curRow = iData.rowTotal < iData.row ? 0 : iData.curRow;
						TEvent.trigger(NAME, ListoyEvent.NEXT_END);
					}
					iData.curPage = Math.ceil(iData.curRow / iData.row) + 1;
					data.y = -iData.curRow * iData.moveHeight;
					getDefinitionByName(AisySkin.TWEEN_LITE).to(iData.group, iData.duration, data);
					break;
			}
			TEvent.trigger(NAME, ListoyEvent.PAGE, [getCurrentPage(), getTotalPage()]);
			data = null;
		}
		
		/**
		 * 设置 页数
		 * @param page
		 * @param data
		 */
		public function setCurrentPage(page:uint, data:Object = null):void
		{
			var t:uint = getTotalPage();
			page = page === 0 ? 1 : page;
			page = page > t ? t : page;
			var b:Boolean;
			if (null !== data && data.hasOwnProperty("R") === true) {
				b = Boolean(data["R"]);
				delete data["R"];
			}
			if (b === false && page === iData.curPage) return;
			switch (iData.mode) {
				case ListoyEnum.MODE_ALL:
					page--;
					switch (iData.layout) {
						case ListoyEnum.LAYOUT_HORIZONTAL:
							setCurrentPosition(page * iData.column, data);
							break;
						case ListoyEnum.LAYOUT_VERTICAL:
							setCurrentPosition(page * iData.row, data);
							break;
					}
					break;
				case ListoyEnum.MODE_PAGE:
					var itemRenderer:Object = iData.itemRenderer;
					var dataProvider:Object = iData.dataProvider;
					var len:uint = iData.row * iData.column;
					var p:uint = iData.curPage;
					var arr:Object = dataProvider.slice((p - 1) * len, p * len);
					var arr2:Object = dataProvider.slice((page - 1) * len, page * len);
					clearItem();
					setItemRenderer(itemRenderer);
					if (page < p) {
						setDataProvider(arr2.concat(arr));
						initializeView();
						var duration:Number = iData.duration;
						setDuration(0);
						setCurrentPosition(uint.MAX_VALUE);
						setDuration(duration);
						setCurrentPosition(0, data);
					}
					else {
						setDataProvider(arr.concat(arr2));
						initializeView();
						setCurrentPosition(uint.MAX_VALUE, data);
					}
					if (page === 1) {
						TEvent.trigger(NAME, ListoyEvent.PREVIOUS_END);
					}
					else if (page === iData.totalPage) {
						TEvent.trigger(NAME, ListoyEvent.NEXT_END);
					}
					setDataProvider(dataProvider);
					iData.totalPage = t;
					iData.curPage = page;
					TEvent.trigger(NAME, ListoyEvent.PAGE, [getCurrentPage(), getTotalPage()]);
					itemRenderer = null;
					dataProvider = null;
					arr = null;
					arr2 = null;
					break;
			}
		}
		
		/**
		 * 开始进行组件实例化
		 * 在 setItemRenderer，setdataProvider 后执行
		 */
		public function initializeView():void
		{
			if (null === _NAME) NAME = null;
			if (null === getData().group) iData.group = new USprite();
			iData.rowTotal = 1;
			iData.columnTotal = 0;
			iData.curRow = iData.curColumn = 0;
			var itemRenderer:Object = iData.itemRenderer;
			var dataProvider:Object = iData.dataProvider;
			var row:uint = iData.row;
			var column:uint = iData.column;
			var len:uint = dataProvider.length;
			var len2:uint = row * column;
			var index:uint = 0;
			var _x:Number = iData.marginH;
			var _y:Number = iData.marginV;
			var _x2:Number = iData.marginH;
			var w:Number = 0;
			var h:Number = 0;
			var obj:DisplayObject;
			switch (iData.mode) {
				case ListoyEnum.MODE_PAGE:
					len2 <<= 1;
					if (len > len2) {
						len = len2;
						dataProvider = dataProvider.slice(0, len);
					}
					break;
				case ListoyEnum.MODE_SHOW:
					if (len > len2) {
						len = len2;
						dataProvider = dataProvider.slice(0, len);
					}
					break;
			}
			while (index < len) {
				for (var i:uint = 0; index < len && i < row; i++) {
					for (var j:uint = 0; index < len && j < column; j++) {
//						创建 item
						obj = itemRenderer is Class ? (new (itemRenderer)(NAME, index, dataProvider[index])) : itemRenderer(NAME, index, dataProvider[index]);
						obj.x = _x;
						obj.y = _y;
						_x += obj.width + iData.paddingH + iData.marginH;
						w = Math.max(w, obj.width);
						h = Math.max(h, obj.height);
						iData.group.addChild(obj);
						if (_y === iData.marginV) iData.columnTotal++;
						index++;
					}
					if (index < len) {
						switch (iData.layout) {
							case ListoyEnum.LAYOUT_HORIZONTAL:
								_y += obj.height + iData.paddingV + iData.marginV;
								if (i === row - 1) {
									_x2 = _x;
									_y = iData.marginV;
								}
								_x = _x2;
								break;
							case ListoyEnum.LAYOUT_VERTICAL:
								_x = iData.marginH;
								_y += obj.height + iData.paddingV + iData.marginV;
								iData.rowTotal++;
								break;
						}
					}
				}
			}
			if (null === iData.group.parent) {
				addChild(iData.group);
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
				iData.mask.graphics.beginFill(0xFF0000, 0.3);
				iData.mask.graphics.drawRect(0, 0, iData.maskWidth, iData.maskHeight);
				iData.mask.graphics.endFill();
				if (null === iData.mask.parent) {
					addChild(iData.mask);
				}
			}
			__layout();
			itemRenderer = null;
			dataProvider = null;
			obj = null;
		}
		
		/**
		 * 返回 翻页持续时间
		 * @return 
		 */
		public function getDuration():Number
		{
			return getData().duration;
		}
		
		/**
		 * 返回 偏移量
		 * @return 
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
		 * 返回 偏移量最大值
		 * @return 
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
		 * 返回 当前页数
		 * @return 
		 */
		public function getCurrentPage():uint
		{
			var p:uint = getData().curPage;
			if (p === 0) {
				getData().curPage = p = 1;
			}
			return p;
		}
		
		/**
		 * 返回 总页数
		 * @return 
		 */
		public function getTotalPage():uint
		{
			var p:uint = getData().totalPage;
			if (p === 0) {
				getData().totalPage = p = 1;
			}
			return p;
		}
		
		/**
		 * 返回 显示宽度
		 * @return 
		 */
		public function getWidth():Number
		{
			return null === iData ? 0 : iData.maskWidth;
		}
		
		/**
		 * 返回 显示高度
		 * @return 
		 */
		public function getHeight():Number
		{
			return null === iData ? 0 : iData.maskHeight;
		}
		
		override public function set x(value:Number):void
		{
			if (super.x === value) return;
			super.x = value;
			if (null !== iData && iData.mode === ListoyEnum.MODE_SHOW) __scroll();
		}
		
		override public function set y(value:Number):void
		{
			if (super.y === value) return;
			super.y = value;
			if (null !== iData && iData.mode === ListoyEnum.MODE_SHOW) __scroll();
		}
		
		override public function get width():Number
		{
			return (null === iData || iData.mode !== ListoyEnum.MODE_SHOW) ? super.width : iData.maskWidth;
		}
		
		override public function get height():Number
		{
			return (null === iData || iData.mode !== ListoyEnum.MODE_SHOW) ? super.height : iData.maskHeight;
		}
		
		/**
		 * 清空显示 Item
		 * 以便重置 Listoy
		 */
		public function clearItem():void
		{
			if (null === iData) return;
			iData.clear();
			graphics.clear();
			if (null !== _NAME) TEvent.clearTrigger(_NAME + "ITEM");
		}
		
		/**
		 * 清空显示对象及侦听
		 */
		override public function clear():void
		{
			super.clear();
			if (null !== iData) {
				graphics.clear();
				iData.clear();
				iData = null;
			}
			if (null !== _NAME) {
				TEvent.clearTrigger(_NAME + "ITEM");
				TEvent.clearTrigger(_NAME);
				_NAME = null;
			}
		}
		
	}
}