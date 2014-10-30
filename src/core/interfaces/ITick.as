﻿package core.interfaces
{
	/**
	 * 需要模拟EnterFrame的补帧物件都需要实现本接口
	 */
	public interface ITick
	{
		/**
		 * 每次enterframe执行的方法
		 */
		function onTick():void;
		
		/**
		 * enterframe的优先值
		 */
		function get priority():Number;
	}
}