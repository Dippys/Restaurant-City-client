package com.playfish.games.cooking.foodking
{
   import com.playfish.games.cooking.GameUser;
   import com.playfish.games.cooking.GameWorld;
   
   public class FoodKingItem
   {
      
      public var name:String;
      
      public var itemType:int;
      
      public var itemId:int;
      
      public var mailType:uint;
      
      public var itemConfig:Object;
      
      public var claimLink:String;
      
      public function FoodKingItem(param1:int, param2:int = 0, param3:String = null)
      {
         super();
         this.itemId = param1;
         this.mailType = param2;
         this.claimLink = param3;
         itemType = GameWorld.getItemType(param1);
         itemConfig = GameWorld.getItemConfig(param1);
         name = itemConfig.name;
      }
      
      public function typeToString() : String
      {
         if(itemType == GameUser.ITEM_TYPE_INGREDIENT)
         {
            return "ingredient";
         }
         if(itemType == GameUser.ITEM_TYPE_RECIPE)
         {
            return "recipe";
         }
         if(itemType == GameUser.ITEM_TYPE_PERK)
         {
            return "reward";
         }
         return "item";
      }
   }
}

