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
		private var _currentLabel:TextField;
		private var HEIGHT:Number = 90;//54;
		private var _beforeLabel:TextField;
		public function Lable( str:String )
		{
			super();
			
			_tf0 = new TextField();
			_tf1 = new TextField();
			
			addChild( _tf0 );
			addChild( _tf1 );
			show( str );
			y = 810;
			width = 400;
		}
		public function show( text:String, duration:Number = 0 ):void
		{
			if( isTF0 )
			{
				_tf1.htmlText = "<font color='#FFFFFF' align='center' face='verdana' size='36'>" + text + "</font>";
				_tf0.htmlText = "";
				_currentLabel = _tf1;
				_beforeLabel = _tf0;
				isTF0 = false;
			}
			else
			{
				_tf0.htmlText = "<font color='#FFFFFF' align='center' face='verdana' size='36'>" + text + "</font>";
				_tf1.htmlText = "";
				_currentLabel = _tf0;
				_beforeLabel = _tf1;
				isTF0 = true;
			}
			
//			_tf0.x = 200 - _tf0.textWidth / 2;
//			_tf1.x = 200 - _tf1.textWidth / 2;
			if( 0 == duration )
			{
				return;
			}
			_currentLabel.y = HEIGHT;
			_currentLabel.alpha = 0;
			TweenLite.to( _beforeLabel, duration, { y:-HEIGHT, alpha:0 } );
			TweenLite.to( _currentLabel, duration, { y:0, alpha:1 } );
		}
		
	}
}