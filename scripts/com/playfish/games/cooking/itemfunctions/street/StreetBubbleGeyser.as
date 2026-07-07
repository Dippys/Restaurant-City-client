package com.playfish.games.cooking.itemfunctions.street
{
   import com.playfish.games.cooking.*;
   
   public class StreetBubbleGeyser extends StreetItemFunction
   {
      
      private static const MAX_NO_BUBBLES_ON_SCREEN:int = 5;
      
      private var building:StreetBuilding;
      
      private var bubbleObjects:Array = new Array();
      
      public function StreetBubbleGeyser(param1:BuildingItem)
      {
         super(param1);
      }
      
      override public function destroy() : void
      {
         var _loc1_:BaseObject = null;
         for each(_loc1_ in bubbleObjects)
         {
            _loc1_.destroy();
         }
      }
      
      override public function init(param1:StreetBuilding) : void
      {
         this.building = param1;
         var _loc2_:int = 0;
         while(_loc2_ < MAX_NO_BUBBLES_ON_SCREEN)
         {
            createBubble();
            _loc2_++;
         }
      }
      
      private function createBubble() : void
      {
         var _loc1_:GeyserBubble = GeyserBubble.createGeyserBubbleForBuilding("GeyserBubble",Engine.rndFloat(-200,200),building.y);
         _loc1_.scaleX = 0.5;
         _loc1_.scaleY = 0.5;
         _loc1_.drawPriority = 1000;
         building.addObject(_loc1_);
         bubbleObjects.push(_loc1_);
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc5_:BaseObject = null;
         super.tick(param1);
         var _loc2_:* = int(bubbleObjects.length - 1);
         while(_loc2_ >= 0)
         {
            _loc5_ = bubbleObjects[_loc2_];
            if(_loc5_.timeLeft <= 0)
            {
               building.removeObject(_loc5_);
               bubbleObjects.splice(_loc2_,1);
            }
            _loc2_--;
         }
         var _loc3_:int = MAX_NO_BUBBLES_ON_SCREEN - bubbleObjects.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            createBubble();
            _loc4_++;
         }
      }
   }
}

