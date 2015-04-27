package core
{
	import flash.system.Security;
	
	import org.ais.system.Ais;
	import org.aisy.display.USprite;
	import org.aisy.upwindow.UpWindowAis;

	[SWF(backgroundColor=0xcccccc, width=960, height=560)]
	public class AisyDemo extends USprite
	{
		public function AisyDemo()
		{
			try {
				Security.allowDomain("*");
				Security.allowInsecureDomain("*");
			}
			catch (error:Error) {}
			
			Ais.IMain = this;
			new UpWindowAis();
			
			addChild(new View());
		}
	}
}