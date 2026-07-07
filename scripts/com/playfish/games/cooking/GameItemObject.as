package com.playfish.games.cooking
{
   public class GameItemObject extends BaseObject
   {
      
      public var fromInventory:Boolean;
      
      public var itemConfig:Object;
      
      public var owned:Boolean;
      
      public var serverUid:int;
      
      public function GameItemObject(param1:Object, param2:UserItem, param3:String = null)
      {
         super(param3);
         this.itemConfig = param1;
         if(param2)
         {
            setUserItem(param2);
         }
      }
      
      public function setUserItem(param1:UserItem) : void
      {
         this.serverUid = param1.serverUid;
      }
      
      public function getUserItem() : UserItem
      {
         var _loc1_:UserItem = new UserItem(itemConfig);
         _loc1_.serverUid = serverUid;
         _loc1_.itemConfig = itemConfig;
         return _loc1_;
      }
   }
}

