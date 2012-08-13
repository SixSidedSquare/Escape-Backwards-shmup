package  
{
	import net.flashpunk.FP;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author ...
	 */
	public class BossBase extends Entity
	{
		[Embed(source = "/images/bossBase.png")]
		private const BOSS_BASE_IMAGE:Class;
		
		private var elapsedTime:Number = 0;
		
		private var wobbleXSpeed:Number = 0;
		private var wobbleXPeriod:Number = 2.5;
		private var wobbleXMagnitude:Number = 15;
		
		private var wobbleYSpeed:Number = 0;
		private var wobbleYPeriod:Number = 30;
		private var wobbleYMagnitude:Number = 1;
		
		private var baseImage:Image;
		
		private var spawnerTimer:Number = 4;
		private var spawnerDelay:Number = 6;
		private var spawnerDelayWobble:Number = 4
		
		public function BossBase(_x:Number, _y:Number) 
		{
			layer = 6;
			
			type = "bossBase";
			width = 100;
			height = 200;
			originX = -22;
			
			baseImage = new Image(BOSS_BASE_IMAGE);
			graphic = baseImage;
			
			super(_x, _y);
		}
		
		override public function update():void 
		{
			super.update();
			
			elapsedTime += FP.elapsed;
			
			if (GameSettings.gameProgress != "Overdrive")
			{
				wobbleXSpeed = Math.cos(Math.PI * 2 * (elapsedTime % wobbleXPeriod) / wobbleXPeriod) * wobbleXMagnitude;
				wobbleYSpeed = Math.cos(Math.PI * 2 * (elapsedTime % wobbleYPeriod) / wobbleYPeriod) * wobbleYMagnitude;
				
				x += wobbleXSpeed * FP.elapsed;
				y += wobbleYSpeed * FP.elapsed;
			}
			
			if (GameSettings.gameProgress == "Reverse")
			{
				if (spawnerTimer < 0)
				{
					var numberToSpawn:Number = FP.choose(2, 2, 1, 3);
					for (var i:Number = 0; i < numberToSpawn; i++)
					{
						FP.world.add(new FloatyEnemy(x + 20, FP.random * 120 + 20));
					}
					spawnerTimer = spawnerDelay + FP.random * spawnerDelayWobble;
				}
				else 
				{
					spawnerTimer -= FP.elapsed;
				}
			}
			else if (GameSettings.gameProgress == "Overdrive")
			{
				wobbleXSpeed = Math.cos(Math.PI * 2 * (elapsedTime % (wobbleXPeriod / 2)) / (wobbleXPeriod / 2)) * wobbleXMagnitude * 2;
				wobbleYSpeed = Math.cos(Math.PI * 2 * (elapsedTime % (wobbleYPeriod / 3)) / (wobbleYPeriod / 3)) * wobbleYMagnitude * 3;
				
				x += wobbleXSpeed * FP.elapsed;
				y += wobbleYSpeed * FP.elapsed;
				
				
				if (spawnerTimer < 0)
				{
					var numberToSpawn:Number = FP.choose(3, 2, 2, 1, 1, 1, 1);
					for (var i:Number = 0; i < numberToSpawn; i++)
					{
						FP.world.add(new FloatyEnemy(x + 20, FP.random * 120 + 20));
					}
					spawnerTimer = spawnerDelay * 0.75 + FP.random * spawnerDelayWobble * 0.75;
				}
				else 
				{
					spawnerTimer -= FP.elapsed;
				}
				
			}
			else if (GameSettings.gameProgress == "Ending")
			{
				x += 50 * FP.elapsed;
			}
		}
		
	}

}