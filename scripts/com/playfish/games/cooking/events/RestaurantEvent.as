package com.playfish.games.cooking.events
{
   import flash.events.Event;
   
   public class RestaurantEvent extends Event
   {
      
      public static const EVENT_ROOM_SIZE_CHANGE:String = "room_size_change";
      
      public static const EVENT_OUTSIDE_AREA_SIZE_CHANGE:String = "outside_area_size_change";
      
      public function RestaurantEvent(param1:String)
      {
         super(param1);
      }
   }
}

