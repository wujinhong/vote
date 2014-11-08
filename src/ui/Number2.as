package ui
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	
	import core.ImageLoader;
	import core.UITool;
	
	import fl.motion.Animator;
	import fl.motion.MotionEvent;

	/**
	 * Number3
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 27, 2014   10:21:07 PM
	 * @version 1.0
	 */
	public class Number2 extends RankSilver
	{
		private var _animator:Animator;
		private var _bitmap:Bitmap;
		private var _func:Function;
		private var _motionIndex:uint = 0;
		private var SCALE:Number = 0.696;
		private var _motionList:Vector.<Object> = new <Object>[
			{ scaleX:Number1.CIRCLE_SCALE, scaleY:Number1.CIRCLE_SCALE, onComplete:onMotionEnd },
			{ scaleX:0.2, scaleY:0.2, onComplete:onMotionEnd },
			{ scaleX:Number1.CIRCLE_SCALE, scaleY:Number1.CIRCLE_SCALE, onComplete:onMotionEnd },
			{ scaleX:0.2, scaleY:0.2, onComplete:onMotionEnd },
			{ scaleX:Number1.CIRCLE_SCALE, scaleY:Number1.CIRCLE_SCALE, onComplete:onMotionEnd },
		];
		public function Number2( func:Function )
		{
			super();
			_func = func;
			var info:Object = Vote.RANK_LIST[ 1 ];
			_bitmap = new Bitmap( ImageLoader.get().getBitmapData( info.icon ) );

			this.circle.image.addChild( _bitmap );
			_bitmap.x = -_bitmap.width / 2;
			_bitmap.y = -_bitmap.height / 2;
			
			UITool.removeChildren( img.container );
			_bitmap = new Bitmap( ImageLoader.get().getBitmapData( info.img ) );
			img.container.addChild( _bitmap );
			_bitmap.width = img.width / SCALE - 32;
			_bitmap.height = img.height / SCALE - 16;
			_bitmap.x = -_bitmap.width / 2;
			_bitmap.y = 8;
			circle.scaleX = circle.scaleY = 0.01;
			img.scaleX = img.scaleY = 0.01;
			
			this.info.rankTF.text = "第二名";
			this.info.nameTF.text = info.nick + "";
			this.info.scoreTF.text = info.vote_num + "票";
			
			info.alpha = 0;
			TweenLite.to( circle, MotionXML.TREMBLE2, _motionList[ _motionIndex ] );
			
			TweenLite.to( img, MotionXML.TREMBLE2, { scaleX:SCALE, scaleY:SCALE } );
		}
		
		/**
		 *
		 */
		protected function onMotionEnd( e:MotionEvent = null ):void
		{
			if( _motionIndex == 2 )
			{
				TweenLite.to( info, 2, { alpha:1 } );
				TweenLite.to( this, 2, { x: this.x - MotionXML.distance } );
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