package com.playfish.rpc.cooking
{
   public class AuditChangeAction
   {
      
      public static const creditShakeTree:uint = 1;
      
      public static const creditChangeBuyMeal:uint = 2;
      
      public static const purchaseInventoryItem:uint = 3;
      
      public static const sellOwnedItem:uint = 4;
      
      public static const fromGameToInventory:uint = 5;
      
      public static const fromInventoryToGame:uint = 6;
      
      public static const saveFloor:uint = 7;
      
      public static const updateEmployee:uint = 8;
      
      public static const lockIngredient:uint = 9;
      
      public static const manageMails:uint = 16;
      
      public static const hireEmployee:uint = 17;
      
      public static const fireEmployee:uint = 18;
      
      public static const sellInventoryItem:uint = 19;
      
      public static const openMail:uint = 20;
      
      public static const deleteMail:uint = 21;
      
      public static const purchaseOwnedItem:uint = 22;
      
      public static const saveOwnedItem:uint = 23;
      
      public static const creditChangeOffLine:uint = 24;
      
      public static const lvlUpdate:uint = 25;
      
      public static const purchasePerks:uint = 32;
      
      public static const addRecipe:uint = 33;
      
      public static const purchaseIngredient:uint = 34;
      
      public static const pickUpTrash:uint = 35;
      
      public static const creditOutRestaurant:uint = 36;
      
      public static const selectRecipe:uint = 37;
      
      public static const seedPlant:uint = 38;
      
      public static const waterPlant:uint = 39;
      
      public static const harvestPlant:uint = 40;
      
      public static const consumeItem:uint = 41;
      
      public static const creditFunctionalItem:uint = 48;
      
      public static const creditVisitFriend:uint = 49;
      
      public static const saveFloors:uint = 50;
      
      public static const moveInGameItemsToInventory:uint = 51;
      
      public var code:Number;
      
      public function AuditChangeAction()
      {
         super();
      }
   }
}

