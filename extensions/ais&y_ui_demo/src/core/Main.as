package core
{
	import org.ais.system.Ais;
	import org.aisy.autoclear.AisyAutoClear;
	import org.aisy.display.USprite;

	[SWF(backgroundColor=0xcccccc, width=960, height=560)]
	public class Main extends USprite
	{
		/**
		 * 
		 * Hey，这是一个神奇的类，通过它可以自动清空添加到 AisyAutoClear 里的所有 IClear
		 * aisy 内的所有 IClear 类都在 clear 接口中调用了 AisyAutoClear.remove(this) 来将自己从 AisyAutoClear 里移除
		 * 但是 aisy 内的所有 IClear 类都没有自动把自己 put 到 AisyAutoClear 中，所以 AisyAutoClear.remove(this) 实际上是不会起作用的
		 * 不过 aisy_ui 中的后缀为 UI（之后提到的所有 UI 皆指此） 的 ICear 都自动把自己 put 到了最上层的 AisyAutoClear （程序中不会只有一个 AisyAutoClear，
		 * 所以这是栈结构，AisyAutoClear 之间没有父子关系，都是平级的，只不过永远有一个在最上层而已） 中，
		 * 如果当程序中用到 UI 的话，请在实例化 UI 之前，使用 AisyAutoClear.newAutoClear() 来创建一个 AisyAutoClear（声名为全局变量，以便在 clear 中清空）
		 * 注意：AisyAutoClear 中的静态 clear 方法会调用所有的创建出来的 AisyAutoClear 对象的 clear 方法
		 * 
		 */
		protected var _autoClear:AisyAutoClear;
		
		public function Main()
		{
//			不要忘啦
			if (!Ais.IMain) Ais.IMain = this;
			init();
		}
		
		protected function init():void
		{
//			创建一个 AisyAutoClear
//			应该最好写在类的最前面，这之后实例化的后缀为 UI 的 ICear 对象
//			或手动通过 AisyAutoClear.put(iClear) 添加的对象，都会加入这个 AisyAutoClear 中（直到另一个 AisyAutoClear 创建之前）
			_autoClear = AisyAutoClear.newAutoClear();
			var v:View = new View();
			v.x = 100;
			v.y = 50;
			addChild(v);
			v = null;
		}
		
		override public function clear():void
		{
			if (null !== _autoClear) {
//				AisyAutoClear 的 remove 方法只会把 iClear 在 AisyAutoClear 中的引用删除，并不会调用 iClear 的 clear 方法
//				而这里的 clear 方法则会调用其中所有的 iClear 的 clear 方法
//				并且将自己清空，同时将 AisyAutoClear.getCurrentAutoClear() 设置为前一个 AisyAutoClear
				_autoClear.clear();
				_autoClear = null;
			}
			super.clear();
		}
		
	}
}