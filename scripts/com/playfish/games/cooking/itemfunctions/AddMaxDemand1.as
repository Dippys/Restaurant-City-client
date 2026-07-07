package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.RoomItem;
   
   public class AddMaxDemand1 extends AddMaxDemand
   {
      
      private static const DEMAND_TO_ADD:int = 10;
      
      public function AddMaxDemand1(param1:RoomItem)
      {
         super(param1,DEMAND_TO_ADD);
      }
   }
}

