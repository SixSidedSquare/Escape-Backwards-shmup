package  
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import flash.display.BlendMode;
	/**
	 * ...
	 * @author ...
	 */
	public class FloatyEnemy extends Entity
	{
		[Embed(source = "/images/floatyShips.png")]
		private const ENEMY_IMAGE:Class;
		private var enemyImage:Image;
		
		private var health:Number = 35;
		private var flashWhite:Boolean = false;
		
		private var moveSpeed:Number = 10;
		
		private var shootTimer:Number = FP.random * 2 + 2;
		private var shootDelay:Number = 2;
		private var shootDelayWobble:Number = 0.5;
		
		public function FloatyEnemy(_x:Number, _y:Number) 
		{
			layer = 7;
			
			type = "floater";
			
			setHitbox(8, 8, 2, 2);
			centerOrigin();
			
			enemyImage = new Image(ENEMY_IMAGE, new Rectangle(0, FP.choose(0, 12), 12, 12));
			enemyImage.flipped = FP.choose(true, false);
			enemyImage.centerOO();
			
			super(_x, _y, enemyImage);
		}
		
		override public function update():void 
		{
			checkBulletCollisions();
			
			// move towards player
			moveTowards(GameSettings.playerReference.x, GameSettings.playerReference.y, moveSpeed * FP.elapsed);
			
			// fire bullets
			if (shootTimer < 0 && onCamera && GameSettings.gameProgress != "KickIt")
			{
				var angleToPlayer:Number = FP.angle(x, y, GameSettings.playerReference.x, GameSettings.playerReference.y);
				FP.world.add(new enemyBullet(x, y, angleToPlayer));
				shootTimer = shootDelay + FP.random * shootDelayWobble;
			}
			else
			{
				shootTimer -= FP.elapsed;
			}
			
			if (GameSettings.gameProgress == "Ending")
			{
				explode();
			}
			
			super.update();
		}
		
		override public function render():void 
		{
			if (flashWhite)
			{
				enemyImage.blend = "invert";
				flashWhite = false;
			}
			else
			{
				enemyImage.blend = "normal";
			}
			super.render();
		}
		
		private function checkBulletCollisions():void
		{
			
			var bulletHit:Array = new Array(); 
			collideInto("playerBullet", x, y, bulletHit);
			for ( var i:Number = 0; i < bulletHit.length; i++ )
			{
				FP.world.remove(bulletHit[i]);
				health--;
				flashWhite = true;
				if (health <= 0)
				{
					GameSettings.exploder.explodeFire(x, y);
					FP.world.remove(this);
					if (GameSettings.gameProgress == "Start")
					{
						GameSettings.randomProgressCounter--;
					}
					i = bulletHit.length;
				}
			}
		}
		
		public function explode():void
		{
			GameSettings.exploder.explodeFire(x, y);
			FP.world.remove(this);
		}
		
	}

}