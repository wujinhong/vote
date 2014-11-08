package {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.ui.Keyboard;
	
	import core.ImageLoader;
	
	import net.HttpMgr;
	import net.JSCall;
	import net.URL;
	import net.URL3;
	
	import tg888.MainWall;
	
	import ui.LotteryBackground;
	import ui.LotteryFail;
	import ui.Winer;
	
	[SWF( height = 1080, width = 1920, frameRate = 60 )]
	public class Lottery extends Sprite
	{
		/**
		 *伪数据 
		 */		
		private var pseudoLotteryData:Array = 
			[
				{
					icon:"http://yx.kklink.com/asimg/10014/HeaderFace/140822134438781.jpg",
					nick:"Jack",
					sex:"M",
					userid:10014
				},
				{
					icon:"http://yx.kklink.com/asimg/10014/HeaderFace/140822134438781.jpg",
					nick:"Jack",
					sex:"M",
					userid:10014
				},
				{
					icon:"http://yx.kklink.com/asimg/10014/HeaderFace/140822134438781.jpg",
					nick:"Jack",
					sex:"M",
					userid:10014
				}
			];
		public static const BACKGROUND_WIDTH:Number = 1920;
		public static const BACKGROUND_HEIGHT:Number = 1080;
		/**
		 * 格式
		 * {
		 *	icon:"http://yx.kklink.com/asimg/10014/HeaderFace/140822134438781.jpg",
		 *	nick:"Jack",
		 *	sex:"M",
		 *	userid:10014
		 * }
		 */		
		public static var lotteryData:Vector.<Object> = new Vector.<Object>();
		public static var currentIndex:int = 0;
		private var _background:LotteryBackground;
		private var _layer:Sprite;
		private var _barid:int;
		private var _token:String;
		private var _loadLength:uint;
		private var intervalID:uint;
		public static var winUser:Object;
		private var _winer:Winer;
		private var _roleLayer:Sprite;
		private var mainWall:MainWall;
		private var _lotteryFail:LotteryFail;
		private var _fail:Boolean = false;
		
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
		private function ASFunc( barid:int = 43, token:String = "842682394cf9a9a0788cf86af7cf2ed9", obj:Object = null ):void
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
			lotteryData.push.apply( null, ret.data );
			
			loadImage();
		}
		
		private function loadImage():void
		{
			_loadLength = lotteryData.length;
			var i:int;
			for( i = 0; i < _loadLength; i++ )
			{
				ImageLoader.get().getImageCallback( lotteryData[ i ].icon, checkAllLoaded );
			}
		}
		private function checkAllLoaded( bitmapData:BitmapData ):void
		{
			_loadLength--;
			trace( "Lottery.checkAllLoaded( bitmapData ): _loadLength" + _loadLength );
			
			if( 0 != _loadLength )
			{
				return;
			}
			if( 0 == lotteryData.length )
			{
				trace("Lottery.begin(): no data");
				return;
			}
			
			mainWall.start();
			
			var params:Object = { barid:_barid, token:_token };
			HttpMgr.get().post( URL3.winer, params, onResult );
		}
		public static function getLotteryRoleIndex():uint
		{
			currentIndex = currentIndex < lotteryData.length ? currentIndex + 1 : 0;
			return currentIndex;
		}
		private function onResult( ret:Object ):void
		{
			if( null == ret.data )
			{
				return;
			}
			if( 0 != ret.code )
			{//ret.code == 0说明为返回成功
				trace( "Lottery.onResult:ret.code = " + ret.code );
				_fail = true;
				return;
			}
			_fail = false;
			winUser = ret.data.user;
			ImageLoader.get().getImageCallback( winUser.icon, winUserLoaded );
		}
		private function winUserLoaded( bitmapData:BitmapData ):void
		{
			trace( "Lottery.winUserLoaded( bitmapData ); 赢家图片加载成功。" );
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, showResult );
		}
		private function showResult( e:KeyboardEvent ):void
		{
			switch( e.keyCode )
			{
				case Keyboard.SPACE:
					stage.removeEventListener( KeyboardEvent.KEY_DOWN, showResult );
					if( _fail )
					{
						_lotteryFail.visible = true;
						_winer.visible = false;
						_winer.stopLight();
					}
					else
					{
						_winer.addBitmap();
						_winer.visible = true;
					}
					mainWall.stopRenderView();
					stage.addEventListener( KeyboardEvent.KEY_DOWN, roll );
					break;
				default:
					break;
			}
		}
		private function roll( e:KeyboardEvent ):void
		{
			switch( e.keyCode )
			{
				case Keyboard.SPACE:
					_lotteryFail.visible = false;
					_winer.visible = false;
					_winer.stopLight();
					mainWall.renderView();
					stage.removeEventListener( KeyboardEvent.KEY_DOWN, roll );
					var params:Object = { barid:_barid, token:_token };
					HttpMgr.get().post( URL3.winer, params, onResult );
					break;
				default:
					break;
			}
		}
		private function onStageResize( e:Event = null ):void
		{
			var newScaleX:Number = stage.stageWidth / BACKGROUND_WIDTH;
			var newScaleY:Number = stage.stageHeight/ BACKGROUND_HEIGHT;
			_layer.x = stage.stageWidth / 2;
			_background.x = stage.stageWidth / 2;
			_background.width = stage.stageWidth;
			_background.height = stage.stageHeight;
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
			
			_roleLayer = new Sprite();
			_layer.addChild( _roleLayer );
			
			mainWall = new MainWall();
			_roleLayer.addChild( mainWall );
			mainWall.x = -MainWall.VIEW_WIDTH / 2;
//			mainWall.width = mainWall.width / 2;
			_winer = new Winer();
			_layer.addChild( _winer );
			_winer.visible = false;
			
			_lotteryFail = new LotteryFail();
			_layer.addChild( _lotteryFail );
			_lotteryFail.visible = false;
		}
	}
}
