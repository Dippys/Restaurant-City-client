package com.playfish.games.cooking.arcadegame.cave
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.arcadegame.ArcadeGame;
   import com.playfish.games.cooking.arcadegame.BitmapSprite;
   import com.playfish.games.cooking.ui.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class WorldArcadeCave extends ArcadeGame
   {
      
      private static var bubbleCreationFrequency:int;
      
      private static const STATE_SPLASH:int = 0;
      
      private static const STATE_READY:int = 1;
      
      private static const STATE_PLAY:int = 2;
      
      private static const STATE_GAMEOVER:int = 3;
      
      public static const WINDOW_WIDTH:int = 320;
      
      public static const WINDOW_HEIGHT:int = 240;
      
      private static const BITMAP_FONT_WIDTH:int = 7;
      
      private static const BITMAP_FONT_HEIGHT:int = 8;
      
      private static const BITMAP_SCOREBOARD_WIDTH:int = BITMAP_FONT_WIDTH * 10;
      
      private static const BITMAP_SCOREBOARD_HEIGHT:int = BITMAP_FONT_HEIGHT;
      
      private static const BITMAP_FISH_HEIGHT:int = 15;
      
      private static const BITMAP_FISH_WIDTH:int = 21;
      
      private static const BITMAP_FOOD_WIDTH:int = 16;
      
      private static const BITMAP_FOOD_HEIGHT:int = 16;
      
      private static const BITMAP_BUBBLES_WIDTH:int = 10;
      
      private static const BITMAP_BUBBLES_HEIGHT:int = 5;
      
      private static const BITMAP_SINGLE_BUBBLE_WIDTH:int = 5;
      
      private static const BITMAP_SINGLE_BUBBLE_HEIGHT:int = 5;
      
      private static const BITMAP_SPARK_WIDTH:int = 7;
      
      private static const BITMAP_SPARK_HEIGHT:int = 12;
      
      private static const BACKGROUND_Y_OFFSET:int = 40;
      
      private static const FOREGROUND_Y_OFFSET:int = 108;
      
      private static const GAME_WIDTH:int = WINDOW_WIDTH;
      
      private static const GAME_HEIGHT:int = WINDOW_HEIGHT;
      
      private static const HANG_TIME:int = 60;
      
      private static const POINTS_SWIM:int = 1;
      
      private static const BUBBLES_TRAIL:int = 0;
      
      private static const BUBBLES_RISE:int = 1;
      
      private static const BUBBLES_AQUARIA:int = 2;
      
      private static const BUBBLE_RISE_HEIGHT:int = 2;
      
      private static const BACKGROUND_STAGE_WIDTH:int = 400;
      
      private static const BACKGROUND_STAGE_HEIGHT:int = 240;
      
      private static const BACKGROUND_STAGE_X_OFFSET:int = (BACKGROUND_STAGE_WIDTH - WINDOW_WIDTH) / 2;
      
      private var backBuffer:BitmapData;
      
      private var gameOverImage:BitmapData;
      
      private var backBufferBitmap:Bitmap;
      
      private var blackBgImage:BitmapData;
      
      private var bubbleArray:Array;
      
      private var splashImage:BitmapData;
      
      private var mapDifficulty:int;
      
      private var bubblesImage:BitmapData;
      
      private var fishSprite:BitmapSprite;
      
      private var screenPositionX:int;
      
      private var screenPositionY:int;
      
      private var lastRightMostStripIndex:int;
      
      private var paintClickScreenCounter:int;
      
      private var blueBgImage:BitmapData;
      
      private var numberSprite:BitmapSprite;
      
      private var bubbleSprite:BitmapSprite;
      
      private var readyImage:BitmapData;
      
      private var mouseButtonDown:Boolean;
      
      private var sparkleSprite:BitmapSprite;
      
      private var caveBackgroundImage:BitmapData;
      
      private var hangTimeAnimate:int;
      
      private var caveMap2:CaveMap2;
      
      private var smallTrophyImage:BitmapData;
      
      private var caveForegroundImage:BitmapData;
      
      private var state:int = 2;
      
      private var score:int;
      
      private var hangTimeCounter:int;
      
      private var noClipping:Boolean = false;
      
      private var clickScreenImage:BitmapData;
      
      private var bubbleAnimationType:int;
      
      private var foodSprite:BitmapSprite;
      
      private var collisionMap:BitmapData;
      
      private var backgroundFishes:BackgroundFishes;
      
      private var foods:Array;
      
      private var playerFish:PlayerFish;
      
      private var sparkleArray:Array;
      
      private var foodScoreArray:Array;
      
      private var gameOver:Boolean;
      
      private var bubbleCreationCounter:int;
      
      public function WorldArcadeCave()
      {
         super();
         loadAssetBitmaps();
         mouseButtonDown = false;
         blackBgImage = new BitmapData(GAME_WIDTH,GAME_HEIGHT,false,0);
         blueBgImage = new BitmapData(GAME_WIDTH,GAME_HEIGHT,false,10218749);
         screenPositionX = screenPositionY = 0;
         foodScoreArray = [10,10,10,10,10];
         backBuffer = new BitmapData(WINDOW_WIDTH,WINDOW_HEIGHT);
         backBufferBitmap = new Bitmap();
         backBufferBitmap.bitmapData = backBuffer;
         backBufferBitmap.x = GAME_X;
         backBufferBitmap.y = GAME_Y;
         addChild(backBufferBitmap);
         collisionMap = new BitmapData(BITMAP_FISH_WIDTH * 2,BITMAP_FISH_HEIGHT * 2);
         addEventListener(MouseEvent.CLICK,handleMouseClick,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown,false,0,true);
         addEventListener(MouseEvent.MOUSE_UP,handleMouseUp,false,0,true);
         addEventListener(KeyboardEvent.KEY_DOWN,handleKeyDown,false,0,true);
         resetGame();
      }
      
      public static function scaleImageBitmap(param1:BitmapData, param2:int) : BitmapData
      {
         var _loc3_:BitmapData = null;
         _loc3_ = new BitmapData(param1.width * param2,param1.height * param2,true,0);
         _loc3_.draw(param1,new Matrix(2,0,0,2,0,0));
         return _loc3_;
      }
      
      private function loadAssetBitmaps() : void
      {
         var _loc1_:BitmapData = null;
         var _loc2_:BitmapData = null;
         splashImage = Engine.getBitmapData("CaveTitleBitmap");
         caveForegroundImage = Engine.getBitmapData("CaveForegroundBitmap");
         caveBackgroundImage = Engine.getBitmapData("CaveBackgroundBitmap");
         clickScreenImage = Engine.getBitmapData("CaveClickScreenBitmap");
         gameOverImage = Engine.getBitmapData("CaveGameOverBitmap");
         smallTrophyImage = Engine.getBitmapData("CaveSmallTrophyBitmap");
         bubblesImage = scaleImageBitmap(Engine.getBitmapData("CaveBubblesBitmap"),2);
         fishSprite = BitmapSprite.createFromBitmapSheet(scaleImageBitmap(Engine.getBitmapData("CaveFishBitmap"),2),BITMAP_FISH_WIDTH * 2,BITMAP_FISH_HEIGHT * 2);
         numberSprite = BitmapSprite.createFromBitmapSheet(scaleImageBitmap(Engine.getBitmapData("CaveNumbersBitmap"),2),BITMAP_FONT_WIDTH * 2,BITMAP_FONT_HEIGHT * 2);
         foodSprite = BitmapSprite.createFromBitmapSheet(scaleImageBitmap(Engine.getBitmapData("CaveFoodBitmap"),2),BITMAP_FOOD_WIDTH * 2,BITMAP_FOOD_HEIGHT * 2);
         bubbleSprite = BitmapSprite.createFromBitmapSheet(scaleImageBitmap(Engine.getBitmapData("CaveBubblesBitmap"),2),BITMAP_SINGLE_BUBBLE_WIDTH * 2,BITMAP_SINGLE_BUBBLE_HEIGHT * 2);
         sparkleSprite = BitmapSprite.createFromBitmapSheet(scaleImageBitmap(Engine.getBitmapData("CaveSparkleBitmap"),2),BITMAP_SPARK_WIDTH * 2,BITMAP_SPARK_HEIGHT * 2);
         backgroundFishes = new BackgroundFishes(3);
         playerFish = new PlayerFish();
      }
      
      public function handleMouseClick(param1:MouseEvent) : void
      {
         if(state == STATE_SPLASH)
         {
            state = STATE_PLAY;
         }
         if(state == STATE_GAMEOVER)
         {
            if(hangTimeCounter < 0)
            {
               resetGame();
            }
         }
      }
      
      private function ageSparkles() : void
      {
         var _loc1_:CaveSparkle = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < sparkleArray.length)
         {
            _loc1_ = sparkleArray[_loc3_];
            _loc1_.age();
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < sparkleArray.length)
         {
            _loc1_ = sparkleArray[_loc4_];
            if(!_loc1_.isDead())
            {
               _loc2_.push(_loc1_);
            }
            _loc4_++;
         }
         sparkleArray = _loc2_;
      }
      
      private function paintBackgroundOnBuffer(param1:BitmapData) : void
      {
         param1.draw(caveBackgroundImage,new Matrix(2,0,0,2,0,BACKGROUND_Y_OFFSET));
         param1.draw(caveForegroundImage,new Matrix(2,0,0,2,0,FOREGROUND_Y_OFFSET));
      }
      
      private function setBubbleCreationFrequency(param1:int) : void
      {
         switch(param1)
         {
            case BUBBLES_TRAIL:
               bubbleCreationFrequency = 3;
               break;
            case BUBBLES_RISE:
               bubbleCreationFrequency = 30;
               break;
            case BUBBLES_AQUARIA:
               bubbleCreationFrequency = 3;
         }
      }
      
      public function handleKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Engine.KEY_UP)
         {
            ++bubbleCreationFrequency;
         }
         else if(param1.keyCode == Engine.KEY_DOWN)
         {
            --bubbleCreationFrequency;
         }
      }
      
      private function paintBitmapNumbers(param1:BitmapData, param2:int, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:String = param2.toString();
         var _loc7_:int = Math.max(_loc6_.length,param3);
         var _loc8_:int = Math.max(_loc7_ - _loc6_.length);
         var _loc9_:int = param4;
         var _loc10_:int = 0;
         while(_loc10_ < _loc7_)
         {
            if(_loc10_ < _loc8_)
            {
               numberSprite.paint(param1,0,_loc9_,param5);
            }
            else
            {
               numberSprite.paint(param1,int(_loc6_.charAt(_loc10_ - _loc8_)),_loc9_,param5);
            }
            _loc9_ += numberSprite.frameWidth + 2;
            _loc10_++;
         }
      }
      
      private function paint() : void
      {
         if(state == STATE_SPLASH)
         {
            backBuffer.draw(blueBgImage);
            backgroundFishes.draw(backBuffer);
            paintBackgroundOnBuffer(backBuffer);
            backBuffer.draw(splashImage,new Matrix(2,0,0,2,0,0));
            if(paintClickScreenCounter < 5)
            {
               backBuffer.draw(clickScreenImage,new Matrix(2,0,0,2,(backBuffer.width - clickScreenImage.width * 2) / 2,180));
            }
         }
         else if(state == STATE_PLAY)
         {
            backBuffer.draw(blueBgImage);
            drawInfiniteScrollingBackground();
            fishSprite.paint(backBuffer,playerFish.getAnimationFrame(),playerFish.positionX - screenPositionX,playerFish.positionY);
            drawBubbles();
            caveMap2.paint(backBuffer,screenPositionX,0);
            paintVisibleIngredients();
            paintSparkles();
            paintBitmapNumbers(backBuffer,score,6,10,5);
            drawHangTimeCounter();
         }
         else if(state == STATE_GAMEOVER)
         {
            if(playerFish.dead)
            {
               backBuffer.draw(blueBgImage);
               drawInfiniteScrollingBackground();
               fishSprite.paint(backBuffer,3,playerFish.positionX - screenPositionX,playerFish.positionY);
               drawBubbles();
               caveMap2.paint(backBuffer,screenPositionX,0);
               paintVisibleIngredients();
               paintSparkles();
               paintBitmapNumbers(backBuffer,score,6,10,5);
               backBuffer.draw(gameOverImage,new Matrix(2,0,0,2,(backBuffer.width - gameOverImage.width * 2) / 2,(backBuffer.height - gameOverImage.height * 2) / 2));
            }
         }
      }
      
      override public function getHighScore(param1:GameUser) : int
      {
         return param1.awards.getValue(GameAwards.AWARD_ARCADE_CAVE_SCORE);
      }
      
      private function ageBubbles() : void
      {
         var _loc2_:CaveBubble = null;
         var _loc5_:int = 0;
         var _loc1_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < bubbleArray.length)
         {
            _loc2_ = bubbleArray[_loc3_];
            _loc2_.decreaseAge();
            if(bubbleAnimationType == BUBBLES_TRAIL)
            {
               _loc2_.decreaseOpacity();
            }
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < bubbleArray.length)
         {
            _loc2_ = bubbleArray[_loc4_];
            if(_loc2_.age > 0)
            {
               _loc1_.push(_loc2_);
            }
            _loc4_++;
         }
         if(bubbleAnimationType == BUBBLES_RISE)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc1_.length)
            {
               _loc2_ = _loc1_[_loc5_];
               _loc2_.positionY -= BUBBLE_RISE_HEIGHT;
               _loc2_.positionX += Engine.rnd(0,4);
               _loc5_++;
            }
         }
         bubbleArray = _loc1_;
      }
      
      private function drawInfiniteScrollingBackground() : void
      {
         var _loc1_:Number = -screenPositionX / 10;
         while(_loc1_ < WINDOW_WIDTH)
         {
            backBuffer.draw(caveBackgroundImage,new Matrix(2,0,0,2,_loc1_,BACKGROUND_Y_OFFSET));
            _loc1_ += caveBackgroundImage.width;
         }
         _loc1_ = -screenPositionX / 3;
         while(_loc1_ < WINDOW_WIDTH)
         {
            backBuffer.draw(caveForegroundImage,new Matrix(2,0,0,2,_loc1_,FOREGROUND_Y_OFFSET));
            _loc1_ += caveBackgroundImage.width;
         }
      }
      
      public function createFood(param1:Number, param2:Number) : void
      {
         var _loc3_:CaveFood = new CaveFood(foodSprite,Engine.rnd(0,foodSprite.frameBitmaps.length));
         _loc3_.x = param1;
         _loc3_.y = param2;
         foods.push(_loc3_);
      }
      
      private function drawBubbles() : void
      {
         var _loc1_:CaveBubble = null;
         var _loc2_:int = 0;
         while(_loc2_ < bubbleArray.length)
         {
            _loc1_ = bubbleArray[_loc2_];
            backBuffer.draw(_loc1_.getBitmap(),new Matrix(1,0,0,1,_loc1_.positionX - screenPositionX,_loc1_.positionY),new ColorTransform(1,1,1,_loc1_.opacity));
            _loc2_++;
         }
      }
      
      private function caveGameOver() : void
      {
         playerFish.dead = true;
         state = STATE_GAMEOVER;
         setNewPlayerScore(score);
      }
      
      private function paintSparkles() : void
      {
         var _loc1_:CaveSparkle = null;
         var _loc2_:BitmapSprite = null;
         var _loc3_:int = 0;
         while(_loc3_ < sparkleArray.length)
         {
            _loc1_ = sparkleArray[_loc3_];
            sparkleSprite.paint(backBuffer,_loc1_.getFrame(),_loc1_.positionX - screenPositionX,_loc1_.positionY);
            _loc3_++;
         }
      }
      
      public function handleMouseDown(param1:MouseEvent) : void
      {
         mouseButtonDown = true;
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:String = null;
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         var _loc5_:CaveFood = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(state == STATE_SPLASH)
         {
            paintClickScreenCounter = (paintClickScreenCounter + 1) % 10;
         }
         updateObjectPositions();
         if(state == STATE_PLAY)
         {
            while(foods.length > 0)
            {
               _loc5_ = foods[0];
               if(_loc5_.x + _loc5_.bitmapSprite.frameWidth >= screenPositionX)
               {
                  break;
               }
               foods.splice(0,1);
            }
            _loc3_ = int(foods.length - 1);
            while(_loc3_ >= 0)
            {
               _loc5_ = foods[_loc3_];
               if(_loc5_.x < playerFish.positionX + fishSprite.frameWidth)
               {
                  if(BitmapSprite.isColliding(playerFish.positionX,playerFish.positionY,fishSprite.frameWidth,fishSprite.frameHeight,_loc5_.x,_loc5_.y,_loc5_.bitmapSprite.frameWidth,_loc5_.bitmapSprite.frameHeight))
                  {
                     sparkleArray.push(new CaveSparkle(_loc5_.x,_loc5_.y));
                     addToScore(10);
                     foods.splice(_loc3_,1);
                  }
               }
               _loc3_--;
            }
            _loc4_ = Math.floor((playerFish.positionX + GAME_WIDTH) / CaveMap2.STRIP_WIDTH);
            if(_loc4_ > lastRightMostStripIndex)
            {
               if(hangTimeCounter == 0)
               {
                  if(_loc4_ % 4 == 0 && Engine.rnd(0,2) == 0)
                  {
                     _loc6_ = Number(caveMap2.topStripsY[_loc4_]);
                     _loc7_ = Number(caveMap2.bottomStripsY[_loc4_]);
                     createFood(_loc4_ * CaveMap2.STRIP_WIDTH,Math.max(0,Math.min(WorldArcadeCave.WINDOW_HEIGHT - 30,Engine.rnd(_loc6_ + 30,_loc7_ - 30))));
                  }
               }
               lastRightMostStripIndex = _loc4_;
            }
         }
         paint();
      }
      
      private function drawHangTimeCounter() : void
      {
         if(hangTimeCounter >= 10)
         {
            numberSprite.paint(backBuffer,1 + hangTimeCounter / 20,(backBuffer.width - BITMAP_FONT_WIDTH * 2) / 2,(backBuffer.height - BITMAP_FONT_HEIGHT * 2) / 2);
         }
      }
      
      override public function setHighScore(param1:int) : void
      {
         GameWorld.gameUser.awards.setValue(GameAwards.AWARD_ARCADE_CAVE_SCORE,param1);
      }
      
      private function createNewBubbles() : void
      {
         var _loc1_:CaveBubble = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(bubbleAnimationType == BUBBLES_AQUARIA)
         {
            bubbleCreationCounter = (bubbleCreationCounter + 1) % bubbleCreationFrequency;
            if(!bubbleCreationCounter && !Engine.rnd(0,2))
            {
               _loc2_ = playerFish.positionX - BITMAP_BUBBLES_WIDTH;
               _loc3_ = playerFish.positionY + BITMAP_FISH_HEIGHT + Engine.rnd(-10,10);
               _loc1_ = new CaveBubble(_loc2_,_loc3_,bubbleSprite);
               bubbleArray.push(_loc1_);
            }
         }
         else if((bubbleCreationCounter = (bubbleCreationCounter + 1) % bubbleCreationFrequency) == 0 && !Engine.rnd(0,5))
         {
            _loc4_ = Engine.rnd(1,4);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(bubbleAnimationType == BUBBLES_RISE)
               {
                  _loc2_ = playerFish.positionX + BITMAP_BUBBLES_WIDTH * 2 + Engine.rnd(-10,10);
                  _loc3_ = playerFish.positionY + Engine.rnd(-10,10);
               }
               else if(bubbleAnimationType == BUBBLES_TRAIL)
               {
                  _loc2_ = playerFish.positionX;
                  _loc3_ = playerFish.positionY;
               }
               _loc1_ = new CaveBubble(_loc2_,_loc3_,bubbleSprite);
               bubbleArray.push(_loc1_);
               _loc5_++;
            }
         }
      }
      
      public function handleMouseUp(param1:MouseEvent) : void
      {
         mouseButtonDown = false;
         if(state == STATE_PLAY)
         {
         }
      }
      
      private function resetGame() : void
      {
         paintClickScreenCounter = 0;
         score = 0;
         bubbleArray = new Array();
         sparkleArray = new Array();
         bubbleCreationCounter = 0;
         bubbleAnimationType = BUBBLES_AQUARIA;
         setBubbleCreationFrequency(bubbleAnimationType);
         playerFish.resetPosition();
         playerFish.resetVelocity();
         playerFish.dead = false;
         screenPositionX = screenPositionY = 0;
         hangTimeCounter = HANG_TIME;
         state = STATE_SPLASH;
         foods = new Array();
         lastRightMostStripIndex = 0;
         caveMap2 = new CaveMap2(this);
         disableShareButton();
      }
      
      private function updateObjectPositions() : void
      {
         if(state == STATE_PLAY)
         {
            if(hangTimeCounter == 0)
            {
               playerFish.swimForward();
               addToScore(POINTS_SWIM);
               playerFish.drop();
               playerFish.updateFishPosition();
               if(mouseButtonDown)
               {
                  playerFish.thrust();
               }
            }
            else
            {
               playerFish.swimForward();
               --hangTimeCounter;
            }
            ageBubbles();
            ageSparkles();
            createNewBubbles();
         }
         else if(state == STATE_GAMEOVER)
         {
            --hangTimeCounter;
         }
         screenPositionX = playerFish.positionX - WorldArcadeCave.WINDOW_WIDTH / 8;
         caveMap2.checkAndCreateStrips(screenPositionX);
         if(state == STATE_PLAY)
         {
            if(!noClipping && checkCollisionBetweenFishAndBackground())
            {
               caveGameOver();
               hangTimeCounter = HANG_TIME / 2;
            }
         }
      }
      
      private function checkPlayerFoodCollision() : void
      {
      }
      
      private function paintVisibleIngredients() : void
      {
         var _loc2_:CaveFood = null;
         var _loc1_:int = 0;
         while(_loc1_ < foods.length)
         {
            _loc2_ = foods[_loc1_];
            if(_loc2_.x < screenPositionX + WINDOW_WIDTH)
            {
               _loc2_.bitmapSprite.paint(backBuffer,_loc2_.foodFrame,_loc2_.x - screenPositionX,_loc2_.y - screenPositionY);
            }
            _loc1_++;
         }
      }
      
      private function checkCollisionBetweenFishAndBackground() : Boolean
      {
         if(playerFish.positionY < -5 || playerFish.positionY + fishSprite.frameHeight > GAME_HEIGHT + 5)
         {
            return true;
         }
         collisionMap.fillRect(new Rectangle(0,0,collisionMap.width,collisionMap.height),0);
         caveMap2.paint(collisionMap,playerFish.positionX,playerFish.positionY,-5);
         var _loc1_:ByteArray = collisionMap.getPixels(new Rectangle(0,0,collisionMap.width,collisionMap.height));
         var _loc2_:ByteArray = fishSprite.getBitmapDataForFrame(fishSprite.frame).getPixels(new Rectangle(0,0,BITMAP_FISH_WIDTH * 2,BITMAP_FISH_HEIGHT * 2));
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(_loc2_[_loc3_] > 0 && _loc1_[_loc3_] > 0)
            {
               hangTimeCounter = HANG_TIME / 2;
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function paintFood(param1:int, param2:int, param3:int) : void
      {
         foodSprite.paint(backBuffer,param1,param2 - screenPositionX,param3 - screenPositionY);
      }
      
      public function addToScore(param1:int) : void
      {
         score += param1;
      }
   }
}

