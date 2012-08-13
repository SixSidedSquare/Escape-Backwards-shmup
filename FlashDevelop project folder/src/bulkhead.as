package  
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author ...
	 */
	public class bulkhead extends Entity
	{
		[Embed(source = "/images/bulkhead.png")]
		private const BULKHEAD_IMAGE:Class;
		
		private var topHalf:Image;
		private var bottomHalf:Image;
		
		public var doneOpening:Boolean = false;
		
		private var tweener1:VarTween;
		private var tweener2:VarTween;
		
		public function bulkhead(_x:Number, _y:Number) 
		{
			layer = 5;
			
			setHitbox(200, 200, -1, 0);
			
			tweener1 = new VarTween(opened);
			tweener2 = new VarTween();
			
			addTween(tweener1);
			addTween(tweener2);
			
			topHalf = new Image(BULKHEAD_IMAGE, new Rectangle(0, 0, 200, 200));
			bottomHalf = new Image(BULKHEAD_IMAGE, new Rectangle(0, 200, 200, 200));
			
			addGraphic(bottomHalf);
			addGraphic(topHalf);
			
			super(_x, _y);
		}
		
		override public function update():void 
		{
			x += GameSettings.backgroundMoveSpeed * FP.elapsed;
			
			
			super.update();
		}
		
		public function open():void
		{
			tweener1.tween(topHalf, "y", topHalf.y - 200, 4, Ease.quartIn);
			tweener2.tween(bottomHalf, "y", bottomHalf.y + 200, 4, Ease.quartIn);
			
			tweener1.start();
			tweener2.start();
		}
		
		private function opened():void
		{
			doneOpening = true;
		}
		
	}

}