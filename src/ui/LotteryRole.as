package ui
{
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
		public function LotteryRole( index:int = -1 )
		{
			super();
			UITool.removeChildren( user.container );
			addBitmap( index );
		}
		public function addBitmap( index:int ):void
		{
			var obj:Object = ( -1 == index ) ? Lottery.winUser : Lottery.lotteryData[ index ];
			bitmap = new Bitmap( ImageLoader.get().getBitmapData( obj.icon ) );
			
			UITool.removeChildren( user.container );
			
			user.container.addChild( bitmap );
			bitmap.width = bitmap.height = IMAGE_WIDTH;
			bitmap.x = bitmap.y = -bitmap.width / 2;
			user.nameTF.text = obj.nick;
		}
	}
}