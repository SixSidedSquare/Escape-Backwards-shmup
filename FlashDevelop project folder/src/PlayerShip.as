package  
{
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerShip extends Entity
	{
		[Embed(source = "/images/shipSprite.png")]
		private const SHIP_IMAGE:Class;
		private var playerSprite:Spritemap;
		
		private var motionVector:Vector3D;
		private var acceleration:Vector3D;
		
		private var shootingCooldown:Number = 0;
		private var shootingDelay:Number = 0.09;
		private var shootingSlowdownFator:Number = 0.33;
		
		private var knockBackTimer:Number = 0;
		private var knockBackMagnitude:Number = 0;
		
		private var maxVerticalSpeedFast:Number = 300;  //pixels per second for all of this
		private var maxLeftSpeedFast:Number = 180;
		private var maxRightSpeedFast:Number = 180;
		
		private var verticalAcceleration:Number = 1600;
		private var horizontalRightAcceleration:Number = 900;
		private var horizontalLeftAcceleration:Number = 900;
		
		private var health:Number = 4;
		private var healthRechargeDelay:Number = 3;
		private var healthRechargeTimer:Number = 0;
		private var invincibleTime:Number = 1.2;
		
		public var moveToPoint:Point = new Point();
		
		private var dead:Boolean = false;
		private var flash:Boolean = false;
		private var flashTimer:Number = 0;
		
		public function PlayerShip(_x:Number, _y:Number) 
		{		
			layer = 0;
			
			Input.define("Up", Key.UP, Key.W);
			Input.define("Down", Key.DOWN, Key.S);
			Input.define("Left", Key.LEFT, Key.A);
			Input.define("Right", Key.RIGHT, Key.D);
			
			type = "player";
			setHitbox(6, 15);
			centerOrigin();
			originX += 2;
			
			// set graphic
			/*
			var tempGraphic:BitmapData = new BitmapData(15, 20, true, 0x00000000);
			Draw.setTarget(tempGraphic);
			playerSprite = new Image(tempGraphic);
			Draw.circle(7, 10, 7, 0x02DAD8);*/
			
			
			motionVector = new Vector3D();
			acceleration = new Vector3D;
			
			playerSprite = new Spritemap(SHIP_IMAGE, 15, 20);
			playerSprite.frame = 4;
			
			playerSprite.blend = "normal";
			
			playerSprite.centerOO();
			addGraphic(playerSprite);
			super(_x, _y);
		}
		
		
		override public function update():void 
		{
			super.update();
			
			
			var tempSlowdownFactor:Number = 1.0;
			
			if (Input.mouseDown && !GameSettings.cantShoot) //shoot
			{
				if (shootingCooldown <= 0)
				{
					var angleToMouse:Number = FP.angle(x - FP.camera.x, y - FP.camera.y, Input.mouseX, Input.mouseY);
					FP.world.add(new playerBullet(x, y, angleToMouse, 1));
					FP.world.add(new playerBullet(x + Math.sin(angleToMouse * FP.RAD ) * 5, y - Math.cos(angleToMouse * FP.RAD ) * 5, angleToMouse, 0));
					FP.world.add(new playerBullet(x - Math.sin(angleToMouse * FP.RAD ) * 5, y + Math.cos(angleToMouse * FP.RAD ) * 5, angleToMouse, 2));
					
					shootingCooldown = shootingDelay;
				}
				else
				{
					shootingCooldown -= FP.elapsed;
				}
				
				tempSlowdownFactor = shootingSlowdownFator;
			}
			
			// check movement inputs
			if (Input.check("Up"))
			{
				motionVector.y -= verticalAcceleration * FP.elapsed;
			}
			if (Input.check("Down"))
			{
				motionVector.y += verticalAcceleration * FP.elapsed;
			}
			if (Input.check("Left"))
			{
				motionVector.x -= horizontalLeftAcceleration * FP.elapsed;
			}
			if (Input.check("Right"))
			{
				motionVector.x += horizontalRightAcceleration * FP.elapsed;
			}
			
			// check for changes in direction, to avoid slippage
			if ( Input.check("Up") && motionVector.y > 0)
			{
				motionVector.y = 0;
			}
			else if ( Input.check("Down") && motionVector.y < 0)
			{
				motionVector.y = 0;
			}
			else if (!Input.check("Up") && !Input.check("Down"))
			{
				motionVector.y *= 0.4;
			} // now for x's
			if ( Input.check("Left") && motionVector.x > 0)
			{
				motionVector.x = 0;
			}
			else if ( Input.check("Right") && motionVector.x < 0)
			{
				motionVector.x = 0;
			}
			else if (!Input.check("Left") && !Input.check("Right"))
			{
				if (GameSettings.gameProgress == "Start" || GameSettings.gameProgress == "Door" || GameSettings.gameProgress == "Ending")
				{
					motionVector.x *= 0.9;
				}
				else if (GameSettings.gameProgress == "Reverse" || GameSettings.gameProgress == "Overdrive")
				{
					motionVector.x = 50; // constantly drag to the right
				}
			}
			
			
			
			// check maxes
			if ( motionVector.y >  maxVerticalSpeedFast * tempSlowdownFactor || motionVector.y < -maxVerticalSpeedFast * tempSlowdownFactor)
			{
				motionVector.y = FP.sign(motionVector.y) * maxVerticalSpeedFast * tempSlowdownFactor;
			}
			if ( motionVector.x >  maxRightSpeedFast * tempSlowdownFactor)
			{
				motionVector.x = FP.sign(motionVector.x) * maxRightSpeedFast * tempSlowdownFactor;
			}
			else if ( motionVector.x <  -maxLeftSpeedFast * tempSlowdownFactor)
			{
				motionVector.x = FP.sign(motionVector.x) * maxLeftSpeedFast * tempSlowdownFactor;
			}
			
			if ( GameSettings.cantMove )
			{
				if (distanceToPoint(moveToPoint.x, moveToPoint.y) > 10)
				{
					moveTowards(moveToPoint.x, moveToPoint.y, 50 * FP.elapsed);
				}
			}
			else
			{
				// move ship, keeping in mind bounds
				x += motionVector.x * FP.elapsed;
				y += motionVector.y * FP.elapsed;
			}
			
			// remember knockback
			if (knockBackTimer > 0)
			{
				knockBackTimer -= FP.elapsed;
				x += knockBackMagnitude * FP.elapsed;
			}
			
			if ( y < 15) y = 16;
			if ( y > FP.screen.height - 15) y = FP.screen.height - 16;
			
			if ( x < 190) x = 191;
			if ( x > 190 + FP.screen.width) x = 190 + FP.screen.width - 1;
			
			
			if (!GameSettings.cantCollide)
			{
				var possibleBullet:Entity = collide("enemyBullet", x, y);
				if (possibleBullet)
				{
					FP.world.remove(possibleBullet);
					
					takeDamage(1);
				}
				
				if (collide("bossBase", x, y))
				{
					health = 0;
					playerSprite.frame = health;
				}
			}
			
			if (healthRechargeTimer > 0)
			{
				healthRechargeTimer -= FP.elapsed;
			}
			else if (health < 4)
			{
				health += 1;
				playerSprite.frame = health;
				//trace("Recharge");
				if (health < 4)
				{
					healthRechargeTimer = healthRechargeDelay;
				}
			}
			
			if (health <= 0 && !dead)
			{
				dead = true;
				GameSettings.exploder.explodeFire(x, y, 20);
				GameSettings.exploder.explodePlayer(x, y, 20);
				//FP.world.remove(this);
				visible = false;
				GameSettings.cantMove = true;
				GameSettings.cantShoot = true;
				GameSettings.cantCollide = true;
				GameSettings.delayTweener = new Alarm(8, resetGame);
				addTween(GameSettings.delayTweener, true);
				
			}
			
			//do the flahshing for invincible
			if (flash)
			{
				if (flashTimer <= 0)
				{
					if (playerSprite.blend == "normal")
					{
						playerSprite.blend = "invert";
					}
					else
					{
						playerSprite.blend = "normal";
					}
					flashTimer = 0.075;
				}
				else
				{
					flashTimer -= FP.elapsed;
				}
			}
			
		}
		
		private function resetGame():void
		{
			FP.world.removeAll();
			FP.world = new MenuWorld();
		}
		
		private function takeDamage(ammount:Number):void
		{
			health -= ammount;
			playerSprite.frame = health;
			healthRechargeTimer = healthRechargeDelay;
			
			GameSettings.cantCollide = true;
			GameSettings.delayTweener = new Alarm(invincibleTime, recollidable);
			addTween(GameSettings.delayTweener, true);
			
			flash = true;
		}
		
		private function recollidable():void
		{
			GameSettings.cantCollide = false;
			flash = false;
			playerSprite.blend = "normal";
		}
		
		public function activateEscapeSpeedReduction():void
		{
			maxLeftSpeedFast = 80;
			maxRightSpeedFast = 260;
			GameSettings.backgroundMoveSpeed = 300;
		}
		
		public function isAlive():Boolean
		{
			return !dead;
		}
		
		public function knockBack(xToAdd:Number, time:Number):void
		{
			takeDamage(1);
			knockBackTimer = time;
			knockBackMagnitude = xToAdd / time;
		}
		
	}

}