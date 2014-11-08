package tg888{
	import org.papervision3d.objects.primitives.Plane;	
	public class WallPlane extends Plane
	{
		public var index:int;
		public var isShadow:Boolean=false;	
		public var isOver:Boolean=false;
		public function WallPlane( i:int = -1, m:* = null, w:Number = 0, h:Number = 0, b:int = 1, c:int = 1 )
		{
			index = i;
			super( m, w, h, b, c );			
		}		
	}

}