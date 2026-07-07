package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.RoomItem;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import flash.display.MovieClip;
   
   public class ClockArms extends RoomItemFunction
   {
      
      public function ClockArms(param1:RoomItem)
      {
         super(param1);
      }
      
      override public function init(param1:WorldRestaurantPlay) : void
      {
         tick(0);
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:Date = new Date();
         var _loc3_:MovieClip = roomItem.getChildMovieClipInstance("mc_content");
         _loc3_.mc_hour.rotation = 30 * (_loc2_.hours % 12 + _loc2_.minutes / 60);
         _loc3_.mc_minute.rotation = 6 * _loc2_.minutes;
      }
   }
}

