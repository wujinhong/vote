package ui
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	
	import core.ImageLoader;
	import core.UITool;

	public class LotteryRole extends LotteryFrame
	{
		public static var roleList:Vector.<LotteryRole> = new Vector.<LotteryRole>();
		public static function getLotteryRole( index:uint ):LotteryRole
		{
			if( 0 == roleList.length )
			{
				return new LotteryRole( index );
			}
			else
			{
				return roleList.pop();
			}
		}
		public static const ROTATION_Y:Number = -80;
		public static const WIDTH:Number = 512
		public static const IMAGE_WIDTH:Number = 0.8 * 512
		public static const DURATION:Number = 8;
		private var bitmap:Bitmap;
		public function LotteryRole( index:int )
		{
			super();
			UITool.removeChildren( user.container );
			
			addBitmap( index );
			TweenLite.killTweensOf( this );
			
			//Tween内容
			rotationY = ROTATION_Y;
			scaleX = scaleY = 0.8;
			x = WIDTH * 2;
			y = 30;
			//Tween内容
			
			TweenLite.to( this, DURATION, { rotationY:0, scaleX:1, scaleY:1, x:0, onComplete:onComplete } );
		}
		private function onComplete():void
		{
			TweenLite.killTweensOf( this );
			TweenLite.to( this, DURATION, { rotationY:-ROTATION_Y, scaleX:-0.8, scaleY:-0.8, x:-2 * WIDTH, onComplete:onCompleteFinal } );
		}
		private function onCompleteFinal():void
		{
			TweenLite.killTweensOf( this );
			roleList.push( this );
		}
		public function addBitmap( index:int ):void
		{
			var obj:Object = Lottery.lotteryData[ index ];
			bitmap = new Bitmap( ImageLoader.get().getBitmapData( obj.icon ) );
			
			UITool.removeChildren( user.container );
			
			user.container.addChild( bitmap );
			bitmap.width = bitmap.height = IMAGE_WIDTH;
			bitmap.x = bitmap.y = -bitmap.width / 2;
			user.nameTF.text = obj.nick;
		}
	}
}