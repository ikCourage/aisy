package org.aisy.upwindow
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	import org.ais.event.TEvent;
	import org.ais.system.Ais;
	import org.aisy.display.USprite;
	import org.aisy.skin.AisySkin;

	/**
	 * 
	 * 弹出窗口组件（注册、管理）类
	 * 需要使用时 new UpWindowAis() 注册全局侦听事件
	 * 只需实例化一次
	 * 
	 * @author viqu
	 * 
	 */
	public class UpWindowAis
	{
		/**
		 * 显示视图
		 */
		protected var _view:USprite
		/**
		 * 视图遮罩
		 */
		protected var _viewMask:USprite;
		/**
		 * 舞台宽度
		 */
		protected var _stageWidth:Number;
		/**
		 * 舞台高度
		 */
		protected var _stageHeight:Number;
		/**
		 * UpWindow 数量
		 */
		protected var _count:uint;
		/**
		 * tabChildren tabEnabled 的属性记录
		 */
		protected var _tabChildrenList:Dictionary;
		
		public function UpWindowAis():void
		{
			init();
		}
		
		/**
		 * 初始化
		 */
		protected function init():void
		{
			if (TEvent.hasTrigger("UP_WINDOW_NEW") === true) TEvent.clearTrigger("UP_WINDOW_NEW");
			if (TEvent.hasTrigger("UP_WINDOW_AIS") === true) TEvent.clearTrigger("UP_WINDOW_AIS");
			TEvent.newTrigger("UP_WINDOW_AIS", __triggerHandler);
		}
		
		/**
		 * 返回视图遮罩
		 * @return 
		 */
		protected function getViewMask():USprite
		{
			return null === _viewMask ? _viewMask = AisySkin.UPWINDOWAIS_MASK() : _viewMask;
		}
		
		/**
		 * 设置 tabChildren
		 * @param value
		 */
		protected function setTabChildren(value:Boolean):void
		{
			if (value === false && null === _tabChildrenList) _tabChildrenList = new Dictionary(true);
			var view:DisplayObjectContainer = AisySkin.UPWINDOWAIS_VIEW;
			view = null !== view ? view : Ais.IMain.stage;
			var i:uint, len:uint = view.numChildren, obj:Object;
			for (i = 0; i < len; i++) {
				obj = view.getChildAt(i);
				if (value === false) {
					if (!_tabChildrenList[obj]) _tabChildrenList[obj] = [obj.hasOwnProperty("tabChildren") === true ? obj.tabChildren : false, obj.hasOwnProperty("tabEnabled") === true ? obj.tabEnabled : false];
					if (obj.hasOwnProperty("tabChildren") === true) obj.tabChildren = false;
					if (obj.hasOwnProperty("tabEnabled") === true) obj.tabEnabled = false;
				}
				else if (null !== _tabChildrenList && _tabChildrenList[obj]) {
					if (obj.hasOwnProperty("tabChildren") === true) obj.tabChildren = _tabChildrenList[obj][0];
					if (obj.hasOwnProperty("tabEnabled") === true) obj.tabEnabled = _tabChildrenList[obj][1];
				}
			}
			if (value === true) _tabChildrenList = null;
			if (null !== _view) _view.tabChildren = true;
			view = null;
			obj = null;
		}
		
		/**
		 * 显示窗口
		 * @param obj
		 * @param name
		 * @param maskMode
		 * @param showBg
		 * @param isDrag
		 * @param isLayout
		 * @param color
		 * @param alpha
		 * @param closeAlpha
		 * @param showClose
		 */
		protected function __show(obj:DisplayObject, name:String, maskMode:uint = 0, showBg:Boolean = true, isDrag:Boolean = true, isLayout:Boolean = true, color:uint = 0x000000, alpha:Number = 0.7, closeAlpha:Number = 1, showClose:Boolean = true):void
		{
			if (null === _view) {
				_view = new USprite();
				if (null !== AisySkin.UPWINDOWAIS_VIEW) AisySkin.UPWINDOWAIS_VIEW.addChild(_view);
				else Ais.IMain.stage.addChild(_view);
			}
			if (maskMode !== 0) {
				setTabChildren(false);
				var i:uint = 0;
				if (maskMode === 1 && null === _viewMask) {
					i = 1;
					_view.addChild(getViewMask());
				}
				else if (maskMode === 2) {
					i = 1;
					_view.addChild(getViewMask());
				}
				if (i === 1) {
					var len:uint = _view.numChildren - 1;
					for (i = 0; i < len; i++) {
						(_view.getChildAt(i) as USprite).tabChildren = false;
					}
				}
			}
			_view.addChild(new UpWindow(_count++, obj, name, maskMode, showBg, isDrag, isLayout, color, alpha, closeAlpha, showClose));
			__resize();
			obj = null;
			name = null;
		}
		
		/**
		 * 清空 UpWindow
		 * @param upWin
		 */
		protected function __clear(upWin:UpWindow = null):void
		{
			_count--;
			_view.removeChild(upWin);
			if (_count === 0) {
				TEvent.trigger("UP_WINDOW_AIS", "CLEAR_ALL");
				return;
			}
			TEvent.trigger("UP_WINDOW_NEW", "RESET_INAME", parseInt(upWin.name));
			if (upWin.MASK_MODE !== 0) {
				var index:uint, maskMode:uint, i:uint, len:uint = _count + 1;
				var objWin:UpWindow;
				for (i = 0; i < len; i++) {
					objWin = _view.getChildAt(i) as UpWindow;
					if (null !== objWin) {
						if (objWin.MASK_MODE === 2) {
							index = parseInt(objWin.name);
							maskMode = 2;
							break;
						}
						else if (objWin.MASK_MODE === 1) {
							index = parseInt(objWin.name);
							maskMode = 1;
						}
					}
				}
				for (i = index; i < _count; i++) {
					(_view.getChildByName(String(i)) as USprite).tabChildren = true;
				}
				if (maskMode === 0) {
					_viewMask.clear();
					_viewMask = null;
				}
				else {
					_view.setChildIndex(_viewMask, index);
				}
				objWin = null;
			}
			TEvent.trigger("UP_WINDOW_NEW", "TOP", {"name": (_view.getChildByName(String(_count - 1)) as UpWindow).NAME});
			upWin = null;
		}
		
		/**
		 * 清空（只保留 “UP_WINDOW_AIS” 侦听）
		 */
		protected function __clearAll():void
		{
			_count = 0;
			setTabChildren(true);
			TEvent.clearTrigger("UP_WINDOW_NEW");
			if (null !== _view) {
				if (null !== _viewMask) {
					_view.removeChild(_viewMask);
					_view.parent.addChildAt(_viewMask, _view.parent.getChildIndex(_view));
					_viewMask.clear();
				}
				_view.clear();
			}
			_view = null;
			_viewMask = null;
			_tabChildrenList = null;
			_stageWidth = 0;
			_stageHeight = 0;
		}
		
		/**
		 * 自适应布局
		 */
		protected function __resize():void
		{
			if (_stageWidth !== Ais.IMain.stage.stageWidth || _stageHeight !== Ais.IMain.stage.stageHeight) {
				TEvent.trigger("UP_WINDOW_NEW", "RESIZE_ALL");
				_stageWidth = Ais.IMain.stage.stageWidth;
				_stageHeight = Ais.IMain.stage.stageHeight;
			}
			if (null === _viewMask) return;
			if (_viewMask.width !== _stageWidth || _viewMask.height !== _stageHeight) {
				_viewMask.width = _stageWidth;
				_viewMask.height = _stageHeight;
			}
		}
		
		/**
		 * 全局侦听
		 * @param type
		 * @param data
		 */
		protected function __triggerHandler(type:String, data:* = null):void
		{
			switch (type) {
				case "SHOW":
					var l:uint = data.length;
					__show.apply(null, l < __show.length ? data.concat(AisySkin.UPWINDOWAIS_SHOW.slice(l - 2)) : data);
					break;
				case "CLEAR":
					if (_count !== 0) __clear(data);
					break;
				case "CLEAR_ALL":
					__clearAll();
					break;
				case "RESIZE":
					__resize();
					break;
				case "GET_VIEW":
					data(_view);
					break;
				case "SET_VIEW":
					_view = data;
					break;
			}
			type = null;
			data = null;
		}
		
	}
}