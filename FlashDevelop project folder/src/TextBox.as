package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author ...
	 */
	public class TextBox extends Entity
	{
		[Embed(source = "/images/textBacking.png")]
		private const BACKING_IMAGE:Class;
		private var backBox:Image;
		
		private var currentText:String = "";
		private var text:Text;
		
		private var dissappearTimer:Number = 0;
		private var timered:Boolean = false; // if not timered, check for space to advance
		
		public function TextBox() 
		{
			layer = 3;
			backBox = new Image(BACKING_IMAGE);
			backBox.alpha = 0.4;
			addGraphic(backBox);
			
			text = new Text(currentText, 3, 3,  { size:8, wordWrap:true, width:125 } );
			text.color = 0x000000;
			text.alpha = 0.8;
			addGraphic(text);
			
			
			
			backBox.scrollX = text.scrollX = 0;
			
			
			super();
			visible = false;
		}
		
		override public function update():void 
		{
			super.update();
			
			if ( visible)
			{
				if (timered)
				{
					dissappearTimer -= FP.elapsed
					if (dissappearTimer < 0)
					{
						visible = false;
					}
				}
				else
				{
					if (Input.pressed(Key.SPACE))
					{
						visible = false;
					}
				}
			}
			
		}
		
		public function displayText(_x:Number, _y:Number, stringText:String, _dissapearTimer:Number = 0):void
		{
			x = _x;
			y = _y;
			
			currentText = stringText;
			text.text = currentText;
			
			visible = true;
			
			if (_dissapearTimer > 0)
			{
				dissappearTimer = _dissapearTimer;
				timered = true;
			}
			else
			{
				timered = false;
			}
		}
		
	}

}