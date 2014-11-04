package ui
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class Lable extends Sprite
	{
		private var _tf0:TextField;
		private var _tf1:TextField;
		private var isTF0:Boolean = false;
		private var HEIGHT:Number = 54;
		public function Lable()
		{
			super();
			
			_tf0 = new TextField();
			_tf1 = new TextField();
			
			graphics.beginFill( 0x000000, 0.01 );
			graphics.drawRect( 0, 0, 400, HEIGHT );
			graphics.endFill();
			
			addChild( _tf0 );
			addChild( _tf1 );
			_tf0.cacheAsBitmap = true;
			_tf1.cacheAsBitmap = true;
			_tf0.width = _tf1.width = width = 400;
			y = 810;
		}
		public function show( text:String, duration:Number = 0 ):void
		{
			TweenLite.killTweensOf( _tf0 );
			TweenLite.killTweensOf( _tf1 );
			if( isTF0 )
			{
				_tf1.htmlText = "<font color='#FFFFFF' align='center' face='verdana' size='36'>" + text + "</font>";
				_tf1.x = 200 - _tf1.textWidth / 2;
				isTF0 = false;
				if( 0 >= duration )
				{
					return;
				}
				_tf1.y = HEIGHT;
				_tf1.alpha = 0;
				TweenLite.killTweensOf( _tf0 );
				TweenLite.killTweensOf( _tf1 );
				TweenLite.to( _tf1, duration, { y:0, alpha:1 } );
				TweenLite.to( _tf0, duration, { y:-HEIGHT, alpha:0 } );
			}
			else
			{
				_tf0.htmlText = "<font color='#FFFFFF' align='center' face='verdana' size='36'>" + text + "</font>";
				_tf0.x = 200 - _tf0.textWidth / 2;
				isTF0 = true;
				if( 0 >= duration )
				{
					return;
				}
				_tf0.y = HEIGHT;
				_tf0.alpha = 0;
				TweenLite.to( _tf0, duration, { y:0, alpha:1 } );
				TweenLite.to( _tf1, duration, { y:-HEIGHT, alpha:0 } );
			}
			
		}
		
	}
}