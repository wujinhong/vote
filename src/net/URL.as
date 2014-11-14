package net
{
	/**
	 * URL
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 23, 2014   5:53:32 PM
	 * @version 1.0
	 */
	public class URL
	{
		/**
		 *AS方法，三个参数：barid:int, eventid:int, token:String, obj:{"game_time":30000,"xxx":44}
		 */
		public static const ASFunc:String = "ASFunc";
		/**
		 *JS方法
		 */
		public static const JSFunc:String = "onSWFReady";
		/**
		 *JS方法 shortcutKeys(int keycode)
		 */
		public static const shortcutKeys:String = "shortcutKeys";
		/**
		 *1.1 全民投票-活动基本信息
		 */
		public static const basicInfo:String = "http://api.moon.kklink.com/screen/voteinfo";
		/**
		 *1.2 全民投票-投票列表（长轮询）投票列表（长轮询）
		 */
		public static const list:String = "http://api.moon.kklink.com/screen/votelist";
		/**
		 *1.3 全民投票-查询结果
		 */
		public static const result:String = "http://api.moon.kklink.com/screen/voteresult";
	}
}