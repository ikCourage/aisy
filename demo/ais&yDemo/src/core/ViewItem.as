package core
{
	import flash.utils.getDefinitionByName;
	
	import org.aisy.button.Button;
	import org.aisy.listoy.ListoyItem;

	internal class ViewItem extends ListoyItem
	{
		public function ViewItem(name:String, index:uint, data:*)
		{
			super(name, index, data);
			init();
		}
		
		private function init():void
		{
			var btn:Button = new Button();
			btn.setClassName("_AISY_BUTTON");
			
			btn.setText(itemInfo.name);
			
			this.addChild(btn);
			
			btn.setClick(__btnHandler);
		}
		
		private function __btnHandler():void
		{
			new (getDefinitionByName(itemInfo.c) as Class)();
		}
		
	}
}