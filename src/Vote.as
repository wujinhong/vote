package
{
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Security;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import core.ImageLoader;
	import core.Looper;
	import core.UITool;
	
	import net.HttpMgr;
	import net.JSCall;
	import net.URL;
	
	import ui.Background;
	import ui.BackgroundImage;
	import ui.CenterShine;
	import ui.Circle;
	import ui.EmptyRole;
	import ui.Light;
	import ui.Number1;
	import ui.Number2;
	import ui.Number3;
	import ui.RotationCircle;
	import ui.Title;
	import ui.VoteRole;
	
	/**
	 * Vote
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 22, 2014   11:11:26 AM
	 * @version 1.0
	 */
	[SWF( height = 540, width = 960, frameRate = 60 )]
	public class Vote extends Sprite
	{
		public static const BACKGROUND_WIDTH:Number = 1920;
		public static const BACKGROUND_HEIGHT:Number = 1080;
		/**_user的数据格式:
		 * {
		 *		icon:"http://yx.kklink.com/asimg/11945/HeaderFace/140821170046501.jpg",	
		 *		nick:"小罗",	
		 *		sex:"F",
		 *		userid:11945,
		 *		vote_num:5
		 * }
		 */
		
		public static var USER:Vector.<Object> = new Vector.<Object>();
		public static var NEW_USER:Array = [];
		public static const EMPTY_ROLE:String = "empty_role";
		public static const END_FRAME_INDEX:uint = 33;
		private var _mouseDir:int;
		private var _layer:Sprite;
		private var _loadLength:int;
		private var _length:int;
		private var _backgroundLogo:Background;
		private var _token:String;
		private var _barid:int;
		private var _eventid:int;
		private var _time:uint;
		private var _emptyRoleNum:int;
		private var _lightCircleLayer:Sprite;
		private var _circle:Circle;
		private var _light:Light;
		private var _title:Title;
		private var _step:uint = 0;
		private var _status:uint = 1;
		private var _roleLayer:Sprite;
		/**
		 *_rankList:
		 * {
		 *		icon:"http://yx.kklink.com/asimg/1124228/HeaderFace/141024203836899.jpg"
		 *		nick:"czx"
		 *		ranking:1
		 *		sex:"M"
		 *		userid:1124228
		 *		vote_num:4
		 * }
		 */		
		public static var RANK_LIST:Vector.<Object> = new Vector.<Object>();
		private var _centerShine:CenterShine;
		private var _number3:Number3;
		private var _number2:Number2;
		private var _backgroundImage:BackgroundImage;
		private var _parameterSet:Boolean = false;
		private var _identifier:int = 0;
		private var _number1:Number1;
		private var _roleIndex:int;
		public function Vote()
		{
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
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener( Event.RESIZE, onStageResize );
			
			Looper.get().init( stage );
			_layer = new Sprite();
			_backgroundImage = new BackgroundImage();//背景大图
			addChild( _backgroundImage );
			_backgroundImage.cacheAsBitmap = true;
			
			_lightCircleLayer = new Sprite();
			_roleLayer = new Sprite();
			
			_circle = new RotationCircle()
			_light = new Light()
			_lightCircleLayer.addChild( _circle );
			_lightCircleLayer.addChild( _light );
			_layer.addChild( _lightCircleLayer );
			_lightCircleLayer.y = _circle.width / 2 - 194;
			_lightCircleLayer.scaleX = _lightCircleLayer.scaleY = 0.66;
			
			_backgroundLogo = new Background();
			_layer.addChild( _backgroundLogo );
			addChild( _layer );
			_layer.addChild( _roleLayer );
			
			_backgroundImage.x = stage.stageWidth / 2;
			_layer.x = stage.stageWidth / 2;
			
			onStageResize();
			
			/*_title = new Title();
			_layer.addChild( _title );
			_title.y = _circle.width / 2;*/
			
			JSCall.addCallback( URL.ASFunc, ASFunc );
			JSCall.CallJS( URL.JSFunc );
//			onClosure();//测试代码
//			setTimeout( gotoCenter, 2000 );
			onReady();
		}
		
		private function gotoCenter():void
		{
			TweenLite.to( _title, 1, { alpha:0.1, scaleX:0.1, scaleY:0.1, y:_title.y - 100, onComplete:onReady } );
		}
		private function onReady():void
		{
			if( null != _title )
			{
				_layer.removeChild( _title );
				_title = null;
			}
			begin();
		}
		
		/**
		 *被JS调用的方法
		 */
		private function ASFunc( barid:int = 0, eventid:int = 0, token:String = "", obj:Object = null ):void
		{
			_barid = barid;
			_eventid = eventid;
			_token = token;
			if( _parameterSet )
			{
				return;
			}
			var param:Object = { barid:_barid, token:_token, eventid:_eventid };
			HttpMgr.get().post( URL.basicInfo, param, onBasicInfo );
			
			begin();
			_parameterSet = true;
		}
		/**
		 *分三步：
		 * 1、中心图标缩小消失后；
		 * 2、JS调用完AS方法
		 * 3、图标加载完成 
		 */		
		private function begin():void
		{
			if( ++_step == 3 )
			{
				addRoles();
				pollPost();
			}
		}
		
		/**
		 *长轮询
		 */
		private function pollPost():void
		{
			var param:Object = { barid:_barid, token:_token, eventid:_eventid, time:_time };
			HttpMgr.get().post( URL.list, param, onPollPost );
		}
		private function onPollPost( ret:Object ):void
		{
			if( null == ret.data )
			{
				return;
			}
			if( 0 != ret.code )
			{//ret.code == 0说明为返回成功
				return;
			}
			_time = ret.data.time;
			_status = ret.data.status;
			if( 0 == _status  )
			{
				getResult();
				return;
			}
			
			NEW_USER = ret.data.user as Array;
			for each( var i:Object in ret.data.vote )
			{
				for( var j:int = 0; j < USER.length; j++ ) 
				{
					if( USER[ j ].userid != i.userid )
					{
						continue;
					}
					USER[ j ].vote_num = i.vote_num;
				}
			}
			loadRoleImage();
			pollPost();
		}
		private function onBasicInfo( ret:Object ):void
		{
			if( null == ret.data )
			{
				return;
			}
			if( 0 != ret.code )
			{//ret.code == 0说明为返回成功
				return;
			}
			
			if( null != ret.data.logo )
			{
				ImageLoader.get().getImage( ret.data.logo, _backgroundLogo.logo );
			}
			if( null != ret.data.title )
			{
				_backgroundLogo.title.text = ret.data.title;
			}
			_time = ret.data.time;
			
			NEW_USER = ret.data.user;
			loadRoleImage();
		}
		
		private function onStageResize( e:Event = null ):void
		{
			var newScaleX:Number = stage.stageWidth / BACKGROUND_WIDTH;
			var newScaleY:Number = stage.stageHeight/ BACKGROUND_HEIGHT;
			_layer.x = stage.stageWidth / 2;
			_backgroundImage.x = stage.stageWidth / 2;
			_backgroundImage.width = stage.stageWidth;
			_backgroundImage.height = stage.stageHeight;
			_layer.scaleX = _layer.scaleY = newScaleX < newScaleY ? newScaleX : newScaleY;
		}
		private function loadRoleImage():void
		{
			_loadLength = NEW_USER.length;
			for( var i:int = 0; i < _loadLength; i++ )
			{
				ImageLoader.get().getImageCallback( NEW_USER[ i ].icon, checkAllLoaded );
			}
			if( 0 == _loadLength )
			{
				begin();
			}
		}
		private function checkAllLoaded( bitmapData:BitmapData = null ):void
		{
			if( 0 != --_loadLength )
			{
				return;
			}
			if( _emptyRoleNum > 0 )
			{
				USER.splice( USER.length - _emptyRoleNum, _emptyRoleNum );
				_emptyRoleNum = 0;
			}
			USER.push.apply( null, NEW_USER );
			checkUserData();
			begin();
		}
		private function checkUserData():void
		{
			if( null == ImageLoader.get().getBitmapData( EMPTY_ROLE ) )
			{
				var bmd:BitmapData = UITool.getUIBitmapData( new EmptyRole() );
				ImageLoader.get().addBitmapData( EMPTY_ROLE, bmd )
			}
			if( _emptyRoleNum > 0 )
			{
				return;
			}
			if( USER.length > 5 )
			{
				return;
			}
			_emptyRoleNum = 5 - USER.length;
			for( var i:int = 0; i < _emptyRoleNum; i++ )
			{
				USER.push( { icon:EMPTY_ROLE } );
			}
		}
		private function addRoles():void
		{
			checkUserData();
			_length = USER.length;
			_roleIndex =  0;
			addRole();
		}
		private function addRole():void
		{
			var role:VoteRole = new VoteRole( _roleIndex, onStop );
			_roleLayer.addChild( role );
			role.y = VoteRole.ROLE_HEIGHT * 0.3 + 20;
			
			var duration:Number = VoteRole.DURATION * 1000 - 200;
			if( _roleIndex < USER.length - 1 )
			{
				_roleIndex++;
			}
			else
			{
				_roleIndex = 0;
			}
			setTimeout( addRole, duration );
		}
		private function getResult():void
		{
			_loadLength = 0;
			var param:Object = { barid:_barid, token:_token, eventid:_eventid, time:_time };
			HttpMgr.get().post( URL.result, param, onResult );
			TweenLite.to( _roleLayer, 1, { alpha:0, y:_roleLayer.y + VoteRole.ROLE_HEIGHT - 100, scaleX:0.1, scaleY:0.1, onComplete:onReomveRoles } );
		
			TweenLite.to( _lightCircleLayer, 1, { y:_circle.width / 2, scaleX:1, scaleY:1 } );
			
			_centerShine = new CenterShine();
			_centerShine.stop();
		}
		private function onReomveRoles():void
		{
			_roleLayer.visible = false;
			_layer.addChild( _centerShine );
			_centerShine.addEventListener( Event.ENTER_FRAME, onCenterShineEnterFrame );
			_centerShine.play();
		}
		
		private function onCenterShineEnterFrame( e:Event ):void
		{
			trace("onCenterShineEnterFrame currentFrame:" + _centerShine.currentFrame );
			
			if( _centerShine.currentFrame >= END_FRAME_INDEX )
			{
				_centerShine.removeEventListener( Event.ENTER_FRAME, onCenterShineEnterFrame );
				checkRankIconLoaded();
			}
		}
		private function onResult( ret:Object = null ):void
		{
			if( null == ret.data )
			{
				return;
			}
			if( 0 != ret.code )
			{//ret.code == 0说明为返回成功
				return;
			}
			RANK_LIST.push.apply( null, ret.data );
			/*RANK_LIST.sort( function( ui1:Object, ui2:Object ):Number
			{
				if( ui1.ranking > ui2.ranking )
				{
					return 1;
				}
				
				if( ui1.ranking < ui2.ranking )
				{
					return -1;
				}
				return 0;
			} );*/
			var rankLength:int = RANK_LIST.length > 3 ? 3 :RANK_LIST.length;
			for( var i:int = 0; i < rankLength; i++ )
			{
				ImageLoader.get().getImageCallback( RANK_LIST[ i ].icon, checkRankIconLoaded );
			}
		}
		private function checkRankIconLoaded( bitmapData:BitmapData = null ):void
		{
			++_loadLength;
			trace( "checkRankIconLoaded : _loadLength : " + _loadLength );
			if( _loadLength != RANK_LIST.length + 1 )
			{
				return;
			}
			showRankCuprum();
		}
		
		private function showRankCuprum():void
		{
			trace("Vote.showRankCuprum()");
			
			_centerShine.stop();
			if( null != _number3 )
			{
				return;
			}
			if( Vote.RANK_LIST.length >= 3 )
			{
				_number3 = new Number3( showRankSilver );
				_layer.addChild( _number3 );
			}
			else if( Vote.RANK_LIST.length == 2 )
			{
				onCenterShineEnterFrame2( null );
			}
			else if( Vote.RANK_LIST.length == 1 )
			{
				onCenterShineEnterFrame3( null );
			}
		}
		private function showRankSilver():void
		{
			_centerShine.addEventListener( Event.ENTER_FRAME, onCenterShineEnterFrame2 );
			_centerShine.gotoAndPlay( 1 );
		}
		private function onCenterShineEnterFrame2( e:Event ):void
		{
			trace("onCenterShineEnterFrame2: currentFrame:" + _centerShine.currentFrame );
			if( _centerShine.currentFrame >= END_FRAME_INDEX )
			{
				_centerShine.stop();
				_centerShine.removeEventListener( Event.ENTER_FRAME, onCenterShineEnterFrame2 );
				if( null != _number2 )
				{
					return;
				}
				_number2 = new Number2( showRankGold );
				_layer.addChild( _number2 );
			}
		}
		private function showRankGold():void
		{
			_centerShine.addEventListener( Event.ENTER_FRAME, onCenterShineEnterFrame3 );
			_centerShine.gotoAndPlay( 1 );
		}
		private function onCenterShineEnterFrame3( e:Event ):void
		{
			if( _centerShine.currentFrame >= END_FRAME_INDEX )
			{
				_centerShine.stop();
				_centerShine.removeEventListener( Event.ENTER_FRAME, onCenterShineEnterFrame3 );
				_centerShine.visible = false;
				if( null != _number1 )
				{
					return;
				}
				_number1 = new Number1()
				_layer.addChild( _number1 );
			}
		}
		private function onStop( role:VoteRole ):void
		{
//			trace( "Vote.onStop( role ):" + role );
		}
	}
}