package  
{
	import net.flashpunk.FP;
	import flash.events.IMEEvent;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author ...
	 */
	public class playerBullet extends Entity
	{
		[Embed(source = "/images/bullets.png")]
		private const BULLETS_IMAGE:Class;
		
		private var bulletImage:Spritemap;
		
		
		private var movingAngle:Number;
		private var speedVector:Vector3D;
		private var speed:Number = 320;
		private var sideBulletShrinker:Number = 0.6;
		
		public function playerBullet(_x:Number, _y:Number, _angle:Number, frame:Number) 
		{
			type = "playerBullet";
			
			setHitbox(5, 5, 0, 0);
			centerOrigin();
			
			movingAngle = _angle;
			
			speedVector = new Vector3D(Math.cos(movingAngle * FP.RAD ) * speed, Math.sin(movingAngle * FP.RAD ) * speed);
			
			
			bulletImage = new Spritemap(BULLETS_IMAGE, 8, 5);
			bulletImage.frame = frame;
			bulletImage.angle = movingAngle;
			bulletImage.centerOO();
			bulletImage.smooth = true;
			
			graphic = bulletImage;
			
			// offset the bullets out a bit when placing them
			var tempScaler:Number = 1.0;
			if (frame == 0 || frame == 2)
			{
				tempScaler = sideBulletShrinker;
			}
			
			super(_x + 12 * tempScaler * speedVector.x / speed , _y + 16 * tempScaler * speedVector.y / speed);
			
		}
		
		override public function update():void 
		{
			super.update();
			
			x += speedVector.x * FP.elapsed;
			y += speedVector.y * FP.elapsed;
			
			// if outside of the frame, destroy
			if ( y > FP.screen.height || y < 0 || x > FP.screen.width * 2 || x < -FP.screen.width)
			{
				FP.world.remove(this);
			}
		}
	}

}