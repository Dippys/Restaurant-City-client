package com.playfish.games.cooking
{
   import com.playfish.games.cooking.actors.Customer;
   import flash.display.MovieClip;
   
   public class DishOrder extends AnimatedObject
   {
      
      public var kitchen:RoomItem;
      
      public var chair:RoomItem;
      
      public var inUserTaskQueue:Boolean = false;
      
      public var tileX:int;
      
      public var recipe:Recipe;
      
      public var tileY:int;
      
      public var table:RoomItem;
      
      public var customer:Customer;
      
      public function DishOrder(param1:Recipe)
      {
         super(param1.className);
         this.recipe = param1;
         var _loc2_:MovieClip = getChildMovieClipInstance("mc_plate");
         if(_loc2_)
         {
            _loc2_.gotoAndStop(param1.level);
         }
         stop();
      }
   }
}

