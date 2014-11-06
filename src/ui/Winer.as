package ui
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	
	import core.ImageLoader;
	import core.UITool;
	
	
	public class Winer extends LotteryRoleContainer
	{
		private var _lotteryLight:LotteryLight;
		private var bitmap:Bitmap;
		public function Winer()
		{
			super();
			_lotteryLight = new LotteryLight();
			addChildAt( _lotteryLight, 0 );
			UITool.stopMovieClip( _lotteryLight );
			
			UITool.removeChildren( container );
			
			y = 230;
		}
		public function addBitmap():void
		{
			var obj:Object = Lottery.winUser;
			bitmap = new Bitmap( ImageLoader.get().getBitmapData( obj.icon ) );
			
			UITool.removeChildren( container );
			
			container.addChild( bitmap );
			bitmap.width = bitmap.height = LotteryRole.IMAGE_WIDTH;
			bitmap.x = bitmap.y = -bitmap.width / 2;
			nameTF.text = obj.nick;
			UITool.playMovieClip( _lotteryLight );
			
			alpha = 0;
			scaleX = scaleY = 0.1;
			TweenLite.killTweensOf( this );
			TweenLite.to( this, 1, { scaleX:1, scaleY:1, alpha:1} );
		}
		public function stopLight():void
		{
			UITool.stopMovieClip( _lotteryLight );
		}
		public function playLight():void
		{
			UITool.playMovieClip( _lotteryLight );
		}
	}
}