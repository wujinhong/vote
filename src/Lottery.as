package {
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.ui.Keyboard;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import core.ImageLoader;
	import core.UITool;
	
	import net.HttpMgr;
	import net.JSCall;
	import net.URL;
	import net.URL2;
	import net.URL3;
	
	import ui.LotteryBackground;
	import ui.LotteryLight;
	import ui.LotteryRole;
	import ui.Winer;
	
	
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
		public static var lotteryData:Vector.<Object> = new Vector.<Object>();
		private var _background:LotteryBackground;
		private var _layer:Sprite;
		private var _barid:int;
		private var _token:String;
		private var _loadLength:uint;
		private var _currentIndex:int = 0;
		private var intervalID:uint;
		public static var winUser:Object;
		private var _winer:Winer;
		private var _roleLayer:Sprite;
		
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
			if( 0 != _loadLength )
			{
				return;
			}
			begin()
		}
		private function getLotteryRoleIndex():uint
		{
			_currentIndex++;
			if( _currentIndex < lotteryData.length )
			{
				return _currentIndex;
			}
			else
			{
				_currentIndex = 0;
				return _currentIndex;
			}
		}
		
		private function begin():void
		{
			if( 0 == lotteryData.length )
			{
				trace("Lottery.begin(): no data");
				return;
			}
//			intervalID = setInterval( oneLotteryRole, LotteryRole.DURATION * 2 + 0.1 );
			intervalID = setTimeout( oneLotteryRole, LotteryRole.DURATION * 2 + 0.1 );
//			_layer.visible = false;
//			setTimeout( showLayer, 2000 );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, roll );
		}
		private function roll( e:KeyboardEvent ):void
		{
			switch( e.keyCode )
			{
				case Keyboard.SPACE:
					_winer.stopLight();
					_winer.visible = false;
					stage.removeEventListener( KeyboardEvent.KEY_DOWN, roll );
					var params:Object = { barid:_barid, token:_token };
					HttpMgr.get().post( URL3.winer, params, onResult );
					break;
				default:
					break;
			}
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
				return;
			}
			winUser = ret.data.user;
			ImageLoader.get().getImageCallback( winUser.icon, winUserLoaded );
		}
		
		private function winUserLoaded( bitmapData:BitmapData ):void
		{
			stage.addEventListener( KeyboardEvent.KEY_DOWN, roll );
			_winer.addBitmap();
			_winer.visible = true;
		}
		private function showLayer():void
		{
			_layer.visible = true;
		}
		private function oneLotteryRole():void
		{
			var lotterRole:LotteryRole = LotteryRole.getLotteryRole( _currentIndex );
			_roleLayer.addChild( lotterRole );
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
			
			_roleLayer = new Sprite();
			_layer.addChild( _roleLayer );
			
			_winer = new Winer();
			_layer.addChild( _winer );
			_winer.visible = false;
		}
	}
}
