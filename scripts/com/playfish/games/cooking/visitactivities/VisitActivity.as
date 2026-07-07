package com.playfish.games.cooking.visitactivities
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import com.playfish.games.cooking.ui.WorldPopUp;
   import com.playfish.games.cooking.usertask.VisitActivityTask;
   import flash.display.MovieClip;
   
   public class VisitActivity
   {
      
      public static const ACTIVITY_STRINGS:Array = ["ActivityFire","ActivityWaterLeak","ActivityMushroom","ActivitySkunk","ActivityBear","ActivityPenguin"];
      
      public static const ACTIVITY_FIRE:int = 0;
      
      public static const ACTIVITY_WATERLEAK:int = 1;
      
      public static const ACTIVITY_MUSHROOM:int = 2;
      
      public static const ACTIVITY_SKUNK:int = 3;
      
      public static const ACTIVITY_BEAR:int = 4;
      
      public static const ACTIVITY_PENGUIN:int = 5;
      
      public static const STATE_INIT:int = 0;
      
      public static const STATE_RUNNING:int = 1;
      
      protected var activityItem:ActivityItem;
      
      protected var popUp:WorldPopUp;
      
      public var state:int = 0;
      
      private var activitySpeechBubble:ActivitySpeechBubble;
      
      protected var helpWantedMC:MovieClip;
      
      public var activityType:int;
      
      public var tileX:int;
      
      public var tileY:int;
      
      public var initComplete:Boolean = false;
      
      protected var activityTask:VisitActivityTask;
      
      public var restaurant:WorldRestaurantPlay;
      
      public function VisitActivity(param1:int)
      {
         super();
         this.activityType = param1;
      }
      
      public static function create(param1:int) : VisitActivity
      {
         var _loc2_:Class = null;
         switch(param1)
         {
            case ACTIVITY_FIRE:
               _loc2_ = Fire;
               break;
            case ACTIVITY_WATERLEAK:
               _loc2_ = WaterLeak;
               break;
            case ACTIVITY_MUSHROOM:
               _loc2_ = Mushrooms;
               break;
            case ACTIVITY_SKUNK:
               _loc2_ = Skunk;
               break;
            case ACTIVITY_BEAR:
               _loc2_ = Bear;
               break;
            case ACTIVITY_PENGUIN:
               _loc2_ = Penguin;
         }
         if(_loc2_)
         {
            return new _loc2_(param1);
         }
         Debug.out("Error: VisitActivity.create() returning null activity");
         return null;
      }
      
      public function run() : Boolean
      {
         if(determineActivityItemLocations())
         {
            addItemsToRestaurant();
            return true;
         }
         return false;
      }
      
      public function init(param1:WorldRestaurantPlay) : void
      {
         this.restaurant = param1;
         activitySpeechBubble = new ActivitySpeechBubble(param1,ACTIVITY_STRINGS[activityType]);
         state = STATE_RUNNING;
      }
      
      protected function addItemsToRestaurant() : void
      {
         activityItem.addToRestaurant();
      }
      
      public function getRoomItem() : ActivityItem
      {
         return activityItem;
      }
      
      public function onActivityCompleted() : void
      {
         activityItem.remove();
         activitySpeechBubble.retract();
      }
      
      public function tick(param1:uint) : void
      {
         if(activitySpeechBubble)
         {
            activitySpeechBubble.tick(param1);
         }
      }
      
      public function determineActivityItemLocations() : Boolean
      {
         return false;
      }
   }
}

