package ui
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import core.ImageLoader;
	import core.UITool;
	
	/**
	 * VoteRole
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 22, 2014   5:23:37 PM
	 * @version 1.0
	 */
	public class VoteRole extends Sprite
	{
		public static const ROLE_WIDTH:Number = 444;
		public static const ROLE_HEIGHT:Number = 650;
		public static const DURATION:Number = 3;
		/**
		 *60 
		 */		
		public static const ROTATION_Y:Number = 60;
		/**
		 * 40
		 */		
		public static const ROTATION_Y1:Number = 40;
		/**
		 *-40 
		 */		
		public static const ROTATION_Y2:Number = -40;
		/**
		 *-60 
		 */		
		public static const ROTATION_Y3:Number = -60;
		/**
		 *从左到右位置（1~5） ,1或5的位置
		 */		
		public static const STAGE_1_5_X:Number = 2.4;
		/**
		 *从左到右位置（1~5） ,2或4的位置
		 */
		public static const STAGE_2_4_X:Number = 1.2;
		
		private var _func:Function;
		private var _roleIndex:int;
		private var _roleInfo:RoleInfo;
		private static var _shine:Shine = new Shine();
		private var _bitmap:Bitmap;
		
		/**
		 * @param sprite
		 * @param func
		 * @param stageIndex
		 * 	从左到右位置（1~5）
		 */
		public function VoteRole( roleIndex:int, func:Function = null )
		{
			super();
			_func = func;
			_roleIndex = roleIndex;
			_bitmap = new Bitmap( ImageLoader.get().getBitmapData( Vote.USER[ roleIndex ].icon ) );
			_bitmap.width = ROLE_WIDTH;
			_bitmap.height = ROLE_HEIGHT;
			_bitmap.x = -_bitmap.width / 2;
			_bitmap.y += 8;
			/****从左到右位置（1~5），初使化位置1***************************/
			x =  ( STAGE_1_5_X + 1 ) * ROLE_WIDTH;
			alpha = 0;
			/****从左到右位置（1~5），初使化位置1***************************/
			if( Vote.USER[ _roleIndex ].icon != Vote.EMPTY_ROLE )
			{
				_roleInfo = new RoleInfo();
				addChild( _roleInfo );
				_roleInfo.nameTF.text = Vote.USER[ roleIndex ].nick;
				_roleInfo.scoreTF.text = Vote.USER[ roleIndex ].vote_num + "票";
				_roleInfo.nameTF.cacheAsBitmap = true;
				_roleInfo.scoreTF.cacheAsBitmap = true;
				_roleInfo.visible = false;
				
				var frame:Frame = new Frame();
				addChild( frame );
				UITool.removeChildren( frame.container );
			}
			addChild( _bitmap );
			cacheAsBitmap = true;
			rotationY = ROTATION_Y;
			TweenLite.killTweensOf( this );
			TweenLite.to( this, DURATION, { x:STAGE_1_5_X * ROLE_WIDTH, alpha:1, onComplete:onComplete1 } );//走向位置1
		}
		private function setOrigin():void
		{
			scaleX = scaleY = 1;
		}
		/**
		 *从左到右位置（1~5），到达位置1
		 */
		private function onComplete1():void
		{
			TweenLite.killTweensOf( this );
			TweenLite.to( this, DURATION, { x:STAGE_2_4_X * ROLE_WIDTH, rotationY:ROTATION_Y1, onComplete:onComplete2 } );//走向位置2
		}
		/**
		 *从左到右位置（1~5），到达位置2
		 */
		private function onComplete2():void
		{
			if( null != _roleInfo )
			{
				_roleInfo.visible = true;
				_roleInfo.alpha = 0;
				TweenLite.killTweensOf( _roleInfo );
				TweenLite.to( _roleInfo, DURATION, { alpha:1 } );
			}
			TweenLite.killTweensOf( this );
			TweenLite.to( this, DURATION, { rotationY:0, x:0, onComplete:onComplete3 } );//走向位置3(即中间)
		}
		/**
		 *从左到右位置（1~5），到达位置3(即中间)
		 */
		private function onComplete3():void
		{
			setOrigin();
			
			TweenLite.killTweensOf( this );
			TweenLite.to( this, DURATION, { rotationY:ROTATION_Y2, x:-STAGE_2_4_X * ROLE_WIDTH, onComplete:onComplete4 } );//走向位置4
			
			if( null != _roleInfo )
			{
				_roleInfo.alpha = 1;
				TweenLite.killTweensOf( _roleInfo );
				TweenLite.to( _roleInfo, DURATION, { alpha:0 } );
				
				addChild( _shine );
				_shine.addEventListener( Event.ENTER_FRAME, onFrameScript );
				
				_shine.visible = true;
				_shine.x = _bitmap.width / 2;
				_shine.y = _bitmap.height;
				_shine.gotoAndPlay( 1 );
			}
		}
		private function onFrameScript( e:Event ):void
		{
			if( _shine.totalFrames == _shine.currentFrame )
			{
				_shine.removeEventListener( Event.ENTER_FRAME, onFrameScript );
				_shine.visible = false;
				_shine.stop();
			}
		}
		/**
		 *从左到右位置（1~5），到达位置4
		 */
		private function onComplete4():void
		{
			setOrigin();
			rotationY = ROTATION_Y2;
			TweenLite.killTweensOf( this );
			TweenLite.to( this, DURATION, { rotationY:ROTATION_Y3, x:-STAGE_1_5_X * ROLE_WIDTH, onComplete:onComplete5 } );//走向位置5
			if( null != _roleInfo )
			{
				_roleInfo.alpha = 0;
			}
		}
		/**
		 *到达最左
		 */
		private function onComplete5():void
		{
			setOrigin();
			rotationY = ROTATION_Y3;
			TweenLite.killTweensOf( this );
			TweenLite.to( this, DURATION, { x:-( STAGE_1_5_X + 1 ) * ROLE_WIDTH, alpha:0, onComplete:onFinalComplete } );
		}
		private function onFinalComplete():void
		{
			setOrigin();
			if( null != parent )
			{
				parent.removeChild( this );
			}
			if( null == _func )
			{
				return;
			}
			_func( this );
		}
	}
}