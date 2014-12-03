package lottery
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	public class MoveShower extends Sprite
	{
		/* private var b:DisplayObject; */
		private var l:Loader;
		private var _mask:Sprite=new Sprite;
		private var _border:Sprite;
		
		private var _conn:LocalConnection;
		private var _width:Number=800;
		private var _height:Number=580;
		
		private var _connTimer:Timer=new Timer(100,0);
		private var _bmp:Bitmap;
		public function MoveShower()
		{
			super();
			initLocalConnection();
		}
		private function initLocalConnection():void
		{
			_connTimer.addEventListener(TimerEvent.TIMER,loadConn);
			_conn=new LocalConnection();
			try{				
				_conn.connect("localConnection");
				_conn.client=this;
			}catch(err:Error){
				_conn.send("localConnection","receive","close","close");
				_conn=null;
				_connTimer.start();
			}
		}
		private function loadConn(e:TimerEvent):void
		{
			try{
				_conn=new LocalConnection();
				_conn.connect("localConnection");
				_conn.client=this;
				_connTimer.stop();
				_connTimer.removeEventListener(TimerEvent.TIMER,loadConn);
			}catch(err:Error){
				_connTimer.start();
			}
		}
		public function receive(mess:String,c:String):void 
		{
			if(mess=="close"){
				try{_conn.close();}catch(e:Error){}
				_conn=null;
			}else{
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		public function play(s:String):void{
			load(s);
		}
		public function stop():void{
			removeBitmap();
		}
		private function load(s:String):void 
		{			
			removeBitmap();
			l=new Loader();
			l.contentLoaderInfo.addEventListener(Event.COMPLETE,showBitMap);	
			l.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			l.contentLoaderInfo.uncaughtErrorEvents.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtErrors, false, 0, true);		
			l.load(new URLRequest(s));			
		}		
		
		protected function handleUncaughtErrors( e:UncaughtErrorEvent ):void
		{
			trace( "MoveShower.handleUncaughtErrors( e )" + e.toString() );
		}
		protected function ioErrorHandler( e:IOErrorEvent ):void
		{
			trace( "MoveShower.ioErrorHandler( e )" + e.toString() );
		}
		private function removeBitmap():void 
		{
			if (_bmp) {
				if (this.contains(_bmp)) {
					this.removeChild(_bmp);				
				}
				_bmp=null;
			} 
			if (l) {	
				try{
				l.contentLoaderInfo.removeEventListener(Event.COMPLETE,showBitMap);	
				l.unloadAndStop(true);
				//trace("unloadAndStop");				
				//l.unload();	
				l.close();	}catch(err:Error){}		
				l=null;
			}			
		}
		private function showBitMap(e:Event):void {	
			_mask.graphics.beginFill(0xffffff,1);
			_mask.graphics.drawRect(0,0,_width,_height);
			_mask.graphics.endFill();
			addChild(_mask);
			
			
			_bmp=e.target.content as Bitmap;
			
			
			_bmp.mask=_mask;	
			_bmp.width=_width;
			_bmp.height=_height;
			addChild(_bmp);
					
			if(!_border)
			{
				_border=new Sprite;
				_border.graphics.lineStyle(2,0xffffff);
				_border.graphics.moveTo(0,0);
				_border.graphics.lineTo(_width,0);
				_border.graphics.lineTo(_width,_height);
				_border.graphics.lineTo(0,_height);
				_border.graphics.lineTo(0,0);
			}
			addChild(_border);
		
		}
	}
}