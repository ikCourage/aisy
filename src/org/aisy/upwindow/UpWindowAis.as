package org.aisy.upwindow
{
	import flash.display.DisplayObject;
	
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
		 * 窗口容器 （UpWindow 集合）
		 */
		protected var _viewWin:USprite
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
		
		public function UpWindowAis():void
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
			TEvent.clearTrigger("UP_WINDOW_NEW");
			TEvent.clearTrigger("UP_WINDOW_AIS");
			TEvent.newTrigger("UP_WINDOW_AIS", __triggerHandler);
		}
		
		/**
		 * 
		 * 返回视图遮罩
		 * 
		 * @return 
		 * 
		 */
		protected function getViewMask():USprite
		{
			return null === _viewMask ? _viewMask = AisySkin.UPWINDOWAIS_MASK() : _viewMask;
		}
		
		/**
		 * 
		 * 设置 tabChildren
		 * 
		 * @param value
		 * 
		 */
		protected function setTabChildren(value:Boolean):void
		{
			var i:uint, len:uint = Ais.IMain.stage.numChildren;
			for (i = 0; i < len; i++) {
				Ais.IMain.stage.getChildAt(i).tabChildren = value;
			}
			if (null !== _view) _view.tabChildren = true;
		}
		
		/**
		 * 
		 * 显示窗口
		 * 
		 * @param obj
		 * @param name
		 * @param maskMode
		 * @param showBg
		 * @param isDrag
		 * @param color
		 * @param alpha
		 * @param closeAlpha
		 * @param showClose
		 * 
		 */
		protected function __show(obj:DisplayObject, name:String, maskMode:uint = 0, showBg:Boolean = true, isDrag:Boolean = true, color:uint = 0x000000, alpha:Number = 0.7, closeAlpha:Number = 1, showClose:Boolean = true):void
		{
			if (null === _view) {
				_view = new USprite();
				_viewWin = new USprite();
				_view.addChild(_viewWin);
				Ais.IMain.stage.addChild(_view);
			}
			
			if (maskMode !== 0) {
				setTabChildren(false);
				var i:uint = 0;
				if (maskMode === 1 && null === _viewMask) {
					i = 1;
					_viewWin.addChild(getViewMask());
				}
				else if (maskMode === 2) {
					i = 1;
					_viewWin.addChild(getViewMask());
				}
				if (i === 1) {
					var len:uint = _viewWin.numChildren - 1;
					for (i = 0; i < len; i++) {
						UpWindow(_viewWin.getChildAt(i)).tabChildren = false;
					}
				}
			}
			
			_viewWin.addChild(new UpWindow(_count++, obj, name, maskMode, showBg, isDrag, color, alpha, closeAlpha, showClose));
			
			__resize();
			
			obj = null;
			name = null;
		}
		
		/**
		 * 
		 * 清空 UpWindow
		 * 
		 * @param upWin
		 * 
		 */
		protected function __clear(upWin:UpWindow = null):void
		{
			_count--;
			_viewWin.removeChild(upWin);
			if (_count === 0) {
				TEvent.trigger("UP_WINDOW_AIS", "CLEAR_ALL");
				return;
			}
			TEvent.trigger("UP_WINDOW_NEW", "RESET_INAME", parseInt(upWin.name));
			if (upWin.MASK_MODE !== 0) {
				_viewWin.removeChild(_viewMask);
				var upInt:uint, maskMode:uint, i:uint;
				var objWin:UpWindow;
				
				for (i = 0; i < _count; i++) {
					objWin = _viewWin.getChildAt(i) as UpWindow;
					if (objWin.MASK_MODE === 2) {
						upInt = parseInt(objWin.name);
						maskMode = 2;
						break;
					}
					else if (objWin.MASK_MODE === 1) {
						upInt = parseInt(objWin.name);
						maskMode = 1;
					}
				}
				for (i = upInt; i < _count; i++) {
					UpWindow(_viewWin.getChildAt(i)).tabChildren = true;
				}
				if (maskMode === 0) {
					_viewMask.clear();
					_viewMask = null;
				}
				else {
					_viewWin.addChildAt(_viewMask, upInt);
				}
				objWin = null;
			}
			TEvent.trigger("UP_WINDOW_NEW", "TOP", {"name": UpWindow(_viewWin.getChildAt(_viewWin.numChildren - 1)).NAME});
			upWin = null;
		}
		
		/**
		 * 
		 * 清空（只保留 “UP_WINDOW_AIS” 侦听）
		 * 
		 */
		protected function __clearAll():void
		{
			_count = 0;
			setTabChildren(true);
			TEvent.clearTrigger("UP_WINDOW_NEW");
			if (null !== _view) _view.clear();
			_view = null;
			_viewMask = null;
			_viewWin = null;
			_stageWidth = 0;
			_stageHeight = 0;
		}
		
		/**
		 * 
		 * 自适应布局
		 * 
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
					__show.apply(null, data);
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
			}
			type = null;
			data = null;
		}
		
	}
}