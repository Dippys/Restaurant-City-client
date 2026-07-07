package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.*;
   
   public class ZombieCustomers extends RoomItemFunction
   {
      
      public function ZombieCustomers(param1:RoomItem)
      {
         super(param1);
      }
      
      public static function getZombieCustomerAvatarItems() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:Array = GameWorld.avatarItemDatabase.getItemsAboveCost("Shirt",0);
         _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         _loc2_ = GameWorld.avatarItemDatabase.getItems("Hair");
         var _loc3_:AvatarItem = new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]);
         _loc1_.push(_loc3_);
         _loc2_ = GameWorld.avatarItemDatabase.getItems("Mouth");
         _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Torn Blue Shorts","Pants")));
         _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Zombie Eyes","Eyes")));
         _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("No Eyebrow","Eyebrows")));
         _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("0x98e3a0","SkinColour")));
         _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("0x332e26","HairColour")));
         if(Engine.rnd(0,2) == 0)
         {
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("No Beard","Facial Hair")));
         }
         else if(Engine.rnd(0,2) == 0)
         {
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("No Beard","Facial Hair")));
         }
         else
         {
            _loc2_ = GameWorld.avatarItemDatabase.getItems("Facial Hair");
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         }
         if(Engine.rnd(0,2) == 0)
         {
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("No Extra","Miscellaneous")));
         }
         else
         {
            _loc2_ = GameWorld.avatarItemDatabase.getItems("Miscellaneous");
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         }
         if(Engine.rnd(0,2) == 0)
         {
            if(!_loc3_.itemConfig.noHat)
            {
               _loc2_ = GameWorld.avatarItemDatabase.getItems("Hat");
               _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
            }
         }
         return _loc1_;
      }
      
      override public function init(param1:WorldRestaurantPlay) : void
      {
         param1.customerAvatarItemsGenerator = getZombieCustomerAvatarItems;
      }
   }
}

