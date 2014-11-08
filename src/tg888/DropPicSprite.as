package {
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	public class DropPicSprite extends MovieClip {
		private var _loader:Loader;		
		private var _index:int;
		public function DropPicSprite( dir:String, index:int )
		{
			_index=index;
			_loader=new Loader();
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadedPic );
			_loader.load( new URLRequest( dir ) );						
		}		
		private function loadedPic( e:Event ):void
		{
			var b:Bitmap=e.target.content as Bitmap;			
			b.width=600;
			b.height=450;
			addChild(b);
			
			var d:Bitmap=new Bitmap();
			d.bitmapData=b.bitmapData.clone();
			d.scaleY=-1;
			d.height=150;
			d.width=600;
			d.y=225+150;
			addChild(d);
			if( _index > 19 )
			{
				d.visible=false;
			}
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}