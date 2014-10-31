package ui
{
	

	/**
	 * MotionXML
	 * 
	 * @author Gordon 597785841@qq.com
	 * @date Oct 29, 2014   11:08:12 AM
	 * @version 1.0
	 */
	public class MotionXML
	{
		public static var xml0:XML = <Motion duration="14" xmlns="fl.motion.*" xmlns:geom="flash.geom.*" xmlns:filters="flash.filters.*">
			<source>
				<Source frameRate="24" scaleX="0.075" scaleY="0.075" rotation="0" elementType="movie clip" symbolName="元件 2">
					<dimensions>
						<geom:Rectangle left="-160.75" top="-160.75" width="321.55" height="321.55"/>
					</dimensions>
					<transformationPoint>
						<geom:Point x="0.4999222515938423" y="0.4999222515938423"/>
					</transformationPoint>
				</Source>
			</source>
		
			<Keyframe index="0" tweenSnap="true" tweenSync="true">
				<color>
					<Color alphaMultiplier="0"/>
				</color>
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
			</Keyframe>
		
			<Keyframe index="9" tweenSnap="true" tweenSync="true" scaleX="1.2" scaleY="1.2">
				<color>
					<Color/>
				</color>
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
			</Keyframe>
		
			<Keyframe index="12" tweenSnap="true" tweenSync="true" scaleX="1" scaleY="1">
				<color>
					<Color/>
				</color>
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
			</Keyframe>
		
			<Keyframe index="15" tweenSnap="true" tweenSync="true" scaleX="1.2" scaleY="1.2">
				<color>
					<Color/>
				</color>
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
			</Keyframe>
		</Motion>;
		public static var xml1:XML = <Motion duration="15" xmlns="fl.motion.*" xmlns:geom="flash.geom.*" xmlns:filters="flash.filters.*">
				<source>
					<Source frameRate="24" scaleX="1.2" scaleY="1.2" rotation="0" elementType="movie clip" symbolName="元件 2">
						<dimensions>
							<geom:Rectangle left="-160.75" top="-160.75" width="321.55" height="321.55"/>
						</dimensions>
						<transformationPoint>
							<geom:Point x="0.4999222515938423" y="0.4999222515938423"/>
						</transformationPoint>
					</Source>
				</source>
			
				<Keyframe index="0" tweenSnap="true" tweenSync="true">
					<tweens>
						<SimpleEase ease="0"/>
					</tweens>
				</Keyframe>
			
				<Keyframe index="2" tweenSnap="true" tweenSync="true" scaleX="0.8333333333333334" scaleY="0.8333333333333334">
					<tweens>
						<SimpleEase ease="0"/>
					</tweens>
				</Keyframe>
			</Motion>;
		/**
		 *前面三个xml是第一个动画，后面两个是第二个动画 
		 */		
		public static var xmls:Vector.<XML> = new <XML>[ xml0, xml1 ];
		public static const distance:Number = 500;
		public static const TREMBLE:Number = 0.6;
		public static const TREMBLE2:Number = 2.2;
	}
}