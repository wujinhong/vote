package {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	import core.ImageLoader;
	
	import net.HttpMgr;
	import net.JSCall;
	import net.URL;
	import net.URL3;
	
	import ui.LotteryBackground;
	
	
	[SWF( height = 540, width = 960, frameRate = 60 )]
	public class Lottery extends Sprite
	{
		public static const BACKGROUND_WIDTH:Number = 1920;
		public static const BACKGROUND_HEIGHT:Number = 1080;
		/**
		 * 格式
		 * {
		 *	icon:"http://yx.kklink.com/asimg/10014/HeaderFace/140822134438781.jpg",
		 *	nick:"Jack",
		 *	sex:"M",
		 *	userid:10014 [0x271e]
		 * }
		 */		
		private var _lotteryData:Vector.<Object> = new Vector.<Object>();
		private var _background:LotteryBackground;
		private var _layer:Sprite;
		private var _barid:int;
		private var _token:String;
		private var _loadLength:uint;
		
		public function Lottery()
		{			
			super();
			Security.allowDomain( "*" );
			Security.allowInsecureDomain( "*" );
			this.addEventListener( Event.ADDED_TO_STAGE, addDOMOVE );
			
		}
		private function addDOMOVE( e:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, addDOMOVE );
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener( Event.RESIZE, onStageResize );
			
			JSCall.addCallback( URL.ASFunc, ASFunc );
			JSCall.CallJS( URL.JSFunc );
			initComponent();
			if( !ExternalInterface.available )
			{
				ASFunc();
			}
			onStageResize();
		}
		
		/**
		 *被JS调用的方法
		 */
		private function ASFunc( barid:int = 1, token:String = "842682394cf9a9a0788cf86af7cf2ed9", obj:Object = null ):void
		{
			_barid = barid;
			_token = token;
			var params:Object = { barid:_barid, token:_token };
			HttpMgr.get().post( URL3.barFriends, params, onLotteryList );
		}
		
		private function onLotteryList( ret:Object ):void
		{
			if( null == ret.data )
			{
				return;
			}
			if( 0 != ret.code )
			{//ret.code == 0说明为返回成功
				trace( "Lottery.onLotteryList:ret.code = " + ret.code );
				return;
			}
			_lotteryData.push.apply( null, ret.data.boy );
			
			loadImage();
		}
		
		private function loadImage():void
		{
			_loadLength = _lotteryData.length;
			var i:int;
			for( i = 0; i < _loadLength; i++ )
			{
				ImageLoader.get().getImageCallback( _lotteryData[ i ].icon, checkAllLoaded );
			}
		}
		private function checkAllLoaded( bitmapData:BitmapData ):void
		{
			_loadLength--;
			if( 0 != _loadLength )
			{
				return;
			}
			begin()
		}
		
		private function begin():void
		{
			
		}
		private function onStageResize( e:Event = null ):void
		{
			var newScaleX:Number = stage.stageWidth / BACKGROUND_WIDTH;
			var newScaleY:Number = stage.stageHeight/ BACKGROUND_HEIGHT;
			_layer.x = stage.stageWidth / 2;
			_background.x = stage.stageWidth / 2;
			_background.width = stage.stageWidth;
			_background.height = stage.stageHeight;
//			_layer.scaleX = _layer.scaleY = newScaleX < newScaleY ? newScaleX : newScaleY;
		}
		private function initComponent():void
		{
			_background = new LotteryBackground();
			addChild( _background );
			_background.x = stage.stageWidth / 2;
			_background.width = stage.stageWidth;
			_background.height = stage.stageHeight;
			_background.cacheAsBitmap = true;
			
			_layer = new Sprite();
			addChild( _layer );
			_layer.x = stage.stageWidth / 2;
		}
	}
}
