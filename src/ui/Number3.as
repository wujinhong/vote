package ui
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	
	import core.ImageLoader;
	
	import fl.motion.Animator;
	import fl.motion.MotionEvent;

	/**
	 * Number3
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 27, 2014   10:21:07 PM
	 * @version 1.0
	 */
	public class Number3 extends RankCuprum
	{
		private var _animator:Animator;
		private var _bitmap:Bitmap;
		private var _func:Function;
		private var _motionIndex:uint = 0;
		private var _motionList:Vector.<Object> = new <Object>[
			{ scaleX:1.2, scaleY:1.2, onComplete:onMotionEnd },
			{ scaleX:0.8, scaleY:0.8, onComplete:onMotionEnd },
			{ scaleX:1, scaleY:1, onComplete:onMotionEnd },
			{ scaleX:0.9, scaleY:0.9, onComplete:onMotionEnd },
			{ scaleX:1, scaleY:1, onComplete:onMotionEnd },
		];
		public function Number3( func:Function )
		{
			super();
			_func = func;
			var info:Object = Vote.RANK_LIST[ 2 ];
			_bitmap = new Bitmap( ImageLoader.get().getBitmapData( info.icon ) );
			
			this.circle.image.addChild( _bitmap );
			/*circle.scaleX = circle.scaleY = 0.075;
			_animator = new Animator( MotionXML.xmls[ _motionIndex ], this.circle );
			_animator.addEventListener( MotionEvent.MOTION_END, onMotionEnd );
			_animator.play();*/
			_bitmap.x = -_bitmap.width / 2;
			_bitmap.y = -_bitmap.height / 2;
			this.info.rankTF.text = "第三名";
			this.info.nameTF.text = info.nick + "";
			this.info.scoreTF.text = info.vote_num + "票";
			info.alpha = 0;
			crown.visible = false;
			TweenLite.to( circle, MotionXML.TREMBLE, _motionList[ _motionIndex ] );
		}
		
		/**
		 *
		 */
		protected function onMotionEnd( e:MotionEvent = null ):void
		{
			if( _motionIndex == 2 )
			{
				crown.visible = true;
				TweenLite.to( info, 1, { alpha:1 } );
				TweenLite.to( this, 1, { x: this.x + MotionXML.distance } );
			}
			_motionIndex++;
			if( _motionIndex == 5 )
			{
				_motionIndex = 3;
				if( null != _func )
				{
					_func();
					_func = null;
				}
			}
			TweenLite.to( circle, MotionXML.TREMBLE, _motionList[ _motionIndex ] );
		}
	}
}