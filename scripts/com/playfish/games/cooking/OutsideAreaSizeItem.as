package com.playfish.games.cooking
{
   import com.playfish.rpc.cooking.OwnedItem;
   
   public class OutsideAreaSizeItem extends UserItem
   {
      
      public var unlockLevel:int;
      
      public var sizeX:int;
      
      public var sizeY:int;
      
      public function OutsideAreaSizeItem(param1:Object, param2:OwnedItem = null)
      {
         super(param1,param2);
         this.unlockLevel = param1.unlockLevel;
         this.sizeX = param1.sizeX;
         this.sizeY = param1.sizeY;
      }
   }
}

