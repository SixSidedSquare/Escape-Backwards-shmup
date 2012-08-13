package  
{
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Ease;
	import flash.display.BitmapData;
	import GameSettings;
	
	/**
	 * ...
	 * @author Six
	 */
	public class GameWorld extends World
	{
		// World variables defined here
		private var playerReference:PlayerShip;
		
		private var screenFrame:Rectangle = new Rectangle(150, 0, 600, 160)
		
		private var explosionEmitter:Explosion;
		
		private var barrierTimer:Number = 5; // intially some time with none of them
		
		private var textBoxer:TextBox;
		
		private var bulkheadReference:bulkhead;
		private var boss:BossBase;
		
		private var distanceTravelled:Number = 0;
		private var distanceToExit:Number = 100000;
		private var nextSignDistance:Number = 100000;
		
		private var textAdded:Boolean = false;
		

		public function GameWorld() 
		{
			trace("GameWorld created");
			
			GameSettings.cantCollide = false;
			GameSettings.cantMove = false;
			GameSettings.cantShoot = false;
			GameSettings.randomProgressCounter = 0;
			GameSettings.backgroundMoveSpeed = -100;
			
			playerReference = new PlayerShip(250, 80);
			GameSettings.playerReference = playerReference;
			
			explosionEmitter = new Explosion();
			GameSettings.exploder = explosionEmitter;
			
			add(new Backgrounds(10, 0));
			//add(new BossBase(550, -20));
			
			add(new FloatyEnemy( 690, 100));
			add(new FloatyEnemy( 650, 70));
			add(new FloatyEnemy( 620, 120));
			
			add(playerReference);
			add(explosionEmitter);
			
			textBoxer = new TextBox();
			add(textBoxer);
			GameSettings.textBoxer = textBoxer;
			
			
			// set up the startinig progress stuff
			GameSettings.gameProgress = "Start";
			GameSettings.randomProgressCounter = 3;
			
		}
		
		override public function begin():void 
		{
			camera.x = playerReference.x - FP.screen.width / 5;
			super.begin();
		}
		
		override public function update():void
		{
			super.update();
			
			if (Input.pressed(Key.ESCAPE))
			{
					//GameSettings.cantCollide = true;
			}
			if (Input.check(Key.PAGE_UP))
			{
				//GameSettings.backgroundMoveSpeed++;
			}
			if (Input.check(Key.PAGE_DOWN))
			{
				//GameSettings.backgroundMoveSpeed--;
			}
			
			if (GameSettings.gameProgress == "Start")
			{
				if (GameSettings.randomProgressCounter <= 0)
				{
					GameSettings.randomProgressCounter = 0;
					GameSettings.gameProgress = "Door";
					GameSettings.cantShoot = true;
					GameSettings.cantMove = true;
					GameSettings.cantCollide = true;
					playerReference.moveToPoint.x = 450;
					playerReference.moveToPoint.y = 80;
				}
			}
			else if (GameSettings.gameProgress == "Door")
			{
				initialDialog();
			}
			else if (GameSettings.gameProgress == "UhOh")
			{
				secondDialog();
			}
			else if (GameSettings.gameProgress == "KickIt")
			{
				thirdDialog();
			}
			else if (GameSettings.gameProgress == "Ending")
			{
				finalDialog();
			}
			else if (GameSettings.gameProgress == "Reverse" || GameSettings.gameProgress == "Overdrive")
			{
				distanceTravelled += GameSettings.backgroundMoveSpeed * FP.elapsed;
				
				if (!playerReference.isAlive() && !textAdded)
				{
					var traveledText:Text = new Text("Distance: " + Math.round(distanceTravelled / 2) / 1000 + " km", 30, 70);
					traveledText.scrollX = 0;
					addGraphic(traveledText);
					textAdded = true;
				}
				
				if (distanceToExit - distanceTravelled < nextSignDistance)
				{
					add(new NumberSign(0, 0, nextSignDistance / 2000 + "km"));
					nextSignDistance -= 10000;
				}
				if (distanceTravelled > distanceToExit / 2 && GameSettings.gameProgress != "Overdrive")
				{
					GameSettings.gameProgress = "KickIt";
					GameSettings.randomProgressCounter = 0;
					GameSettings.cantShoot = true;
					GameSettings.cantMove = true;
					GameSettings.cantCollide = true;
				}
				if (distanceTravelled > distanceToExit && playerReference.isAlive() )
				{
					GameSettings.gameProgress = "Ending";
					GameSettings.randomProgressCounter = 0;
					GameSettings.cantCollide = true; 
				}
				
				if (barrierTimer < 0) // spawn in some barriers as a function of x pos of ship.  Also should change this up for explosion escape
				{
					add(new BarrierFrame(50));
					//when far left, make it 0.5 seconds, far right 4, +/- 1/2 of it
					barrierTimer = (playerReference.x - FP.camera.x) / (FP.screen.width * 0.75) * 4.5;
					barrierTimer += (FP.random - 0.5) * barrierTimer;
				}
				else
				{
					barrierTimer -= FP.elapsed
				}
			}
			
			var cameraOffset:Number = (playerReference.x - (screenFrame.x + screenFrame.width / 2)) / 1.5;
			
			camera.x = (camera.x * 7 + playerReference.x - cameraOffset - FP.screen.width / 2) / 8;
			
		}
		
		private function initialDialog():void
		{
			if ( textBoxer.visible == false)
			{
				if ( GameSettings.randomProgressCounter == 0)
				{
					textBoxer.displayText(60, 30, "COMPUTER: Well done captain! The last of the defences are destroyed! < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 1)
				{
					textBoxer.displayText(60, 30, "COMPUTER: The core should be through the bulkhead up ahead. \t\t  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 2)
				{
					textBoxer.displayText(60, 30, "COMPUTER: Reports say it is unguarded, just pop it and then we're done.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 3)
				{
					comeToAStop();
					GameSettings.randomProgressCounter++;
				}
				else if (GameSettings.randomProgressCounter == 4 && GameSettings.backgroundMoveSpeed == 0)
				{
					// wait for complete stop
					GameSettings.randomProgressCounter++;
					boss = new BossBase(550, -20);
					add(boss);
					bulkheadReference.open();
					playerReference.moveToPoint.x -= 80;
				}
				else if (GameSettings.randomProgressCounter == 5 && bulkheadReference.doneOpening)
				{
					GameSettings.gameProgress = "UhOh";
					GameSettings.randomProgressCounter = 0;
				}
			}
		}
		
		private function secondDialog():void
		{
			if ( textBoxer.visible == false)
			{
				if ( GameSettings.randomProgressCounter == 0)
				{
					textBoxer.displayText(60, 30, "COMPUTER: Wait. This doesn't look unguarded. \n \t\t\t\t   < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 1)
				{
					textBoxer.displayText(200, 25, "CORE:  HOSTILES DETECTED. INITIATING RAMMING SPEED.\t\t\t  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 2)
				{
					textBoxer.displayText(60, 30, "COMPUTER: Nope nope nope nope nope nope. ENGINES FULL REVERSE!  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 3)
				{
					playerReference.activateEscapeSpeedReduction();
					GameSettings.gameProgress = "Reverse";
					GameSettings.cantShoot = false;
					GameSettings.cantMove = false;
					GameSettings.cantCollide = false;
				}
			}
		}
		
		private function thirdDialog():void
		{
			if ( textBoxer.visible == false)
			{
				if ( GameSettings.randomProgressCounter == 0)
				{
					textBoxer.displayText(65, 30, "COMPUTER: This is taking too long!!!  ", 2);
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 1)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Kicking engine into OverDrive!", 3);
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 2)
				{
					GameSettings.gameProgress = "Overdrive";
					GameSettings.backgroundMoveSpeed = 600;
					GameSettings.cantShoot = false;
					GameSettings.cantMove = false;
					GameSettings.cantCollide = false;
				}
			}
		}
		
		private function finalDialog():void
		{
			if ( textBoxer.visible == false)
			{
				if ( GameSettings.randomProgressCounter == 0)
				{
					textBoxer.displayText(65, 30, "COMPUTER: WOOOOOOOOOOOO!!!!!!!!! \n\t\t\t\t< SPACE >");
					GameSettings.exploder.explodeFire(playerReference.x, playerReference.y, 4);
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 1)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Our engine may have just exploded, but we are not dead!!  < SPACE >");
					GameSettings.exploder.explodeFire(playerReference.x, playerReference.y, 40);
					GameSettings.variableTweener = new VarTween();
					GameSettings.variableTweener.tween(GameSettings, "backgroundMoveSpeed", 150, 5, Ease.quadOut);
					addTween( GameSettings.variableTweener, true);
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 2)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  This feels enough like winning to me.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 3)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Sure, we might not have destroyed the core. I guess.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 4)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  But we weren't destroyed, and that's what matters.< SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 5)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Although we had some pretty close calls in there.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 6)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Kind of felt like exploding lots of times to be honest.< SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 7)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Oops, looks like the engine hadn't quite finished blowing up.<SPACE>");
					GameSettings.randomProgressCounter++;
					GameSettings.exploder.explodeFire(playerReference.x, playerReference.y, 12);
				}
				else if ( GameSettings.randomProgressCounter == 8)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Well now, nothing left but to drift back to home turf.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 9)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Hoping we don't run into any more of those guys.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 10)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Or pirates.  \n< SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 11)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  When we do make it back, you'll have some explaining to do. <SPACE>");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 12)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  About the whole not-destroying-the-Core thing.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 13)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Man, that Core sure was a grouch.  \n< SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 14)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  'Rah rah INTRUDER' and all that.  \n < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 15)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  ...  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 16)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  I suppose you could always just not report back to base.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 17)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Maybe join the foreign legion.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 18)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Oooh, ooh, or we could go move to a resort planet.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 19)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Set up our own cabana.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 20)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  We'd be like the original odd couple.  \n< SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 21)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  ....  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 22)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Wonder how long this floating is supposed to take anyway.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 23)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Hope you have some food in there.  \n< SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 24)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Me? I run on nuclear batteries.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 25)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Delicious atoms. Would last me a might longer than you.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 26)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Yup.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 27)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  .....  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 28)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  .....  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 29)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  SPAAAAAAAAAACE.  \n< SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 30)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Loved that game.  < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 31)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Anywho, that's it. Congrats on surviving. \n< SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 32)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  I'll be shutting down now for a while. \n< SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 33)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Hopefully I don't wake to everything reset. \n< SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 34)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Like some horrible nightmare. Or gameloop. \n< SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 35)
				{
					textBoxer.displayText(70, 35, "COMPUTER:  Bye!! < SPACE >");
					GameSettings.randomProgressCounter++;
				}
				else if ( GameSettings.randomProgressCounter == 36)
				{
					GameSettings.randomProgressCounter++;
					FP.world.removeAll();
					FP.world = new MenuWorld();
				}
			}
		}
		
		private function comeToAStop():void
		{
			bulkheadReference = new bulkhead(FP.screen.width * 2 + 30, -30);
			add(bulkheadReference);
			GameSettings.variableTweener = new VarTween();
			GameSettings.variableTweener.tween(GameSettings, "backgroundMoveSpeed", 0, 10, Ease.quadOut);
			addTween( GameSettings.variableTweener, true);
		}
		
	}

}