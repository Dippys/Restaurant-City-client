package com.playfish.games.cooking.rpc
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.rpc.cooking.*;
   
   public class RpcGetUserProfile extends RpcBase
   {
      
      public var userInfo:UserInfo;
      
      public var ingredientShops:Array;
      
      public function RpcGetUserProfile()
      {
         super();
      }
      
      public function getUserProfileOK(param1:UserInfo, param2:Array) : void
      {
         var _loc3_:RpcEvent = null;
         Debug.out("getUserProfileOK ingredientShops=" + param2 + " user id=" + param1.id.networkUid);
         this.userInfo = param1;
         this.ingredientShops = param2;
         if(hasEventListener(RpcEvent.SUCCESS))
         {
            _loc3_ = new RpcEvent(RpcEvent.SUCCESS);
            _loc3_.successCode = RpcClient.STATUS_OK;
            dispatchEvent(_loc3_);
         }
      }
      
      public function getUserProfileFail() : void
      {
         Debug.out("getUserProfileFail");
         if(!Debug.NETWORK_ONLY)
         {
            userInfo = GameWorld.getDummyUserInfo(0);
            ingredientShops = new Array();
            ingredientShops[0] = new IngredientMarketItem();
            ingredientShops[0].ingredientId = 4000000;
            ingredientShops[0].price = 1000;
            ingredientShops[1] = new IngredientMarketItem();
            ingredientShops[1].ingredientId = 4000001;
            ingredientShops[1].price = 1000;
            ingredientShops[2] = new IngredientMarketItem();
            ingredientShops[2].ingredientId = 4000002;
            ingredientShops[2].price = 1000;
         }
         if(hasEventListener(RpcEvent.FAIL))
         {
            dispatchEvent(new RpcEvent(RpcEvent.FAIL));
         }
      }
      
      override public function commit() : Boolean
      {
         GameWorld.rpcClient.getUserProfile(getUserProfileOK,getUserProfileFail);
         return true;
      }
      
      public function applyData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:IngredientMarketItem = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         if(userInfo)
         {
            GameWorld.setUserInfo(userInfo);
            _loc1_ = 0;
            while(_loc1_ < ingredientShops.length)
            {
               _loc2_ = ingredientShops[_loc1_];
               _loc3_ = GameWorld.getItemConfig(_loc2_.ingredientId);
               WorldIngredientShopPopUp.shopIngredientItems.push(_loc3_);
               WorldIngredientShopPopUp.shopIngredientPrices.push(_loc2_.price);
               _loc1_++;
            }
            if(GameWorld.gameUser.usedAvatarItems.length == 0)
            {
               _loc4_ = GameWorld.gameUser.getDefaultAvatarItems();
               _loc1_ = 0;
               while(_loc1_ < _loc4_.length)
               {
                  GameWorld.gameUser.addUsedAvatarItem(_loc4_[_loc1_]);
                  GameWorld.saveProfileHandler.purchaseItem(_loc4_[_loc1_]);
                  _loc1_++;
               }
            }
         }
      }
   }
}

