package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import flash.events.MouseEvent;
   
   public class DebugAddDemand extends DebugEntryButton
   {
      
      private var demand:int;
      
      public function DebugAddDemand(param1:int)
      {
         this.demand = param1;
         super("Add " + param1 + " popularity",null);
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         if(WorldRestaurantPlay.instance)
         {
            WorldRestaurantPlay.instance.addDemand(demand);
         }
      }
      
      override public function isAvailable() : Boolean
      {
         return WorldRestaurantPlay.instance != null;
      }
   }
}

