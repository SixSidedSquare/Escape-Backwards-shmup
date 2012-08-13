package  
{
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.misc.VarTween;
	/**
	 * ...
	 * @author Six
	 */
	public class GameSettings
	{
		public static var backgroundMoveSpeed:Number = -100;
		public static var exploder:Explosion;
		public static var gameProgress:String;
		public static var textBoxer:TextBox;
		public static var playerReference:PlayerShip;
		
		public static var randomProgressCounter:Number = 0;
		
		public static var cantShoot:Boolean = false;
		public static var cantMove:Boolean = false;
		public static var cantCollide:Boolean = false;
		
		public static var variableTweener:VarTween;
		public static var delayTweener:Alarm;
	}

}