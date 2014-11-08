package tg888
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import core.UITool;
	
	import gs.TweenLite;
	import gs.easing.Back;
	import gs.easing.Elastic;
	import gs.easing.Strong;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	import ui.LotteryRole;

	/**
	 * 
	 * @author Administrator
	 * 
	 */	
	public class MainWall extends Sprite
	{
		public static const VIEW_WIDTH:Number = 1920;
		//shadow
		private var shadowDown:Number=-460;
		private var _view:Viewport3D;
		private var _scenes:Scene3D;
		private var _camera:Camera3D;
		private var _render:BasicRenderEngine;
		//3dparams
		private var _camerarotation:Number;
		private var numOfRotations:Number=1;
		
		private var materials:Array=new Array();
		private var Planes:Array=new Array();
		private var shadows:Array=new Array();		
		
		//xml message****************************
		private var folder:String = "thumbnails/";
		private var flashmo_xml:XML;
		private var _urlTitle:Array=new Array;
		private var _address:Array=new Array;	
		private var title_list:Array = new Array();
		
		private var anglePer:Number;
		private var outCircle:int;
		private var inCircle:int;
		
		private var _loding:Loader;
		private var _loadingIndex:int=0;
	
		/* action  */		 		
		private var actionPlane:WallPlane;
		private var _showIndex:int=-1;
		private var _positionStop:int=0;
		
		private var ms:MoveShower = new MoveShower();
		
		public var IsTimeUp:int = 1;
		public function MainWall()
		{
			super();
		}	
		public function start():void
		{
			init3D();
			loadXML();
		}
		private function init3D():void 
		{	
			_pannelCenter = new Plane();
			_pannelCenter.y = 0;
			_view=new Viewport3D( VIEW_WIDTH,1080,false,true);
			addChild(_view);	
			_scenes=new Scene3D();
			_camera=new Camera3D();			
			//addLoadingICO();		
			_render=new BasicRenderEngine();		
		}
		private function loadXML():void
		{			
			flashmo_xml = <files>	
				<file pic="a01" mov="a01" title="二维码" urlTitle="查看更多" urlTarget="ewm"> </file>
				<file pic="a02" mov="a01" title="商信通" urlTitle="查看更多" urlTarget="sxt"> </file>
				<file pic="a03" mov="a01" title="农信通" urlTitle="查看更多" urlTarget="nxt"> </file>
				<file pic="a04" mov="a01" title="财信通" urlTitle="查看更多" urlTarget="cxt"> </file>
				<file pic="a05" mov="a01" title="警务通" urlTitle="查看更多" urlTarget="jwt"> </file>
				<file pic="a06" mov="a01" title="车务通" urlTitle="查看更多" urlTarget="cwt"> </file>
				<file pic="a07" mov="a01" title="gprs监控" urlTitle="查看更多" urlTarget="gprs"> </file>
				<file pic="a08" mov="a01" title="校信通" urlTitle="查看更多" urlTarget="xxt"> </file>
				<file pic="a09" mov="a01" title="一卡通" urlTitle="查看更多" urlTarget="ykt"> </file>
				<file pic="a10" mov="a01" title="商务宝" urlTitle="查看更多" urlTarget="swb"> </file>
				<file pic="a11" mov="a01" title="移动400" urlTitle="查看更多" urlTarget="yd4"> </file>
				<file pic="a12" mov="a01" title="企信通" urlTitle="查看更多" urlTarget="qxt"> </file>
				<file pic="a13" mov="a01" title="移动总机" urlTitle="查看更多" urlTarget="ydzj"> </file>
				<file pic="a14" mov="a01" title="综合V网" urlTitle="查看更多" urlTarget="zhvw"> </file>
				<file pic="a15" mov="a01" title="集团彩铃" urlTitle="查看更多" urlTarget="jtcl"> </file>
				<file pic="a16" mov="a01" title="企业建站" urlTitle="查看更多" urlTarget="qyjz"> </file>
				<file pic="a17" mov="a01" title="办公助理" urlTitle="查看更多" urlTarget="bgzl"> </file>
				<file pic="a18" mov="a01" title="移动OA" urlTitle="查看更多" urlTarget="ydoa"> </file>
				<file pic="a19" mov="a01" title="企业邮箱" urlTitle="查看更多" urlTarget="qyyx"> </file>
				<file pic="a20" mov="a01" title="PTX业务" urlTitle="查看更多" urlTarget="ptx"> </file>
				
				<word name="标题" size='16' font='黑体' b='1' color="0xffffff" urlTitle="查看更多"></word>
				<word name="链接" size='10' font='宋体' b='1' color="0xffffff" urlTitle="查看更多" ></word>	
				<filter name="前面发光" range="8" color="0xffffff" alpha="0.8" ></filter>
				<filter name="原位模糊" range="6"  alpha="1" ></filter>
				<filter name="字体发光" range="10" color="0xffffff" alpha="0.8" ></filter>		
				<circle out="2000"  inc="375" yup="0" ydown="0"  urlTitle="查看更多" total="30"></circle>
				<camera rotationX="-60" rotationZ="-60" focus="20" zoom="20" xPoint="-5000" yPoint="0" zPoint="0" ></camera>
				<mc x="113" y="45" width="800" height="602" plx="2" ply="2"></mc>
			</files>;
			
			total = flashmo_xml.circle[0].@total
			outCircle = flashmo_xml.circle[0].@out;
			inCircle = flashmo_xml.circle[0].@inc;		
			
			_camera.rotationX = _camerarotation = flashmo_xml.camera[0].@rotationX;
			_camera.rotationZ = flashmo_xml.camera[0].@rotationZ;
			_camera.zoom = flashmo_xml.camera[0].@zoom;
			_camera.focus = flashmo_xml.camera[0].@focus;
			_camera.z = flashmo_xml.camera[0].@zPint;
			_camera.y = flashmo_xml.camera[0].@yPoint;
			_camera.x = flashmo_xml.camera[0].@xPoint;
			
			_loadingIndex = 0;
			anglePer = ( ( Math.PI * 2 ) * numOfRotations ) / total;
			renderAction();
			loadSmallPics();
		}
		private function loadSmallPics():void 
		{				
			if( null != _p )
			{
				_scenes.addChild( _p );
			}
			if( _loadingIndex < Lottery.lotteryData.length )
			{
				doLoadSmallPics();
			}
			else
			{
				addPlaneListeners();
				trace( "MainWall.loadSmallPics(  ):Lottery.lotteryData.length" + Lottery.lotteryData.length);
			}
			renderView();
		}
	
		private var _p:WallPlane;
		private var _pannelCenter:Plane;
		private function doLoadSmallPics():void 
		{
			if( _loadingIndex >= total )
			{
				return;
			}
			_urlTitle.push( Lottery.lotteryData[ _loadingIndex ].nick );
			_address.push( Lottery.lotteryData[ _loadingIndex ].icon );
			//title_list.push( flashmo_xml.file[ _loadingIndex ].@title.toString() );
			//var dir:String = folder +"pic/"+ flashmo_xml.file[_loadingIndex].@pic.toString()+".gif";
			var lotterRole:LotteryRole = LotteryRole.getLotteryRole( _loadingIndex );
			
			var bmd:BitmapData = UITool.getUIBitmapData( lotterRole );
			var bfm:BitmapMaterial = new BitmapMaterial( bmd );
			bfm.smooth = true;
			bfm.interactive = true;
			bfm.doubleSided = true;
			materials.push( bfm );
			var p:WallPlane = new WallPlane( _loadingIndex, bfm, 400, 500, flashmo_xml.mc[0].@plx, flashmo_xml.mc[0].@ply);
			_p = p;
			Planes.push( p );
			initPosition( p, outCircle );
//			/*if( _loadingIndex < 20 )
//			{				
				/*var sd:ShadowMovieClip=new ShadowMovieClip(bmd);
				var bfm2:MovieMaterial=new MovieMaterial(sd,true,true,false);
				var p2:WallPlane = new WallPlane(_loadingIndex,bfm2, 600, 450, flashmo_xml.mc[0].@plx, flashmo_xml.mc[0].@ply);
				p2.isShadow = true;
				_scenes.addChild( p2 );
				shadows.push( p2 );
				initShadowPosition( p2, outCircle );*/
//			}*/
			addNext();
		}
		private function addNext():void
		{
			trace( "MainWall.addNext( e ):_loadingIndex" + _loadingIndex );
			_loadingIndex++;
			loadSmallPics();
		}
		private function initShadowPosition(p:WallPlane,c:int):void 
		{
			p.rotationY = ( -p.index * anglePer ) * ( 180 / Math.PI ) + 90;
			p.x = Math.cos( p.index * anglePer ) * c;
			p.z = Math.sin( p.index * anglePer ) * c;
			var yp:Number = flashmo_xml.circle[0].@ydown;
			p.y = shadowDown + yp;
		}
		private function initPosition(p:WallPlane,c:int):void 
		{						
			p.rotationY = ( -p.index * anglePer ) * ( 180 / Math.PI ) + 90;
			p.x = Math.cos( p.index * anglePer ) * c;
			p.z = Math.sin( p.index * anglePer ) * c;
			p.y = p.index >= 20 ? flashmo_xml.circle[0].@yup : flashmo_xml.circle[0].@ydown;
			var dy:Number = p.rotationY - _camera.rotationY;
			if( dy < -270 )
			{
				dy += 360;
			}
			else if( dy > 270 )
			{
				dy -= 360;
			}
			TweenLite.to( _camera, 0.3, { rotationY:( _camera.rotationY + dy ),  ease:Strong.easeInOut } );	
		}
		/**
		 *停止渲染 
		 */		
		public function stopRenderView() :void
		{//浏览状态
			if( this.hasEventListener( Event.ENTER_FRAME ) )
			{
				this.removeEventListener( Event.ENTER_FRAME, renderActs );
				this.removeEventListener( Event.ENTER_FRAME, renderRO );
				this.removeEventListener( Event.ENTER_FRAME, render );
			}
		}
		/**
		 *渲染 
		 */		
		public function renderView() :void
		{//浏览状态
			if( this.hasEventListener( Event.ENTER_FRAME ) )
			{
				this.removeEventListener( Event.ENTER_FRAME, renderActs );
				this.removeEventListener( Event.ENTER_FRAME, renderRO );
			}
			this.addEventListener( Event.ENTER_FRAME, render );
		}
		private function renderAction():void
		{//动作状态
			if( this.hasEventListener( Event.ENTER_FRAME ) )
			{
				this.removeEventListener(Event.ENTER_FRAME, render);
				this.removeEventListener(Event.ENTER_FRAME, renderRO);
			}
			addEventListener(Event.ENTER_FRAME, renderActs);
		}
		private function renderRotation():void
		{//旋转状态
			if( this.hasEventListener( Event.ENTER_FRAME ) )
			{
				this.removeEventListener(Event.ENTER_FRAME, render);
				this.removeEventListener(Event.ENTER_FRAME, renderActs);
			}
			addEventListener(Event.ENTER_FRAME, renderRO);			
		}
		/**
		 *do render 
		 * @param e
		 */		
		private function renderActs( e:Event ):void
		{
			_render.renderScene( _scenes, _camera, _view );			
		}
		private function renderRO( e:Event ):void
		{			
			_render.renderScene( _scenes, _camera, _view );			
		}
		
		private function render( e:Event ):void
		{
			try
			{
				renderTo( stage.mouseX, stage.mouseY );
			}
			catch(e:Error)
			{
				
			}
		}
		
		private var radian:Number = 0;
		private var speed:Number = 0.04;
		private var radius:Number = 2500;
		private var total:int;
		
		private function renderTo( xx:Number, yy:Number ):void
		{
			try
			{
				//_camera.rotationY-=1-xx/(stage.stageWidth/2);
//				therter += 1 - xx / ( stage.stageWidth / 2 );
				radian += speed;
				_camera.x = radius * Math.cos( radian );
				_camera.z = radius * Math.sin( radian );
				
				_camera.lookAt( _pannelCenter );
			}
			catch(e:Error)
			{
				
			}
			_render.renderScene( _scenes, _camera, _view );
		}
		/**
		 *添加plane 事件 
		 */		
		private function addPlaneListeners():void
		{
			removeFilters();
			for (var i:int=0; i<Planes.length; i++) 
			{
				var plane:WallPlane=Planes[i] as WallPlane;
				plane.addEventListener( InteractiveScene3DEvent.OBJECT_OVER, p_rollover );
				plane.addEventListener( InteractiveScene3DEvent.OBJECT_OUT, p_rollout );
				plane.addEventListener( InteractiveScene3DEvent.OBJECT_PRESS, p_click );
			}
		}
		private function removeFilters():void
		{
			for( var i:int=0; i < Planes.length; i++ )
			{
				var plane:WallPlane=Planes[i] as WallPlane;
				if( plane != actionPlane )
				{
					_view.getChildLayer(plane).filters = [];
				}
			}
		}
		private function removePlaneListeners():void
		{
			for( var i:int=0; i < Planes.length; i++ )
			{
				var plane:WallPlane=Planes[i] as WallPlane;
				plane.removeEventListener( InteractiveScene3DEvent.OBJECT_OVER, p_rollover );
				plane.removeEventListener( InteractiveScene3DEvent.OBJECT_OUT, p_rollout );
				plane.removeEventListener( InteractiveScene3DEvent.OBJECT_PRESS, p_click );
			}
		}
		
		private function p_click( me:InteractiveScene3DEvent ):void
		{	
			this.IsTimeUp = 1;
			if( null != actionPlane )
			{
				_view.getChildLayer(actionPlane).filters = [];
			}
			actionPlane = me.target as WallPlane;
			var g:GlowFilter=new GlowFilter();
			g.blurX=g.blurY=flashmo_xml.filter[0].@range;
			g.color=flashmo_xml.filter[0].@color;
			g.alpha=flashmo_xml.filter[0].@alpha;
			_view.getChildLayer( actionPlane ).filters = [g];//添加滤镜
			
			if( _showIndex == -1 )
			{
				rotaCamera();
			}
			else
			{
				hieMC();				
			}
		}
		private function p_rollover(me:InteractiveScene3DEvent):void
		{
			var sp:WallPlane = me.target as WallPlane;
		
			_view.getChildLayer( sp ).buttonMode = true;
			showGlow( sp );
			showText( sp.index );
			
			//if(!sp.isOver)shakePlane(sp);
			trace("-------------------")
			sp.isOver = true;
		}
		private function p_rollout(me:InteractiveScene3DEvent):void
		{
			var sp:WallPlane = me.target as WallPlane;
			_view.getChildLayer(sp).buttonMode=false;
			hideGlow( sp );
			hideText();
			
			//sp.y=sp.index>= 20?flashmo_xml.circle[0].@yup:flashmo_xml.circle[0].@ydown;
			//trace(sp.y);
			//TweenLite.to(sp, 1, {rotationZ:0,y:sp.index>= 20?flashmo_xml.circle[0].@yup:flashmo_xml.circle[0].@ydown,  ease:Elastic.easeOut});	
		}
		/**
		 *开始显示 
		 */		
		private function rotaCamera():void
		{
			_showIndex = actionPlane.index;			
			removePlaneListeners();			
			renderAction();
			var dy:Number = actionPlane.rotationY- _camera.rotationY;
			while( dy < -180 )
			{
				dy += 360;
			}
			while( dy > 180 )
			{
				dy -= 360;
			}
			TweenLite.killTweensOf( _camera );
			TweenLite.to( _camera, 1, { rotationY:( _camera.rotationY + dy ),  ease:Back.easeOut, delay:0.1, onComplete:showPlane } );
		}
		private function showPlane():void
		{
			var targetX:Number = Math.cos(actionPlane.index * anglePer) * inCircle;
			var targetZ:Number = Math.sin(actionPlane.index * anglePer) * inCircle;
			TweenLite.to( actionPlane, 1, {x:targetX,y:_camera.y+15,z:targetZ,rotationX:_camerarotation,  ease:Back.easeIn, onComplete:showComplete});
			if( actionPlane.index < 20 )
			{
				TweenLite.to( getShadow(actionPlane.index), 1, {x:targetX,y:_camera.y+this.shadowDown,z:targetZ,rotationX:_camerarotation,  ease:Back.easeInOut, onComplete:showComplete});
			}
			//hideShadow();
			renderRotation();
		}
		
		private function showComplete():void
		{	
			var tt:Timer=new Timer( 1000, 1 );
			tt.addEventListener( TimerEvent.TIMER, doShowMC );	
			tt.start();		
		}	
		private function doShowMC( e:TimerEvent ):void
		{
			var tt:Timer = Timer( e.target );
			tt.stop();
			tt.removeEventListener( TimerEvent.TIMER, doShowMC );	
			tt = null;

			//actionPlane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, p_click);			
			var dir:String=folder +"mov/"+ flashmo_xml.file[actionPlane.index].@pic.toString()+".gif";
			
			ms.play( dir );
			ms.x = 112.25;//113;
			ms.y = 0.25;//83.5;
			ms.alpha = 0;
			if( !this.contains( ms ) )
			{
				this.addChild( ms );
			}
			TweenLite.to( ms, 1, { alpha:1, ease:Back.easeInOut } );
			stopRendering();
			ms.addEventListener( Event.COMPLETE, showEnd );
			ms.addEventListener( MouseEvent.CLICK, stopMOV );
			ms.buttonMode=true;
			//ms.addEventListener(MouseEvent.MOUSE_DOWN,dragMC);
		}
		private function showEnd(e:Event):void		
		{
			ms.removeEventListener( Event.COMPLETE, showEnd );
			this.hieMC();
		}
		
		private function dragMC( e:Event ):void
		{
			ms.startDrag();
			try
			{
				stage.addEventListener( MouseEvent.MOUSE_UP, stopDragMC );
			}
			catch( e:Error )
			{
				
			}
		}
		private function stopDragMC(e:Event):void
		{
			try
			{
				stage.removeEventListener( MouseEvent.MOUSE_UP, stopDragMC );
			}
			catch( e:Error )
			{
				
			}
			stopDrag();
			trace( ms.x + '/' + ms.y );
		}
		private function stopMOV(e:Event):void
		{
			hieMC();
		}
		private function showPlaneFilter():void
		{
			for( var i:int=0; i < Planes.length; i++ )
			{
				var plane:WallPlane = Planes[i] as WallPlane;
				if( plane != actionPlane )
				{
					var b:BlurFilter=new BlurFilter();
					b.blurX=b.blurY=flashmo_xml.filter[1].@range;
					_view.getChildLayer(plane).filters=[b];
				}
				else
				{
					//var bfm:BitmapFileMaterial=BitmapFileMaterial(materials[i]);
					var g:GlowFilter = new GlowFilter();
					g.blurX = g.blurY = flashmo_xml.filter[0].@range;
					g.color = flashmo_xml.filter[0].@color;
					g.alpha = flashmo_xml.filter[0].@alpha;
					_view.getChildLayer( actionPlane ).filters = [g];
					_view.getChildLayer( plane ).filters = [g];
					/* _mc.filters=[g]; */
				}
			}
		}	
		/**
		 *隐藏 
		 */		
		private function hieMC():void
		{
			TweenLite.killTweensOf( ms );
			TweenLite.to( ms, 1, { alpha:0, ease:Strong.easeOut, onComplete:doHideMC } );			
		}
		private function doHideMC():void
		{
			/* var tt:Timer=new Timer(1000,1);
			tt.addEventListener(TimerEvent.TIMER,excuteHideMC)
			tt.start();	 */
			ms.stop();			
			if( this.contains( ms ) ) 
			{
				removeChild( ms );
			}
			this.renderAction()
			_showIndex = -1;
			hidePlane();
		}
		private function excuteHideMC(e:Event):void
		{
			var tt:Timer = e.target as Timer;
			tt.stop();
			tt.removeEventListener(Event.COMPLETE,excuteHideMC)
			tt = null;
			trace("stop");
			ms.stop();			
			if( this.contains( ms ) )
			{
				removeChild(ms);
			} 				
			addPlaneListeners();				
			renderView();
			_showIndex = -1;
			hidePlane();
		}
		private function hidePlane():void
		{
			var targetX:Number=Math.cos(actionPlane.index * anglePer) * outCircle;
			var targetZ:Number=Math.sin(actionPlane.index * anglePer) * outCircle;
			var targetY:Number=actionPlane.index>19?flashmo_xml.circle[0].@yup:flashmo_xml.circle[0].@ydown;			
			TweenLite.to( actionPlane, 1, { x:targetX, y:targetY, z:targetZ, rotationX:0, ease:Back.easeOut, delay:0, onComplete:PlaneBackOver } );
			var wp:WallPlane = this.getShadow(actionPlane.index);
			if( null == wp )
			{
				return;
			}			
			TweenLite.to(wp, 1, {x:targetX,y:targetY+shadowDown,z:targetZ,rotationX:0,  ease:Back.easeInOut, delay:0});
		}		
		private function PlaneBackOver():void
		{			
			this.renderView();
			addPlaneListeners();
		}
		private function showGlow(p:WallPlane):void
		{
			if( p != actionPlane )
			{
				var g:GlowFilter=new GlowFilter();
				g.blurX=g.blurY=flashmo_xml.filter[0].@range;
				g.color=flashmo_xml.filter[0].@color;
				g.alpha=flashmo_xml.filter[0].@alpha;
				_view.getChildLayer(p).filters=[g];
			}
		}	
		private function hideGlow(p:WallPlane):void
		{
			if( p!=actionPlane )
			{
				_view.getChildLayer(p).filters=[];
			}
		}
		/**
		 *隐藏显示倒影 
		 * 
		 */		
		private function hideShadow():void
		{
			for(var i:int=0;i<this.shadows.length;i++)
			{
				var p2:WallPlane=shadows[i] as WallPlane;
				if(p2.index==this.actionPlane.index)
				{		
					//trace(p2.index+'/'+this.actionPlane.index);				
					this._scenes.removeChild(p2);
				}				
			}	
		}
		private function showShadow():void
		{
			
			for(var i:int=0;i<this.shadows.length;i++)
			{
				var p2:WallPlane=shadows[i] as WallPlane;
				
				if(p2.index==this.actionPlane.index)
				{		
					this._scenes.addChild(p2);
					//earthQuare(-1,0.5);
				}
			}	
		}
		/**
		 *地震效果 
		 * @param side震动方向 默认为上
		 * 
		 */		
		private function earthQuare(side:int=1):void
		{
			TweenLite.to(_camera, .3, {rotationX:side*10,  ease:Strong.easeIn,onComplete:QuareDown});	
		}
		private function QuareDown():void
		{
			TweenLite.to(_camera, 1, {rotationX:0,  ease:Elastic.easeOut,onComplete:Quareback});	
		}
		private function Quareback():void
		{
			//TweenLite.to(_camera, 2, {rotationZ:0,  ease:Back.easeInOut,onComplete:Quareback});	
		}
		/**
		 *摇动图片 
		 * @param p
		 * 
		 */		
		private function shakePlane(p:WallPlane,side:int=1):void
		{
			var yp:Number=p.y;
			TweenLite.to(p, .3, {y:p.y+10,  ease:Strong.easeIn,onComplete:PlaneBack,onCompleteParams:[p,yp]});
			
			if(p.index>=20)
			{
				//TweenLite.to(p, .3, {rotationZ:side*10,  ease:Strong.easeIn,onComplete:PlaneBack,onCompleteParams:[p,yp]});
			}
			else
			{
				for(var i:int=0;i<this.shadows.length;i++)
				{
					var p2:WallPlane= this.shadows[i] as WallPlane;
					if(p2.index==p.index)
					TweenLite.to(p2, .3, {y:p2.y-10,  ease:Strong.easeIn,onComplete:PlaneBack,onCompleteParams:[p2,p2.y]});		
				}
			}
		}
		private function PlaneBack(p:WallPlane,yp:Number):void
		{
			TweenLite.to(p, 1, {rotationZ:0,y:yp,  ease:Elastic.easeOut,onComplete:reSetPlane,onCompleteParams:[p]});	
		}
		private function reSetPlane(p:WallPlane):void
		{	
			if(p.isShadow)
			{
				var down:Number=flashmo_xml.circle[0].@ydown
				p.y=down+this.shadowDown
				//trace(flashmo_xml.circle[0].@ydown+this.shadowDown);
			}
			else
			{
				p.index>= 20?flashmo_xml.circle[0].@yup:flashmo_xml.circle[0].@ydown
				p.isOver=false;
			}
			//resetpositions();
		}
		private function getShadow(index:int):WallPlane
		{
			//trace(index);
			var sha:WallPlane;
			for(var i:int=0;i<this.shadows.length;i++)
			{
				var pp:WallPlane=shadows[i] as WallPlane;
				if(pp.index==index)
				{
					sha=pp;
					break;
				}
			}
			//trace(sha+'/'+sha.index);
			return sha;
		}
		private function resetpositions():void
		{
			var yp:Number =flashmo_xml.circle[0].@ydown;
			for(var j:int=0;j<this.shadows.length;j++)
			{
				var p2:WallPlane=WallPlane(shadows[j]);
				TweenLite.to(p2, .3, {y:yp+this.shadowDown,  ease:Elastic.easeInOut,onComplete:PlaneBack,onCompleteParams:[p,yp]});
		
			}
			
			for(var i:int;i<this.Planes.length;i++)
			{
				var p:WallPlane=WallPlane(Planes[i]);
				yp = p.index>= 20?flashmo_xml.circle[0].@yup:flashmo_xml.circle[0].@ydown;
			
				TweenLite.to(p, .3, {y:yp,  ease:Elastic.easeInOut,onComplete:PlaneBack,onCompleteParams:[p,yp]});
			}
			
		}
		private function showText(index:int):void
		{
			var txt:String;
			var url:String;
			for(var i:int=0;i<this.title_list.length;i++)
			{
				if(i==index)
				{
					txt=this.title_list[i];
					url=this._address[i];
				}
			}
			var tf:TextFormat=new TextFormat;
			tf.color=0xffffff;
			
			var ft:GlowFilter=new GlowFilter;
			ft.color=0xffff00;
			ft.alpha=.5;
		}
		private function hideText():void
		{
			//if(this.contains(_showText))this.removeChild(_showText);
		}
		//************************************<
		private function stopRendering():void
		{
			removeEventListener(Event.ENTER_FRAME, render);
			removeEventListener(Event.ENTER_FRAME, renderActs);
			removeEventListener(Event.ENTER_FRAME, renderRO);
			//trace("stop enterFrame listener");
		}
		private function GetMessage(s:String):String
		{
			var ss:String;
			for(var i:int=0;i<this.flashmo_xml.file.length();i++)
			{
				if(s==this.flashmo_xml.file[i].@title)
				{
					ss=this.flashmo_xml.file[i].@urlTarget;
				}
			}
			return ss;
		}
		private function GetBordor():Sprite
		{
			var s:Sprite=new Sprite;  
			return s;
		}
	}
}