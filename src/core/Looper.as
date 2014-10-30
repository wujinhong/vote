package core
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import core.interfaces.ILeap;
	import core.interfaces.ITick;
	
	/**
	 * 循环管理器 
	 * 通过循环管理器可以对每一帧应该执行的事务进行管理。
	 */
	public class Looper
	{
		private static var _instance:Looper = null;
		
		private var _ticks:Vector.<ITick> = new Vector.<ITick>();
		private var _leaps:Vector.<ILeap> = new Vector.<ILeap>();
		private var _running:Boolean = false;
		private var _lastTime:Number = -1;
		private var _elapsed:Number = 0;
		private var _interpolation:Number = 0;
		private var _stage:Stage;
		private var _gameTime:Number = 0;
		/**
		 *按照帧频，每帧的时间 
		 */		
		private var _delayTime:int;
		/**
		 *累计间隔时间 
		 */		
		private var _cumulativeTime:int = 0;
		private var _oldTime:int = 0;
		private var _newTime:int = 0;

		public static function get():Looper
		{
			if( null == _instance )
			{
				_instance = new Looper( new Singleton() );
			}
			
			return _instance;
		}
		
		public function Looper( s:Singleton )
		{
			if( null == s )
			{
				throw new Error( "此对象是单例，请通过get()获得" );
			}
		}
		
		/**
		 * Destroys this method.
		 */
		public function destroy():void
		{
			if( _running )
			{
				stop();
			}
			_ticks = null;
			_instance = null;
		}
		
		public function get running():Boolean
		{
			return _running;
		}
		
		public function get gameTime():Number
		{
			return _gameTime;
		}
		
		/**
		 * Starts the game loop.
		 * 传入舞台
		 */
		public function init( stage:Stage ):void
		{
			if( _running )
			{
				return;	//throw new Error("正在运行，无法再次运行");
			}
			
			_stage = stage;
			_delayTime = 1000 /  _stage.frameRate;
			_lastTime = -1;
			_elapsed = 0;
			_oldTime = getTimer();
		}
		/**
		 * run the game loop again.
		 */
		private function run():void
		{
			if( _running )
			{
				return;	//throw new Error("正在运行，无法再次运行");
			}
			
			_running = true;
			_delayTime = 1000 / _stage.frameRate;
			_lastTime = -1;
			_elapsed = 0;
			_oldTime = getTimer();
			
			_stage.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		/**
		 * 停止
		 */
		public function stop():void
		{
			if( 0 != _leaps.length || 0 != _ticks.length )
			{
				return;
			}
			if( !_running )
			{
				return;	//throw new Error("已经停止，无法再停止");
			}
			
			_running = false;
			_stage.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		/**
		 * 添加enterframe的组件
		 */
		public function addLeapComponent( leap:ILeap ):void
		{
			if( _leaps.indexOf( leap ) != -1 )
			{
				return;	//throw new Error("这个组件已经添加过了。");
			}
			
			_leaps.push( leap );
			
			_leaps.sort( function( ui1:ILeap, ui2:ILeap ):Number
			{
				if( ui1.priority > ui2.priority )
				{
					return 1;
				}
				
				if( ui1.priority < ui2.priority )
				{
					return -1;
				}
				return 0;
			} );
			
			if( 1 == _leaps.length && 0 == _ticks.length )
			{
				run();
			}
		}
		
		/**
		 * 去除enterframe组件
		 */
		public function removeLeapComponent( component:ILeap ):void
		{
			if( _leaps.indexOf( component ) == -1 )
			{
				return;	//throw new Error("没有找到该组件，无法删除组件");
			}
			
			_leaps.splice( _leaps.indexOf( component ), 1 );
			stop();
		}
		
		/**
		 * 是否已经添加了组件
		 */
		public function hasILeap( component:ILeap ):Boolean
		{
			return _leaps.indexOf( component ) != -1;
		}
		
		/**
		 * 添加enterframe的组件
		 */
		public function addTickedComponent( ticker:ITick ):void
		{
			if( _ticks.indexOf( ticker ) != -1 )
			{
				return;	//throw new Error("这个组件已经添加过了。");
			}
			
			_ticks.push( ticker );
			
			_ticks.sort( function( ui1:ITick, ui2:ITick ):Number
			{
				if( ui1.priority > ui2.priority )
				{
					return 1;
				}
				
				if( ui1.priority < ui2.priority )
				{
					return -1;
				}
				return 0;
			} );
			
			if( 1 == _ticks.length && 0 == _leaps.length )
			{
				run();
			}
		}
		
		/**
		 * 去除enterframe组件
		 */
		public function removeTickedComponent( component:ITick ):void
		{
			if( _ticks.indexOf( component ) == -1 )
			{
				return;	//throw new Error("没有找到该组件，无法删除组件");
			}
			
			_ticks.splice( _ticks.indexOf( component ), 1 );
			
			stop();
		}
		
		/**
		 * 是否已经添加了组件
		 */
		public function hasITick( component:ITick ):Boolean
		{
			return _ticks.indexOf( component ) != -1;
		}
		
		/**
		 * enterframe
		 */		
		private function onEnterFrame( e:Event ):void
		{
			leaping();
			_newTime = getTimer();
			_cumulativeTime += ( _newTime - _oldTime );
			var count:int = Math.round( _cumulativeTime / _delayTime );//掉帧数量
			if( count <= 3 )
			{
				advance();
			}
			else if( count > 3 )//累计掉帧数量超过3次时，进行补帧
			{
				while( _cumulativeTime >= _delayTime )
				{
					advance();
					_cumulativeTime = _cumulativeTime - _delayTime;
				}
			}
			
			_oldTime = getTimer();
		}
		
		/**
		 * The primary advance call in the loop.
		 */
		private function advance():void
		{
			for each ( var tick:ITick in _ticks )
				tick.onTick();
		}
		/**
		 * The primary advance call in the loop.
		 */
		private function leaping():void
		{
			for each ( var leap:ILeap in _leaps )
				leap.onTick();
		}
	}
}
internal class Singleton{}