package net
{
	import flash.external.ExternalInterface;

	/**
	 * JSCall
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 23, 2014   7:00:57 PM
	 * @version 1.0
	 */
	public class JSCall
	{
		public static function addCallback( FuncName:String, onClosure:Function ):void
		{
			if( ExternalInterface.available )
			{
				ExternalInterface.addCallback( FuncName, onClosure );
			}
		}
		public static function CallJS( FuncName:String, ...argu ):void
		{
			if( ExternalInterface.available )
			{
				ExternalInterface.call.apply( null, [ FuncName ].concat( argu ) );
			}
		}
	}
}