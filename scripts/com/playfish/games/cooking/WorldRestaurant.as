package com.playfish.games.cooking
{
   import com.playfish.games.cooking.actors.Billboard;
   import com.playfish.games.cooking.actors.GardenPlotActor;
   import com.playfish.games.cooking.events.*;
   import com.playfish.games.cooking.extension.restaurant.OutsideArea;
   import com.playfish.games.cooking.extension.restaurant.RestaurantExtensionBase;
   import com.playfish.games.cooking.ui.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.*;
   
   public class WorldRestaurant extends BaseWorld
   {
      
      public static const DEFAULT_RESTAURANT_ITEMS:Array = [{
         "name":"Stove",
         "id":3070000,
         "tileX":6,
         "tileY":2,
         "rotation":3
      },{
         "name":"Simple Door",
         "id":3010000,
         "tileX":0,
         "tileY":4,
         "rotation":0
      },{
         "name":"Basic Window",
         "id":3000011,
         "tileX":0,
         "tileY":2,
         "rotation":0
      },{
         "name":"Basic Window",
         "id":3000011,
         "tileX":0,
         "tileY":6,
         "rotation":0
      },{
         "name":"Classic Chair",
         "id":3040001,
         "tileX":2,
         "tileY":3,
         "rotation":0
      },{
         "name":"Classic Chair",
         "id":3040001,
         "tileX":2,
         "tileY":5,
         "rotation":0
      },{
         "name":"Classic Chair",
         "id":3040001,
         "tileX":5,
         "tileY":5,
         "rotation":0
      },{
         "name":"White Cloth Table",
         "id":3030010,
         "tileX":3,
         "tileY":3,
         "rotation":0
      },{
         "name":"White Cloth Table",
         "id":3030010,
         "tileX":3,
         "tileY":5,
         "rotation":0
      },{
         "name":"White Cloth Table",
         "id":3030010,
         "tileX":6,
         "tileY":5,
         "rotation":0
      },{
         "name":"Neutral Blue",
         "id":3060016,
         "tileX":0,
         "tileY":1,
         "rotation":0
      },{
         "name":"Neutral Blue",
         "id":3060016,
         "tileX":1,
         "tileY":0,
         "rotation":0
      },{
         "name":"Achievement Panel",
         "id":3200000,
         "tileX":2,
         "tileY":0,
         "rotation":1
      },{
         "name":"Letter Box",
         "id":3300000,
         "tileX":1,
         "tileY":7,
         "rotation":0
      },{
         "name":"Menu Holder",
         "id":3100000,
         "tileX":4,
         "tileY":0,
         "rotation":1
      },{
         "name":"DelicateBush",
         "id":3020003,
         "tileX":1,
         "tileY":1,
         "rotation":0
      },{
         "name":"DelicateBush",
         "id":3020003,
         "tileX":7,
         "tileY":1,
         "rotation":0
      },{
         "name":"DelicateBush",
         "id":3020003,
         "tileX":7,
         "tileY":7,
         "rotation":0
      }];
      
      public static const MAX_NUM_TILES_X:int = 20;
      
      public static const MAX_NUM_TILES_Y:int = 40;
      
      public static const SHADOW_DRAW_PRIORITY:int = -1000000;
      
      public static const FLOOR_DRAW_PRIORITY:int = -1000002;
      
      public static const SCORE_POPUP_PRIORITY:int = 1000000;
      
      public static const GARDEN_TILE_X:int = 3;
      
      public static const GARDEN_TILE_Y:int = -9;
      
      public static const ROOM_INDEX_MAIN:int = 0;
      
      public static const ROOM_INDEX_OUTSIDE_AREA:int = 1;
      
      public static const RESTAURANT_BOUND:Object = {
         "top":-550,
         "bottom":1200,
         "left":-1450,
         "right":1100
      };
      
      public static const MAX_RESTAURANT_BOUND:Object = {
         "top":-750,
         "bottom":1400,
         "left":-1650,
         "right":1300
      };
      
      public static var ratio:int = 2;
      
      public static var tileWidth:int = 80;
      
      public static var tileHeight:int = tileWidth / ratio;
      
      public static var tileWidthHalf:int = tileWidth / 2;
      
      public static var tileHeightHalf:int = tileHeight / 2;
      
      private static const ITEM_ROTATION_TO_ACTOR_DIRECTION_MAP:Array = [1,7,5,3];
      
      private var floor:Bitmap;
      
      protected var roadLayer:MovieClip;
      
      private var extensions:Array = new Array();
      
      protected var wallItems:Array = new Array();
      
      private var scrollSpeedX:Number = 0;
      
      private var scrollSpeedY:Number = 0;
      
      public var activeOutsideAreaRoomIndex:int = 1;
      
      public var wallMap:Array = new Array();
      
      public var moveGesture:Boolean = false;
      
      protected var billboard:Billboard;
      
      protected var buttonLayer:BaseObject;
      
      public var itemMap:Array = new Array();
      
      private var baseOutsideAreaFloor:Shape;
      
      public var canvasWidth:Number = 760;
      
      public var activeRoomIndex:int = 0;
      
      private var prevScrollMouseX:Number = 0;
      
      private var prevScrollMouseY:Number = 0;
      
      private var outsideAreaFloor:Bitmap;
      
      protected var placedItems:Array = new Array();
      
      public var numOutsideTilesX:int;
      
      public var numOutsideTilesY:int;
      
      protected var trees:Array = new Array();
      
      public var numTilesX:int;
      
      public var numTilesY:int;
      
      public var canvasHeight:Number = 600;
      
      public var floorLayer:Sprite;
      
      protected var plots:Array = new Array();
      
      private var baseFloor:Shape;
      
      private var targetZoomScale:Number = 1;
      
      private var prevScrollTime:int = 0;
      
      public var room:BaseObject;
      
      public var gameUser:GameUser;
      
      private var scrolling:Boolean = false;
      
      public function WorldRestaurant(param1:GameUser)
      {
         var _loc2_:int = getTimer();
         PerfTrace.mark("WorldRestaurant constructor begin");
         super();
         this.gameUser = param1;
         init();
         PerfTrace.slow("WorldRestaurant init",_loc2_,5);
         _loc2_ = getTimer();
         addRestaurantExtension(new OutsideArea(this));
         PerfTrace.slow("WorldRestaurant OutsideArea",_loc2_,5);
         PerfTrace.mark("WorldRestaurant constructor end");
      }
      
      public static function paintGrid(param1:Shape, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int = -1, param8:Number = 1) : void
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         if(param7 != -1)
         {
            param1.graphics.beginFill(param7,0.5);
            param1.graphics.moveTo(getScreenX(param2,param3),getScreenY(param2,param3));
            param1.graphics.lineTo(getScreenX(param4,param3),getScreenY(param4,param3));
            param1.graphics.lineTo(getScreenX(param4,param5),getScreenY(param4,param5));
            param1.graphics.lineTo(getScreenX(param2,param5),getScreenY(param2,param5));
            param1.graphics.endFill();
         }
         param1.graphics.lineStyle(1,param6);
         var _loc9_:Number = param2;
         while(_loc9_ < param4 + 1)
         {
            _loc11_ = getScreenX(_loc9_,param3);
            _loc12_ = getScreenY(_loc9_,param3);
            _loc13_ = getScreenX(_loc9_,param5);
            _loc14_ = getScreenY(_loc9_,param5);
            param1.graphics.moveTo(_loc11_,_loc12_);
            param1.graphics.lineTo(_loc13_,_loc14_);
            _loc9_++;
         }
         var _loc10_:Number = param3;
         while(_loc10_ < param5 + 1)
         {
            _loc11_ = getScreenX(param2,_loc10_);
            _loc12_ = getScreenY(param2,_loc10_);
            _loc13_ = getScreenX(param4,_loc10_);
            _loc14_ = getScreenY(param4,_loc10_);
            param1.graphics.moveTo(_loc11_,_loc12_);
            param1.graphics.lineTo(_loc13_,_loc14_);
            _loc10_++;
         }
      }
      
      public static function getScreenX(param1:int, param2:int) : Number
      {
         return (param1 - param2) * tileWidthHalf;
      }
      
      public static function getTileDrawPriority(param1:int, param2:int) : int
      {
         return getTileIndex(param1,param2) << 8;
      }
      
      public static function getTileIndex(param1:int, param2:int) : int
      {
         return param2 * MAX_NUM_TILES_X + param1;
      }
      
      public static function getTileIndexX(param1:int, param2:int) : int
      {
         return (param1 + 2 * param2) / tileWidth;
      }
      
      public static function getFacingTile(param1:int, param2:int, param3:int) : Object
      {
         if(param3 == 0)
         {
            param1++;
         }
         else if(param3 == 1)
         {
            param2++;
         }
         else if(param3 == 2)
         {
            param1--;
         }
         else if(param3 == 3)
         {
            param2--;
         }
         return {
            "x":param1,
            "y":param2
         };
      }
      
      public static function getDefaultRoomItems() : Array
      {
         var _loc3_:Object = null;
         var _loc4_:UserItem = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < DEFAULT_RESTAURANT_ITEMS.length)
         {
            _loc3_ = DEFAULT_RESTAURANT_ITEMS[_loc2_];
            _loc4_ = new UserItem(getItemConfig(_loc3_.name));
            _loc4_.x = _loc3_.tileX;
            _loc4_.y = _loc3_.tileY;
            _loc4_.data = _loc3_.rotation;
            _loc1_.push(_loc4_);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function getTileXFromTileIndex(param1:int) : int
      {
         return param1 % MAX_NUM_TILES_X;
      }
      
      public static function getTileYFromTileIndex(param1:int) : int
      {
         return Math.floor(param1 / MAX_NUM_TILES_X);
      }
      
      public static function getTileIndexY(param1:int, param2:int) : int
      {
         return (2 * param2 - param1) / (2 * tileHeight);
      }
      
      public static function getItemConfig(param1:String) : Object
      {
         return GameWorld.interiorItemDatabase.getItem(param1);
      }
      
      public static function getActorDirectionFromItemRotation(param1:int) : int
      {
         return ITEM_ROTATION_TO_ACTOR_DIRECTION_MAP[param1];
      }
      
      public static function getScreenY(param1:int, param2:int) : Number
      {
         return (param1 + param2) * tileHeightHalf;
      }
      
      public function getRoomIndex(param1:int, param2:int) : int
      {
         if(isTileInOutsideArea(param1,param2))
         {
            return activeOutsideAreaRoomIndex;
         }
         return activeRoomIndex;
      }
      
      public function clearOutsideAreaFloorTiles() : void
      {
         if(outsideAreaFloor)
         {
            outsideAreaFloor.bitmapData.fillRect(new Rectangle(0,0,outsideAreaFloor.bitmapData.width,outsideAreaFloor.bitmapData.height),0);
         }
      }
      
      public function paintMainFloorMap() : void
      {
         if(gameUser.floors[activeRoomIndex])
         {
            paintFloorMap(floor,gameUser.floors[activeRoomIndex].tiles,numTilesY);
         }
      }
      
      protected function rotateRoomItem(param1:RoomItem, param2:int = -1, param3:int = -1) : void
      {
         var _loc4_:int = 0;
         var _loc5_:RoomItem = null;
         if(param1.subItems != null)
         {
            removeFromItemMap(param1);
         }
         if(param2 == -1)
         {
            param1.rotate();
         }
         else
         {
            param1.setRotation(param2);
         }
         if(param3 == -1)
         {
            param1.setHeight(getItemHeightAtTile(param1,param1.tileX,param1.tileY));
         }
         else
         {
            param1.setHeight(param3);
         }
         if(param1.subItems != null)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.subItems.length)
            {
               _loc5_ = param1.subItems[_loc4_];
               _loc5_.drawPriority = param1.drawPriority + getTileDrawPriority(_loc5_.subItemTileOffsetX,_loc5_.subItemTileOffsetY) + _loc5_.curHeight;
               _loc4_++;
            }
            addToItemMap(param1);
         }
      }
      
      public function init() : void
      {
         var _loc7_:DisplayObject = null;
         var _loc8_:RestaurantTreeObject = null;
         var _loc9_:GardenPlotActor = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Array = null;
         var _loc13_:int = getTimer();
         PerfTrace.mark("WorldRestaurant.init begin");
         room = new BaseObject();
         room.graphics.beginFill(11788396);
         room.graphics.drawRect(-2000,-2000,4000,4000);
         room.graphics.endFill();
         addObject(room);
         roadLayer = Engine.getMovieClip("Road");
         roadLayer.cacheAsBitmap = true;
         room.addChild(roadLayer);
         PerfTrace.slow("WorldRestaurant.init road",_loc13_,5);
         _loc13_ = getTimer();
         floorLayer = new Sprite();
         room.addChild(floorLayer);
         baseFloor = new Shape();
         baseOutsideAreaFloor = new Shape();
         floorLayer.addChild(baseFloor);
         floorLayer.addChild(baseOutsideAreaFloor);
         var _loc1_:MovieClip = Engine.getMovieClip("RoadTrees");
         var _loc2_:Number = 0;
         while(_loc2_ < _loc1_.numChildren)
         {
            _loc7_ = _loc1_.getChildAt(_loc2_);
            if(_loc7_ is MovieClip)
            {
               _loc8_ = new RestaurantTreeObject(getQualifiedClassName(_loc7_));
               _loc8_.x = _loc7_.x;
               _loc8_.y = _loc7_.y;
               _loc8_.drawPriority = getTileDrawPriority(getTileIndexX(_loc7_.x,_loc7_.y),getTileIndexY(_loc7_.x,_loc7_.y));
               trees.push(_loc8_);
               room.addObject(_loc8_);
            }
            _loc2_++;
         }
         PerfTrace.slow("WorldRestaurant.init road trees",_loc13_,5);
         _loc13_ = getTimer();
         billboard = new Billboard(0,0,this);
         room.addObject(billboard);
         var _loc3_:int = gameUser.level.value;
         var _loc4_:int = int(GameWorld.LEVEL_THRESHOLDS[_loc3_].roomSizeX);
         var _loc5_:int = int(GameWorld.LEVEL_THRESHOLDS[_loc3_].roomSizeY);
         var _loc6_:BaseObject = new BaseObject("HerbGarden");
         _loc6_.cacheAsBitmap = true;
         _loc6_.x = getScreenX(GARDEN_TILE_X,GARDEN_TILE_Y);
         _loc6_.y = getScreenY(GARDEN_TILE_X,GARDEN_TILE_Y);
         _loc6_.drawPriority = SHADOW_DRAW_PRIORITY;
         room.addObject(_loc6_);
         _loc2_ = 0;
         while(_loc2_ < 9)
         {
            _loc9_ = new GardenPlotActor(GARDEN_TILE_X + Math.floor(_loc2_ / 3) * 2,GARDEN_TILE_Y + 4 - _loc2_ % 3 * 2,this,gameUser.gardenPlots[_loc2_],_loc2_);
            room.addObject(_loc9_);
            plots.push(_loc9_);
            _loc6_.getChildMovieClipInstance("mc_plot" + _loc2_).visible = false;
            _loc2_++;
         }
         PerfTrace.slow("WorldRestaurant.init garden plots",_loc13_,5);
         _loc13_ = getTimer();
         setRoomSize(_loc4_,_loc5_);
         if(gameUser.outsideAreaSizeItems.length > 0)
         {
            setOutsideAreaSize(gameUser.outsideAreaSizeItems[0].sizeX,gameUser.outsideAreaSizeItems[0].sizeY);
         }
         PerfTrace.slow("WorldRestaurant.init room size",_loc13_,5);
         _loc13_ = getTimer();
         room.x = canvasWidth / 2;
         room.y = tileHeight * 2;
         _loc2_ = 0;
         while(_loc2_ < MAX_NUM_TILES_X * MAX_NUM_TILES_Y)
         {
            itemMap[_loc2_] = new Array();
            _loc2_++;
         }
         if(gameUser != null)
         {
            _loc10_ = gameUser.activeFloorIndex;
            _loc11_ = _loc10_ + 1;
            loadRoom(gameUser,_loc10_,_loc11_);
            PerfTrace.slow("WorldRestaurant.init loadRoom",_loc13_,5);
         }
         else
         {
            addDefaultWalls();
            _loc12_ = getDefaultRoomItems();
            _loc2_ = 0;
            while(_loc2_ < _loc12_.length)
            {
               placeDefaultRoomItem(_loc12_[_loc2_],_loc12_[_loc2_].tileX,_loc12_[_loc2_].tileY);
               _loc2_++;
            }
            PerfTrace.slow("WorldRestaurant.init defaults",_loc13_,5);
         }
         _loc13_ = getTimer();
         buttonLayer = new BaseObject();
         buttonLayer.drawPriority = 20000;
         addObject(buttonLayer);
         room.addEventListener(MouseEvent.MOUSE_DOWN,onWorldMouseDown);
         room.addEventListener(MouseEvent.MOUSE_UP,onWorldMouseUp);
         room.addEventListener(MouseEvent.ROLL_OUT,onWorldMouseUp);
         GameWorld.gameEventDispatcher.addEventListener(GameEvent.LEVEL_UP,onLevelUp,false,0,true);
         PerfTrace.slow("WorldRestaurant.init listeners",_loc13_,5);
         PerfTrace.mark("WorldRestaurant.init end placedItems=" + placedItems.length + " trees=" + trees.length);
      }
      
      override public function destroy() : void
      {
         var _loc2_:RoomItem = null;
         var _loc1_:int = 0;
         while(_loc1_ < extensions.length)
         {
            extensions[_loc1_].destroy();
            extensions[_loc1_] = null;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < placedItems.length)
         {
            _loc2_ = placedItems[_loc1_];
            _loc2_.destroyFunctions();
            _loc1_++;
         }
         GameWorld.gameEventDispatcher.removeEventListener(GameEvent.LEVEL_UP,onLevelUp);
      }
      
      protected function removeFromItemMap(param1:RoomItem) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:int = getTileIndex(param1.tileX,param1.tileY);
         var _loc3_:int = 0;
         while(_loc3_ < param1.numTilesX)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.numTilesY)
            {
               _loc5_ = _loc2_ + getTileIndex(_loc3_,_loc4_);
               if(_loc5_ >= 0 && Boolean(itemMap[_loc5_]))
               {
                  _loc6_ = int(itemMap[_loc5_].indexOf(param1));
                  if(_loc6_ != -1)
                  {
                     itemMap[_loc5_].splice(_loc6_,1);
                  }
               }
               _loc4_++;
            }
            _loc3_++;
         }
         if(param1.wallItem)
         {
            wallMap[_loc2_] = null;
            _loc7_ = wallItems.indexOf(param1);
            if(_loc7_ != -1)
            {
               wallItems.splice(_loc7_,1);
            }
         }
         if(param1.subItems)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.subItems.length)
            {
               removeFromItemMap(param1.subItems[_loc3_]);
               _loc3_++;
            }
         }
      }
      
      public function paintFloorTile(param1:Bitmap, param2:Sprite, param3:int, param4:int, param5:int) : void
      {
         param1.bitmapData.draw(param2,new Matrix(1,0,0,1,getScreenX(param3,param4) + param5 * tileWidthHalf,getScreenY(param3,param4)));
      }
      
      public function addRestaurantExtension(param1:RestaurantExtensionBase) : void
      {
         extensions.push(param1);
         param1.init();
      }
      
      public function getInteractiveItemUserTile(param1:RoomItem) : Object
      {
         var _loc2_:int = param1.getRotationCount();
         var _loc3_:* = param1.tileX;
         var _loc4_:* = param1.tileY;
         if(_loc2_ == 0)
         {
            _loc3_ += param1.numTilesX;
         }
         else if(_loc2_ == 1)
         {
            _loc4_ += param1.numTilesY;
         }
         else if(_loc2_ == 2)
         {
            _loc3_--;
         }
         else if(_loc2_ == 3)
         {
            _loc4_--;
         }
         return {
            "x":_loc3_,
            "y":_loc4_
         };
      }
      
      public function paintFloorMap(param1:Bitmap, param2:Array, param3:int) : void
      {
         var _loc7_:Object = null;
         if(!param1 || !param2)
         {
            return;
         }
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < param2.length)
         {
            if(param2[_loc6_] > 0)
            {
               _loc7_ = GameWorld.interiorItemDatabase.getItemFromId(param2[_loc6_]);
               if(!_loc7_)
               {
                  Engine.showMessage("painting a tile with id=" + param2[_loc6_] + " that does not exist");
               }
               else
               {
                  paintFloorTile(param1,Engine.getMovieClip(_loc7_.className),_loc4_,_loc5_,param3);
               }
            }
            if(++_loc4_ >= MAX_NUM_TILES_X)
            {
               _loc5_++;
               _loc4_ = 0;
            }
            _loc6_++;
         }
      }
      
      public function getTileTopHeight(param1:int, param2:int, param3:RoomItem = null) : int
      {
         var _loc7_:RoomItem = null;
         var _loc4_:int = 0;
         var _loc5_:int = getTileIndex(param1,param2);
         var _loc6_:* = int(itemMap[_loc5_].length - 1);
         while(_loc6_ >= 0)
         {
            _loc7_ = itemMap[_loc5_][_loc6_];
            if(_loc7_ != param3)
            {
               return _loc7_.getTopHeight();
            }
            _loc6_--;
         }
         return _loc4_;
      }
      
      public function setOutsideAreaSize(param1:int, param2:int) : void
      {
         if(this.numOutsideTilesX != param1 || this.numOutsideTilesY != param2)
         {
            this.numOutsideTilesX = param1;
            this.numOutsideTilesY = param2;
            if(outsideAreaFloor)
            {
               floorLayer.removeChild(outsideAreaFloor);
               outsideAreaFloor.bitmapData.dispose();
               outsideAreaFloor = null;
            }
            baseOutsideAreaFloor.graphics.clear();
            if(param1 > 0 && param2 > 0)
            {
               outsideAreaFloor = createFloorTileLayer(param1,param2);
               outsideAreaFloor.x = getScreenX(0,numTilesY) - param2 * tileWidthHalf;
               outsideAreaFloor.y = getScreenY(0,numTilesY);
               floorLayer.addChild(outsideAreaFloor);
               fillBaseArea(baseOutsideAreaFloor.graphics,10668375,1,0,param1,param2);
            }
            onFloorSizeChanged();
            if(hasEventListener(RestaurantEvent.EVENT_OUTSIDE_AREA_SIZE_CHANGE))
            {
               dispatchEvent(new RestaurantEvent(RestaurantEvent.EVENT_OUTSIDE_AREA_SIZE_CHANGE));
            }
         }
      }
      
      public function getBedItemUserTile(param1:RoomItem) : Object
      {
         var _loc2_:int = param1.getRotationCount();
         var _loc3_:int = param1.tileX;
         var _loc4_:int = param1.tileY;
         if(_loc2_ == 2)
         {
            _loc3_ += param1.numTilesX - 1;
         }
         else if(_loc2_ == 3)
         {
            _loc4_ += param1.numTilesY - 1;
         }
         return {
            "x":_loc3_,
            "y":_loc4_
         };
      }
      
      public function disableButton(param1:MovieClip) : void
      {
         param1.mouseEnabled = false;
         param1.mouseChildren = false;
         param1.alpha = 0.2;
      }
      
      private function onWorldMouseDown(param1:MouseEvent) : void
      {
         moveGesture = false;
         scrolling = true;
         prevScrollMouseX = mouseX;
         prevScrollMouseY = mouseY;
         prevScrollTime = getTimer();
         addEventListener(MouseEvent.MOUSE_MOVE,onWorldMouseMove,false,0,true);
      }
      
      public function clearMainFloorTiles() : void
      {
         if(floor)
         {
            floor.bitmapData.fillRect(new Rectangle(0,0,floor.bitmapData.width,floor.bitmapData.height),0);
         }
      }
      
      public function removeAllItems() : void
      {
         var _loc2_:RoomItem = null;
         var _loc1_:* = int(placedItems.length - 1);
         while(_loc1_ >= 0)
         {
            _loc2_ = placedItems[_loc1_];
            if(_loc2_.editable)
            {
               removeRoomItem(_loc2_);
            }
            _loc1_--;
         }
         setWallPaper(getWallItem(0,1),null);
         setWallPaper(getWallItem(1,0),null);
         clearMainFloorTiles();
         clearOutsideAreaFloorTiles();
      }
      
      private function setAutoRotateItem(param1:RoomItem, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:RoomItem = null;
         if(Boolean(param1) && param1.getMaxRotationCount() == 16)
         {
            _loc3_ = 0;
            _loc4_ = itemMap[getTileIndex(param1.tileX,param1.tileY - 1)][0];
            if((Boolean(_loc4_)) && _loc4_.itemConfig.id == param1.itemConfig.id)
            {
               if(param2)
               {
                  setAutoRotateItem(_loc4_,false);
               }
               _loc3_ += 1;
            }
            _loc4_ = itemMap[getTileIndex(param1.tileX + 1,param1.tileY)][0];
            if((Boolean(_loc4_)) && _loc4_.itemConfig.id == param1.itemConfig.id)
            {
               if(param2)
               {
                  setAutoRotateItem(_loc4_,false);
               }
               _loc3_ += 2;
            }
            _loc4_ = itemMap[getTileIndex(param1.tileX,param1.tileY + 1)][0];
            if((Boolean(_loc4_)) && _loc4_.itemConfig.id == param1.itemConfig.id)
            {
               if(param2)
               {
                  setAutoRotateItem(_loc4_,false);
               }
               _loc3_ += 4;
            }
            _loc4_ = itemMap[getTileIndex(param1.tileX - 1,param1.tileY)][0];
            if((Boolean(_loc4_)) && _loc4_.itemConfig.id == param1.itemConfig.id)
            {
               if(param2)
               {
                  setAutoRotateItem(_loc4_,false);
               }
               _loc3_ += 8;
            }
            param1.setRotation(_loc3_);
         }
      }
      
      public function isWalkableFrom(param1:int, param2:int, param3:int, param4:int, param5:Boolean = false, param6:Boolean = false) : Boolean
      {
         if(param5 || isWalkable(param3,param4))
         {
            if(!param6 && param3 - param1 != 0 && param4 - param2 != 0)
            {
               if(!isWalkable(param3,param2) || !isWalkable(param1,param4))
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }
      
      public function isTableFree(param1:RoomItem) : Boolean
      {
         return param1.tableTopOrder == null && itemMap[getTileIndex(param1.tileX,param1.tileY)].length == 1;
      }
      
      public function isTileInOutsideArea(param1:int, param2:int) : Boolean
      {
         return param2 >= numTilesY && param1 < numOutsideTilesX;
      }
      
      protected function setZoom(param1:Number) : void
      {
         room.scaleX = param1;
         room.scaleY = param1;
      }
      
      public function removeRoomItem(param1:RoomItem) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         room.removeObject(param1);
         if(param1.parentItem == null)
         {
            placedItems.splice(placedItems.indexOf(param1),1);
            removeFromItemMap(param1);
         }
         if(param1.subItems != null)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.subItems.length)
            {
               removeRoomItem(param1.subItems[_loc2_]);
               _loc2_++;
            }
         }
         if(param1.getMaxRotationCount() == 16)
         {
            setAutoRotateItem(itemMap[getTileIndex(param1.tileX,param1.tileY - 1)][0],false);
            setAutoRotateItem(itemMap[getTileIndex(param1.tileX + 1,param1.tileY)][0],false);
            setAutoRotateItem(itemMap[getTileIndex(param1.tileX,param1.tileY + 1)][0],false);
            setAutoRotateItem(itemMap[getTileIndex(param1.tileX - 1,param1.tileY)][0],false);
         }
         if(param1.attachedWalls)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.attachedWalls.length)
            {
               if(param1.attachedWalls[_loc2_].doorMask != null)
               {
                  _loc3_ = int(param1.attachedWalls[_loc2_].doorMask.length - 1);
                  while(_loc3_ >= 0)
                  {
                     if(param1.attachedWalls[_loc2_].doorMask[_loc3_].parentItem == param1)
                     {
                        param1.attachedWalls[_loc2_].removeChild(param1.attachedWalls[_loc2_].doorMask[_loc3_]);
                        param1.attachedWalls[_loc2_].doorMask.splice(_loc3_,1);
                     }
                     _loc3_--;
                  }
               }
               param1.attachedWalls[_loc2_] = null;
               _loc2_++;
            }
            param1.attachedWalls = null;
         }
      }
      
      public function onLevelUp(param1:GameEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(gameUser == GameWorld.gameUser)
         {
            _loc2_ = GameWorld.gameUser.level.value;
            if(GameWorld.LEVEL_THRESHOLDS[_loc2_].roomSizeX > numTilesX || GameWorld.LEVEL_THRESHOLDS[_loc2_].roomSizeY > numTilesY)
            {
               setRoomSize(GameWorld.LEVEL_THRESHOLDS[_loc2_].roomSizeX,GameWorld.LEVEL_THRESHOLDS[_loc2_].roomSizeY);
               addDefaultWalls();
               paintMainFloorMap();
            }
            _loc3_ = 0;
            while(_loc3_ < gameUser.gardenPlots.length)
            {
               if(plots[_loc3_].plot == null)
               {
                  plots[_loc3_].setPlot(gameUser.gardenPlots[_loc3_]);
               }
               _loc3_++;
            }
         }
      }
      
      private function onWorldMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = getTimer() - prevScrollTime;
         prevScrollTime = getTimer();
         var _loc3_:Number = mouseX - prevScrollMouseX;
         var _loc4_:Number = mouseY - prevScrollMouseY;
         scrollSpeedX = Math.max(-0.8,Math.min(0.8,_loc3_ / _loc2_));
         scrollSpeedY = Math.max(-0.8,Math.min(0.8,_loc4_ / _loc2_));
         room.x += _loc3_;
         room.y += _loc4_;
         prevScrollMouseX = mouseX;
         prevScrollMouseY = mouseY;
         if(Math.abs(_loc3_) >= 4 || Math.abs(_loc4_) >= 4)
         {
            moveGesture = true;
         }
      }
      
      protected function addDefaultWalls() : void
      {
         var _loc5_:RoomItem = null;
         var _loc1_:int = 1;
         while(_loc1_ < numTilesX)
         {
            if(wallMap[getTileIndex(_loc1_,0)] == null)
            {
               _loc5_ = new RoomItem(getItemConfig("White Walls"),null);
               _loc5_.rotate();
               _loc5_.editable = false;
               placeRoomItem(_loc5_,_loc1_,0);
            }
            _loc1_++;
         }
         var _loc2_:Number = 1;
         while(_loc2_ < numTilesY)
         {
            if(wallMap[getTileIndex(0,_loc2_)] == null)
            {
               _loc5_ = new RoomItem(getItemConfig("White Walls"),null);
               _loc5_.editable = false;
               placeRoomItem(_loc5_,0,_loc2_);
            }
            _loc2_++;
         }
         if(wallMap[getTileIndex(0,0)] == null)
         {
            _loc5_ = new RoomItem(getItemConfig("Wall Corner"),null);
            _loc5_.editable = false;
            placeRoomItem(_loc5_,0,0);
         }
         var _loc3_:RoomItem = getWallItem(0,1);
         if(_loc3_ != null && _loc3_.wallpaperRoomItem != null)
         {
            setWallPaper(_loc3_,_loc3_.wallpaperRoomItem);
         }
         var _loc4_:RoomItem = getWallItem(1,0);
         if(_loc4_ != null && _loc4_.wallpaperRoomItem != null)
         {
            setWallPaper(_loc4_,_loc4_.wallpaperRoomItem);
         }
      }
      
      public function getItemAtTile(param1:int, param2:int) : RoomItem
      {
         var _loc3_:Array = itemMap[getTileIndex(param1,param2)];
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            return _loc3_[0];
         }
         return null;
      }
      
      public function paintOutsideAreaFloorMap() : void
      {
         if(gameUser.floors[activeOutsideAreaRoomIndex])
         {
            paintFloorMap(outsideAreaFloor,gameUser.floors[activeOutsideAreaRoomIndex].tiles,numOutsideTilesY);
         }
      }
      
      public function getWallItem(param1:int, param2:int) : RoomItem
      {
         return wallMap[getTileIndex(param1,param2)];
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(WorldPopUp.activePopUp.length == 0)
         {
            if(Engine.isKeyPressed(Engine.KEY_RIGHT))
            {
               if(scrollSpeedX > 0)
               {
                  scrollSpeedX = -scrollSpeedX;
               }
               else
               {
                  scrollSpeedX = Math.max(-0.8,scrollSpeedX - 0.4);
               }
            }
            else if(Engine.isKeyPressed(Engine.KEY_LEFT))
            {
               if(scrollSpeedX < 0)
               {
                  scrollSpeedX = -scrollSpeedX;
               }
               else
               {
                  scrollSpeedX = Math.min(0.8,scrollSpeedX + 0.4);
               }
            }
            if(Engine.isKeyPressed(Engine.KEY_DOWN))
            {
               if(scrollSpeedY > 0)
               {
                  scrollSpeedY = -scrollSpeedY;
               }
               else
               {
                  scrollSpeedY = Math.max(-0.8,scrollSpeedY - 0.4);
               }
            }
            else if(Engine.isKeyPressed(Engine.KEY_UP))
            {
               if(scrollSpeedY < 0)
               {
                  scrollSpeedY = -scrollSpeedY;
               }
               else
               {
                  scrollSpeedY = Math.min(0.8,scrollSpeedY + 0.4);
               }
            }
         }
         if(scrollSpeedX != 0 || scrollSpeedY != 0)
         {
            if(!scrolling)
            {
               room.x += scrollSpeedX * param1;
               room.y += scrollSpeedY * param1;
            }
            _loc3_ = Engine.getAngle(0,0,scrollSpeedX,scrollSpeedY);
            _loc4_ = -0.25 * Math.cos(_loc3_);
            _loc5_ = 0.25 * Math.sin(_loc3_);
            if(scrollSpeedX > 0)
            {
               scrollSpeedX = Math.max(0,scrollSpeedX + _loc4_);
            }
            else if(scrollSpeedX < 0)
            {
               scrollSpeedX = Math.min(0,scrollSpeedX + _loc4_);
            }
            if(scrollSpeedY > 0)
            {
               scrollSpeedY = Math.max(0,scrollSpeedY + _loc5_);
            }
            else if(scrollSpeedY < 0)
            {
               scrollSpeedY = Math.min(0,scrollSpeedY + _loc5_);
            }
            if(scrollSpeedX == 0 && scrollSpeedY == 0)
            {
               room.x = Math.floor(room.x);
               room.y = Math.floor(room.y);
            }
         }
         if(!scrolling)
         {
            _loc6_ = room.x;
            if(room.x > -RESTAURANT_BOUND.left * room.scaleX)
            {
               _loc6_ = -RESTAURANT_BOUND.left * room.scaleX;
            }
            else if(room.x < canvasWidth - RESTAURANT_BOUND.right * room.scaleX)
            {
               _loc6_ = canvasWidth - RESTAURANT_BOUND.right * room.scaleX;
            }
            room.x += (_loc6_ - room.x) / 4;
            _loc7_ = room.y;
            if(room.y > -RESTAURANT_BOUND.top * room.scaleY)
            {
               _loc7_ = -RESTAURANT_BOUND.top * room.scaleY;
            }
            else if(room.y < canvasHeight - RESTAURANT_BOUND.bottom * room.scaleY)
            {
               _loc7_ = canvasHeight - RESTAURANT_BOUND.bottom * room.scaleY;
            }
            room.y += (_loc7_ - room.y) / 4;
         }
         if(room.x > -MAX_RESTAURANT_BOUND.left * room.scaleX)
         {
            room.x = -MAX_RESTAURANT_BOUND.left * room.scaleX;
         }
         else if(room.x < canvasWidth - MAX_RESTAURANT_BOUND.right * room.scaleX)
         {
            room.x = canvasWidth - MAX_RESTAURANT_BOUND.right * room.scaleX;
         }
         if(room.y > -MAX_RESTAURANT_BOUND.top * room.scaleY)
         {
            room.y = -MAX_RESTAURANT_BOUND.top * room.scaleY;
         }
         else if(room.y < canvasHeight - MAX_RESTAURANT_BOUND.bottom * room.scaleY)
         {
            room.y = canvasHeight - MAX_RESTAURANT_BOUND.bottom * room.scaleY;
         }
         if(targetZoomScale != room.scaleX)
         {
            if(targetZoomScale > room.scaleX)
            {
               room.scaleX += 0.1;
               if(targetZoomScale < room.scaleX)
               {
                  room.scaleX = targetZoomScale;
               }
            }
            else if(targetZoomScale < room.scaleX)
            {
               room.scaleX -= 0.1;
               if(targetZoomScale > room.scaleX)
               {
                  room.scaleX = targetZoomScale;
               }
            }
            setZoom(room.scaleX);
         }
         var _loc2_:int = 0;
         while(_loc2_ < extensions.length)
         {
            extensions[_loc2_].tick(param1);
            _loc2_++;
         }
      }
      
      public function setWallPaper(param1:RoomItem, param2:RoomItem) : void
      {
         var _loc4_:RoomItem = null;
         var _loc5_:MovieClip = null;
         var _loc3_:int = 0;
         while(_loc3_ < wallItems.length)
         {
            _loc4_ = wallItems[_loc3_];
            if(_loc4_.tileX != 0 || _loc4_.tileY != 0)
            {
               if(param1.getRotationCount() == _loc4_.getRotationCount())
               {
                  if(_loc4_.wallpaper)
                  {
                     _loc4_.removeChild(_loc4_.wallpaper);
                     _loc4_.wallpaper = null;
                     _loc4_.wallpaperRoomItem = null;
                  }
                  if(param2)
                  {
                     _loc5_ = Engine.getMovieClip(param2.itemConfig.className);
                     _loc5_.gotoAndStop(_loc4_.getRotationCount() + 1);
                     _loc4_.wallpaper = _loc5_;
                     _loc4_.wallpaperRoomItem = param2;
                     _loc4_.addChildAt(_loc5_,1);
                  }
               }
            }
            _loc3_++;
         }
      }
      
      public function enableButton(param1:MovieClip) : void
      {
         param1.mouseEnabled = true;
         param1.mouseChildren = true;
         param1.alpha = 1;
      }
      
      private function onWorldMouseUp(param1:MouseEvent) : void
      {
         scrolling = false;
         removeEventListener(MouseEvent.MOUSE_MOVE,onWorldMouseMove);
      }
      
      public function fillBaseArea(param1:Graphics, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         param1.beginFill(param2,1);
         param1.moveTo(getScreenX(param3,param4),getScreenY(param3,param4));
         param1.lineTo(getScreenX(param3,param6),getScreenY(param3,param6));
         param1.lineTo(getScreenX(param5,param6),getScreenY(param5,param6));
         param1.lineTo(getScreenX(param5,param4),getScreenY(param5,param4));
         param1.endFill();
      }
      
      public function getItemHeightAtTile(param1:RoomItem, param2:int, param3:int) : int
      {
         var _loc6_:Number = NaN;
         if(isItemOutOfBound(param1,param2,param3))
         {
            return 0;
         }
         var _loc4_:int = 0;
         var _loc5_:Number = 0;
         while(_loc5_ < param1.numTilesX)
         {
            _loc6_ = 0;
            while(_loc6_ < param1.numTilesY)
            {
               _loc4_ = Math.max(getTileTopHeight(param2 + _loc5_,param3 + _loc6_,param1),_loc4_);
               _loc6_++;
            }
            _loc5_++;
         }
         if(param1.subItems != null)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.subItems.length)
            {
               _loc4_ = Math.max(getItemHeightAtTile(param1.subItems[_loc5_],param2 + param1.subItems[_loc5_].subItemTileOffsetX,param3 + param1.subItems[_loc5_].subItemTileOffsetY),_loc4_);
               _loc5_++;
            }
         }
         return _loc4_;
      }
      
      private function createFloorTileLayer(param1:int, param2:int) : Bitmap
      {
         var _loc3_:int = (param1 + param2) * tileWidthHalf;
         var _loc4_:int = (param1 + param2) * tileHeightHalf;
         var _loc5_:BitmapData = new BitmapData(_loc3_,_loc4_,true,0);
         var _loc6_:Bitmap = new Bitmap(_loc5_);
         _loc6_.smoothing = true;
         return _loc6_;
      }
      
      public function placeRoomItem(param1:RoomItem, param2:int, param3:int, param4:Number = -1) : void
      {
         var _loc5_:RoomItem = null;
         var _loc6_:MovieClip = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:RoomItem = null;
         var _loc10_:MovieClip = null;
         var _loc11_:Matrix = null;
         var _loc12_:Number = NaN;
         updateItemRoomPosition(param1,param2,param3);
         if(param1.floorTileItem)
         {
            if(param1.roomIndex == activeRoomIndex)
            {
               paintFloorTile(floor,param1,param1.roomTileX,param1.roomTileY,numTilesY);
            }
            else if(param1.roomIndex == activeOutsideAreaRoomIndex)
            {
               paintFloorTile(outsideAreaFloor,param1,param1.roomTileX,param1.roomTileY,numOutsideTilesY);
            }
            return;
         }
         if(param1.wallpaperItem)
         {
            _loc5_ = getWallItem(param2,param3);
            if(_loc5_ == null)
            {
               if(param2 == 0)
               {
                  _loc5_ = getWallItem(0,1);
               }
               else
               {
                  _loc5_ = getWallItem(1,0);
               }
            }
            placedItems.push(param1);
            setWallPaper(_loc5_,param1);
            return;
         }
         if(param1.parentItem == null)
         {
            param1.setTilePosition(param2,param3);
            placedItems.push(param1);
            if(!param1.wallDecorationItem)
            {
               if(param4 == -1)
               {
                  param1.setHeight(getItemHeightAtTile(param1,param2,param3));
               }
               else
               {
                  param1.setHeight(param4);
               }
            }
            addToItemMap(param1);
         }
         if(Math.round(param1.itemHeight) == 0)
         {
            param1.drawPriority = FLOOR_DRAW_PRIORITY;
         }
         else if(param1.doorItem)
         {
            if(param1.getRotationCount() == 0)
            {
               param1.drawPriority = getTileDrawPriority(param2 + 1,param3) - 1;
            }
            else
            {
               param1.drawPriority = getTileDrawPriority(param2 - 1,param3 + 1);
            }
         }
         else if(param1.wallDecorationItem)
         {
            param1.drawPriority = getTileDrawPriority(param2 + param1.fullGridSizeX - 1,param3);
         }
         else
         {
            param1.drawPriority = getTileDrawPriority(param2,param3) + param1.curHeight;
         }
         if(param1.getMaxRotationCount() == 16)
         {
            setAutoRotateItem(param1,true);
         }
         room.addObject(param1);
         if(param1.doorItem || param1.wallDecorationItem)
         {
            _loc6_ = param1.getChildMovieClipInstance("mc_mask");
            if(_loc6_)
            {
               _loc6_.visible = false;
               _loc6_.mouseEnabled = false;
               _loc7_ = 0;
               while(_loc7_ < param1.numTilesX)
               {
                  _loc8_ = 0;
                  while(_loc8_ < param1.numTilesY)
                  {
                     _loc9_ = getWallItem(param2 + _loc7_,param3 + _loc8_);
                     if(_loc9_ != null)
                     {
                        _loc10_ = Engine.getMovieClip(getQualifiedClassName(_loc6_));
                        _loc11_ = _loc6_.transform.matrix;
                        _loc11_.translate(-getScreenX(_loc7_ + param1.subItemTileOffsetX,_loc8_ + param1.subItemTileOffsetY),-getScreenY(_loc7_ + param1.subItemTileOffsetX,_loc8_ + param1.subItemTileOffsetY));
                        _loc10_.transform.matrix = _loc11_;
                        _loc10_.parentItem = param1;
                        _loc10_.mouseEnabled = false;
                        _loc10_.mouseChildren = false;
                        _loc10_.cacheAsBitmap = false;
                        _loc10_.blendMode = BlendMode.ERASE;
                        _loc9_.cacheAsBitmap = false;
                        _loc9_.blendMode = BlendMode.LAYER;
                        if(_loc9_.doorMask == null)
                        {
                           _loc9_.doorMask = new Array();
                        }
                        _loc9_.doorMask.push(_loc10_);
                        _loc9_.addChild(_loc10_);
                        if(param1.attachedWalls == null)
                        {
                           param1.attachedWalls = new Array();
                        }
                        param1.attachedWalls.push(_loc9_);
                     }
                     _loc8_++;
                  }
                  _loc7_++;
               }
            }
         }
         if(param1.subItems != null)
         {
            _loc12_ = 0;
            while(_loc12_ < param1.subItems.length)
            {
               placeRoomItem(param1.subItems[_loc12_],param1.subItems[_loc12_].tileX,param1.subItems[_loc12_].tileY);
               _loc12_++;
            }
         }
      }
      
      protected function addToItemMap(param1:RoomItem) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc2_:int = getTileIndex(param1.tileX,param1.tileY);
         var _loc3_:Number = 0;
         while(_loc3_ < param1.numTilesX)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.numTilesY)
            {
               _loc5_ = _loc2_ + getTileIndex(_loc3_,_loc4_);
               if(_loc5_ >= 0 && Boolean(itemMap[_loc5_]))
               {
                  itemMap[_loc5_].push(param1);
               }
               _loc4_++;
            }
            _loc3_++;
         }
         if(param1.wallItem)
         {
            wallMap[_loc2_] = param1;
            _loc3_ = 0;
            while(_loc3_ < wallItems.length)
            {
               if(param1.drawPriority >= wallItems[_loc3_].drawPriority)
               {
                  wallItems.splice(_loc3_,0,param1);
                  break;
               }
               _loc3_++;
            }
            if(_loc3_ == wallItems.length)
            {
               wallItems.push(param1);
            }
         }
         if(param1.subItems != null)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.subItems.length)
            {
               addToItemMap(param1.subItems[_loc3_]);
               _loc3_++;
            }
         }
      }
      
      public function updateItemRoomPosition(param1:RoomItem, param2:int, param3:int) : void
      {
         param1.roomIndex = getRoomIndex(param2,param3);
         param1.roomTileX = param2;
         param1.roomTileY = param3;
         if(param1.roomIndex == activeOutsideAreaRoomIndex)
         {
            param1.roomTileY -= numTilesY;
         }
      }
      
      public function getTableForChair(param1:RoomItem) : RoomItem
      {
         var _loc2_:Object = getFacingTile(param1.tileX,param1.tileY,param1.getRotationCount());
         var _loc3_:RoomItem = getItemAtTile(_loc2_.x,_loc2_.y);
         if(Boolean(_loc3_) && _loc3_.tableItem)
         {
            return _loc3_;
         }
         return null;
      }
      
      private function onFloorSizeChanged() : void
      {
         var _loc2_:BaseObject = null;
         var _loc1_:int = 0;
         while(_loc1_ < trees.length)
         {
            _loc2_ = BaseObject(trees[_loc1_]);
            _loc2_.mouseEnabled = false;
            if(_loc2_.hitTestObject(floorLayer))
            {
               _loc2_.visible = false;
            }
            else
            {
               _loc2_.visible = true;
            }
            _loc1_++;
         }
      }
      
      public function isTileOutOfBound(param1:int, param2:int) : Boolean
      {
         if(param2 >= numTilesY)
         {
            return param1 < 0 || param1 >= numOutsideTilesX || param2 >= numTilesY + numOutsideTilesY;
         }
         return param1 < 0 || param1 >= numTilesX || param2 < 0 || param2 >= numTilesY;
      }
      
      public function zoom(param1:Number, param2:Boolean) : void
      {
         if(param2)
         {
            setZoom(param1);
         }
         targetZoomScale = param1;
      }
      
      public function focus(param1:Number, param2:Number) : void
      {
         room.x = -param1 * room.scaleX + canvasWidth / 2;
         room.y = -param2 * room.scaleY + canvasHeight / 2;
      }
      
      public function addGourmetPoints(param1:Number) : void
      {
         GameWorld.addGourmetPoints(param1);
      }
      
      public function loadRoom(param1:GameUser, param2:int, param3:int) : void
      {
         var _loc5_:RoomItem = null;
         var _loc6_:UserItem = null;
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         var _loc9_:int = getTimer();
         PerfTrace.mark("WorldRestaurant.loadRoom begin usedItems=" + param1.usedRestaurantItems.length + " active=" + param2 + " outside=" + param3);
         this.activeRoomIndex = param2;
         this.activeOutsideAreaRoomIndex = param3;
         removeAllItems();
         addDefaultWalls();
         PerfTrace.slow("WorldRestaurant.loadRoom clear/defaultWalls",_loc9_,5);
         _loc9_ = getTimer();
         var _loc4_:Array = new Array();
         for each(_loc6_ in param1.usedRestaurantItems)
         {
            if(_loc6_.roomIndex == param2 || _loc6_.roomIndex == param3)
            {
               _loc5_ = RoomItem.createRoomItems(_loc6_.itemConfig,_loc6_);
               _loc5_.owned = true;
               if(_loc5_.roomIndex == param2)
               {
                  if(_loc5_.roomTileX < 0)
                  {
                     _loc5_.roomTileX = 0;
                  }
                  else if(_loc5_.roomTileX >= numTilesX)
                  {
                     _loc5_.roomTileX = numTilesX - 1;
                  }
                  if(_loc5_.roomTileY < 0)
                  {
                     _loc5_.roomTileY = 0;
                  }
                  else if(_loc5_.roomTileY >= numTilesY)
                  {
                     _loc5_.roomTileY = numTilesY - 1;
                  }
                  if(_loc5_.roomTileX == 0 && _loc5_.roomTileY == 0)
                  {
                     _loc5_.roomTileX = 1;
                  }
               }
               else if(_loc5_.roomIndex == param3)
               {
                  if(_loc5_.roomTileX < 0)
                  {
                     _loc5_.roomTileX = 0;
                  }
                  else if(_loc5_.roomTileX >= numOutsideTilesX)
                  {
                     _loc5_.roomTileX = numOutsideTilesX - 1;
                  }
                  if(_loc5_.roomTileY < 0)
                  {
                     _loc5_.roomTileY = 0;
                  }
                  else if(_loc5_.roomTileY >= numOutsideTilesY)
                  {
                     _loc5_.roomTileY = numOutsideTilesY - 1;
                  }
               }
               if(_loc5_.surface && !_loc5_.stackable)
               {
                  placeItemInRoom(_loc5_.clone(),_loc5_.roomTileX,_loc5_.roomTileY,_loc5_.roomIndex);
               }
               else
               {
                  _loc4_.push(_loc5_);
               }
            }
         }
         PerfTrace.slow("WorldRestaurant.loadRoom create/filter pending=" + _loc4_.length + " placed=" + placedItems.length,_loc9_,5);
         _loc9_ = getTimer();
         _loc7_ = 0;
         _loc8_ = int(_loc4_.length - 1);
         while(_loc8_ >= 0)
         {
            _loc5_ = _loc4_[_loc8_];
            if(_loc5_.surface && _loc5_.stackable)
            {
               placeItemInRoom(_loc5_,_loc5_.roomTileX,_loc5_.roomTileY,_loc5_.roomIndex);
               _loc4_.splice(_loc8_,1);
            }
            _loc8_--;
         }
         PerfTrace.slow("WorldRestaurant.loadRoom stackable surfaces pending=" + _loc4_.length + " placed=" + placedItems.length,_loc9_,5);
         _loc9_ = getTimer();
         for each(_loc5_ in _loc4_)
         {
            placeItemInRoom(_loc5_,_loc5_.roomTileX,_loc5_.roomTileY,_loc5_.roomIndex);
         }
         PerfTrace.slow("WorldRestaurant.loadRoom remaining items placed=" + placedItems.length,_loc9_,5);
         _loc9_ = getTimer();
         paintMainFloorMap();
         paintOutsideAreaFloorMap();
         PerfTrace.slow("WorldRestaurant.loadRoom paint floor maps",_loc9_,5);
         PerfTrace.mark("WorldRestaurant.loadRoom end placedItems=" + placedItems.length);
      }
      
      private function placeDefaultRoomItem(param1:RoomItem, param2:int, param3:int) : void
      {
         param1.owned = true;
         placeRoomItem(param1,param2,param3);
         param1 = param1.clone();
         param1.owned = true;
         gameUser.addUsedRestaurantItem(param1.getUserItem());
      }
      
      public function isWalkable(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(!isTileOutOfBound(param1,param2))
         {
            _loc3_ = getTileIndex(param1,param2);
            if(wallMap[_loc3_] == null)
            {
               return itemMap[_loc3_].length == 0;
            }
            _loc4_ = 0;
            while(_loc4_ < itemMap[_loc3_].length)
            {
               if(itemMap[_loc3_][_loc4_].doorItem)
               {
                  return true;
               }
               _loc4_++;
            }
         }
         return false;
      }
      
      public function isValid(param1:RoomItem, param2:int, param3:int) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:RoomItem = null;
         var _loc10_:int = 0;
         if(param1.numTilesX == 0 && param1.numTilesY == 0)
         {
            return true;
         }
         if(isItemOutOfBound(param1,param2,param3))
         {
            return false;
         }
         if(param1.outdoor)
         {
            if(!isTileInOutsideArea(param2,param3))
            {
               return false;
            }
         }
         var _loc4_:int = getTileIndex(param2,param3);
         if(param1.floorTileItem)
         {
            if(param2 == 0 || param3 == 0)
            {
               return false;
            }
            return true;
         }
         if(param1.wallDecorationItem)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.numTilesX)
            {
               _loc6_ = 0;
               while(_loc6_ < param1.numTilesY)
               {
                  _loc7_ = getTileIndex(param1.tileX + _loc5_,param1.tileY + _loc6_);
                  if(wallMap[_loc7_] == null || itemMap[_loc7_].length > 1)
                  {
                     return false;
                  }
                  _loc6_++;
               }
               _loc5_++;
            }
            return true;
         }
         if(wallMap[_loc4_] != null)
         {
            if(!(param1.wallDecorationItem || param1.wallpaperItem))
            {
               return false;
            }
            if(param1.wallDecorationItem && itemMap[_loc4_].length > 1)
            {
               return false;
            }
         }
         else
         {
            if(param1.wallDecorationItem || param1.wallpaperItem)
            {
               return false;
            }
            _loc5_ = 0;
            while(_loc5_ < param1.numTilesX)
            {
               _loc6_ = 0;
               while(_loc6_ < param1.numTilesY)
               {
                  _loc8_ = itemMap[getTileIndex(param1.tileX + _loc5_,param1.tileY + _loc6_)];
                  _loc9_ = _loc8_[_loc8_.length - 1];
                  _loc10_ = 5;
                  if(_loc9_ == param1)
                  {
                     _loc9_ = _loc8_[_loc8_.length - 2];
                     _loc10_++;
                  }
                  if(Boolean(_loc9_) && (!param1.stackable || !_loc9_.surface))
                  {
                     return false;
                  }
                  if(_loc8_.length > _loc10_ - 1)
                  {
                     return false;
                  }
                  _loc6_++;
               }
               _loc5_++;
            }
         }
         if(param1.subItems != null)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.subItems.length)
            {
               if(!isValid(param1.subItems[_loc5_],param2 + param1.subItems[_loc5_].subItemTileOffsetX,param3 + param1.subItems[_loc5_].subItemTileOffsetY))
               {
                  return false;
               }
               _loc5_++;
            }
         }
         return true;
      }
      
      public function isItemOutOfBound(param1:RoomItem, param2:int, param3:int) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1.wallItem || param1.wallDecorationItem || param1.wallpaperItem)
         {
            return !(param2 >= 0 && param3 >= 0 && param2 < numTilesX && param3 < numTilesY);
         }
         if(param2 < 1 || param3 < 1)
         {
            return true;
         }
         _loc4_ = param2 + param1.numTilesX - 1;
         _loc5_ = param3 + param1.numTilesY - 1;
         if(_loc5_ >= numTilesY)
         {
            if(_loc4_ >= numOutsideTilesX || _loc5_ >= numTilesY + numOutsideTilesY)
            {
               return true;
            }
         }
         else if(_loc4_ >= numTilesX || _loc5_ >= numTilesY)
         {
            return true;
         }
         return false;
      }
      
      private function placeItemInRoom(param1:RoomItem, param2:int, param3:int, param4:int) : void
      {
         if(param4 == activeOutsideAreaRoomIndex)
         {
            param3 += numTilesY;
         }
         placeRoomItem(param1,param2,param3);
      }
      
      public function getPlots() : Array
      {
         return plots;
      }
      
      public function setRoomSize(param1:int, param2:int) : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         var _loc5_:RoomItem = null;
         if(this.numTilesX != param1 || this.numTilesY != param2)
         {
            this.numTilesX = param1;
            this.numTilesY = param2;
            if(floor)
            {
               floorLayer.removeChild(floor);
               floor.bitmapData.dispose();
            }
            floor = createFloorTileLayer(param1,param2);
            floor.x = -param2 * tileWidthHalf;
            floorLayer.addChild(floor);
            baseFloor.graphics.clear();
            fillBaseArea(baseFloor.graphics,15132390,1,1,param1,param2);
            baseOutsideAreaFloor.x = getScreenX(0,param2);
            baseOutsideAreaFloor.y = getScreenY(0,param2);
            if(outsideAreaFloor)
            {
               outsideAreaFloor.x = getScreenX(0,param2) - numOutsideTilesY * tileWidthHalf;
               outsideAreaFloor.y = getScreenY(0,param2);
            }
            billboard.setTilePosition(-4,param2);
            _loc3_ = new Array();
            _loc4_ = int(placedItems.length - 1);
            while(_loc4_ >= 0)
            {
               _loc5_ = placedItems[_loc4_];
               if(_loc5_.roomIndex == activeOutsideAreaRoomIndex)
               {
                  _loc3_.push(_loc5_);
                  removeRoomItem(_loc5_);
               }
               _loc4_--;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               placeItemInRoom(_loc5_,_loc5_.roomTileX,_loc5_.roomTileY,_loc5_.roomIndex);
               _loc4_++;
            }
            onFloorSizeChanged();
            if(hasEventListener(RestaurantEvent.EVENT_ROOM_SIZE_CHANGE))
            {
               dispatchEvent(new RestaurantEvent(RestaurantEvent.EVENT_ROOM_SIZE_CHANGE));
            }
         }
      }
   }
}

