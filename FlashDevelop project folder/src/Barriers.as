package  
{
	import net.flashpunk.FP;
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author ...
	 */
	public class Barriers extends Entity
	{
		
		public function Barriers(_x:Number, _y:Number) 
		{
			layer = 10;
			
			x = _x;
			y = _y;
			
			// create a random width and height rectangle
			width = FP.rand(30) + 20;
			height = FP.rand(60) + 30;
			var blockImage:BitmapData = new BitmapData(width, height, false, 0xCCC4C4);
			
			graphic = new Image(blockImage);
			
			
			super(x, y);
		}
		
		override public function update():void 
		{
			super.update();
			
			x += GameSettings.backgroundMoveSpeed * FP.elapsed;
			
			var possiblePlayer:Entity = collide("player", x, y);
			if (possiblePlayer && !GameSettings.cantCollide)
			{
				// destroy this
				FP.world.remove(this);
				// add explosion
				GameSettings.exploder.explodeBarrier(x, y);
				// knockback player
				(possiblePlayer as PlayerShip).knockBack(70, 0.3);
			}
			else if (collide("floater", x, y))
			{
				(collide("floater", x, y) as FloatyEnemy).explode();
				
				FP.world.remove(this);
				GameSettings.exploder.explodeBarrier(x, y);				
			}
			else if (collide("bossBase", x, y))
			{
				// destroy this
				FP.world.remove(this);
				
				// add explosion
				GameSettings.exploder.explodeBarrier(x, y);				
			}
			
			if (x > FP.screen.width * 2)
			{
				FP.world.remove(this);
			}
		}
		
	}

}