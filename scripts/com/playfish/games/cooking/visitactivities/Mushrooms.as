package com.playfish.games.cooking.visitactivities
{
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import com.playfish.games.cooking.actors.GardenPlotActor;
   
   public class Mushrooms extends VisitActivity
   {
      
      private static const MUSHROOM_X:int = 480;
      
      private static const MUSHROOM_Y:int = -127;
      
      private static const TARGET_X:Number = -160;
      
      private static const TARGET_Y:Number = 280;
      
      private static const START_X:Number = 320;
      
      private static const START_Y:Number = 80;
      
      private static const MUSHROOM_STRINGS:Array = ["Mushroom01","Mushroom02"];
      
      private var acceleration:Number = 0.2;
      
      private var prevX:Number;
      
      private var prevY:Number;
      
      private var scroll:Boolean = true;
      
      public var clockContainerPlot:GardenPlotActor;
      
      private var mushrooms:Array = new Array();
      
      public var clickedPlotId:int;
      
      private var velocity:Number = 0;
      
      private var mushroomIndices:Array = new Array();
      
      private var scrollTimer:int = 1000;
      
      public function Mushrooms(param1:int)
      {
         super(param1);
      }
      
      private function reachedTarget() : Boolean
      {
         if(Math.abs(TARGET_X - restaurant.room.x) < 5)
         {
            return true;
         }
         return false;
      }
      
      override public function init(param1:WorldRestaurantPlay) : void
      {
         super.init(param1);
         param1.disablePlots();
         param1.focus(param1.getPlots()[4].x,param1.getPlots()[4].y);
      }
      
      override public function onActivityCompleted() : void
      {
         restaurant.enablePlots();
         super.onActivityCompleted();
      }
      
      override public function determineActivityItemLocations() : Boolean
      {
         activityItem = new ActivityItem(this,"PoisonousMushroom",ActivityItem.NON_BLOCKING);
         activityItem.setScreenPosition(false,MUSHROOM_X,MUSHROOM_Y);
         return true;
      }
      
      private function getYFromX(param1:Number) : Number
      {
         return (param1 - 320) / (TARGET_X - START_X) * (TARGET_Y - START_Y) + START_Y;
      }
      
      override public function tick(param1:uint) : void
      {
         super.tick(param1);
      }
      
      private function getVelocityFromDistance() : Number
      {
         var _loc1_:Number = TARGET_X - restaurant.room.x;
         return _loc1_ / 5;
      }
   }
}

