package lottery
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class ShadowMovieClip extends Sprite
	{
		/* private var _mark:WallMask; */
		private var _loader:Loader;
		public function ShadowMovieClip( bitmapData:BitmapData )
		{
			super();					
			var bm2:Bitmap=createRef( bitmapData );
			bm2.width = 400;
			bm2.height = 300;
					
			this.addChild( bm2 );
		}
		private function createRef(bd:BitmapData):Bitmap
		{
	    	//倒置
		    var mtx:Matrix = new Matrix();
		    mtx.d = 1;
		    mtx.ty = bd.height;
		    // 添加渐变遮罩
		    var width:int = bd.width;
		    var height:int = bd.height;
		    mtx = new Matrix();
		    mtx.createGradientBox(width,height,0.5 * Math.PI);
		    var shape:Shape = new Shape();
		    shape.graphics.beginGradientFill( GradientType.LINEAR ,[0,0],[0,0.4],[0,0xFF], mtx );
		
		    shape.graphics.drawRect(0,0,width,height);
		    shape.graphics.endFill();
		    var mask_bd:BitmapData = new BitmapData(width,height,true,0);
		    mask_bd.draw(shape);
		    // 生成最终效果
		     bd.copyPixels(bd,bd.rect,new Point(0,0),mask_bd,new Point(0,0),false); 
		    // 将倒影放置于图片下方
		    var ref:Bitmap=new Bitmap(); 
		    ref.bitmapData=bd; 		    
		    return ref;
   		 }   		
	}
}