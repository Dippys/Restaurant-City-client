package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.RoomItem;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   
   public class AddCustomerWaitTime extends RoomItemFunction
   {
      
      public function AddCustomerWaitTime(param1:RoomItem)
      {
         super(param1);
      }
      
      override public function init(param1:WorldRestaurantPlay) : void
      {
         param1.customerWaitTimeModifier = 1000;
      }
   }
}

