package
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.Security;
	import flash.ui.Keyboard;
	
	import core.ImageLoader;
	import core.Looper;
	import core.UITool;
	
	import net.HttpMgr;
	import net.JSCall;
	import net.URL;
	import net.URL2;
	
	import ui.Girl;
	import ui.Heart;
	import ui.HeartLine;
	import ui.Lable;
	import ui.Man;
	import ui.MatchBackground;
	import ui.RoleContainer;
	import ui.RotationCircle;
	import ui.SmallHearts;
	import ui.SuccessClip;
	import ui.TopIcon;
	import ui.TopLight;
	
	/**
	 * MatchLover
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 30, 2014   2:38:21 PM
	 * @version 1.0
	 */
	[SWF( height = 540, width = 960, frameRate = 60 )]
	public class MatchLover extends Sprite
	{
		public static const BACKGROUND_WIDTH:Number = 1920;
		public static const BACKGROUND_HEIGHT:Number = 1080;
		
		private var _layer:Sprite;
		/**
		 *背景大图 
		 */		
		private var _background:MatchBackground;
		private var _topLight:TopLight;
		private var _smallHearts:SmallHearts;
		private var _manBigIcon:Man;
		private var _girlBigIcon:Girl;
		private var _heartLine:HeartLine;
		private var _heart:Heart;
		private var _circle:RotationCircle;
		private var _barid:int;
		private var _token:String;
		/**
		 * 格式
		 * {
		 *	icon:"http://yx.kklink.com/asimg/10014/HeaderFace/140822134438781.jpg",
		 *	nick:"Jack",
		 *	sex:"M",
		 *	userid:10014 [0x271e]
		 * }
		 */		
		private var _manData:Vector.<Object> = new Vector.<Object>();
		/**
		 * 格式
		 * {
		 *	icon:"http://yx.kklink.com/asimg/10014/HeaderFace/140822134438781.jpg",
		 *	nick:"何桂明",
		 *	sex:"F",
		 *	userid:10014 [0x271e]
		 * }
		 */	
		private var _girlData:Vector.<Object> = new Vector.<Object>();
		private var _loadLength:uint;
		private var _girl0:RoleContainer;
		private var _girl1:RoleContainer;
		private var _man0:RoleContainer;
		private var _man1:RoleContainer;
		private var _girlIndex:int;
		private var _manIndex:int;
		private var _UP_DURATION:Number = 1.6;
		private var MIN_DURATION:Number = 0.4;
		private var SUBTRACT:Number = 0.1;
		private var RADIUS:Number = 572;
		private var DIAMETER:Number = RADIUS * 2;
		private var _topIcon:TopIcon;
		private var _stop:Boolean = false;
		private var _matchBoyInfo:Object;
		private var _matchGirlInfo:Object;
		private var _oneRoleStop:Boolean = false;
		private var _success:SuccessClip;
		private var _label0:Lable;
		private var _label1:Lable;
		public function MatchLover()
		{
			Security.allowDomain( "*" );
			Security.allowInsecureDomain( "*" );
			super();
			if( null != stage ) 
			{
				initUI();
				return;
			}
			
			addEventListener( Event.ADDED_TO_STAGE, initUI );
		}
		private function initUI( e:Event = null ):void
		{
			if( null != e )
			{
				removeEventListener( Event.ADDED_TO_STAGE, initUI );
			}
			Looper.get().init( stage );
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener( Event.RESIZE, onStageResize );
			
			JSCall.addCallback( URL.ASFunc, ASFunc );
			JSCall.CallJS( URL.JSFunc );
			initComponent();
			ASFunc();
		}
		/**
		 *被JS调用的方法
		 */
		private function ASFunc( barid:int = 1, token:String = "842682394cf9a9a0788cf86af7cf2ed9", obj:Object = null ):void
		{
			_barid = barid;
			_token = token;
			var params:Object = { barid:_barid, token:_token };
			HttpMgr.get().post( URL2.barList, params, onBarList );
		}
		
		private function onBarList( ret:Object ):void
		{
			if( null == ret.data )
			{
				return;
			}
			if( 0 != ret.code )
			{//ret.code == 0说明为返回成功
				return;
			}
			_manData.push.apply( null, ret.data.boy );
			_girlData.push.apply( null, ret.data.girl );
			
			loadImage();
		}
		
		private function loadImage():void
		{
			_loadLength = _manData.length;
			var i:int;
			for( i = 0; i < _loadLength; i++ )
			{
				ImageLoader.get().getImageCallback( _manData[ i ].icon, checkAllLoaded );
			}
			_loadLength = _girlData.length;
			for( i = 0; i < _loadLength; i++ )
			{
				ImageLoader.get().getImageCallback( _girlData[ i ].icon, checkAllLoaded );
			}
			_loadLength = _manData.length;
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
			_girlIndex = 0;
			_manIndex = 0;
			
			var bitmap:Bitmap = new Bitmap( ImageLoader.get().getBitmapData( _girlData[ _girlIndex ].icon ) );
			_girl0.container.addChild( bitmap );
			setBack( _girl0 );
			setBitmapPos( bitmap );
			
			bitmap = new Bitmap( ImageLoader.get().getBitmapData( _manData[ _manIndex ].icon ) );
			_man0.container.addChild( bitmap );
			setBack( _man0 );
			setBitmapPos( bitmap );
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, roll );
		}
		private function roll( e:KeyboardEvent ):void
		{
			switch( e.keyCode )
			{
				case Keyboard.BACKSPACE:
				case Keyboard.CONTROL:
					stage.removeEventListener( KeyboardEvent.KEY_DOWN, roll );
					UITool.playMovieClip( _heartLine );
					TweenLite.to( _man0, _UP_DURATION, { y:0, onComplete:onManComplete0 } );
					_label0.show( _manData[ _manIndex ].nick, _UP_DURATION );
					TweenLite.to( _girl0, _UP_DURATION, { y:0, onComplete:onGirlComplete0 } );
					_label1.show( _girlData[ _girlIndex ].nick, _UP_DURATION );
					
					var params:Object = { barid:_barid, token:_token };
					HttpMgr.get().post( URL2.pair, params, onPair );
					break;
				default:
					break;
			}
		}
		
		private function onPair( ret:Object ):void
		{
			if( null == ret.data )
			{
				return;
			}
			if( 0 != ret.code )
			{//ret.code == 0说明为返回成功
				trace( "ret.code = " + ret.code );
				return;
			}
//			_manData.push.apply( null, ret.data.boy );
			_matchBoyInfo = ret.data.boy;
			_matchGirlInfo = ret.data.girl;
			_loadLength = 0;
			ImageLoader.get().getImageCallback( _matchBoyInfo.icon, matchLoverImagesLoaded );
			ImageLoader.get().getImageCallback( _matchGirlInfo.icon, matchLoverImagesLoaded );
		}
		private function matchLoverImagesLoaded( bitmapData:BitmapData):void
		{
			_loadLength++
			if( _loadLength == 2 )
			{
				stage.addEventListener( KeyboardEvent.KEY_DOWN, showResult );
			}
		}
		
		private function showResult( e:KeyboardEvent ):void
		{
			switch( e.keyCode )
			{
				case Keyboard.BACKSPACE:
				case Keyboard.CONTROL:
					_stop = true;
					break;
				default:
					break;
			}
		}
		private function get UP_DURATION():Number
		{
			return _UP_DURATION;
		}
		private function set UP_DURATION( upDuration:Number ):void
		{
			if( _UP_DURATION < MIN_DURATION )
			{
				return;
			}
			_UP_DURATION = upDuration;
		}
		
		private function stopOnResult():void
		{
			if( !_oneRoleStop )
			{
				_oneRoleStop = true;
				return;
			}
			UITool.playMovieClip( _smallHearts );
			UITool.playMovieClip( _topLight );
			UITool.stopMovieClip( _heartLine );
			_heartLine.visible = false;
			
			_success = new SuccessClip();
			_layer.addChild( _success );
			_success.ui.addEventListener( Event.ENTER_FRAME, onSuccessEnterFrame );
		}
		private function onSuccessEnterFrame( e:Event ):void
		{
			if( _success.ui.currentLabel >= "stop" )
			{
				UITool.stopMovieClip( _success );
				_success.ui.removeEventListener( Event.ENTER_FRAME, onSuccessEnterFrame );
			}
		}
		/**
		 *第一个到达中心
		 */		
		private function onManComplete0():void
		{
			if( _stop && _matchBoyInfo.userid == _manData[ _manIndex ].userid )
			{
				stopOnResult();
				return;
			}
			manIndex++;
			UP_DURATION -= SUBTRACT;
			var bitmap:Bitmap = new Bitmap( ImageLoader.get().getBitmapData( _manData[ _manIndex ].icon ) );
			UITool.removeChildren( _man1.container );
			_man1.container.addChild( bitmap );
			setBack( _man1 );
			setBitmapPos( bitmap );
			
			TweenLite.killTweensOf( _man0 );
			TweenLite.killTweensOf( _man1 );
			TweenLite.to( _man1, _UP_DURATION, { y:0, onComplete:onManComplete1 } );
			_label0.show( _manData[ _manIndex ].nick, _UP_DURATION );
			TweenLite.to( _man0, _UP_DURATION, { y:-DIAMETER } );
		}
		/**
		 *第二个到达中心
		 */		
		private function onManComplete1():void
		{
			if( _stop && _matchBoyInfo.userid == _manData[ _manIndex ].userid )
			{
				stopOnResult();
				return;
			}
			manIndex++;
			UP_DURATION -= SUBTRACT;
			var bitmap:Bitmap = new Bitmap( ImageLoader.get().getBitmapData( _manData[ _manIndex ].icon ) );
			UITool.removeChildren( _man0.container );
			_man0.container.addChild( bitmap );
			setBack( _man0 );
			setBitmapPos( bitmap );
			
			TweenLite.killTweensOf( _man0 );
			TweenLite.killTweensOf( _man1 );
			TweenLite.to( _man0, _UP_DURATION, { y:0, onComplete:onManComplete0 } );
			_label0.show( _manData[ _manIndex ].nick, _UP_DURATION );
			TweenLite.to( _man1, _UP_DURATION, { y:-DIAMETER } );
		}
		private function onGirlComplete0():void
		{
			if( _stop && _matchGirlInfo.userid == _girlData[ girlIndex ].userid )
			{
				stopOnResult();
				return;
			}
			girlIndex++;
			var bitmap:Bitmap = new Bitmap( ImageLoader.get().getBitmapData( _girlData[ _girlIndex ].icon ) );
			UITool.removeChildren( _girl1.container );
			_girl1.container.addChild( bitmap );
			setBack( _girl1 );
			setBitmapPos( bitmap );
			
			TweenLite.killTweensOf( _girl0 );
			TweenLite.killTweensOf( _girl1 );
			TweenLite.to( _girl1, _UP_DURATION, { y:0, onComplete:onGirlComplete1 } );
			_label1.show( _girlData[ _girlIndex ].nick, _UP_DURATION );
			TweenLite.to( _girl0, _UP_DURATION, { y:-DIAMETER } );
		}
		private function onGirlComplete1():void
		{
			if( _stop && _matchGirlInfo.userid == _girlData[ girlIndex ].userid )
			{
				stopOnResult();
				return;
			}
			girlIndex++;
			var bitmap:Bitmap = new Bitmap( ImageLoader.get().getBitmapData( _girlData[ _girlIndex ].icon ) );
			UITool.removeChildren( _girl0.container );
			_girl0.container.addChild( bitmap );
			setBack( _girl0 );
			setBitmapPos( bitmap );
			
			TweenLite.killTweensOf( _girl0 );
			TweenLite.killTweensOf( _girl1 );
			TweenLite.to( _girl0, _UP_DURATION, { y:0, onComplete:onGirlComplete0 } );
			_label1.show( _girlData[ _girlIndex ].nick, _UP_DURATION );
			TweenLite.to( _girl1, _UP_DURATION, { y:-DIAMETER } );
		}
		private function get girlIndex():int
		{
			return _girlIndex;
		}
		private function get manIndex():int
		{
			return _manIndex;
		}
		private function set girlIndex( girlIndex:int ):void
		{
			if( _girlIndex < _girlData.length - 1 )
			{
				_girlIndex++;
			}
			else
			{
				_girlIndex = 0;
			}
		}
		private function set manIndex( manIndex:int ):void
		{
			if( _manIndex < _manData.length - 1 )
			{
				_manIndex++;
			}
			else
			{
				_manIndex = 0;
			}
		}
		private function setBack( container:Sprite ):void
		{
			container.y = DIAMETER;
		}
		private function setBitmapPos( bitmap:Bitmap ):void
		{
			bitmap.height = RADIUS;
			bitmap.width = RADIUS;
			bitmap.x = -RADIUS / 2;
			bitmap.y = -RADIUS / 2;
		}
		private function initComponent():void
		{
			_background = new MatchBackground();
			addChild( _background );
			_background.x = stage.stageWidth / 2;
			_background.width = stage.stageWidth;
			_background.height = stage.stageHeight;
			_background.cacheAsBitmap = true;
			
			_layer = new Sprite();
			addChild( _layer );
			_layer.x = stage.stageWidth / 2;
			
			_topIcon = new TopIcon();
			_layer.addChild( _topIcon );
			
			_topLight = new TopLight();
			_layer.addChild( _topLight );
			UITool.stopMovieClip( _topLight );
			
			_circle = new RotationCircle()
			_layer.addChild( _circle );
			_circle.y = _circle.width / 2;
			_circle.scaleX = _circle.scaleY = 0.66;
			
			_smallHearts = new SmallHearts();
			_layer.addChild( _smallHearts );
			UITool.stopMovieClip( _smallHearts );
			
			_heartLine = new HeartLine();
			_layer.addChild( _heartLine );
			UITool.stopMovieClip( _heartLine );
			
			_heart = new Heart();
			_layer.addChild( _heart );
			
			_manBigIcon = new Man();
			_layer.addChild( _manBigIcon );
			UITool.removeChildren( _manBigIcon.icon.container );
			
			_girlBigIcon = new Girl();
			_layer.addChild( _girlBigIcon );
			UITool.removeChildren( _girlBigIcon.icon.container );
			
			_girl0 = new RoleContainer();
			_girl1 = new RoleContainer();
			_girlBigIcon.icon.container.addChild( _girl0 );
			_girlBigIcon.icon.container.addChild( _girl1 );
			UITool.removeChildren( _girl0.container );
			UITool.removeChildren( _girl1.container );
			
			_man0 = new RoleContainer();
			_man1 = new RoleContainer();
			UITool.removeChildren( _man0.container );
			UITool.removeChildren( _man1.container );
			_manBigIcon.icon.container.addChild( _man0 );
			_manBigIcon.icon.container.addChild( _man1 );
			
			_label0 = new Lable();
			_label1 = new Lable();
			_label0.x = -600;
			_label1.x = 200;
			
			_layer.addChild( _label0 );
			_layer.addChild( _label1 );
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
	}
}