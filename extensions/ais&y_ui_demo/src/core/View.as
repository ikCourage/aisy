package core
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.aisy.autoclear.AisyAutoClear;
	import org.aisy.display.UMovieClip;
	import org.aisy.display.USprite;
	import org.aisy.listoy.Listoy;

	public class View extends USprite
	{
		/**
		 * 为了避免在程序后续版本中可能会出现的要添加到 AisyAutoClear 的需求，建议每次都实例化一个
		 */
		protected var _autoClear:AisyAutoClear;
		protected var _radioList:Listoy;
		protected var _checkBoxList:Listoy;
		protected var bgMc:UMovieClip;
		
		public function View()
		{
			init();
		}
		
		protected function init():void
		{
//			提示：因为 RadioItem 里会创建 AisyAutoClear，所以此 _autoClear 只作用于 bgMc
//			可以通过 AisyAutoClear.setCurrentAutoClear 来将 _autoClear 重新指定到最上层（如果需要的话，一般情况是不需要的）
			_autoClear = AisyAutoClear.newAutoClear();
			__initBgMc();
			__initRadioList();
			__initCheckBoxList();
			__addEvent();
		}
		
		protected function __initBgMc():void
		{
//			这是 UMovieClip，实现了 IClear
			bgMc = new DEMO_UMOVIECLIP_2();
			addChild(bgMc);
		}
		
		protected function __initRadioList():void
		{
			var v:Vector.<Boolean> = new Vector.<Boolean>(6, true);
			_radioList = new Listoy();
//			这里现在支持  Array 和 vector 等可以通过下标访问的，拥有 length 属性的一切对象
			_radioList.setDataProvider(v);
			_radioList.setItemRenderer(RadioItem);
			_radioList.initializeView();
			_radioList.y = height + 30;
			addChild(_radioList);
			v = null;
		}
		
		protected function __initCheckBoxList():void
		{
			var v:Vector.<Boolean> = new Vector.<Boolean>(6, true);
			_checkBoxList = new Listoy();
			_checkBoxList.setDataProvider(v);
			_checkBoxList.setItemRenderer(CheckBoxItem);
			_checkBoxList.initializeView();
			_checkBoxList.y = height + 30;
			addChild(_checkBoxList);
			v = null;
		}
		
		/**
		 * 
		 * 添加了侦听，但是不需要手动的删除，因为 clear 会删除所有的
		 * 注意：这里的这个侦听是加在 IClear 上的，如果不是（普通 MovieClip、SimpleButton、TextField 等），需要手动删除
		 * 
		 */
		protected function __addEvent():void
		{
//			mc_btn 也是 UMovieClip，并且使用了 AisyAutoClear 所以不需要手动清空侦听
			bgMc.mc_btn.addEventListener(MouseEvent.CLICK, __mcBtnHandler);
		}
		
		protected function __mcBtnHandler(e:Event):void
		{
			var obj:DisplayObject = e.target as DisplayObject;
			
			switch (obj.name) {
				case "btn_0":
					bgMc.txt_output.text = new Date();
					break;
				case "btn_1":
//					bgMc.mc_btn 此时有 MouseEvent.CLICK 侦听，所以值为 true
					trace(bgMc.mc_btn.hasEventListener(MouseEvent.CLICK));
					
					_autoClear.clear();
					
//					_autoClear.clear 已经调用了其中所有 IClear 的 clear 方法，
//					bgMc.mc_btn 此时已经没有 MouseEvent.CLICK 侦听，所以值为 false
					trace(bgMc.mc_btn.hasEventListener(MouseEvent.CLICK));
					break;
			}
			
			obj = null;
			e = null;
		}
		
		/**
		 * 
		 * 借助于 AisyAutoClear 的 clear，
		 * 我们不需要像以前那样手动的调用 bgMc.clear()，只需要 bgMc = null
		 * 事实上，对于一个完整的 USprite 的树形结构（从根到子一路全部都是 USprite、UMovieClip 等可显示的 IClear 对象，中间没有不是 ICear 的对象），
		 * 我们并不需要 AisyAutoclear，也不需要手动的对子 USprite 对象调用 clear，
		 * 但要保证这个 USprite 对象通过 addChild 添加到了显示列表，对于没有添加的需要手动调用 USprite.clear，
		 * 或已经将其 put 进了 AisyAutoClear 的则不需要手动调用 USprite.clear
		 * 所以，如果我们做了 AisyAutoClear 的 clear 操作，那么一般情况下，我们在这里只需要对全局变量设置为空，而不需要重复清空
		 * 
		 */
		override public function clear():void
		{
			if (null !== _autoClear) {
				_autoClear.clear();
				_autoClear = null;
			}
			super.clear();
			_radioList = null;
			_checkBoxList = null;
			bgMc = null;
		}
		
	}
}