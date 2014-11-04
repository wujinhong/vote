package core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * ImageLoader
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 24, 2014   2:45:18 PM
	 * @version 1.0
	 */
	public class ImageLoader
	{
		private static var _instance:ImageLoader = null;
		
		private var _imageDictionary:Dictionary;
		public static function get():ImageLoader
		{
			if( null == _instance )
			{
				_instance = new ImageLoader( new Singleton() );
			}
			
			return _instance;
		}
		
		public function ImageLoader( s:Singleton )
		{
			if( null == s )
			{
				throw new Error( "此对象是单例，请通过get()获得" );
			}
			_imageDictionary = new Dictionary();
		}
		public function addBitmapData( imageURL:String, bitmapData:BitmapData ):void
		{
			_imageDictionary[ imageURL ] = { callbacks:[], containers:[], BitmapData:bitmapData };
		}
		public function getBitmapData( imageURL:String ):BitmapData
		{
			if( null == _imageDictionary[ imageURL ] )
			{
				return null;
			}
			if( null == _imageDictionary[ imageURL ].BitmapData )
			{
				return null;
			}
			return _imageDictionary[ imageURL ].BitmapData;
		}
		public function hasImage( imageURL:String ):Boolean
		{
			if( null == _imageDictionary[ imageURL ] )
			{
				return false;
			}
			if( null == _imageDictionary[ imageURL ].BitmapData )
			{
				return false;
			}
			return true;
		}
		/**
		 * @param imageURL
		 * @param func方法格式如下：
		 * 		func( BitmapData );
		 */		
		public function getImageCallback( imageURL:String, func:Function ):void
		{
			if( null == _imageDictionary[ imageURL ] )
			{
				var loader:Loader = new Loader()
				var urlRequest:URLRequest = new URLRequest( imageURL );
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loaderComplete );
				loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
				loader.contentLoaderInfo.uncaughtErrorEvents.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtErrors, false, 0, true);
				loader.load( urlRequest );
				_imageDictionary[ imageURL ] = { callbacks:[ func ], containers:[] };
				return;
			}
			
			var loadTask:Object = _imageDictionary[ imageURL ];
			if( null == loadTask.BitmapData )
			{
				loadTask.callbacks.push( func );
				return;
			}
			func( loadTask.BitmapData );
		}
		public function getImage( imageURL:String, container:DisplayObjectContainer ):void
		{
			if( null == _imageDictionary[ imageURL ] )
			{
				var loader:Loader = new Loader()
				var urlRequest:URLRequest = new URLRequest( imageURL );
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loaderComplete );
				loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
				loader.contentLoaderInfo.uncaughtErrorEvents.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtErrors, false, 0, true);
				loader.load( urlRequest );
				_imageDictionary[ imageURL ] = { callbacks:[], containers:[ container ] };
				return;
			}
			
			var loadTask:Object = _imageDictionary[ imageURL ];
			if( null == loadTask.BitmapData )
			{
				loadTask.containers.push( container );
				return;
			}
//			container.removeChildren(); //player 11不支持
			UITool.removeChildren( container );
			container.addChild( new Bitmap( loadTask.BitmapData ) );
		}
		
		/**
		 *
		 */
		private function loaderComplete( e:Event ):void
		{
			var loadTask:Object = _imageDictionary[ e.target.url ];
			loadTask.BitmapData = e.target.content.bitmapData;
			
			e.target.removeEventListener( Event.COMPLETE, loaderComplete );
			e.target.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			e.target.uncaughtErrorEvents.removeEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtErrors );
			var len:uint = loadTask.containers.length;
			var containers:Array = loadTask.containers;
			for( var i:int = 0; i < len; i++ ) 
			{
//				containers[ i ].removeChildren();//player 11不支持
				UITool.removeChildren( containers[ i ] );
				containers[ i ].addChild( new Bitmap( loadTask.BitmapData ) );
			}
			len = loadTask.callbacks.length;
			var callbacks:Array = loadTask.callbacks;
			for( var j:int = 0; j < len; j++ )
			{
				callbacks[ j ]( loadTask.BitmapData );
			}
			loadTask.callbacks = [];
			loadTask.containers = [];
		}
		/**
		 *
		 */
		private function ioErrorHandler( e:Event ):void
		{
			trace( "ImageLoader.ioErrorHandler( e )", e );
			e.target.removeEventListener( Event.COMPLETE, loaderComplete );
			e.target.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			e.target.uncaughtErrorEvents.removeEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtErrors );
		}
		private function handleUncaughtErrors( e:UncaughtErrorEvent ):void
		{
			e.target.removeEventListener( Event.COMPLETE, loaderComplete );
			e.target.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			e.target.uncaughtErrorEvents.removeEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtErrors );
			e.preventDefault();
			trace(e);
		}
	}
}
internal class Singleton{}