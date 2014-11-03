package ui
{
	import core.Looper;
	import core.interfaces.ILeap;

	/**
	 * RotationCircle
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 30, 2014   3:43:08 PM
	 * @version 1.0
	 */
	public class RotationCircle extends Circle implements ILeap
	{
		public function RotationCircle()
		{
			super();
			Looper.get().addLeapComponent( this );
		}
		
		public function onTick():void
		{
			this.circle0.rotation += 1.5;
			this.circle1.rotation += 1;
			this.circle2.rotation += 1;
			this.circle3.rotation += 2;
		}
		
		public function get priority():Number
		{
			return 5;
		}
	}
}