package aisy.d_scroller
{
	import com.greensock.TweenLite;
	
	import flash.display.Shape;
	
	import org.aisy.display.USprite;

	public class ScrollerSkin_0 extends USprite
	{
		public var up:Shape;
		public var down:Shape;
		public var line:Line;
		protected var _mode:int;
		protected var _width:Number = 7;
		
		public function ScrollerSkin_0()
		{
			up = new Shape();
			down = new Shape();
			line = new Line();
			line.width = _width;
			addChild(line);
		}
		
		public function show(value:Number):void
		{
			TweenLite.to(line, value, {"x": rotation === 0 ? -int(_width * 0.8) : 0, "width": int(_width * 1.8)});
		}
		
		public function hide(value:Number):void
		{
			TweenLite.to(line, value, {"x": 0, "width": _width});
		}
		
		public function setSize(value:Number, mode:int):void
		{
			line.height = value;
			_mode = mode;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value - (_mode === 0 ? 0 : 1);
		}
		
		override public function set y(value:Number):void
		{
			super.y = value - (_mode === 0 ? 0 : 1);
		}
		
		override public function clear():void
		{
			super.clear();
			up = null;
			down = null;
			line = null;
		}
	}
}
import flash.display.Shape;

import org.aisy.display.USprite;

internal class Line extends USprite
{
	public var line:Shape;
	public var drag:Drag;
	protected var _width:Number;
	protected var _height:Number;
	
	public function Line()
	{
		line = new Shape();
		line.graphics.beginFill(0xFFFFFF, 0);
		line.graphics.drawRect(0, 0, 1, 1);
		line.graphics.endFill();
		addChild(line);
		drag = new Drag();
		drag.name = "drag";
		addChild(drag);
	}
	
	override public function set width(value:Number):void
	{
		_width = value;
		drag.width = value;
		line.width = value;
	}
	
	override public function get width():Number
	{
		return _width;
	}
	
	override public function set height(value:Number):void
	{
		_height = value;
		line.height = value;
		drag.y = 0;
	}
	
	override public function get height():Number
	{
		return _height;
	}
	
	override public function clear():void
	{
		super.clear();
		line = null;
		drag = null;
	}
}

internal class Drag extends USprite
{
	protected var _width:Number;
	
	override public function set height(value:Number):void
	{
		graphics.clear();
		graphics.beginFill(0x000000, 0.5);
		graphics.drawRoundRect(0, 0, _width, value, _width);
		graphics.endFill();
	}
	
	override public function set width(value:Number):void
	{
		_width = value;
		height = height;
	}
	
}