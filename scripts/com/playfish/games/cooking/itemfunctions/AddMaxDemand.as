package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.*;
   
   public class AddMaxDemand extends RoomItemFunction
   {
      
      public static var addedItems:Array = new Array();
      
      public var demandToAdd:int = 20;
      
      public var restaurant:WorldRestaurantPlay;
      
      public function AddMaxDemand(param1:RoomItem, param2:int)
      {
         super(param1);
         this.demandToAdd = param2;
      }
      
      override public function init(param1:WorldRestaurantPlay) : void
      {
         this.restaurant = param1;
         if(addedItems.indexOf(int(roomItem.itemConfig.id)) == -1)
         {
            param1.maxDemand += demandToAdd;
         }
         addedItems.push(int(roomItem.itemConfig.id));
      }
      
      override public function destroy() : void
      {
         super.destroy();
         var _loc1_:int = addedItems.indexOf(int(roomItem.itemConfig.id));
         addedItems.splice(_loc1_,1);
         _loc1_ = addedItems.indexOf(int(roomItem.itemConfig.id));
         if(_loc1_ == -1)
         {
            restaurant.maxDemand -= demandToAdd;
         }
         restaurant = null;
      }
   }
}

