package tg888{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.net.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import gs.TweenLite;
	import gs.easing.*;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;

	public class Mynew3DWall extends Sprite {
		private var _view:Viewport3D;
		private var _scenes:Scene3D;
		private var _camera:Camera3D;
		private var _render:BasicRenderEngine;

		private var numOfRotations:Number=2;
		private var yPos=0;
		private var filename_list:Array = new Array();
		private var url_list = new Array();
		private var url_target_list:Array = new Array();
		private var title_list = new Array();
		private var description_list:Array = new Array();
		private var Planes:Array=new Array();
		private var materials:Array=new Array();
		private var actionPlane:WallPlane;
		private var pc:Plane=new Plane();
		private var showIndex=-1;
		private var anglePer:Number;
		private var outCircle:int;
		private var inCircle:int;

		//xml message****************************
		private var folder:String = "thumbnails/";
		private var flashmo_xml:XML;
		private var _urlTitle:Array;
		private var _address:Array;	

		private var _showIndex:int=-1;
		private var _positionStop:int=0;

		//private var _mc:myMC=new myMC();
		private var _loding:Loader;
		private var _loadingIndex:int=0;
		//test***********************************
		private var _testCircle:int;
		private var _camerarotation:Number;
		public function Mynew3DWall() {			
			//System.useCodePage=true;
			init3D();
			loadXML();
		}
		private function init3D():void {
			_urlTitle=new Array();
			_address=new Array();
			/* cmc.alpha=0;
			cmc.mouseEnabled=false;	 */		
			//_mc.addEventListener(Event.COMPLETE,gameOver);
			_view=new Viewport3D(1024,768,false,true);
			addChild(_view);
			/* addChild(messages); */
			/* messages.mouseEnabled=false; */
			_scenes=new Scene3D();
			_camera=new Camera3D();			
			addLoadingICO();		
			_render=new BasicRenderEngine();
			//addEventListener(KeyboardEvent.KEY_DOWN,moveCamera);
		}
		private function moveCamera(e:KeyboardEvent):void {
			if (!actionPlane) {
				return;
			}
			//trace("_testCircle:"+actionPlane.index+"|"+_testCircle);
			switch (e.keyCode) {
				case 37 :
					//_mc.width--;
					break;
				case 38 :
					//_mc.height--;					
					break;
				case 39 :
					//_mc.width++;
					break;
				case 40 :
					//_mc.height++;					
					break;
			}			
		}
		private function loadXML():void {
			flashmo_xml = new XML();
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, createThumbnail);
			loader.load(new URLRequest("files.xml"));
		}
		private function createThumbnail(e:Event):void {			
			flashmo_xml = XML(e.target.data);
			
			var total:int = flashmo_xml.thumbnail.length();
			outCircle=flashmo_xml.circle[0].@out;
			inCircle=flashmo_xml.circle[0].@inc;
			_testCircle=inCircle;
			_loadingIndex=0;
			anglePer = ((Math.PI*2) * numOfRotations) / total;
			loadSmallPics();
			
			_camera.rotationX=_camerarotation=flashmo_xml.camera[0].@rotationX;
			_camera.zoom=flashmo_xml.camera[0].@zoom
			_camera.z=flashmo_xml.camera[0].@zPint;
			_camera.y=flashmo_xml.camera[0].@yPoint;
			_camera.x=flashmo_xml.camera[0].@xPoint;			
		}
		private function loadSmallPics():void {			
			if (_loadingIndex<flashmo_xml.thumbnail.length()) {
				doLoadSmallPics();
			} else {
				removeLoadingICO();
				renderView();
				addPlaneListeners();
			}
		}
		private function doLoadSmallPics():void {
			//trace(flashmo_xml.thumbnail[_loadingIndex].@urlTitle+"/");
			_urlTitle.push(flashmo_xml.thumbnail[_loadingIndex].@urlTitle);
			_address.push(flashmo_xml.thumbnail[_loadingIndex].@urlTarget);
			title_list.push( flashmo_xml.thumbnail[_loadingIndex].@title.toString() );
			
				//var pidUrl:String=folder +"小图/"+ flashmo_xml.thumbnail[_loadingIndex].@filename.toString()+".gif";
				//var sp:DropPicSprite=new DropPicSprite(pidUrl,_loadingIndex);
				//sp.addEventListener(Event.COMPLETE,addNext);
				//var bfm:MovieMaterial = new MovieMaterial(sp,false,true,false,new Rectangle(0,0,600,450));
				
			var bfm:BitmapFileMaterial = new BitmapFileMaterial(
			folder +"小图/"+ flashmo_xml.thumbnail[_loadingIndex].@filename.toString()+".gif");
			
			bfm.addEventListener(Event.COMPLETE,addNext);
			bfm.oneSide = false;
			bfm.smooth = true;
			bfm.interactive =true;
			materials.push(bfm);
			var p:WallPlane = new WallPlane(_loadingIndex,bfm, 600, 600, 3, 3);
			_scenes.addChild(p);
			Planes.push(p);
			_scenes.addChild(p);
			initPosition(p,outCircle);
			_render.renderScene(_scenes,_camera,_view);
			//trace("doLoadSmallPics:++++++renderScene....");
		}
		private function addNext(e:Event):void {
			_loadingIndex++;
			loadSmallPics();
		}
		private function initPosition(p:WallPlane,c:int):void {//i:int,anglePer:Number,p:Plane,c:int):void {
			p.rotationY = (-p.index*anglePer) * (180/Math.PI) + 90;
			p.x = Math.cos(p.index * anglePer) * c;
			p.z = Math.sin(p.index * anglePer) * c;
			p.y = yPos;

			if ( (p.index+1) % 20 == 0 ) {
				yPos += flashmo_xml.circle[0].@ydir;
			}
			var dy:Number=p.rotationY- _camera.rotationY;
			if (dy<-270) {
				dy+=360;
			} else if (dy>270) {
				dy-=360;
			}
			TweenLite.to(_camera, 0.2, {rotationY:(_camera.rotationY+dy),  ease:Strong.easeInOut});			
		}
		private function p_rollover(me:InteractiveScene3DEvent):void {
			var sp:WallPlane = me.target as WallPlane;
			_view.getChildLayer(sp).buttonMode=true;
			showGlow(sp);
/* 			messages.tn_title.htmlText = title_list[sp.index]; */
/* 			messages.linkAddress.tn_url.htmlText = _urlTitle[sp.index]; */
/* 			messages.tn_target.text = _address[sp.index]; */
			formatFont();
		}
		private function p_rollout(me:InteractiveScene3DEvent):void {
			var sp:WallPlane = me.target as WallPlane;
			_view.getChildLayer(sp).buttonMode=false;
			hideGlow(sp);
/* 			messages.tn_title.text = ""; */
/* 			messages.linkAddress.tn_url.text = ""; */
/* 			messages.tn_target.text = "";			 */
			formatFont();
		}
		private function showGlow(p:WallPlane):void {
			if (p!=actionPlane) {
				var g:GlowFilter=new GlowFilter();
				g.blurX=g.blurY=flashmo_xml.filter[0].@range;
				g.color=flashmo_xml.filter[0].@color;
				g.alpha=flashmo_xml.filter[0].@alpha;
				_view.getChildLayer(p).filters=[g];
			}
		}
		private function hideGlow(p:WallPlane):void {
			if (p!=actionPlane) {
				_view.getChildLayer(p).filters=[];
			}
		}
		function p_click(me:InteractiveScene3DEvent):void {//单击
			if (actionPlane) {
				_view.getChildLayer(actionPlane).filters=[];
			}
			actionPlane = me.target as WallPlane;
			var g:GlowFilter=new GlowFilter();
			g.blurX=g.blurY=flashmo_xml.filter[0].@range;
			g.color=flashmo_xml.filter[0].@color;
			g.alpha=flashmo_xml.filter[0].@alpha;
			_view.getChildLayer(actionPlane).filters=[g];

			if (_showIndex==-1) {
				RotaCamera();
			} else {
				hieMC();				
			}
		}
		private function hieMC():void{
			/* if (this.contains(_mc)) {
					removeChild(_mc);
				} */
				addPlaneListeners();
				stopRendering();
				renderView();
				_showIndex=-1;
				hidePlane();
		}
		private function hidePlane():void {
			var targetX:Number=Math.cos(actionPlane.index * anglePer) * outCircle;
			var targetZ:Number=Math.sin(actionPlane.index * anglePer) * outCircle;
			var targetY:Number=actionPlane.index>19?flashmo_xml.circle[0].@ydir:0;			
			TweenLite.to(actionPlane, 0.5, {x:targetX,y:targetY,z:targetZ,rotationX:0,  ease:Back.easeOut, delay:0});
		}
		function showPlane():void {
			var targetX:Number=Math.cos(actionPlane.index * anglePer) * inCircle;
			var targetZ:Number=Math.sin(actionPlane.index * anglePer) * inCircle;
			TweenLite.to(actionPlane, 0.7, {x:targetX,y:25,z:targetZ,rotationX:_camerarotation,  ease:Back.easeIn, onComplete:showComplete});
			stopRendering();
			renderRotation();
		}
		private function showComplete():void {			
			actionPlane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, p_click);
/* 			_mc.alpha=0;			 */
			/* addChild(_mc); */
			/* TweenLite.to(_mc, 0.5 ,{alpha:1 , ease:Strong.easeIn,onComplete:SWFComplete}); */
			showPlaneFilter();
		}
		private function SWFComplete():void{
			stopRendering();
		/* 	_mc.load(folder + flashmo_xml.thumbnail[_showIndex].@filename.toString());
		 */}
		//************************************<
		function stopRendering():void {
			removeEventListener(Event.ENTER_FRAME, render);
			removeEventListener(Event.ENTER_FRAME, renderActs);
			removeEventListener(Event.ENTER_FRAME, renderRO);
			//trace("stop enterFrame listener");
		}
		function renderView() :void{//浏览状态
			addEventListener(Event.ENTER_FRAME, render);
		}
		function renderAction():void {//动作状态
			addEventListener(Event.ENTER_FRAME, renderActs);
			//trace("add renderActs listener");
			
		}
		function renderRotation() :void{//旋转状态
			addEventListener(Event.ENTER_FRAME, renderRO);
			//trace("renderRotation is running");
		}
		function render(e:Event):void {
			renderTo(stage.mouseX,stage.mouseY);
		}
		function renderActs(e:Event):void {
			_render.renderScene(_scenes,_camera,_view);
			trace("renderActs:++renderScene....");
		}
		function renderRO(e:Event):void {			
			_render.renderScene(_scenes,_camera,_view);
			trace("renderRO:++renderScene....");
		}
		//************************************>

		function renderTo(xx:Number,yy:Number):void {
			_camera.rotationY-=1-xx/(stage.stageWidth/2);
			_render.renderScene(_scenes,_camera,_view);
			//trace("renderTo:++++++renderScene....");
		}
		function reSetposition():void {
			yPos=0;
			var anglePer:Number = ((Math.PI*2) * numOfRotations) / Planes.length;
			for (var i:int=0; i<Planes.length; i++) {
				initPosition(Planes[i],outCircle);
			}
		}
		function addPlaneListeners():void {
			for (var i:int=0; i<Planes.length; i++) {
				var plane:WallPlane=Planes[i] as WallPlane;
				if (plane!=actionPlane) {
					_view.getChildLayer(plane).filters=[];
				}
				plane.addEventListener( InteractiveScene3DEvent.OBJECT_OVER, p_rollover );
				plane.addEventListener( InteractiveScene3DEvent.OBJECT_OUT, p_rollout );
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, p_click );
			}
		}
		function removePlaneListeners():void {
			for (var i:int=0; i<Planes.length; i++) {
				var plane:WallPlane=Planes[i] as WallPlane;
				plane.removeEventListener( InteractiveScene3DEvent.OBJECT_OVER, p_rollover );
				plane.removeEventListener( InteractiveScene3DEvent.OBJECT_OUT, p_rollout );
				plane.removeEventListener(InteractiveScene3DEvent.OBJECT_PRESS, p_click );
			}
		}
		private function RotaCamera():void {
			_showIndex=actionPlane.index;			
			removePlaneListeners();
			stopRendering();
			renderAction();
			var dy:Number=actionPlane.rotationY- _camera.rotationY;
			while (dy<-180) {
				dy+=360;
			}
			while (dy>180) {
				dy-=360;
			}
			TweenLite.to(_camera, 1, {rotationY:(_camera.rotationY+dy),  ease:Back.easeOut, delay:0.1, onComplete:showPlane});

		}
		private function showPlaneFilter():void {
			for (var i:int=0; i<Planes.length; i++) {
				var plane:WallPlane=Planes[i] as WallPlane;
				if (plane!=actionPlane) {
					var b:BlurFilter=new BlurFilter();
					b.blurX=b.blurY=flashmo_xml.filter[1].@range;
					_view.getChildLayer(plane).filters=[b];
				} else {
					//var bfm:BitmapFileMaterial=BitmapFileMaterial(materials[i]);
					var g:GlowFilter=new GlowFilter();
					g.blurX=g.blurY=flashmo_xml.filter[0].@range;
					g.color=flashmo_xml.filter[0].@color;
					g.alpha=flashmo_xml.filter[0].@alpha;
					_view.getChildLayer(actionPlane).filters=[g];
					_view.getChildLayer(plane).filters=[g];
					/* _mc.filters=[g]; */
				}
			}
		}
		private function formatFont():void {
			var f:TextFormat=new TextFormat();
			f.size=flashmo_xml.word[0].@size;
			f.font=flashmo_xml.word[0].@font;
			f.bold=flashmo_xml.word[0].@font=="1"?true:false;
			f.color=flashmo_xml.word[0].@color;
			var t:TextField;
/* 			messages.tn_title.filters=[new DropShadowFilter(0,0)];			 */
/* 			messages.tn_title.setTextFormat(f); */
			
			var f2:TextFormat=new TextFormat();
			f2.size=flashmo_xml.word[1].@size;
			f2.font=flashmo_xml.word[1].@font;
			f2.bold=flashmo_xml.word[1].@font=="1"?true:false;
			f2.color=flashmo_xml.word[1].@color;
/* 			messages.linkAddress.tn_url.filters=[new DropShadowFilter(0,0)]; */
/* 			messages.linkAddress.tn_url.setTextFormat(f2); */
		}
		private function addLoadingICO():void {
			//trace("loading"+_loding)
			if (!_loding) {
				_loding=new Loader();
				_loding.load(new URLRequest("loading.swf"));
				_loding.x=1024/2;
				_loding.y=768/2-25;
			}//trace(_loding)
			addChild(_loding);
			//trace("loading...");
		}
		private function removeLoadingICO():void {
			if (_loding) {
				if (this.contains(_loding)) {
					this.removeChild(_loding);
					trace("end loading...");
				}
			}
		}
		private function gameOver(e:Event):void{
			hieMC();
		}
	}
}