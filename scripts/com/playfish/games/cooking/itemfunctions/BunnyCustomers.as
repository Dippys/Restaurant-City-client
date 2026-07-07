package com.playfish.games.cooking.itemfunctions
{
   import com.playfish.games.cooking.AvatarItem;
   import com.playfish.games.cooking.Engine;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.RoomItem;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   
   public class BunnyCustomers extends RoomItemFunction
   {
      
      public function BunnyCustomers(param1:RoomItem)
      {
         super(param1);
      }
      
      public static function getBunnyCustomerAvatarItems() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("BunnyGirl Top","Shirt")));
         _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("BunnyGirl Skirt","Skirt")));
         _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Pigtails","Hair")));
         _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Pretty Pink Eyes","Eyes")));
         _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Big Tooth","Mouth")));
         _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("No Eyebrow","Eyebrows")));
         _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Pink Cheeks","Miscellaneous")));
         switch(Engine.rnd(0,3))
         {
            case 0:
               _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Black Bunny Ears","Hat")));
               _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("0xBA875C","SkinColour")));
               _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("0x332e26","HairColour")));
               break;
            case 1:
               _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("White Bunny Ears","Hat")));
               _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("0xffffff","SkinColour")));
               _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("0xf0ece3","HairColour")));
               break;
            case 2:
               _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("Brown Bunny Ears","Hat")));
               _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("0xBA875C","SkinColour")));
               _loc1_.push(new AvatarItem(GameWorld.avatarItemDatabase.getItemFromGroup("0xa9773e","HairColour")));
         }
         return _loc1_;
      }
      
      override public function init(param1:WorldRestaurantPlay) : void
      {
         param1.customerAvatarItemsGenerator = getBunnyCustomerAvatarItems;
      }
   }
}

