package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.RoomItem;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   
   public class RoomItemFunction
   {
      
      protected var roomItem:RoomItem;
      
      public function RoomItemFunction(param1:RoomItem)
      {
         super();
         this.roomItem = param1;
      }
      
      public static function create(param1:String, param2:RoomItem) : RoomItemFunction
      {
         var _loc3_:Class = null;
         switch(param1)
         {
            case "PoshCustomers":
               _loc3_ = PoshCustomers;
               break;
            case "ZombieCustomers":
               _loc3_ = ZombieCustomers;
               break;
            case "BananaTrash":
               _loc3_ = BananaTrash;
               break;
            case "SeaShellTrash":
               _loc3_ = SeaShellTrash;
               break;
            case "BunnyCustomers":
               _loc3_ = BunnyCustomers;
               break;
            case "ClockArms":
               _loc3_ = ClockArms;
               break;
            case "BubbleGeyser":
               _loc3_ = BubbleGeyser;
               break;
            case "LeafFootprint":
               _loc3_ = LeafFootprint;
               break;
            case "SnowFootprint":
               _loc3_ = SnowFootprint;
               break;
            case "AddCustomerWaitTime":
               _loc3_ = AddCustomerWaitTime;
               break;
            case "AddMaxDemand1":
               _loc3_ = AddMaxDemand1;
               break;
            case "CrystalTrash":
               _loc3_ = CrystalTrash;
               break;
            case "SnowGenerator":
               _loc3_ = SnowGenerator;
               break;
            case "SantaElfCustomers":
               _loc3_ = SantaElfCustomers;
               break;
            case "AddMaxDemand2":
               _loc3_ = AddMaxDemand2;
               break;
            case "HeartGenerator":
               _loc3_ = HeartGenerator;
         }
         if(_loc3_)
         {
            return new _loc3_(param2);
         }
         return null;
      }
      
      public function init(param1:WorldRestaurantPlay) : void
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

