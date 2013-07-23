package aisy.d_confirm
{
	import org.aisy.confirm.Confirm;

	public class D_Confirm
	{
		public function D_Confirm()
		{
			Confirm.getInstance().show("这是一个确认框", "提示", __confirmHandler);
		}
		
		private function __confirmHandler(value:Boolean):void
		{
			trace(value);
		}
		
	}
}