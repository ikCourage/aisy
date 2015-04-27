package org.aisy.tip
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.aisy.display.USprite;
	import org.aisy.skin.AisySkin;

	/**
	 * 
	 * 提示
	 * 
	 * @author viqu
	 * 
	 */
	public class Tip
	{
		/**
		 * 显示视图
		 */
		static protected var __listView:Dictionary;
		/**
		 * 对象数组
		 */
		static protected var __listObjs:Dictionary;
		
		/**
		 * 创建并返回显示视图
		 * @param obj
		 * @return 
		 */
		static public function getView(obj:Object):USprite
		{
			if (null === __listView) __listView = new Dictionary(true);
			var us:USprite = __listView[obj];
			if (null === us) __listView[obj] = us = new USprite();
			obj = null;
			return us;
		}
		
		/**
		 * 显示
		 * @param e：MouseEvent
		 */
		static protected function __show(e:MouseEvent):void
		{
			var obj:InteractiveObject = e.currentTarget as InteractiveObject;
			obj.stage.addChild(getView(obj));
			
			var f:Function = AisySkin.TIP_SKIN;
			if (null !== __listObjs[obj][0]) f = __listObjs[obj][0];
			f.apply(null, [e, getView(obj)].concat(__listObjs[obj].slice(1)).slice(0, f.length));
			f = null;
			
			obj.addEventListener(MouseEvent.ROLL_OUT, __hide, false, 0, true);
			obj.addEventListener(MouseEvent.MOUSE_MOVE, __move, false, 0, true);
			obj = null;
			e = null;
		}
		
		/**
		 * 移除显示 执行 clearView()
		 * @param e：MouseEvent
		 */
		static protected function __hide(e:MouseEvent):void
		{
			var obj:InteractiveObject = e.currentTarget as InteractiveObject;
			
			var f:Function = AisySkin.TIP_SKIN;
			if (null !== __listObjs[obj][0]) f = __listObjs[obj][0];
			var b:int = parseInt(f.apply(null, [e, getView(obj)].concat(__listObjs[obj].slice(1)).slice(0, f.length)));
			f = null;
			
			obj.removeEventListener(MouseEvent.MOUSE_MOVE, __move);
			obj.removeEventListener(MouseEvent.ROLL_OUT, __hide);
			obj = null;
			e = null;
			if (b === 0) clearView();
			else if (b === 2) clearView(obj);
		}
		
		/**
		 * 鼠标移动 计算布局
		 * @param e：MouseEvent
		 */
		static protected function __move(e:MouseEvent):void
		{
			var obj:InteractiveObject = e.currentTarget as InteractiveObject;
			
			var f:Function = AisySkin.TIP_SKIN;
			if (null !== __listObjs[obj][0]) f = __listObjs[obj][0];
			f.apply(null, [e, getView(obj)].concat(__listObjs[obj].slice(1)).slice(0, f.length));
			f = null;
			obj = null;
		}
		
		/**
		 * 添加具有 Tip 的对象
		 * @param obj
		 * @param tip
		 * @param skinHandler (e, view, tip, ...parameters)
		 * @param parameters
		 */
		static public function addTip(obj:InteractiveObject, tip:Object, skinHandler:Function = null, ...parameters):void
		{
			if (null === __listObjs) __listObjs = new Dictionary(true);
			if (null == __listObjs[obj]) {
				__listObjs[obj] = [skinHandler, tip].concat(parameters);
				obj.addEventListener(MouseEvent.ROLL_OVER, __show, false, 0, true);
			}
			else {
				__listObjs[obj] = [skinHandler, tip].concat(parameters);
			}
			obj = null;
			tip = null;
			skinHandler = null;
			parameters = null;
		}
		
		/**
		 * 移除 obj 的 Tip
		 * @param obj
		 */
		static public function removeTip(obj:InteractiveObject):void
		{
			obj.removeEventListener(MouseEvent.ROLL_OVER, __show);
			obj.removeEventListener(MouseEvent.MOUSE_MOVE, __move);
			obj.removeEventListener(MouseEvent.ROLL_OUT, __hide);
			if (null !== __listObjs) delete __listObjs[obj];
			obj = null;
		}
		
		/**
		 * 移除显示
		 * @param obj
		 */
		static public function clearView(obj:Object = null):void
		{
			if (null !== __listView) {
				if (null === obj) {
					for each (var i:USprite in __listView) {
						i.clear();
					}
					__listView = null;
				}
				else if (__listView[obj]) {
					__listView[obj].clear();
					delete __listView[obj];
				}
			}
			obj = null;
		}
		
		/**
		 * 清空
		 */
		static public function clear():void
		{
			clearView();
			for (var i:* in __listObjs) {
				i.removeEventListener(MouseEvent.ROLL_OVER, __show);
				i.removeEventListener(MouseEvent.MOUSE_MOVE, __move);
				i.removeEventListener(MouseEvent.ROLL_OUT, __hide);
			}
			__listObjs = null;
		}
		
	}
}