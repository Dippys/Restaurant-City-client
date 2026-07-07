package com.playfish.games.cooking
{
   import com.playfish.rpc.cooking.OwnedItem;
   import com.playfish.rpc.share.NetworkUid;
   
   public class UserItem
   {
      
      private static var nextLocalUid:int = -1;
      
      public var y:int;
      
      public var employeeId:NetworkUid;
      
      public var serverUid:int;
      
      public var data:int;
      
      public var itemConfig:Object;
      
      public var roomIndex:int;
      
      public var x:int;
      
      public function UserItem(param1:Object, param2:OwnedItem = null)
      {
         super();
         this.itemConfig = param1;
         if(param2)
         {
            setOwnedItem(param2);
         }
         else
         {
            this.serverUid = getNextLocalUid();
         }
      }
      
      public static function getNextLocalUid() : int
      {
         return nextLocalUid--;
      }
      
      public function getOwnedItem() : OwnedItem
      {
         var _loc1_:OwnedItem = new OwnedItem();
         _loc1_.id = serverUid;
         _loc1_.globalItemId = itemConfig.id;
         _loc1_.positionX = x;
         _loc1_.positionY = y;
         _loc1_.roomIndex = roomIndex;
         _loc1_.employeeId = employeeId;
         _loc1_.data = data;
         return _loc1_;
      }
      
      public function setOwnedItem(param1:OwnedItem) : void
      {
         this.serverUid = param1.id;
         this.x = param1.positionX;
         this.y = param1.positionY;
         this.roomIndex = param1.roomIndex;
         this.employeeId = param1.employeeId;
         this.data = param1.data;
      }
   }
}

