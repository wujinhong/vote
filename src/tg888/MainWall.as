package tg888
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import core.UITool;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	import ui.LotteryRole;

	public class MainWall extends Sprite
	{
		public static const VIEW_WIDTH:Number = 1920;
		private var _view:Viewport3D;
		private var _scenes:Scene3D;
		private var _camera:Camera3D;
		private var _render:BasicRenderEngine;
		
		private var materials:Vector.<MaterialObject3D> = new Vector.<MaterialObject3D>();
		private var _planes:Vector.<WallPlane> = new Vector.<WallPlane>();
		private var flashmo_xml:XML;
		
		private var anglePer:Number;
		/**
		 *半径 
		 */		
		private var outCircle:int;
		private var _loadingIndex:int = 0;
		
		private var radian:Number = 0;
		private var speed:Number = 0.04;
//		private var speed:Number = 0.004;
		private var radius:Number = 2400;
		private var total:int;
		private var showingIndex:int;
		
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
			_scenes = new Scene3D();
			_camera = new Camera3D();			
			_render = new BasicRenderEngine();
		}
		private function loadXML():void
		{			
			flashmo_xml = <files>	
				<circle out="2000"  urlTitle="查看更多" total="30"></circle>
				<camera rotationX="-60" rotationZ="-60" focus="20" zoom="20"></camera>
				<mc x="113" y="45" width="800" height="602" plx="2" ply="2"></mc>
			</files>;
			
			total = flashmo_xml.circle[0].@total
			outCircle = flashmo_xml.circle[0].@out;
			
			_camera.rotationX = flashmo_xml.camera[0].@rotationX;
			_camera.rotationZ = flashmo_xml.camera[0].@rotationZ;
			_camera.zoom = flashmo_xml.camera[0].@zoom;
			_camera.focus = flashmo_xml.camera[0].@focus;
			
			_loadingIndex = 0;
			anglePer = ( Math.PI * 2 ) / total;
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
		}
	
		private var _p:WallPlane;
		private var _pannelCenter:Plane;
		private function doLoadSmallPics():void 
		{
			if( _loadingIndex >= total )
			{
				return;
			}
			var lotterRole:LotteryRole = LotteryRole.getLotteryRole( _loadingIndex );
			var bmd:BitmapData = UITool.getUIBitmapData( lotterRole );
			var bmm:BitmapMaterial = new BitmapMaterial( bmd );
			bmm.smooth = true;
			bmm.interactive = true;
			bmm.doubleSided = true;
			materials.push( bmm );
			var p:WallPlane = new WallPlane( _loadingIndex, bmm, 400, 500, flashmo_xml.mc[0].@plx, flashmo_xml.mc[0].@ply);
			p.material.doubleSided = false;
			_p = p;
			_planes.push( p );
			initPosition( p, outCircle );
			addNext();
		}
		private function addNext():void
		{
			trace( "MainWall.addNext( e ):_loadingIndex" + _loadingIndex );
			_loadingIndex++;
			loadSmallPics();
		}
		/**
		 *停止渲染 ；浏览状态
		 */		
		public function stopRenderView( before:Boolean = false ) :void
		{
			if( this.hasEventListener( Event.ENTER_FRAME ) )
			{
				this.removeEventListener( Event.ENTER_FRAME, render );
			}
			if( !before )
			{
				return;
			}
			var letf:Number = radian % ( Math.PI * 2 );
			showingIndex = Math.ceil( letf / anglePer );
			var lotterRole:LotteryRole = new LotteryRole();
			var bmd:BitmapData = UITool.getUIBitmapData( lotterRole );
			
			var bmm:BitmapMaterial = new BitmapMaterial( bmd );
			_planes[ showingIndex ].material = bmm;
			render( null );
		}
		private function initPosition(p:WallPlane,c:int):void 
		{						
			p.rotationY = ( -p.index * anglePer ) * ( 180 / Math.PI ) - 90;
			p.x = Math.cos( p.index * anglePer ) * c;
			p.z = Math.sin( p.index * anglePer ) * c;
		}
		/**
		 *渲染 ；浏览状态
		 */
		public function renderView( before:Boolean = false ) :void
		{
			this.addEventListener( Event.ENTER_FRAME, render );
			var lotterRole:LotteryRole;
			var bmd:BitmapData;
			var bmm:BitmapMaterial;
			for( var i:int = 0; i < _planes.length; i++ ) 
			{
				lotterRole = LotteryRole.getLotteryRole( i );
				bmd = UITool.getUIBitmapData( lotterRole );
				bmm = new BitmapMaterial( bmd );
				_planes[ i ].material = bmm;
			}
			
			if( before )
			{
				lotterRole = LotteryRole.getLotteryRole( showingIndex );
				bmd = UITool.getUIBitmapData( lotterRole );
				bmm = new BitmapMaterial( bmd );
				_planes[ showingIndex ].material = bmm;
			}
		}
		
		private function render( e:Event ):void
		{
			try
			{
				radian += speed;
				_camera.x = radius * Math.cos( radian );
				_camera.z = radius * Math.sin( radian );
				
				_camera.lookAt( _pannelCenter );
				if( radian >= Math.PI * 2 )
				{
					radian = 0;
				}
			}
			catch(e:Error)
			{
				
			}
			_render.renderScene( _scenes, _camera, _view );
		}
	}
}