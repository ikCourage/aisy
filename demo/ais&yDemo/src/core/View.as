package core
{
	import aisy.d_button.D_Button;
	import aisy.d_checkbox.D_CheckBox;
	import aisy.d_confirm.D_Confirm;
	import aisy.d_drag.D_Drag;
	import aisy.d_image.D_Image;
	import aisy.d_radio.D_Radio;
	import aisy.d_scroller.D_Scroller;
	import aisy.d_ulist.D_UList;
	import aisy.d_upwindow.D_UpWindow;
	
	import com.greensock.TweenLite;
	
	import flash.text.Font;
	import flash.text.TextFormat;
	
	import org.aisy.display.USprite;
	import org.aisy.listoy.Listoy;
	import org.aisy.skin.AisySkin;

	internal class View extends USprite
	{
		public function View()
		{
			init();
		}
		
		private function init():void
		{
			initTextFormat();
			
			var arr:Array = [
				{"name": "图片", "c": "aisy.d_image.D_Image"},
				{"name": "多选框", "c": "aisy.d_checkbox.D_CheckBox"},
				{"name": "单选框", "c": "aisy.d_radio.D_Radio"},
				{"name": "确认框", "c": "aisy.d_confirm.D_Confirm"},
				{"name": "按钮", "c": "aisy.d_button.D_Button"},
				{"name": "弹框", "c": "aisy.d_upwindow.D_UpWindow"},
				{"name": "下拉列表", "c": "aisy.d_ulist.D_UList"},
				{"name": "拖动", "c": "aisy.d_drag.D_Drag"},
				{"name": "滚动条", "c": "aisy.d_scroller.D_Scroller"}
			];
			
			var _listoy:Listoy = new Listoy();
			_listoy.setRowColumn(arr.length, 1);
			
			_listoy.setItemRenderer(ViewItem);
			_listoy.setDataProvider(arr);
			_listoy.initializeView();
			
			this.addChild(_listoy);
			
			AisySkin.MOBILE = true;
			
			new D_Scroller();
			
		}
		
		private function initTextFormat():void
		{
			var r:RegExp = /(YaHei)|(雅黑)/ig;
			var arr:Array = Font.enumerateFonts(true);
			for each (var i:Font in arr) {
				if (r.test(i.fontName)) return;
			}
			AisySkin.TEXTFORMAT = __TextFormat;
		}
		
		private function __TextFormat():TextFormat
		{
			var f:TextFormat = new TextFormat("Arial", 16);
			return f;
		}
		
		private function __import():void
		{
			D_Image;
			D_CheckBox;
			D_Radio;
			D_Confirm;
			D_Button;
			D_UpWindow;
			D_UList;
			D_Drag;
			D_Scroller;
			
			_AISY_BUTTON;
			_AISY_CONFIRM_SKIN;
			_AISY_LOADING;
			_AISY_CHECKBOX_SKIN_0;
			_AISY_CHECKBOX_SKIN_1;
			_AISY_RADIO_SKIN_0;
			_AISY_RADIO_SKIN_1;
			_AISY_SCROLLER_SKIN;
			ULIST_SKIN_LABEL;
			ULIST_SKIN_ITEM;
			
			TweenLite;
		}
		
	}
}