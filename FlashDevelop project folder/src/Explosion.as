package  
{
  import flash.display.BitmapData;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Emitter;
  import net.flashpunk.utils.Ease;
  import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author ...
	 */
	public class Explosion extends Entity
	{
		
		private var squareEmitter:Emitter;
		private var largeCircleEmitter:Emitter;
		
		
		public function Explosion() 
		{
			var tempBitmap:BitmapData = new BitmapData(25, 25, true, 0x00000000);
			Draw.setTarget(tempBitmap);
			Draw.circlePlus(12, 12, 12);
			Draw.resetTarget();
			largeCircleEmitter = new Emitter(tempBitmap);
			
			squareEmitter = new Emitter(new BitmapData(10, 10));
			
			squareEmitter.newType("barriers", [0]);
			squareEmitter.setMotion("barriers", 300, 120, 1, 100, 150, 1, Ease.quadOut);
			squareEmitter.setGravity("barriers", 5, 5);
			squareEmitter.setAlpha("barriers");
			squareEmitter.setColor("barriers", 0xFF555566, 0xFF555566);
			
			largeCircleEmitter.newType("smoke", [0]);
			largeCircleEmitter.setMotion("smoke", 0, 0, 0.2, 360, 50, 0.8, Ease.quadOut);
			largeCircleEmitter.setGravity("smoke", -1, 2);
			largeCircleEmitter.setAlpha("smoke");
			largeCircleEmitter.setColor("smoke", 0xFF272733, 0xFF272733);
			
			largeCircleEmitter.newType("fire", [0]);
			largeCircleEmitter.setMotion("fire", 0, 0, 0.2, 360, 50, 0.8, Ease.quadOut);
			largeCircleEmitter.setGravity("fire", -1, 2);
			largeCircleEmitter.setAlpha("fire");
			largeCircleEmitter.setColor("fire", 0xFFCC4433, 0xFF000000);
			
			largeCircleEmitter.newType("player", [0]);
			largeCircleEmitter.setMotion("player", 0, 10, 2, 360, 120, 5, Ease.quadOut);
			largeCircleEmitter.setGravity("player", -1, 2);
			largeCircleEmitter.setAlpha("player");
			largeCircleEmitter.setColor("player", 0xFFAABBFF, 0xFF000000);
			
			addGraphic(squareEmitter);
			addGraphic(largeCircleEmitter);
			super();
		}
		
		public function explodeBarrier(_x:Number, _y:Number, particleCount:Number = 10):void
		{
			for (var i:int = 0; i < particleCount; i++) 
			{
				squareEmitter.emit("barriers", _x, _y + ((particleCount % 4) / 2 - 1) * 5);
				largeCircleEmitter.emit("smoke", _x, _y);
			}
		}
		
		public function explodeFire(_x:Number, _y:Number, particleCount:Number = 10):void
		{
			for (var i:int = 0; i < particleCount; i++) 
			{
				largeCircleEmitter.emit("fire", _x-12, _y-12);
			}
		}
		
		public function explodePlayer(_x:Number, _y:Number, particleCount:Number = 10):void
		{
			for (var i:int = 0; i < particleCount; i++) 
			{
				largeCircleEmitter.emit("player", _x-12, _y-12);
			}
		}		
		
	}

}