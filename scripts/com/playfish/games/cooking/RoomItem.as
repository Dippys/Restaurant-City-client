package com.playfish.games.cooking
{
   import com.playfish.games.cooking.actors.CleanerEmployee;
   import com.playfish.games.cooking.actors.Customer;
   import com.playfish.games.cooking.actors.Waitor;
   import com.playfish.games.cooking.itemfunctions.*;
   import com.playfish.games.cooking.ui.ToolTip;
   import com.playfish.games.cooking.utils.*;
   import flash.display.*;
   import flash.filters.*;
   import flash.geom.Rectangle;
   import flash.utils.*;
   
   public class RoomItem extends GameItemObject
   {
      
      public var tableItem:Boolean = false;
      
      public var fullGridSizeY:int;
      
      public var toiletWater:BaseObject;
      
      public var outdoor:Boolean = false;
      
      public var floorTileItem:Boolean = false;
      
      public var waiter:Waitor;
      
      public var fullGridSizeX:int;
      
      public var menuItem:Boolean = false;
      
      public var toilet:Boolean = false;
      
      public var decorItem:Boolean = false;
      
      public var subItemTileOffsetY:int = 0;
      
      public var itemHeight:Number;
      
      public var subItemTileOffsetX:int = 0;
      
      public var wallpaper:MovieClip;
      
      private var rotationCount:int;
      
      public var wallpaperItem:Boolean = false;
      
      public var doorTimer:int;
      
      public var wallDecorationItem:Boolean = false;
      
      public var roomTileX:int = -1;
      
      public var roomTileY:int = -1;
      
      public var toiletStatus:BaseObject;
      
      public var subItems:Array = null;
      
      public var editable:Boolean = true;
      
      public var musicPlayer:Boolean = false;
      
      public var tileX:int = -1;
      
      public var tileY:int = -1;
      
      public var subItemAutoSplit:Boolean = false;
      
      public var mailItem:Boolean = false;
      
      public var notGiftable:Boolean = false;
      
      private var glowEffect:GlowEffect;
      
      public var chairItem:Boolean = false;
      
      public var bed:Boolean = false;
      
      public var curHeight:int = 0;
      
      public var sink:Boolean = false;
      
      public var drink:Boolean = false;
      
      public var numTilesX:int;
      
      public var noInventory:Boolean = false;
      
      public var notSellable:Boolean = false;
      
      public var numTilesY:int;
      
      public var kitchen:Boolean = false;
      
      public var attachedWalls:Array;
      
      public var gridLayer:Shape;
      
      public var surface:Boolean = false;
      
      public var wallpaperRoomItem:RoomItem;
      
      public var cleaner:CleanerEmployee;
      
      public var roomIndex:int = 0;
      
      public var doorMask:Array;
      
      public var itemFunctions:Array;
      
      public var unique:Boolean = false;
      
      public var canOrderDrink:Boolean;
      
      public var inUserTaskQueue:Boolean = false;
      
      public var parentItem:RoomItem = null;
      
      public var doorItem:Boolean = false;
      
      public var stackable:Boolean = false;
      
      public var toolTip:ToolTip;
      
      public var customer:Customer;
      
      public var tableTopOrder:DishOrder;
      
      public var interactive:Boolean = false;
      
      public var canOrderFood:Boolean;
      
      public var usageCount:int;
      
      public var wallDivider:Boolean = false;
      
      public var achievementItem:Boolean = false;
      
      public var operateTimePercentage:int = 100;
      
      public var wallItem:Boolean = false;
      
      public function RoomItem(param1:Object, param2:UserItem, param3:String = null)
      {
         var _loc5_:int = 0;
         if(param3 == null)
         {
            param3 = param1.className;
         }
         super(param1,param2,param3);
         content.stop();
         if(param1.group.types != null)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.group.types.length)
            {
               this[param1.group.types[_loc5_]] = true;
               _loc5_++;
            }
         }
         if(param1.types)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.types.length)
            {
               this[param1.types[_loc5_]] = true;
               _loc5_++;
            }
         }
         if(param1.operateTimePercentage)
         {
            operateTimePercentage = int(param1.operateTimePercentage);
         }
         if(content.mc_mask)
         {
            content.mc_mask.visible = false;
         }
         var _loc4_:Rectangle = getBounds(this);
         numTilesX = Math.max(1,Math.round(_loc4_.right / WorldRestaurant.tileWidthHalf));
         numTilesY = Math.max(1,Math.round(_loc4_.bottom / WorldRestaurant.tileHeightHalf) - numTilesX);
         if(param1.sizeX)
         {
            numTilesX = param1.sizeX;
         }
         if(param1.sizeY)
         {
            numTilesY = param1.sizeY;
         }
         setGridSize(numTilesX,numTilesY);
         fullGridSizeX = numTilesX;
         fullGridSizeY = numTilesY;
         itemHeight = -_loc4_.top + (WorldRestaurant.tileHeight * numTilesY - _loc4_.bottom);
         if(!isAnimated(content,true))
         {
            cacheAsBitmap = true;
         }
         Debug.out(param3 + " numTileX=" + numTilesX + " numTileY=" + numTilesY + " itemHeight=" + itemHeight + " cacheAsBitmap=" + cacheAsBitmap);
      }
      
      private static function getRowMask(param1:RoomItem, param2:int) : Shape
      {
         var _loc3_:Number = param1.itemHeight + 20;
         var _loc4_:Shape = new Shape();
         _loc4_.graphics.beginFill(255 << param2 * 8,1);
         _loc4_.graphics.moveTo(WorldRestaurant.getScreenX(0,param2 + 1),WorldRestaurant.getScreenY(0,param2 + 1));
         _loc4_.graphics.lineTo(WorldRestaurant.getScreenX(param1.fullGridSizeX,param2 + 1),WorldRestaurant.getScreenY(param1.fullGridSizeX,param2 + 1));
         _loc4_.graphics.lineTo(WorldRestaurant.getScreenX(param1.fullGridSizeX,param2),WorldRestaurant.getScreenY(param1.fullGridSizeX,param2));
         _loc4_.graphics.lineTo(WorldRestaurant.getScreenX(param1.fullGridSizeX,param2),WorldRestaurant.getScreenY(param1.fullGridSizeX,param2) - _loc3_);
         _loc4_.graphics.lineTo(WorldRestaurant.getScreenX(0,param2),WorldRestaurant.getScreenY(0,param2) - _loc3_);
         _loc4_.graphics.lineTo(WorldRestaurant.getScreenX(0,param2 + 1),WorldRestaurant.getScreenY(0,param2 + 1) - _loc3_);
         _loc4_.graphics.lineTo(WorldRestaurant.getScreenX(0,param2 + 1),WorldRestaurant.getScreenY(0,param2 + 1));
         _loc4_.graphics.endFill();
         return _loc4_;
      }
      
      public static function createRoomItems(param1:Object, param2:UserItem) : RoomItem
      {
         var _loc4_:RoomItem = null;
         var _loc5_:int = 0;
         var _loc6_:MovieClip = null;
         var _loc7_:RoomItem = null;
         var _loc8_:RoomItem = null;
         var _loc9_:Shape = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc3_:RoomItem = new RoomItem(param1,null);
         if(_loc3_.content["sub0"])
         {
            _loc4_ = new RoomItem(param1,null,getQualifiedClassName(_loc3_.content["sub0"]));
            _loc4_.subItems = new Array();
            _loc5_ = 1;
            while(true)
            {
               _loc6_ = _loc3_.content["sub" + _loc5_];
               if(!_loc6_)
               {
                  break;
               }
               _loc7_ = new RoomItem(param1,null,getQualifiedClassName(_loc6_));
               _loc7_.parentItem = _loc4_;
               _loc7_.subItemTileOffsetX = WorldRestaurant.getTileIndexX(_loc6_.x,_loc6_.y);
               _loc7_.subItemTileOffsetY = WorldRestaurant.getTileIndexY(_loc6_.x,_loc6_.y);
               _loc4_.subItems.push(_loc7_);
               _loc4_.fullGridSizeX = Math.max(_loc4_.fullGridSizeX,_loc7_.subItemTileOffsetX + 1);
               _loc4_.fullGridSizeY = Math.max(_loc4_.fullGridSizeY,_loc7_.subItemTileOffsetY + 1);
               _loc5_++;
            }
            if(param2)
            {
               _loc4_.setUserItem(param2);
            }
            return _loc4_;
         }
         if(_loc3_.numTilesX > 1 || _loc3_.numTilesY > 1)
         {
            _loc3_.subItemAutoSplit = true;
            _loc3_.subItems = new Array();
            if(_loc3_.numTilesX == _loc3_.numTilesY)
            {
               _loc8_ = new RoomItem(param1,null);
               _loc8_.mouseEnabled = false;
               _loc8_.mouseChildren = false;
               _loc8_.setGridSize(0,0);
               _loc8_.parentItem = _loc3_;
               _loc9_ = getLeftHalfMask(_loc3_);
               _loc8_.content.addChild(_loc9_);
               _loc8_.content.mask = _loc9_;
               _loc8_.subItemTileOffsetX = _loc3_.fullGridSizeX - 1;
               _loc8_.subItemTileOffsetY = _loc3_.fullGridSizeY - 1;
               _loc8_.content.x = -WorldRestaurant.getScreenX(_loc8_.subItemTileOffsetX,_loc8_.subItemTileOffsetY);
               _loc8_.content.y = -WorldRestaurant.getScreenY(_loc8_.subItemTileOffsetX,_loc8_.subItemTileOffsetY);
               _loc3_.subItems.push(_loc8_);
            }
            else
            {
               _loc10_ = Math.max(_loc3_.fullGridSizeX,_loc3_.fullGridSizeY);
               _loc11_ = 1;
               while(_loc11_ < _loc10_)
               {
                  _loc8_ = new RoomItem(param1,null);
                  _loc8_.mouseEnabled = false;
                  _loc8_.mouseChildren = false;
                  _loc8_.setGridSize(0,0);
                  _loc8_.parentItem = _loc3_;
                  _loc9_ = getRowMask(_loc3_,_loc11_);
                  _loc8_.content.addChild(_loc9_);
                  _loc8_.content.mask = _loc9_;
                  _loc8_.subItemTileOffsetX = 0;
                  _loc8_.subItemTileOffsetY = _loc11_;
                  _loc8_.content.x = -WorldRestaurant.getScreenX(_loc8_.subItemTileOffsetX,_loc8_.subItemTileOffsetY);
                  _loc8_.content.y = -WorldRestaurant.getScreenY(_loc8_.subItemTileOffsetX,_loc8_.subItemTileOffsetY);
                  _loc3_.subItems.push(_loc8_);
                  if(_loc11_ >= _loc3_.fullGridSizeY)
                  {
                     _loc8_.visible = false;
                  }
                  _loc11_++;
               }
            }
         }
         if(param2)
         {
            _loc3_.setUserItem(param2);
         }
         return _loc3_;
      }
      
      private static function getLeftHalfMask(param1:RoomItem) : Shape
      {
         var _loc2_:int = Math.max(param1.fullGridSizeX,param1.fullGridSizeY);
         var _loc3_:Number = param1.itemHeight + 20;
         var _loc4_:Shape = new Shape();
         _loc4_.graphics.beginFill(0,1);
         _loc4_.graphics.moveTo(0,-_loc3_);
         _loc4_.graphics.lineTo(0,WorldRestaurant.getScreenY(_loc2_,_loc2_));
         _loc4_.graphics.lineTo(WorldRestaurant.getScreenX(0,_loc2_),WorldRestaurant.getScreenY(0,_loc2_));
         _loc4_.graphics.lineTo(WorldRestaurant.getScreenX(0,_loc2_),WorldRestaurant.getScreenY(0,_loc2_) - _loc3_);
         _loc4_.graphics.endFill();
         return _loc4_;
      }
      
      private static function getRightHalfMask(param1:RoomItem) : Shape
      {
         var _loc2_:int = Math.max(param1.fullGridSizeX,param1.fullGridSizeY);
         var _loc3_:Number = param1.itemHeight + 20;
         var _loc4_:Shape = new Shape();
         _loc4_.graphics.beginFill(0,1);
         _loc4_.graphics.moveTo(0,-_loc3_);
         _loc4_.graphics.lineTo(WorldRestaurant.getScreenX(param1.numTilesX,param1.numTilesY),WorldRestaurant.getScreenY(param1.numTilesX,param1.numTilesY));
         _loc4_.graphics.lineTo(WorldRestaurant.getScreenX(param1.numTilesX,0),WorldRestaurant.getScreenY(param1.numTilesX,0));
         _loc4_.graphics.lineTo(WorldRestaurant.getScreenX(param1.numTilesX,0),WorldRestaurant.getScreenY(param1.numTilesX,0) - _loc3_);
         _loc4_.graphics.endFill();
         return _loc4_;
      }
      
      override public function setUserItem(param1:UserItem) : void
      {
         super.setUserItem(param1);
         roomTileX = param1.x;
         roomTileY = param1.y;
         setTilePosition(param1.x,param1.y);
         roomIndex = param1.roomIndex;
         var _loc2_:int = param1.data as int;
         setRotation(_loc2_ & 0x0F);
         usageCount = (_loc2_ & 0xF0) >> 4;
      }
      
      public function setRotation(param1:int) : void
      {
         var _loc2_:int = getRotationCount();
         var _loc3_:int = 0;
         if(param1 > _loc2_)
         {
            _loc3_ = param1 - _loc2_;
         }
         else if(param1 < _loc2_)
         {
            _loc3_ = getMaxRotationCount() - _loc2_ + param1;
         }
         var _loc4_:Number = 0;
         while(_loc4_ < _loc3_)
         {
            rotate();
            _loc4_++;
         }
      }
      
      public function setGridSize(param1:int, param2:int) : void
      {
         numTilesX = param1;
         numTilesY = param2;
      }
      
      public function copyRotation(param1:RoomItem) : void
      {
         setRotation(param1.getRotationCount());
      }
      
      public function getTopHeight() : Number
      {
         return itemHeight + curHeight;
      }
      
      public function setHeight(param1:int) : void
      {
         var _loc2_:Number = NaN;
         if(param1 != curHeight)
         {
            y += curHeight;
            curHeight = param1;
            y -= curHeight;
            if(gridLayer != null)
            {
               gridLayer.y = curHeight;
            }
            if(subItems != null)
            {
               _loc2_ = 0;
               while(_loc2_ < subItems.length)
               {
                  subItems[_loc2_].setHeight(curHeight);
                  _loc2_++;
               }
            }
         }
      }
      
      override public function manipulate(param1:int) : void
      {
         var _loc2_:Number = NaN;
         super.manipulate(param1);
         if(subItems != null)
         {
            _loc2_ = 0;
            while(_loc2_ < subItems.length)
            {
               subItems[_loc2_].manipulate(param1);
               _loc2_++;
            }
         }
      }
      
      public function rotate() : void
      {
         var _loc2_:RoomItem = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Shape = null;
         rotationCount = (rotationCount + 1) % getMaxRotationCount();
         setGridSize(numTilesY,numTilesX);
         var _loc1_:int = fullGridSizeX;
         fullGridSizeX = fullGridSizeY;
         fullGridSizeY = _loc1_;
         if(content.currentFrame == content.totalFrames)
         {
            content.gotoAndStop(1);
         }
         else
         {
            content.nextFrame();
         }
         if(subItems != null)
         {
            if(subItemAutoSplit)
            {
               if(fullGridSizeX == fullGridSizeY)
               {
                  _loc2_ = subItems[0];
                  _loc2_.rotate();
                  _loc2_.subItemTileOffsetX = fullGridSizeX - 1;
                  _loc2_.subItemTileOffsetY = fullGridSizeY - 1;
                  _loc2_.content.x = -WorldRestaurant.getScreenX(_loc2_.subItemTileOffsetX,_loc2_.subItemTileOffsetY);
                  _loc2_.content.y = -WorldRestaurant.getScreenY(_loc2_.subItemTileOffsetX,_loc2_.subItemTileOffsetY);
                  _loc2_.setTilePosition(tileX + _loc2_.subItemTileOffsetX,tileY + _loc2_.subItemTileOffsetY);
               }
               else
               {
                  _loc3_ = 0;
                  while(_loc3_ < subItems.length)
                  {
                     _loc2_ = subItems[_loc3_];
                     _loc2_.rotate();
                     _loc4_ = _loc3_ + 1;
                     if(_loc4_ < fullGridSizeY)
                     {
                        if(_loc2_.content.mask)
                        {
                           _loc2_.content.removeChild(_loc2_.content.mask);
                           _loc2_.content.mask = null;
                        }
                        _loc5_ = getRowMask(this,_loc3_ + 1);
                        _loc2_.content.addChild(_loc5_);
                        _loc2_.content.mask = _loc5_;
                        _loc2_.visible = true;
                     }
                     else
                     {
                        _loc2_.visible = false;
                     }
                     _loc3_++;
                  }
               }
            }
            else
            {
               _loc3_ = 0;
               while(_loc3_ < subItems.length)
               {
                  subItems[_loc3_].rotate();
                  _loc1_ = int(subItems[_loc3_].subItemTileOffsetX);
                  subItems[_loc3_].subItemTileOffsetX = -subItems[_loc3_].subItemTileOffsetY;
                  subItems[_loc3_].subItemTileOffsetY = _loc1_;
                  subItems[_loc3_].setTilePosition(tileX + subItems[_loc3_].subItemTileOffsetX,tileY + subItems[_loc3_].subItemTileOffsetY);
                  _loc3_++;
               }
            }
         }
      }
      
      public function clone() : RoomItem
      {
         var _loc1_:RoomItem = createRoomItems(itemConfig,getUserItem());
         _loc1_.editable = editable;
         return _loc1_;
      }
      
      public function initFunctions(param1:WorldRestaurantPlay) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:RoomItemFunction = null;
         if(itemConfig.functions)
         {
            _loc2_ = itemConfig.functions.split(/\s*,\s*/);
            if(_loc2_.length > 0)
            {
               itemFunctions = new Array();
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = RoomItemFunction.create(_loc2_[_loc3_],this);
                  if(_loc4_)
                  {
                     itemFunctions.push(_loc4_);
                     _loc4_.init(param1);
                  }
                  _loc3_++;
               }
               if(itemFunctions.length <= 0)
               {
                  itemFunctions = null;
               }
            }
         }
      }
      
      public function getRotationCount() : int
      {
         return rotationCount;
      }
      
      public function setTilePosition(param1:int, param2:int) : void
      {
         var _loc3_:Number = NaN;
         tileX = param1;
         tileY = param2;
         x = WorldRestaurant.getScreenX(tileX,tileY);
         y = WorldRestaurant.getScreenY(tileX,tileY) - curHeight;
         if(subItems != null)
         {
            _loc3_ = 0;
            while(_loc3_ < subItems.length)
            {
               subItems[_loc3_].setTilePosition(param1 + subItems[_loc3_].subItemTileOffsetX,param2 + subItems[_loc3_].subItemTileOffsetY);
               _loc3_++;
            }
         }
      }
      
      public function glow(param1:Boolean, param2:int = 16777215) : void
      {
         var _loc3_:Number = NaN;
         if(param1)
         {
            if(glowEffect == null)
            {
               glowEffect = new GlowEffect(this,param2);
            }
         }
         else if(glowEffect != null)
         {
            glowEffect.remove();
            glowEffect = null;
         }
         if(subItems != null)
         {
            _loc3_ = 0;
            while(_loc3_ < subItems.length)
            {
               subItems[_loc3_].glow(param1,param2);
               _loc3_++;
            }
         }
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:int = 0;
         if(itemFunctions)
         {
            _loc2_ = 0;
            while(_loc2_ < itemFunctions.length)
            {
               itemFunctions[_loc2_].tick(param1);
               _loc2_++;
            }
         }
      }
      
      public function getMaxRotationCount() : int
      {
         if(subItems != null && !subItemAutoSplit)
         {
            return 4;
         }
         return content.totalFrames;
      }
      
      public function isBroken() : Boolean
      {
         return Boolean(itemConfig.breakCount) && usageCount >= itemConfig.breakCount;
      }
      
      public function hideGrid() : void
      {
         var _loc1_:Number = NaN;
         if(Boolean(gridLayer) && Boolean(gridLayer.parent))
         {
            gridLayer.parent.removeChild(gridLayer);
            if(subItems != null)
            {
               _loc1_ = 0;
               while(_loc1_ < subItems.length)
               {
                  subItems[_loc1_].hideGrid();
                  _loc1_++;
               }
            }
         }
      }
      
      public function isRotatable() : Boolean
      {
         if(wallDecorationItem || wallItem)
         {
            return false;
         }
         return getMaxRotationCount() > 1;
      }
      
      public function setPosition(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         x = param1;
         y = param2 - curHeight;
         if(subItems != null)
         {
            _loc3_ = 0;
            while(_loc3_ < subItems.length)
            {
               subItems[_loc3_].setPosition(param1 + WorldRestaurant.getScreenX(subItems[_loc3_].subItemTileOffsetX,subItems[_loc3_].subItemTileOffsetY),param2 + WorldRestaurant.getScreenY(subItems[_loc3_].subItemTileOffsetX,subItems[_loc3_].subItemTileOffsetY));
               _loc3_++;
            }
         }
      }
      
      public function getBytes() : ByteArray
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeUnsignedInt(itemConfig.nameHash);
         _loc1_.writeShort(tileX);
         _loc1_.writeShort(tileY);
         _loc1_.writeByte(getRotationCount());
         _loc1_.writeBoolean(editable);
         return _loc1_;
      }
      
      public function destroyFunctions() : void
      {
         var _loc1_:int = 0;
         if(itemFunctions)
         {
            _loc1_ = 0;
            while(_loc1_ < itemFunctions.length)
            {
               itemFunctions[_loc1_].destroy();
               _loc1_++;
            }
            itemFunctions = null;
         }
      }
      
      public function setGrid(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         if(numTilesX > 0 && numTilesY > 0)
         {
            if(gridLayer == null)
            {
               if(!floorTileItem && !wallDecorationItem)
               {
                  gridLayer = new Shape();
               }
            }
         }
         if(gridLayer != null)
         {
            gridLayer.graphics.clear();
            gridLayer.y = curHeight;
            if(param1)
            {
               WorldRestaurant.paintGrid(gridLayer,0,0,numTilesX,numTilesY,10551200,5308240,0.5);
            }
            else
            {
               WorldRestaurant.paintGrid(gridLayer,0,0,numTilesX,numTilesY,16744576,16711680,0.5);
            }
            if(subItems != null)
            {
               _loc2_ = 0;
               while(_loc2_ < subItems.length)
               {
                  subItems[_loc2_].setGrid(param1);
                  _loc2_++;
               }
            }
         }
      }
      
      public function showGrid() : void
      {
         var _loc1_:Number = NaN;
         if(Boolean(gridLayer) && !contains(gridLayer))
         {
            addChildAt(gridLayer,0);
            if(subItems != null)
            {
               _loc1_ = 0;
               while(_loc1_ < subItems.length)
               {
                  subItems[_loc1_].showGrid();
                  _loc1_++;
               }
            }
         }
      }
      
      private function isAnimated(param1:MovieClip, param2:Boolean = false) : Boolean
      {
         var _loc4_:DisplayObject = null;
         if(!param2 && param1.totalFrames > 1)
         {
            return true;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ is MovieClip)
            {
               if(isAnimated(MovieClip(_loc4_)))
               {
                  return true;
               }
            }
            _loc3_++;
         }
         return false;
      }
      
      override public function getUserItem() : UserItem
      {
         var _loc1_:UserItem = super.getUserItem();
         _loc1_.x = roomTileX;
         _loc1_.y = roomTileY;
         _loc1_.data = getRotationCount() | usageCount << 4;
         _loc1_.roomIndex = roomIndex;
         return _loc1_;
      }
   }
}

