package  
{
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author ...
	 */
	public class BarrierFrame extends Entity
	{
		[Embed(source = "/images/topFrames.png")]
		private const TOP_IMAGE:Class;
		[Embed(source = "/images/bottomFrames.png")]
		private const BOTTOM_IMAGE:Class;
		
		private var moveSpeed:Number = 300;
		
		public function BarrierFrame(_x:Number) 
		{
			layer = 11;
			x = _x;
			
			if (FP.choose("top", "bottom") == "top")
			{				
				// choose a random frame for the image
				graphic = new Image(TOP_IMAGE, new Rectangle(FP.choose(0, 1, 2, 3) * 115, 0, 115, 85));
				y = 0;
				
				// place the wall at a random height on it
				FP.world.add(new Barriers(x + 30, FP.rand(40) + 10));
			}
			else
			{
				// choose a random frame for the image
				graphic = new Image(BOTTOM_IMAGE, new Rectangle(FP.choose(0, 1, 2, 3) * 115, 0, 115, 85));
				y = FP.screen.height - 85;
				
				// place the wall at a random height on it
				
				FP.world.add(new Barriers(x + 30, y + (FP.rand(40) + 10)));
			}
			super(x, y);
		}
		
		override public function update():void 
		{
			super.update();
			
			x += GameSettings.backgroundMoveSpeed * FP.elapsed;
			
			
			if (x > FP.screen.width * 2)
			{
				FP.world.remove(this);
			}
		}
		
	}

}