package
{
	import flash.display.Bitmap;
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
	import core.Looper;
	import core.UITool;
	import core.interfaces.ILeap;
	
	import net.HttpMgr;
	import net.JSCall;
	import net.URL;
	import net.URL2;
	
	import ui.Fail;
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
	public class MatchLover extends Sprite implements ILeap
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
		 *	userid:10014
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
		private var _UP_DURATION:Number = 0.3;
		private var SUBTRACT:Number = 0.1;
		private var _topIcon:TopIcon;
		/**
		 * {
		 * icon:"http://yx.kklink.com/asimg/male/141102404606283.jpg",
		 * nick:"两口遇三金",
		 * sex:"M",
		 * userid:233774
		 * }
		 */		
		private var _matchBoyInfo:Object;
		/**
		 * {
		 * icon:"http://yx.kklink.com/asimg/male/141102404606283.jpg",
		 * nick:"两口遇三金",
		 * sex:"M",
		 * userid:233774
		 * }
		 */
		private var _matchGirlInfo:Object;
		private var _success:SuccessClip;
		private var _label0:Lable;
		private var _label1:Lable;
		private var _fail:Boolean = false;
		private var failPanel:Fail;
		private var _newBoy:Array;
		private var _newGirl:Array;
		private var _newLoadLength:uint;
		private var speed:Number = 96;
		/**
		 *572
		 */		
		private var DIAMETER:Number = speed * 6;
		/*private var speed:Number = 16;
		private var DIAMETER:Number = speed * 36;*/
		private var _centerLayer:Sprite;
		public function MatchLover()
		{
			super();
			Security.allowDomain( "*" );
			Security.allowInsecureDomain( "*" );
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
				trace( "MatchLover.onBarList:ret.code = " + ret.code );
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
			begin();
		}
		
		private function begin():void
		{
			_girlIndex = 0;
			_manIndex = 0;
			
			var bitmap:Bitmap = new Bitmap( ImageLoader.get().getBitmapData( _girlData[ _girlIndex ].icon ) );
			_girl1.container.addChild( bitmap );
			setGirlBack( _girl0 );
			setGirlBack( _girl1 );
			setBitmapPos( bitmap );
			
			bitmap = new Bitmap( ImageLoader.get().getBitmapData( _manData[ _manIndex ].icon ) );
			_man1.container.addChild( bitmap );
			_man0.y = DIAMETER;
			_man1.y = DIAMETER;
			setBitmapPos( bitmap );
			
			var params:Object = { barid:_barid, token:_token };
			HttpMgr.get().post( URL2.pair, params, onPair );
		}
		private function roll( e:KeyboardEvent ):void
		{
			switch( e.keyCode )
			{
				case Keyboard.SPACE:
					stage.removeEventListener( KeyboardEvent.KEY_DOWN, roll );
					UITool.playMovieClip( _heartLine );
					
					_smallHearts.visible = false;
					_topLight.visible = false;
					_success.visible = false;
					UITool.stopMovieClip( _smallHearts );
					UITool.stopMovieClip( _topLight );
					UITool.playMovieClip( _heartLine );
					_heartLine.visible = true;
					failPanel.visible = false;
					
					_man0.visible = true;
					_man1.visible = true;
					_girl0.visible = true;
					_girl1.visible = true;
					_label0.visible = true;
					_label1.visible = true;
					
					Looper.get().addLeapComponent( this );
					_label0.show( _manData[ _manIndex ].nick, _UP_DURATION );
					_label1.show( _girlData[ _girlIndex ].nick, _UP_DURATION );
					
					stage.addEventListener( KeyboardEvent.KEY_DOWN, showResult );
					break;
				default:
					break;
			}
		}
		
		public function onTick(  ):void
		{
			_man0.y -= speed;
			_man1.y -= speed;
			if( 0 == _man0.y )
			{
				setMan( _man1 );
				_label0.show( _manData[ _manIndex ].nick, _UP_DURATION );
			}
			if( 0 == _man1.y )
			{
				setMan( _man0 );
				_label0.show( _manData[ _manIndex ].nick, _UP_DURATION );
			}
			_girl0.y += speed;
			_girl1.y += speed;
			if( 0 == _girl0.y )
			{
				setGirl( _girl1 );
				_label1.show( _girlData[ _girlIndex ].nick, _UP_DURATION );
			}
			if( 0 == _girl1.y )
			{
				setGirl( _girl0 );
				_label1.show( _girlData[ _girlIndex ].nick, _UP_DURATION );
			}
		}
		public function get priority():Number
		{
			return 0;
		}
		
		
		private function loadNewImage():void
		{
			_newLoadLength = _newBoy.length;
			var i:int;
			for( i = 0; i < _newLoadLength; i++ )
			{
				ImageLoader.get().getImageCallback( _newBoy[ i ].icon, checkNewAllLoaded );
			}
			_newLoadLength = _newGirl.length;
			for( i = 0; i < _newLoadLength; i++ )
			{
				ImageLoader.get().getImageCallback( _newGirl[ i ].icon, checkNewAllLoaded );
			}
			_newLoadLength = _newBoy.length + _newGirl.length;
		}
		private function checkNewAllLoaded( bmd:BitmapData ):void
		{
			_newLoadLength--;
			if( 0 != _newLoadLength )
			{
				return;
			}
			if( _newBoy.length > 0 )
			{
				_manData.push.apply( null, _newBoy );
				_newBoy = [];
			}
			if( _newGirl.length > 0 )
			{
				_girlData.push.apply( null, _newGirl );
				_newGirl = [];
			}
		}
		private function matchLoverImagesLoaded( bitmapData:BitmapData):void
		{
			_loadLength++
			if( _loadLength == 2 )
			{
				trace( "MatchLover.matchLoverImagesLoaded( bitmapData );配对男女图片加载成功！" );
				stage.removeEventListener( KeyboardEvent.KEY_DOWN, roll );
				stage.addEventListener( KeyboardEvent.KEY_DOWN, roll );
			}
		}
		
		private function showResult( e:KeyboardEvent ):void
		{
			switch( e.keyCode )
			{
				case Keyboard.SPACE:
					trace( "MatchLover.showResult( e ):显示结果" );
					stage.removeEventListener( KeyboardEvent.KEY_DOWN, showResult );
					
					Looper.get().removeLeapComponent( this );
					
					if( _fail )
					{
						failPanel.visible = true;
						
						_man0.visible = false;
						_man1.visible = false;
						_girl0.visible = false;
						_girl1.visible = false;
						
						_label0.visible = false;
						_label1.visible = false;
						
						stage.addEventListener( KeyboardEvent.KEY_DOWN, roll );
					}
					else
					{
						showSeccess();
					}
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
			//			ret.code = 0;
			if( 0 != ret.code )
			{//ret.code == 0说明为返回成功
				trace( "onPair:ret.code = " + ret.code );
				_fail = true;
				stage.removeEventListener( KeyboardEvent.KEY_DOWN, roll );
				stage.addEventListener( KeyboardEvent.KEY_DOWN, roll );
				return;
			}
			_fail = false;
			_matchBoyInfo = ret.data.boy;
			_matchGirlInfo = ret.data.girl;
			
			//			_matchBoyInfo = _manData[ _manIndex ];
			//			_matchGirlInfo = _girlData[ _girlIndex ];
			
			_loadLength = 0;
			ImageLoader.get().getImageCallback( _matchBoyInfo.icon, matchLoverImagesLoaded );
			ImageLoader.get().getImageCallback( _matchGirlInfo.icon, matchLoverImagesLoaded );
			_newBoy = ret.data.list.boy as Array;
			_newGirl= ret.data.list.girl as Array;
			loadNewImage();
		}
		private function showSeccess():void
		{
			var bmd:BitmapData = ImageLoader.get().getBitmapData( _matchBoyInfo.icon );
			var bitmap:Bitmap = new Bitmap( bmd );
			UITool.removeChildren( _man1.container );
			_man1.container.addChild( bitmap );
			_man1.y = 0;
			setBitmapPos( bitmap );
			
			bmd = ImageLoader.get().getBitmapData( _matchGirlInfo.icon );
			bitmap = new Bitmap( bmd );
			UITool.removeChildren( _girl1.container );
			_girl1.container.addChild( bitmap );
			_girl1.y = 0;
			setBitmapPos( bitmap );
			
			_smallHearts.visible = true;
			
			UITool.playMovieClip( _smallHearts );
			UITool.stopMovieClip( _heartLine );
			_heartLine.visible = false;
			
			_topLight.visible = true;
			_topLight.mc.gotoAndPlay( 1 );
			_topLight.mc.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			
			_success.visible = true;
			_success.ui.gotoAndPlay( 1 );
			_success.ui.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		private function onEnterFrame( e:Event ):void
		{
			trace( "_success.ui.currentFrame = " + _success.ui.currentFrame + "; _topLight.mc.currentFrame = " + _topLight.mc.currentFrame );
			if( _success.ui.currentFrame >= 10 || _success.ui.currentLabel == "stop" )
			{
				_success.ui.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
				_success.ui.stop();
				UITool.stopMovieClip( _success );
			}
			if( _topLight.mc.currentFrame >= 10 || _topLight.mc.currentLabel == "stop" )
			{
				_topLight.mc.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
				_topLight.mc.stop();
				UITool.stopMovieClip( _topLight );
			}
			if( ( _success.ui.currentFrame >= 10 || _success.ui.currentLabel == "stop" ) && 
				( _topLight.mc.currentFrame >= 10 || _topLight.mc.currentLabel == "stop" ) )
			{
				stage.removeEventListener( KeyboardEvent.KEY_DOWN, roll );
				stage.addEventListener( KeyboardEvent.KEY_DOWN, roll );
			}
		}
		private function setMan( man:RoleContainer ):void
		{
			manIndex++;
			var bmd:BitmapData = ImageLoader.get().getBitmapData( _manData[ _manIndex ].icon );
			var bitmap:Bitmap = new Bitmap( bmd );
			UITool.removeChildren( man.container );
			man.container.addChild( bitmap );
			man.y = DIAMETER;
			setBitmapPos( bitmap );
		}
		private function setGirl( girl:RoleContainer ):void
		{
			girlIndex++;
			var bitmap:Bitmap = new Bitmap( ImageLoader.get().getBitmapData( _girlData[ _girlIndex ].icon ) );
			UITool.removeChildren( girl.container );
			girl.container.addChild( bitmap );
			setGirlBack( girl );
			setBitmapPos( bitmap );
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
		private function setGirlBack( container:Sprite ):void
		{
			container.y = -DIAMETER;
		}
		private function setBitmapPos( bitmap:Bitmap ):void
		{
			bitmap.height = DIAMETER;
			bitmap.width = DIAMETER;
			bitmap.x = -DIAMETER / 2;
			bitmap.y = -DIAMETER / 2;
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
			
			_centerLayer = new Sprite();
			_layer.addChild( _centerLayer );
			
			_topLight = new TopLight();
			_layer.addChild( _topLight );
			UITool.stopMovieClip( _topLight );
			
			_circle = new RotationCircle()
			_centerLayer.addChild( _circle );
			_circle.y = _circle.width / 2;
			_circle.scaleX = _circle.scaleY = 0.66;
			
			_smallHearts = new SmallHearts();
			_centerLayer.addChild( _smallHearts );
			UITool.stopMovieClip( _smallHearts );
			
			_heartLine = new HeartLine();
			_centerLayer.addChild( _heartLine );
			UITool.stopMovieClip( _heartLine );
			
			_heart = new Heart();
			_centerLayer.addChild( _heart );
			
			_manBigIcon = new Man();
			_centerLayer.addChild( _manBigIcon );
			UITool.removeChildren( _manBigIcon.icon.container );
			
			_girlBigIcon = new Girl();
			_centerLayer.addChild( _girlBigIcon );
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
			
			_centerLayer.addChild( _label0 );
			_centerLayer.addChild( _label1 );
			
			_success = new SuccessClip();
			_centerLayer.addChild( _success );
			_success.visible = false;
			
			failPanel = new Fail();
			_centerLayer.addChild( failPanel );
			failPanel.visible = false;
			failPanel.graphics.beginFill( 0x000000, 0.5 );
			failPanel.graphics.drawRect( -BACKGROUND_WIDTH, -BACKGROUND_HEIGHT, BACKGROUND_WIDTH * 2, BACKGROUND_HEIGHT * 2 );
			failPanel.graphics.endFill();
			
//			_centerLayer.y -= 50;
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