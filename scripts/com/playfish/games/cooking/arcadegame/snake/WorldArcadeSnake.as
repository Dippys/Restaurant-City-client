package com.playfish.games.cooking.arcadegame.snake
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.arcadegame.*;
   import com.playfish.games.cooking.ui.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   
   public class WorldArcadeSnake extends ArcadeGame
   {
      
      private static const LEVEL_MAP:Array = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,4,0,0,0,0,0,0
      ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,1,3,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,1,3,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,5,5,3,0,0,0,0,0,0,1,5,5,8,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,10,5,5,3,0,0,0,0,0,0,1,5,5,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,7,0,0,0,0,7,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,4,0,0,0,4,0,0,0,0,4,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,7,0,0,0,0,7,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]];
      
      private static const STATE_SPLASH:int = 0;
      
      private static const STATE_READY:int = 1;
      
      private static const STATE_PLAY:int = 2;
      
      private static const STATE_GAMEOVER:int = 3;
      
      private static const LEVEL_THRESHOLD:int = 100;
      
      private static const FOOD_SCORE:int = 10;
      
      private static const MAX_FOOD_COUNT:int = 8;
      
      private static const DEFAULT_SNAKE_MOVE_DELAY:int = 200;
      
      private static const MIN_SNAKE_MOVE_DELAY:int = 50;
      
      private static const SNAKE_MOVE_DELAY_DECREASE:int = 10;
      
      private static const NUM_TILES_X:int = 20;
      
      private static const NUM_TILES_Y:int = 14;
      
      private static const TILE_WIDTH:int = 16;
      
      private static const TILE_HEIGHT:int = 16;
      
      private static const MAP_WIDTH:int = NUM_TILES_X * TILE_WIDTH;
      
      private static const MAP_HEIGHT:int = NUM_TILES_Y * TILE_HEIGHT;
      
      private static const HUD_HEIGHT:int = 16;
      
      private static const BITMAP_FONT_WIDTH:int = 12;
      
      private static const BITMAP_FONT_HEIGHT:int = 10;
      
      private static const TILE_EMPTY:int = 0;
      
      private static const TILE_BLOCK:int = 1;
      
      private static const TILE_FOOD:int = 2;
      
      private static const DEFAULT_SNAKE_LENGTH:int = 4;
      
      private var foodBlocks:Array;
      
      private var backBuffer:BitmapData;
      
      private var insertCoinImage:BitmapData;
      
      private var score:int;
      
      private var snakeMoveTimer:int;
      
      private var gameOverImage:BitmapData;
      
      private var backBufferBitmap:Bitmap;
      
      private var state:int = 2;
      
      private var bgImage:BitmapData;
      
      private var prevSnakeSpeedX:int = 0;
      
      private var prevSnakeSpeedY:int = 0;
      
      private var borderSprite:BitmapSprite;
      
      private var curLevel:int = 0;
      
      private var snakeSprite:BitmapSprite;
      
      private var splashImage:BitmapData;
      
      private var foodSprite:BitmapSprite;
      
      private var tileMap:Array;
      
      private var snakeSpeedX:int = 1;
      
      private var snakeMoveDelay:int = 200;
      
      private var foodCount:int = 1;
      
      private var snakeSpeedY:int = 0;
      
      private var mapImage:BitmapData;
      
      private var snakeBlocks:Array;
      
      private var numberSprite:BitmapSprite;
      
      private var paintInsertCoinCounter:int;
      
      private var readyImage:BitmapData;
      
      public function WorldArcadeSnake()
      {
         var _loc2_:int = 0;
         super();
         splashImage = Engine.getBitmapData("SnakeSplashBitmap");
         bgImage = Engine.getBitmapData("BgBitmap");
         insertCoinImage = Engine.getBitmapData("InsertCoinBitmap");
         readyImage = Engine.getBitmapData("ReadyBitmap");
         gameOverImage = Engine.getBitmapData("GameOverBitmap");
         snakeSprite = BitmapSprite.createFromBitmapSheet(Engine.getBitmapData("SnakeBitmap"),TILE_WIDTH,TILE_HEIGHT);
         numberSprite = BitmapSprite.createFromBitmapSheet(Engine.getBitmapData("NumberBitmap"),BITMAP_FONT_WIDTH,BITMAP_FONT_HEIGHT);
         foodSprite = BitmapSprite.createFromBitmapSheet(Engine.getBitmapData("FoodBitmap"),TILE_WIDTH,TILE_HEIGHT);
         borderSprite = BitmapSprite.createFromBitmapSheet(Engine.getBitmapData("BorderBitmap"),TILE_WIDTH,TILE_HEIGHT);
         mapImage = new BitmapData(bgImage.width,bgImage.height);
         backBuffer = new BitmapData(bgImage.width,bgImage.height);
         backBufferBitmap = new Bitmap();
         backBufferBitmap.bitmapData = backBuffer;
         backBufferBitmap.x = GAME_X;
         backBufferBitmap.y = GAME_Y;
         addChild(backBufferBitmap);
         tileMap = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < NUM_TILES_X)
         {
            tileMap[_loc1_] = new Array();
            _loc2_ = 0;
            while(_loc2_ < NUM_TILES_Y)
            {
               tileMap[_loc1_][_loc2_] = TILE_EMPTY;
               _loc2_++;
            }
            _loc1_++;
         }
         addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,0,true);
         resetGame();
         state = STATE_SPLASH;
      }
      
      private function paintSnake(param1:BitmapData) : void
      {
         var _loc2_:SnakeBlock = snakeBlocks[0];
         var _loc3_:SnakeBlock = snakeBlocks[snakeBlocks.length - 1];
         var _loc4_:int = 1;
         while(_loc4_ < snakeBlocks.length - 1)
         {
            if((snakeBlocks[_loc4_].tileX != _loc2_.tileX || snakeBlocks[_loc4_].tileY != _loc2_.tileY) && (snakeBlocks[_loc4_].tileX != _loc3_.tileX || snakeBlocks[_loc4_].tileY != _loc3_.tileY))
            {
               snakeSprite.paint(param1,snakeBlocks[_loc4_].frame,snakeBlocks[_loc4_].tileX * TILE_WIDTH,snakeBlocks[_loc4_].tileY * TILE_HEIGHT + HUD_HEIGHT,snakeBlocks[_loc4_].rotation);
            }
            _loc4_++;
         }
         if(_loc3_.tileX != _loc2_.tileX || _loc3_.tileY != _loc2_.tileY)
         {
            snakeSprite.paint(param1,4,_loc3_.tileX * TILE_WIDTH,_loc3_.tileY * TILE_HEIGHT + HUD_HEIGHT,_loc3_.rotation);
         }
         var _loc5_:int = _loc2_.tileX * TILE_WIDTH;
         var _loc6_:int = _loc2_.tileY * TILE_HEIGHT + HUD_HEIGHT;
         snakeSprite.paint(param1,1,_loc5_,_loc6_,_loc2_.rotation);
         if(snakeSpeedX > 0)
         {
            snakeSprite.paint(param1,0,_loc5_ + TILE_WIDTH,_loc6_,_loc2_.rotation);
         }
         else if(snakeSpeedX < 0)
         {
            snakeSprite.paint(param1,0,_loc5_ - TILE_WIDTH,_loc6_,_loc2_.rotation);
         }
         else if(snakeSpeedY > 0)
         {
            snakeSprite.paint(param1,0,_loc5_,_loc6_ + TILE_HEIGHT,_loc2_.rotation);
         }
         else if(snakeSpeedY < 0)
         {
            snakeSprite.paint(param1,0,_loc5_,_loc6_ - TILE_HEIGHT,_loc2_.rotation);
         }
      }
      
      private function getDirectionForSnakeBlock(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:SnakeBlock = snakeBlocks[param1];
         var _loc4_:int = param1 - 1;
         var _loc5_:SnakeBlock = snakeBlocks[param1 - 1];
         if(_loc5_)
         {
            _loc2_ |= getDirection(_loc3_.tileX,_loc3_.tileY,_loc5_.tileX,_loc5_.tileY);
         }
         var _loc6_:SnakeBlock = snakeBlocks[param1 + 1];
         if(_loc6_)
         {
            _loc2_ |= getDirection(_loc3_.tileX,_loc3_.tileY,_loc6_.tileX,_loc6_.tileY);
         }
         return _loc2_;
      }
      
      private function loadMap(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < NUM_TILES_X)
         {
            _loc4_ = 0;
            while(_loc4_ < NUM_TILES_Y)
            {
               tileMap[_loc2_][_loc4_] = TILE_EMPTY;
               _loc4_++;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < NUM_TILES_X)
         {
            tileMap[_loc2_][0] = TILE_BLOCK;
            tileMap[_loc2_][NUM_TILES_Y - 1] = TILE_BLOCK;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < NUM_TILES_Y)
         {
            tileMap[0][_loc2_] = TILE_BLOCK;
            tileMap[NUM_TILES_X - 1][_loc2_] = TILE_BLOCK;
            _loc2_++;
         }
         snakeBlocks = new Array();
         _loc2_ = 0;
         while(_loc2_ < DEFAULT_SNAKE_LENGTH)
         {
            snakeBlocks[_loc2_] = new SnakeBlock();
            snakeBlocks[_loc2_].tileX = NUM_TILES_X / 2;
            snakeBlocks[_loc2_].tileY = NUM_TILES_Y - 2;
            tileMap[snakeBlocks[_loc2_].tileX][snakeBlocks[_loc2_].tileY] = TILE_BLOCK;
            _loc2_++;
         }
         snakeBlocks[0].setDirection(SnakeBlock.LEFT);
         snakeSpeedX = 1;
         snakeSpeedY = 0;
         mapImage.draw(bgImage);
         var _loc3_:Array = LEVEL_MAP[param1];
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            if(_loc3_[_loc2_] != 0)
            {
               _loc5_ = _loc2_ % NUM_TILES_X;
               _loc6_ = Math.floor(_loc2_ / NUM_TILES_X);
               borderSprite.paint(mapImage,_loc3_[_loc2_] - 1,_loc5_ * TILE_WIDTH,_loc6_ * TILE_HEIGHT + HUD_HEIGHT,0);
               tileMap[_loc5_][_loc6_] = TILE_BLOCK;
            }
            _loc2_++;
         }
         foodBlocks = new Array();
         createFoods();
      }
      
      override public function tick(param1:uint) : void
      {
         if(Debug.DEBUG)
         {
            if(Engine.isKeyPressed(Engine.KEY_SPACE))
            {
               levelUp();
               paint();
               return;
            }
         }
         if(state == STATE_SPLASH)
         {
            paintInsertCoinCounter = (paintInsertCoinCounter + 1) % 10;
            if(Engine.anyKey())
            {
               snakeMoveTimer = 1000;
               state = STATE_READY;
            }
            paint();
         }
         else if(state == STATE_READY)
         {
            snakeMoveTimer -= param1;
            if(snakeMoveTimer <= 0)
            {
               state = STATE_PLAY;
               paint();
            }
         }
         else if(state == STATE_PLAY)
         {
            if(prevSnakeSpeedY == 0)
            {
               if(Engine.isKeyPressed(Engine.KEY_UP))
               {
                  snakeSpeedX = 0;
                  snakeSpeedY = -1;
               }
               else if(Engine.isKeyPressed(Engine.KEY_DOWN))
               {
                  snakeSpeedX = 0;
                  snakeSpeedY = 1;
               }
            }
            if(prevSnakeSpeedX == 0)
            {
               if(Engine.isKeyPressed(Engine.KEY_LEFT))
               {
                  snakeSpeedX = -1;
                  snakeSpeedY = 0;
               }
               else if(Engine.isKeyPressed(Engine.KEY_RIGHT))
               {
                  snakeSpeedX = 1;
                  snakeSpeedY = 0;
               }
            }
            snakeMoveTimer -= param1;
            if(snakeMoveTimer <= 0)
            {
               moveSnake(snakeSpeedX,snakeSpeedY);
               if(state == STATE_PLAY)
               {
                  snakeMoveTimer = snakeMoveDelay;
               }
               paint();
            }
         }
         else if(state == STATE_GAMEOVER)
         {
            snakeMoveTimer -= param1;
            if(snakeMoveTimer <= 0)
            {
               if(Engine.anyKey())
               {
                  resetGame();
                  state = STATE_SPLASH;
               }
            }
         }
      }
      
      private function createFoods() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:FoodBlock = null;
         if(foodCount > foodBlocks.length)
         {
            _loc1_ = new Array();
            _loc2_ = new Array();
            _loc3_ = 0;
            while(_loc3_ < NUM_TILES_X)
            {
               _loc5_ = 0;
               while(_loc5_ < NUM_TILES_Y)
               {
                  if(tileMap[_loc3_][_loc5_] == TILE_EMPTY)
                  {
                     _loc1_.push(_loc3_);
                     _loc2_.push(_loc5_);
                  }
                  _loc5_++;
               }
               _loc3_++;
            }
            _loc4_ = foodCount - foodBlocks.length;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(_loc1_.length <= 0)
               {
                  break;
               }
               _loc6_ = Engine.rnd(0,_loc1_.length);
               _loc7_ = int(_loc1_[_loc6_]);
               _loc8_ = int(_loc2_[_loc6_]);
               _loc1_.splice(_loc6_,1);
               _loc2_.splice(_loc6_,1);
               tileMap[_loc7_][_loc8_] = TILE_FOOD;
               _loc9_ = new FoodBlock();
               _loc9_.frame = Engine.rnd(0,foodSprite.frameBitmaps.length);
               _loc9_.tileX = _loc7_;
               _loc9_.tileY = _loc8_;
               foodBlocks.push(_loc9_);
               _loc3_++;
            }
         }
      }
      
      private function levelUp() : void
      {
         snakeMoveDelay = Math.max(snakeMoveDelay - SNAKE_MOVE_DELAY_DECREASE,MIN_SNAKE_MOVE_DELAY);
         foodCount = Math.min(foodCount + 1,MAX_FOOD_COUNT);
         ++curLevel;
         loadMap(curLevel % LEVEL_MAP.length);
         snakeMoveTimer = 1000;
         state = STATE_READY;
      }
      
      private function getDirection(param1:int, param2:int, param3:int, param4:int) : int
      {
         var _loc5_:int = 0;
         if(param3 < param1)
         {
            _loc5_ |= SnakeBlock.LEFT;
         }
         else if(param3 > param1)
         {
            _loc5_ |= SnakeBlock.RIGHT;
         }
         if(param4 < param2)
         {
            _loc5_ |= SnakeBlock.UP;
         }
         else if(param4 > param2)
         {
            _loc5_ |= SnakeBlock.DOWN;
         }
         return _loc5_;
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         if(state == STATE_GAMEOVER)
         {
            resetGame();
            state = STATE_SPLASH;
         }
      }
      
      override public function setHighScore(param1:int) : void
      {
         GameWorld.gameUser.awards.setValue(GameAwards.AWARD_ARCADE_SNAKE_SCORE,param1);
      }
      
      override public function getHighScore(param1:GameUser) : int
      {
         return param1.awards.getValue(GameAwards.AWARD_ARCADE_SNAKE_SCORE);
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
         var _loc1_:int = 0;
         if(state == STATE_SPLASH)
         {
            backBuffer.draw(splashImage);
            if(paintInsertCoinCounter < 5)
            {
               backBuffer.draw(insertCoinImage,new Matrix(1,0,0,1,(backBuffer.width - insertCoinImage.width) / 2,150));
            }
         }
         else
         {
            backBuffer.draw(mapImage);
            paintBitmapNumbers(backBuffer,score,6,230,7);
            paintSnake(backBuffer);
            _loc1_ = 0;
            while(_loc1_ < foodBlocks.length)
            {
               foodSprite.paint(backBuffer,foodBlocks[_loc1_].frame,foodBlocks[_loc1_].tileX * TILE_WIDTH,foodBlocks[_loc1_].tileY * TILE_HEIGHT + HUD_HEIGHT);
               _loc1_++;
            }
            if(state == STATE_GAMEOVER)
            {
               backBuffer.draw(gameOverImage,new Matrix(1,0,0,1,(mapImage.width - gameOverImage.width) / 2,(mapImage.height - gameOverImage.height) / 2 + HUD_HEIGHT));
            }
            else if(state == STATE_READY)
            {
               backBuffer.draw(readyImage,new Matrix(1,0,0,1,(mapImage.width - readyImage.width) / 2,(mapImage.height - readyImage.height) / 2 + HUD_HEIGHT));
            }
         }
      }
      
      private function resetGame() : void
      {
         paintInsertCoinCounter = 0;
         curLevel = 0;
         score = 0;
         foodCount = 1;
         snakeMoveDelay = DEFAULT_SNAKE_MOVE_DELAY;
         loadMap(0);
         disableShareButton();
         Engine.resetKeys();
      }
      
      private function paintFood(param1:BitmapData) : void
      {
         foodSprite.paint(param1,foodSprite.frame,foodSprite.x,foodSprite.y + HUD_HEIGHT);
      }
      
      private function addScore(param1:int) : void
      {
         var _loc2_:int = score;
         score += param1;
         var _loc3_:int = getScoreThreshold(curLevel + 1);
         if(_loc2_ < _loc3_ && score >= _loc3_)
         {
            levelUp();
         }
      }
      
      private function getScoreThreshold(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1)
         {
            _loc2_ = Math.min(_loc2_ + 50,400);
            _loc3_ += _loc2_;
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function moveSnake(param1:int, param2:int) : void
      {
         var _loc6_:SnakeBlock = null;
         var _loc7_:SnakeBlock = null;
         var _loc8_:int = 0;
         var _loc9_:SnakeBlock = null;
         var _loc10_:SnakeBlock = null;
         var _loc3_:* = int(snakeBlocks.length - 1);
         while(_loc3_ >= 0)
         {
            _loc6_ = snakeBlocks[_loc3_];
            tileMap[_loc6_.tileX][_loc6_.tileY] = TILE_EMPTY;
            _loc3_--;
         }
         _loc3_ = int(snakeBlocks.length - 1);
         while(_loc3_ > 0)
         {
            _loc7_ = snakeBlocks[_loc3_ - 1];
            snakeBlocks[_loc3_].tileX = _loc7_.tileX;
            snakeBlocks[_loc3_].tileY = _loc7_.tileY;
            _loc3_--;
         }
         snakeBlocks[0].tileX += param1;
         snakeBlocks[0].tileY += param2;
         _loc3_ = int(snakeBlocks.length - 1);
         while(_loc3_ > 0)
         {
            tileMap[snakeBlocks[_loc3_].tileX][snakeBlocks[_loc3_].tileY] = TILE_BLOCK;
            _loc3_--;
         }
         _loc3_ = 0;
         while(_loc3_ < snakeBlocks.length)
         {
            _loc8_ = getDirectionForSnakeBlock(_loc3_);
            if(_loc8_ != 0)
            {
               snakeBlocks[_loc3_].setDirection(_loc8_);
            }
            _loc3_++;
         }
         var _loc4_:int = int(snakeBlocks[0].tileX);
         var _loc5_:int = int(snakeBlocks[0].tileY);
         switch(tileMap[_loc4_][_loc5_])
         {
            case TILE_FOOD:
               _loc9_ = new SnakeBlock();
               _loc10_ = snakeBlocks[snakeBlocks.length - 1];
               _loc9_.tileX = _loc10_.tileX;
               _loc9_.tileY = _loc10_.tileY;
               _loc9_.setDirection(_loc10_.direction);
               snakeBlocks.push(_loc9_);
               _loc3_ = 0;
               while(_loc3_ < foodBlocks.length)
               {
                  if(foodBlocks[_loc3_].tileX == _loc4_ && foodBlocks[_loc3_].tileY == _loc5_)
                  {
                     foodBlocks.splice(_loc3_,1);
                     break;
                  }
                  _loc3_++;
               }
               addScore(FOOD_SCORE);
               createFoods();
               break;
            case TILE_BLOCK:
               snakeMoveTimer = 1000;
               setNewPlayerScore(score);
               state = STATE_GAMEOVER;
               Engine.resetKeys();
         }
         prevSnakeSpeedX = param1;
         prevSnakeSpeedY = param2;
      }
   }
}

