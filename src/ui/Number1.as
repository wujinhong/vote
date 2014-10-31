package ui
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	
	import core.ImageLoader;
	
	import fl.motion.Animator;
	import fl.motion.MotionEvent;

	/**
	 * Number1
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 27, 2014   9:18:55 PM
	 * @version 1.0
	 */
	public class Number1 extends RankGold
	{
		private var _animator:Animator;
		private var _bitmap:Bitmap;
		private var _motionIndex:uint = 0;
		private var _motionList:Vector.<Object> = new <Object>[
			{ scaleX:1, scaleY:1, onComplete:onMotionEnd },
			{ scaleX:0.8, scaleY:0.8, onComplete:onMotionEnd },
			{ scaleX:1, scaleY:1, onComplete:onMotionEnd },
			{ scaleX:0.9, scaleY:0.9, onComplete:onMotionEnd },
			{ scaleX:1, scaleY:1, onComplete:onMotionEnd },
		];
		public function Number1()
		{
			super();
			
			var info:Object = Vote.RANK_LIST[ 0 ];
			_bitmap = new Bitmap( ImageLoader.get().getBitmapData( info.icon ) );
			
			this.circle.image.addChild( _bitmap );
			circle.scaleX = circle.scaleY = 0.2;
			/*circle.scaleX = circle.scaleY = 0.075;
			_animator = new Animator( MotionXML.xmls[ _motionIndex ], this.circle );
			_animator.addEventListener( MotionEvent.MOTION_END, onMotionEnd );
			_animator.play();*/
			
			_bitmap.x = -_bitmap.width / 2;
			_bitmap.y = -_bitmap.height / 2;
			this.info.rankTF.text = "第一名";
			this.info.nameTF.text = info.nick + "";
			this.info.scoreTF.text = info.vote_num + "票";
			TweenLite.to( circle, MotionXML.TREMBLE2, _motionList[ _motionIndex ] );
		}
		protected function onMotionEnd( e:MotionEvent = null ):void
		{
			if( _motionIndex == 2 )
			{
				crown.visible = true;
				TweenLite.to( info, 1, { alpha:1 } );
			}
			_motionIndex++;
			if( _motionIndex == 5 )
			{
				_motionIndex = 3;
			}
			TweenLite.to( circle, MotionXML.TREMBLE, _motionList[ _motionIndex ] );
		}
	}
}