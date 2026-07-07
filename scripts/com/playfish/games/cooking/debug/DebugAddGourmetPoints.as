package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import flash.events.MouseEvent;
   
   public class DebugAddGourmetPoints extends DebugEntryButton
   {
      
      private var points:int;
      
      public function DebugAddGourmetPoints(param1:int)
      {
         this.points = param1;
         super("Add " + param1 + " Gourmet Points",null);
      }
      
      override public function onClick(param1:MouseEvent) : void
      {
         if(WorldRestaurantPlay.instance)
         {
            WorldRestaurantPlay.instance.addGourmetPoints(points);
         }
         else
         {
            GameWorld.addGourmetPoints(points);
         }
      }
      
      override public function isAvailable() : Boolean
      {
         return true;
      }
   }
}

