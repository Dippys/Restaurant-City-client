package com.playfish.games.cooking.itemfunctions.street
{
   import com.playfish.games.cooking.BuildingItem;
   import com.playfish.games.cooking.StreetBuilding;
   
   public class StreetItemFunction
   {
      
      protected var roomItem:BuildingItem;
      
      public function StreetItemFunction(param1:BuildingItem)
      {
         super();
         this.roomItem = param1;
      }
      
      public static function create(param1:String, param2:BuildingItem) : StreetItemFunction
      {
         var _loc3_:Class = null;
         switch(param1)
         {
            case "StreetBubbleGeyser":
               _loc3_ = StreetBubbleGeyser;
               break;
            case "StreetLeafGenerator":
               _loc3_ = StreetLeafGenerator;
               break;
            case "StreetSnowGenerator":
               _loc3_ = StreetSnowGenerator;
               break;
            case "StreetHeartGenerator":
               _loc3_ = StreetHeartGenerator;
         }
         if(_loc3_)
         {
            return new _loc3_(param2);
         }
         return null;
      }
      
      public function init(param1:StreetBuilding) : void
      {
      }
      
      public function destroy() : void
      {
      }
      
      public function tick(param1:uint) : void
      {
      }
   }
}

