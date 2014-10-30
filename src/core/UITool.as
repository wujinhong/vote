package core
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
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