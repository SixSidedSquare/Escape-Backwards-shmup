package  
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author ...
	 */
	public class enemyBullet extends Entity
	{
		[Embed(source = "/images/bulletEnemy.png")]
		private const BULLETS_IMAGE:Class;
		
		private var bulletImage:Image;
		
		
		private var movingAngle:Number;
		private var speedVector:Vector3D;
		private var speed:Number = 150;
		
		public function enemyBullet(_x:Number, _y:Number, _angle:Number) 
		{
			type = "enemyBullet";
			
			setHitbox(4, 4, 1, 2);
			centerOrigin();
			
			movingAngle = _angle;
			speedVector = new Vector3D(Math.cos(movingAngle * FP.RAD ) * speed, Math.sin(movingAngle * FP.RAD ) * speed);
			
			
			bulletImage = new Image(BULLETS_IMAGE);
			bulletImage.angle = movingAngle;
			bulletImage.centerOO();
			bulletImage.smooth = true;
			
			graphic = bulletImage;
			
			// offset the bullets out a bit when placing them
			
			super(_x + 4 * speedVector.x / speed , _y + 4 * speedVector.y / speed);
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