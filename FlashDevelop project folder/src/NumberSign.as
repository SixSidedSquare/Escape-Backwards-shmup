package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	/**
	 * ...
	 * @author ...
	 */
	public class NumberSign extends Entity
	{
		[Embed(source = "/images/distanceSign.png")]
		private const BACKING_IMAGE:Class;
		private var sign:Image;
		private var text:Text;
		
		public function NumberSign(_x:Number, _y:Number, signText:String) 
		{
			layer = 19;
			
			sign = new Image(BACKING_IMAGE);
			addGraphic(sign);
			
			text = new Text(signText, 30, 20,  { size:32, wordWrap:true, width:125 } );
			text.color = 0x111111;
			addGraphic(text);
			
			super(_x, _y);
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