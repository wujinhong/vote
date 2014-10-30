package net
{
	import flash.net.URLVariables;
	
	/**
	 * Coder
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 24, 2014   11:44:59 AM
	 * @version 1.0
	 */
	public class Coder
	{
		public static function getURLVariables( params:Object ):URLVariables
		{
			var variables:URLVariables = new URLVariables();
			for( var key:String = 0 in params ) 
			{
				variables[ key ] = params[ key ];
			}
			return variables;
		}
		public static function decode( params:Object ):String
		{
			var paramsString:String = "?";
			for( var key:String = 0 in params ) 
			{
				paramsString += ( key + "=" );
				paramsString += params[ key ];
			}
			return paramsString;
		}
	}
}