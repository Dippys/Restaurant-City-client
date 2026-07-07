package com.playfish.games.cooking.foodking
{
   import com.playfish.games.cooking.Debug;
   import com.playfish.games.cooking.Engine;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import com.playfish.games.cooking.WorldStreet;
   import com.playfish.games.cooking.actors.FoodkingActor;
   import com.playfish.games.cooking.actors.FoodkingStreetActor;
   import com.playfish.games.cooking.debug.DebugAddBlackSheep;
   import com.playfish.games.cooking.ui.FoodKingPopUp;
   import flash.events.MouseEvent;
   
   public class FoodKing
   {
      
      public static var foundForSession:Boolean = false;
      
      public static var chanceOfAppearing:int = 20;
      
      public var roomActor:FoodkingActor;
      
      public var street:WorldStreet;
      
      private var timerOn:Boolean = false;
      
      private var appearTimer:int = 0;
      
      public var streetActor:FoodkingStreetActor;
      
      public var restaurant:WorldRestaurantPlay;
      
      public function FoodKing(param1:WorldRestaurantPlay, param2:WorldStreet)
      {
         super();
         this.restaurant = param1;
         this.street = param2;
      }
      
      private function showBlackSheepPopUp() : void
      {
         var _loc1_:FoodKingPopUp = new FoodKingPopUp(this);
         _loc1_.show();
      }
      
      public function removeCurrentInstance() : void
      {
         if(roomActor)
         {
            roomActor.removeEventListener(MouseEvent.CLICK,onBlackSheepClick);
            restaurant.room.removeObject(roomActor);
            roomActor = null;
         }
         if(streetActor)
         {
            streetActor.removeEventListener(MouseEvent.CLICK,onBlackSheepClick);
            street.removeObjectFromStreet(streetActor);
            streetActor = null;
         }
      }
      
      public function tick(param1:uint) : void
      {
         if(timerOn)
         {
            if(appearTimer <= 0)
            {
               Debug.out("Foodking: Timer reached 0, Greg should appear now!");
               restaurant.room.addObject(roomActor);
               roomActor.addEventListener(MouseEvent.CLICK,onBlackSheepClick);
               timerOn = false;
            }
            appearTimer -= param1;
         }
      }
      
      private function onBlackSheepClick(param1:MouseEvent) : void
      {
         showBlackSheepPopUp();
      }
      
      public function addToRestaurant(param1:int = -1) : void
      {
         if(foundForSession)
         {
            return;
         }
         if(DebugAddBlackSheep.alwaysAppear || !Engine.rnd(0,chanceOfAppearing))
         {
            param1 = Engine.rnd(0,FoodkingActor.numberOfStates());
            roomActor = new FoodkingActor(restaurant,param1);
            if(param1 == FoodkingActor.STATE_WALK && !DebugAddBlackSheep.alwaysAppear)
            {
               timerOn = true;
            }
            else
            {
               restaurant.room.addObject(roomActor);
               roomActor.addEventListener(MouseEvent.CLICK,onBlackSheepClick);
            }
         }
      }
      
      public function addToStreet() : void
      {
         if(foundForSession)
         {
            return;
         }
         if(DebugAddBlackSheep.alwaysAppear || !Engine.rnd(0,chanceOfAppearing))
         {
            streetActor = new FoodkingStreetActor(street);
            street.addObjectToStreet(streetActor);
            streetActor.addEventListener(MouseEvent.CLICK,onBlackSheepClick);
         }
      }
   }
}

