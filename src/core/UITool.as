package core
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * UITool
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 24, 2014   3:05:12 PM
	 * @version 1.0
	 */
	public class UITool
	{
		private static var funcDiction:Dictionary = new Dictionary();
		
		public static function getUIBitmapData( displayObject:DisplayObject ):BitmapData
		{
			var bmd:BitmapData = new BitmapData( displayObject.width, displayObject.height );
			bmd.draw( displayObject );
			return bmd;
		}
		public static function removeChildren( container:DisplayObjectContainer ):void
		{
			while( container.numChildren )
			{
				container.removeChildAt( 0 );
			}
		}
		public static function stopMovieClip( displayObject:DisplayObject ):void
		{
			if( null == displayObject || !( displayObject is DisplayObjectContainer ) )
			{
				return;
			}
			var container:DisplayObjectContainer = displayObject as DisplayObjectContainer;
			var mc:MovieClip;
			var childrenNum:uint = container.numChildren;
			for( var i:int = 0; i < childrenNum; i++ ) 
			{
				var child:DisplayObject = container.getChildAt( i );
				stopMovieClip( mc );
				if( child is MovieClip )
				{
					mc = child as MovieClip;
					mc.stop();
				} 
			}
		}
		public static function playMovieClip( displayObject:DisplayObject ):void
		{
			if( null == displayObject || !( displayObject is DisplayObjectContainer ) )
			{
				return;
			}
			var container:DisplayObjectContainer = displayObject as DisplayObjectContainer;
			var mc:MovieClip;
			var childrenNum:uint = container.numChildren;
			for( var i:int = 0; i < childrenNum; i++ ) 
			{
				var child:DisplayObject = container.getChildAt( i );
				playMovieClip( mc );
				if( child is MovieClip )
				{
					mc = child as MovieClip;
					mc.play();
				} 
			}
		}
		public static function addPlayOverHandler( mc:MovieClip, func:Function ):void
		{
			funcDiction[ mc ] = func;
			mc.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			mc.play();
		}
		private static function onEnterFrame( e:Event ):void
		{
			var mc:MovieClip = e.target as MovieClip;
			if( mc.currentFrame != mc.totalFrames )
			{
				return;
			}
			mc.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			var func:Function = funcDiction[ mc ];
			if( null == func )
			{
				return;
			}
			funcDiction[ mc ] = null;
			delete funcDiction[ mc ];
			func();
		}
	}
}