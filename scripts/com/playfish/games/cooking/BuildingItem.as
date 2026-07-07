package com.playfish.games.cooking
{
   import com.playfish.games.cooking.itemfunctions.street.StreetItemFunction;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   
   public class BuildingItem extends GameItemObject
   {
      
      public var flipped:Boolean;
      
      public var itemFunctions:Array;
      
      public var draggable:Boolean;
      
      public var roof:Boolean;
      
      public var wallTile:Boolean;
      
      public var body:Boolean;
      
      public var banner:Boolean;
      
      public var onFloor:Boolean;
      
      public var wallAttach:Boolean;
      
      private var glowStep:Number = -1;
      
      public var type:int = -1;
      
      public var notGiftable:Boolean;
      
      public function BuildingItem(param1:UserItem)
      {
         super(param1.itemConfig,param1,param1.itemConfig.className);
         this.x = param1.x;
         this.y = param1.y;
         if(param1.data == 1)
         {
            this.flipped = true;
         }
         var _loc2_:int = 0;
         while(_loc2_ < itemConfig.group.types.length)
         {
            this[itemConfig.group.types[_loc2_]] = true;
            _loc2_++;
         }
         var _loc3_:MovieClip = getChildMovieClipInstance("mc_rect");
         if(_loc3_)
         {
            _loc3_.visible = false;
         }
         this.drawPriority = itemConfig.group.drawPriority;
      }
      
      override public function setUserItem(param1:UserItem) : void
      {
         super.setUserItem(param1);
         this.x = param1.x;
         this.y = param1.y;
         if(param1.data == 1)
         {
            this.flipped = true;
         }
      }
      
      public function isFlippable() : Boolean
      {
         return !banner && !roof && !body && !wallTile;
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
      
      public function glow(param1:Boolean) : void
      {
         if(param1 != (glowStep != -1))
         {
            if(param1)
            {
               glowStep = 0;
            }
            else
            {
               glowStep = -1;
               filters = null;
            }
         }
      }
      
      public function clone() : BuildingItem
      {
         var _loc1_:BuildingItem = new BuildingItem(getUserItem());
         _loc1_.owned = owned;
         return _loc1_;
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         if(glowStep != -1)
         {
            glowStep += 0.1;
            _loc2_ = (Math.sin(glowStep) + 1) / 4;
            _loc3_ = 1 - _loc2_;
            _loc4_ = _loc2_ * 255;
            _loc5_ = new Array(_loc3_,0,0,0,_loc4_,0,_loc3_,0,0,_loc4_,0,0,_loc3_,0,_loc4_,0,0,0,1,0);
            filters = new Array(new ColorMatrixFilter(_loc5_));
         }
         if(itemFunctions)
         {
            _loc6_ = 0;
            while(_loc6_ < itemFunctions.length)
            {
               itemFunctions[_loc6_].tick(param1);
               _loc6_++;
            }
         }
      }
      
      public function initFunctions(param1:StreetBuilding) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:StreetItemFunction = null;
         if(itemConfig.functions)
         {
            _loc2_ = itemConfig.functions.split(/\s*,\s*/);
            if(_loc2_.length > 0)
            {
               itemFunctions = new Array();
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = StreetItemFunction.create(_loc2_[_loc3_],this);
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
      
      override public function getUserItem() : UserItem
      {
         var _loc1_:UserItem = super.getUserItem();
         _loc1_.x = x;
         _loc1_.y = y;
         if(flipped)
         {
            _loc1_.data = 1;
         }
         else
         {
            _loc1_.data = 0;
         }
         return _loc1_;
      }
      
      public function flip() : void
      {
         flipped = !flipped;
         if(flipped)
         {
            manipulate(FLIP_HORIZONTAL);
         }
         else
         {
            manipulate(0);
         }
      }
   }
}

