package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * MatchLover
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 30, 2014   2:38:21 PM
	 * @version 1.0
	 */
	public class MatchLover extends Sprite
	{
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
		}//
	}
}