package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import ui.BackgroundImage;
	
	/**
	 * MatchLover
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 30, 2014   2:38:21 PM
	 * @version 1.0
	 */
	[SWF( height = 540, width = 960, frameRate = 60 )]
	public class MatchLover extends Sprite
	{
		public static const BACKGROUND_WIDTH:Number = 1920;
		public static const BACKGROUND_HEIGHT:Number = 1080;
		
		private var _layer:Sprite;
		/**
		 *背景大图 
		 */		
		private var _backgroundImage:BackgroundImage;
		public function MatchLover()
		{
			super();
			if( null != stage ) 
			{
				initUI();
				return;
			}
			
			addEventListener( Event.ADDED_TO_STAGE, initUI );
		}
		private function initUI( e:Event = null ):void
		{
			if( null != e )
			{
				removeEventListener( Event.ADDED_TO_STAGE, initUI );
			}
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener( Event.RESIZE, onStageResize );
			
			_layer = new Sprite();
			_backgroundImage = new BackgroundImage();
			addChild( _backgroundImage );
			_backgroundImage.cacheAsBitmap = true;
		}
		private function onStageResize( e:Event = null ):void
		{
			var newScaleX:Number = stage.stageWidth / BACKGROUND_WIDTH;
			var newScaleY:Number = stage.stageHeight/ BACKGROUND_HEIGHT;
			_layer.x = stage.stageWidth / 2;
			_backgroundImage.x = stage.stageWidth / 2;
			_layer.scaleX = _layer.scaleY = newScaleX < newScaleY ? newScaleX : newScaleY;
		}
	}
}