package com.adobe.utils
{
	/**
	 * 
	 * @author xdanger.liu 
	 * @version 1.0.0 创建时间：2012-3-21 下午03:55:56
	 * 
	 */	
	public class MathUtils
	{
		public function MathUtils()
		{
		}
		
		/**
		 * 求两点之间的距离 
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */		
		public static function getDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var vx:Number = x1 - x2;
			var vy:Number = y1 - y2;
			var hyp:Number = Math.sqrt(Math.pow(vx,2) + Math.pow(vy,2));
			return hyp;
		}
		
		/**
		 * 求两点之间的角度 
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */		
		public static function getAngle(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var vx:Number = x2 - x1;
			var vy:Number = y2 - y1;
			var hyp:Number = Math.sqrt(Math.pow(vx,2) + Math.pow(vy,2));
			//斜边长度
			var cos:Number = vx / hyp;
			var radian:Number = Math.acos(cos);
			//求出弧度
			var angle:Number = 180 / (Math.PI / radian);
			//用弧度算出角度   
			if (vy<0)
			{
				angle = -angle;
			} 
			else if ((vy == 0) && (vx <0))
			{
				angle = 180;
			}
			return angle;
		}
	}
}
