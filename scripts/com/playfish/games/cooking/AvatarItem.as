package com.playfish.games.cooking
{
   import com.playfish.rpc.cooking.OwnedItem;
   
   public class AvatarItem extends UserItem
   {
      
      public var groupName:String;
      
      public var priority:int = 0;
      
      public function AvatarItem(param1:Object, param2:OwnedItem = null)
      {
         super(param1,param2);
         if(param1.group.priority)
         {
            this.priority = param1.group.priority;
         }
         if(param1.priority)
         {
            this.priority = param1.priority;
         }
         groupName = param1.group.name;
         if(param1.group.parent)
         {
            groupName = param1.group.parent;
         }
      }
      
      public function clone() : AvatarItem
      {
         return new AvatarItem(itemConfig,getOwnedItem());
      }
   }
}

