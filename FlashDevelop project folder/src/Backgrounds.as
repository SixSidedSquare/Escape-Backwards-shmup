package  
{
	import net.flashpunk.FP;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import GameSettings;
	/**
	 * ...
	 * @author ...
	 */
	public class Backgrounds extends Entity
	{
		private var topLayer1:Image;
		private var topLayer2:Image;
		
		private var middleLayer1:Image;
		private var middleLayer2:Image;
		
		private var starLayer1:Image;
		private var starLayer2:Image;
		
		[Embed(source = "/images/background.png")]
		private const BACKGROUND_IMAGE:Class;
		[Embed(source = "/images/background2.png")]
		private const BACKGROUND_2_IMAGE:Class;
		[Embed(source = "/images/backgroundStars.png")]
		private const BACKGROUND_STARS_IMAGE:Class;
		
		public function Backgrounds(_layer:Number, _paralax:Number) 
		{
			layer = 20;
			
			starLayer1 = new Image(BACKGROUND_STARS_IMAGE);
			starLayer2 = new Image(BACKGROUND_STARS_IMAGE);
			
			addGraphic(starLayer1);
			addGraphic(starLayer2);
			
			starLayer2.x = -starLayer2.width;
			starLayer1.scrollX = starLayer2.scrollX = 0.1;
			
			
			middleLayer1 = new Image(BACKGROUND_2_IMAGE);
			middleLayer2 = new Image(BACKGROUND_2_IMAGE);
			
			addGraphic(middleLayer1);
			addGraphic(middleLayer2);
			
			middleLayer2.x = -middleLayer2.width;
			middleLayer1.scrollX = middleLayer2.scrollX = 0.5;
			
			
			topLayer1 = new Image(BACKGROUND_IMAGE);
			topLayer2 = new Image(BACKGROUND_IMAGE);
			
			
			addGraphic(topLayer1);
			addGraphic(topLayer2);
			
			topLayer2.x = -topLayer2.width;
			topLayer1.scrollX = topLayer2.scrollX = 0.9;
			
			super();
		}
		
		override public function update():void 
		{
			super.update();
			
			starLayer1.x += GameSettings.backgroundMoveSpeed * starLayer1.scrollX * FP.elapsed;
			starLayer2.x += GameSettings.backgroundMoveSpeed * starLayer2.scrollX * FP.elapsed;
			if (starLayer1.x > starLayer1.width)
			{
				starLayer1.x -= starLayer1.width * 2;
				starLayer1.flipped = FP.choose(true, false);
			}
			else if (starLayer1.x < -starLayer1.width)
			{
				starLayer1.x += starLayer1.width * 2;
				starLayer1.flipped = FP.choose(true, false);				
			}
			if (starLayer2.x > starLayer2.width)
			{
				starLayer2.x -= starLayer2.width * 2;
				starLayer2.flipped = FP.choose(true, false);
			}
			else if (starLayer2.x < -starLayer2.width)
			{
				starLayer2.x += starLayer2.width * 2;
				starLayer2.flipped = FP.choose(true, false);				
			}
			
			middleLayer1.x += GameSettings.backgroundMoveSpeed * middleLayer1.scrollX * FP.elapsed;
			middleLayer2.x += GameSettings.backgroundMoveSpeed * middleLayer2.scrollX * FP.elapsed;
			if (middleLayer1.x > middleLayer1.width && GameSettings.gameProgress != "Ending")
			{
				middleLayer1.x -= middleLayer1.width * 2;
				middleLayer1.flipped = FP.choose(true, false);
			}
			else if (middleLayer1.x < -middleLayer1.width && GameSettings.gameProgress != "Ending")
			{
				middleLayer1.x += middleLayer1.width * 2;
				middleLayer1.flipped = FP.choose(true, false);				
			}
			if (middleLayer2.x > middleLayer2.width && GameSettings.gameProgress != "Ending")
			{
				middleLayer2.x -= middleLayer2.width * 2;
				middleLayer2.flipped = FP.choose(true, false);
			}
			else if (middleLayer2.x < -middleLayer2.width && GameSettings.gameProgress != "Ending")
			{
				middleLayer2.x += middleLayer2.width * 2;
				middleLayer2.flipped = FP.choose(true, false);				
			}
			
			
			topLayer1.x += GameSettings.backgroundMoveSpeed * topLayer1.scrollX * FP.elapsed;
			topLayer2.x += GameSettings.backgroundMoveSpeed * topLayer2.scrollX * FP.elapsed;
			if (topLayer1.x > topLayer1.width && GameSettings.gameProgress != "Ending")
			{
				topLayer1.x -= topLayer1.width * 2;
				topLayer1.flipped = FP.choose(true, false);
			}
			else if (topLayer1.x < -topLayer1.width && GameSettings.gameProgress != "Ending")
			{
				topLayer1.x += topLayer1.width * 2;
				topLayer1.flipped = FP.choose(true, false);				
			}
			if (topLayer2.x > topLayer2.width && GameSettings.gameProgress != "Ending")
			{
				topLayer2.x -= topLayer2.width * 2;
				topLayer2.flipped = FP.choose(true, false);
			}
			else if (topLayer2.x < -topLayer2.width && GameSettings.gameProgress != "Ending")
			{
				topLayer2.x += topLayer2.width * 2;
				topLayer2.flipped = FP.choose(true, false);				
			}
			
		}
		
	}

}