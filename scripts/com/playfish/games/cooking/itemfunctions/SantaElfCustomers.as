package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.*;
   
   public class SantaElfCustomers extends RoomItemFunction
   {
      
      public function SantaElfCustomers(param1:RoomItem)
      {
         super(param1);
      }
      
      public static function getSantaElfCustomerAvatarItems() : Array
      {
         var _loc2_:Array = null;
         var _loc1_:Array = new Array();
         _loc2_ = GameWorld.avatarItemDatabase.getItemsBelowCost("HairColour",100);
         _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         _loc2_ = GameWorld.avatarItemDatabase.getItemsBelowCost("SkinColour",100);
         _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         if(Engine.rnd(0,2) == 0)
         {
            _loc2_ = new Array();
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Ponytail","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Shoulder Long Hair","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Pigtails","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Long Hair","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Leah","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Granny","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Glamour","Hair"));
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("No Beard","Facial Hair")));
         }
         else
         {
            _loc2_ = new Array();
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Classic","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Fringe","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Emo","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Spike","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Manga","Hair"));
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
            _loc2_ = GameWorld.avatarItemDatabase.getItems("Facial Hair");
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         }
         _loc2_ = GameWorld.avatarItemDatabase.getItems("Eyes");
         _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         _loc2_ = GameWorld.avatarItemDatabase.getItems("Eyebrows");
         _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         _loc2_ = GameWorld.avatarItemDatabase.getItems("Mouth");
         _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         _loc2_ = GameWorld.avatarItemDatabase.getItems("Miscellaneous");
         _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
         if(Engine.rnd(0,2) == 0)
         {
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Festive Red Coat","Shirt")));
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Festive Red Pants","Pants")));
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Festive Hat","Hat")));
         }
         else
         {
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Elf Costume","Shirt")));
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Elf Stockings","Pants")));
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Elf Hat","Hat")));
         }
         return _loc1_;
      }
      
      override public function init(param1:WorldRestaurantPlay) : void
      {
         param1.customerAvatarItemsGenerator = getSantaElfCustomerAvatarItems;
      }
   }
}

