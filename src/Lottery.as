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
	import core.UITool;
	
	import net.HttpMgr;
	import net.JSCall;
	import net.URL;
	import net.URL3;
	
	import tg888.MainWall;
	
	import ui.LotteryBackground;
	import ui.LotteryFail;
	import ui.LotteryLoading;
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
		private var _loading:LotteryLoading;
		private var _isLoading:Boolean = true;
		private var _rolling:Boolean = false;
		
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
			stage.addEventListener( KeyboardEvent.KEY_DOWN, shortcutKeys );
			initComponent();
			if( !ExternalInterface.available )
			{
				ASFunc();
			}
			onStageResize();
		}
		
		protected function shortcutKeys( e:KeyboardEvent ):void
		{
			JSCall.CallJS( URL.shortcutKeys, e.keyCode );
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
			_loading.visible = true;
			UITool.playMovieClip( _loading );
		}
		
		private function onLotteryList( ret:Object ):void
		{
			if( null == ret.data )
			{
				trace( "Lottery.onLotteryList:null == ret.data; " + ret.code );
				return;
			}
			if( 0 != ret.code )
			{//ret.code == 0说明为返回成功
				trace( "Lottery.onLotteryList:ret.code = " + ret.code );
				return;
			}
			lotteryData.push.apply( null, ret.data );
			_loadLength = lotteryData.length;
			var i:int;
			for( i = 0; i < _loadLength; i++ )
			{
				ImageLoader.get().getImageCallback( lotteryData[ i ].icon, checkAllLoaded );
			}
			trace( "Lottery.onLotteryList( ret ); 图片加载中。" );
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
			mainWall.visible = false;
			mainWall.start();
			mainWall.renderView();
			
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
			mainWall.stopRenderView();
			mainWall.visible = true;
			
			if( 0 != ret.code )
			{//ret.code == 0说明为返回成功
				trace( "Lottery.onResult:ret.code = " + ret.code );
				_fail = true;
				readyForRoll( null );
				return;
			}
			if( null == ret.data )
			{
				return;
			}
			_fail = false;
			winUser = ret.data.user;
			ImageLoader.get().getImageCallback( winUser.icon, readyForRoll );
		}
		private function readyForRoll( bitmapData:BitmapData ):void
		{
			trace( "Lottery.winUserLoaded( bitmapData ); 赢家图片加载成功。" );
			
			_loading.visible = false;
			UITool.stopMovieClip( _loading );
			_isLoading = false;
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onRoll );
		}
		private function onResult2( ret:Object ):void
		{
			_isLoading = false;
			if( 0 != ret.code )
			{//ret.code == 0说明为返回成功
				trace( "Lottery.onResult:ret.code = " + ret.code );
				_fail = true;
				readyForRoll2( null );
				return;
			}
			if( null == ret.data )
			{
				return;
			}
			_fail = false;
			winUser = ret.data.user;
			ImageLoader.get().getImageCallback( winUser.icon, readyForRoll2 );
		}
		private function readyForRoll2( bitmapData:BitmapData ):void
		{
			trace( "Lottery.readyForRoll2( bitmapData ); 赢家图片加载成功。" );
			_loading.visible = false;
			UITool.stopMovieClip( _loading );
			if( _rolling )
			{
				roll();
			}
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
					mainWall.stopRenderView( true );
					var params:Object = { barid:_barid, token:_token };
					HttpMgr.get().post( URL3.winer, params, onResult2 );
					_isLoading = true;
					_rolling = false;
					stage.addEventListener( KeyboardEvent.KEY_DOWN, onRoll );
					break;
				default:
					break;
			}
		}
		private function onRoll( e:KeyboardEvent ):void
		{
			switch( e.keyCode )
			{
				case Keyboard.SPACE:
					_rolling = true;
					stage.removeEventListener( KeyboardEvent.KEY_DOWN, onRoll );
					
					_lotteryFail.visible = false;
					_winer.visible = false;
					_winer.stopLight();
					
					if( !_isLoading )
					{
						roll();
					}
					else
					{
						_loading.visible = true;
						UITool.playMovieClip( _loading );
					}
					break;
				default:
					break;
			}
		}
		private function roll():void
		{
			mainWall.renderView( true );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, showResult );
			_loading.visible = false;
			UITool.stopMovieClip( _loading );
		}
		private function onStageResize( e:Event = null ):void
		{
			var newScaleX:Number = stage.stageWidth / BACKGROUND_WIDTH;
			var newScaleY:Number = stage.stageHeight/ BACKGROUND_HEIGHT;
			_layer.x = stage.stageWidth / 2;
			_background.x = stage.stageWidth / 2;
			_background.width = stage.stageWidth;
			_background.height = stage.stageHeight;
			_layer.scaleX = _layer.scaleY = newScaleX < newScaleY ? newScaleX : newScaleY;
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
			_winer = new Winer();
			_layer.addChild( _winer );
			_winer.visible = false;
			
			_lotteryFail = new LotteryFail();
			_layer.addChild( _lotteryFail );
			_lotteryFail.visible = false;
			_lotteryFail.graphics.beginFill( 0x000000, 0.5 );
			_lotteryFail.graphics.drawRect( -BACKGROUND_WIDTH, -BACKGROUND_HEIGHT, BACKGROUND_WIDTH * 2, BACKGROUND_HEIGHT * 2 );
			_lotteryFail.graphics.endFill();
			
			_loading = new LotteryLoading();
			_layer.addChild( _loading );
		}
	}
}
