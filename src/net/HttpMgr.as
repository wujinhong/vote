package net
{
	import com.adobe.serialization.json.JSONNew;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	
	/**
	 * HttpMgr
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 22, 2014   8:17:51 PM
	 * @version 1.0
	 */
	public class HttpMgr
	{
		private static var _instance:HttpMgr = null;
		
		private var _FuncDiction:Dictionary;
		public static function get():HttpMgr
		{
			if( null == _instance )
			{
				_instance = new HttpMgr( new Singleton() );
			}
			
			return _instance;
		}
		
		public function HttpMgr( s:Singleton )
		{
			if( null == s )
			{
				throw new Error( "此对象是单例，请通过get()获得" );
			}
			_FuncDiction = new Dictionary();
		}
		public function getData( url:String, params:Object, onReturn:Function ):void
		{
			var request:URLRequest = new URLRequest( url + Coder.decode( params ) );
			request.method = URLRequestMethod.GET;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener( Event.COMPLETE, onComplete );
			urlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			urlLoader.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler);
			_FuncDiction[ urlLoader ] = onReturn;
			try
			{
				urlLoader.load( request );
			}
			catch( e:Error )
			{
				trace( "Unable to load requested url:" + url );
			}
		}
		public function post( url:String, params:Object, onReturn:Function ):void
		{
			var request:URLRequest = new URLRequest( url );
			request.method = URLRequestMethod.POST;
			request.data = Coder.getURLVariables( params );
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener( Event.COMPLETE, onComplete );
			urlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
			urlLoader.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			//如有需要添加另外两个事件：ProgressEvent.PROGRESS、HTTPStatusEvent.HTTP_STATUS
			_FuncDiction[ urlLoader ] = onReturn;
			try
			{
				urlLoader.load( request );
			}
			catch( e:Error )
			{
				trace( "Unable to load requested url:" + url );
			}
		}
		
		private function onComplete( e:Event ):void
		{
			var func:Function = _FuncDiction[ e.target ];
			var data:* = e.target.data;
			e.target.removeEventListener( Event.COMPLETE, onComplete );
			e.target.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
			e.target.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			if( null != data )
			{
				func( ( data is String ) ? JSONNew.decode( data ) : data );
			}
			else
			{
				trace( "e.target.data is null" );
			}
			_FuncDiction[ e.target ] = null;
		}
		
		private function securityErrorHandler( e:SecurityErrorEvent ):void
		{
			trace( "securityErrorHandler: " + e );
		}
		private function ioErrorHandler( e:IOErrorEvent ):void
		{
			trace( "ioErrorHandler: " + e );
		}
	}
}
internal class Singleton{}