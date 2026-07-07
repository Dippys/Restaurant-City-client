package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.RoomItem;
   
   public class AddMaxDemand2 extends AddMaxDemand
   {
      
      private static const DEMAND_TO_ADD:int = 20;
      
      public function AddMaxDemand2(param1:RoomItem)
      {
         super(param1,DEMAND_TO_ADD);
      }
   }
}

