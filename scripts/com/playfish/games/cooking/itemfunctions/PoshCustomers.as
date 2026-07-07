package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.*;
   
   public class PoshCustomers extends RoomItemFunction
   {
      
      public function PoshCustomers(param1:RoomItem)
      {
         super(param1);
      }
      
      public static function getPoshCustomerAvatarItems() : Array
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
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Granny","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Glamour","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Pigtails","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Long Hair","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Leah","Hair"));
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
            _loc2_ = new Array();
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Luxurious Eyes","Eyes"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Smoky Eyes","Eyes"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Pretty Pink Eyes","Eyes"));
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
            _loc2_ = new Array();
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Curvy EyeBrow","Eyebrows"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Classic EyeBrow","Eyebrows"));
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
            _loc2_ = new Array();
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Pink Puffy Lips","Mouth"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Purple Power Lips","Mouth"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Luscious Red Lips","Mouth"));
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("No Beard","Facial Hair")));
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Elegant Top","Shirt")));
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Elegant Black Skirt","Skirt")));
         }
         else
         {
            _loc2_ = new Array();
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Classic","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Fringe","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Spike","Hair"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Emo","Hair"));
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
            _loc2_ = new Array();
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Basic Eyes","Eyes"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Happy Eyes","Eyes"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Brown Eyes","Eyes"));
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
            _loc2_ = new Array();
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Soft EyeBrow","Eyebrows"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Fluffy EyeBrow","Eyebrows"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("ZigZag EyeBrow","Eyebrows"));
            _loc2_.push(GameWorld.avatarItemDatabase.getItemFromGroup("Sharp EyeBrow","Eyebrows"));
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
            _loc2_ = GameWorld.avatarItemDatabase.getItemsAboveCost("Facial Hair",1);
            _loc1_.push(new AvatarItem(_loc2_[Engine.rnd(0,_loc2_.length)]));
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Black Tux","Shirt")));
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Great Smile","Mouth")));
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Black Top Hat","Hat")));
            _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Black Pants","Pants")));
         }
         _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("No Extra","Miscellaneous")));
         return _loc1_;
      }
      
      override public function init(param1:WorldRestaurantPlay) : void
      {
         param1.customerAvatarItemsGenerator = getPoshCustomerAvatarItems;
      }
   }
}

