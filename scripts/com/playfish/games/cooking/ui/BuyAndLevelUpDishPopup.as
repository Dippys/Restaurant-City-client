package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.events.GameEvent;
   import com.playfish.games.cooking.rpc.RpcEvent;
   import com.playfish.games.cooking.rpc.RpcPurchaseCashItemIngredients;
   import com.playfish.games.cooking.rpc.RpcRequestManager;
   import com.playfish.games.cooking.ui.bank.WorldBankPaymentProvider;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class BuyAndLevelUpDishPopup extends WorldPopUp
   {
      
      private var recipeMenu:WorldRecipeMenu;
      
      private var recipe:Recipe;
      
      private var totalCost:Number = 0;
      
      private var recipePanel:MovieClip;
      
      private var tokens:Array;
      
      private var missingIngredients:Array;
      
      public function BuyAndLevelUpDishPopup(param1:WorldRecipeMenu, param2:Array, param3:Recipe, param4:MovieClip)
      {
         var _loc5_:IngredientItem = null;
         var _loc6_:MovieClip = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:IngredientItem = null;
         var _loc10_:int = 0;
         var _loc11_:MovieClip = null;
         tokens = new Array();
         this.recipeMenu = param1;
         this.missingIngredients = param2;
         this.recipe = param3;
         this.recipePanel = param4;
         for each(_loc5_ in param2)
         {
            tokens.push(_loc5_.itemConfig.hash);
         }
         _loc6_ = Engine.getMovieClip("BuyDishPopupAnim");
         _loc7_ = _loc6_.mc_content;
         Debug.out("missingIngredients=" + param2);
         for each(_loc9_ in param2)
         {
            totalCost += parseInt(_loc9_.itemConfig.cash);
         }
         Debug.out("totalCost=" + totalCost);
         _loc10_ = 0;
         _loc11_ = _loc7_["mc_ingredient" + _loc10_];
         while(_loc11_)
         {
            _loc11_.visible = false;
            _loc10_++;
            _loc11_ = _loc7_["mc_ingredient" + _loc10_];
         }
         var _loc12_:int = 0;
         while(_loc12_ < param2.length)
         {
            _loc8_ = Engine.getMovieClip(param2[_loc12_].className);
            _loc8_.stop();
            _loc11_ = _loc7_["mc_ingredient" + _loc12_];
            _loc11_.icon = _loc8_;
            _loc11_.icon.x = _loc11_.x;
            _loc11_.icon.y = _loc11_.y;
            param1.matchSize(_loc11_.icon,_loc11_);
            _loc7_.addChild(_loc11_.icon);
            _loc11_.icon.toolTip = new ToolTip(_loc11_.icon,param2[_loc12_].itemConfig.name);
            _loc12_++;
         }
         _loc7_.mc_recipe.stop();
         GameWorld.textHandler.setTextFieldWithId(_loc7_.tf_title,"PurchaseMissingIngredients");
         var _loc13_:MovieClip = Engine.getMovieClip(param3.className);
         _loc13_.stop();
         _loc7_.mc_recipe.icon = _loc13_;
         GameWorld.textHandler.setTextField(_loc7_.mc_recipe.mc_level.tf_level,new String(param3.level));
         if(_loc13_.mc_plate)
         {
            _loc13_.mc_plate.gotoAndStop(param3.level);
         }
         _loc7_.mc_recipe.mc_icon.removeChildAt(0);
         _loc7_.mc_recipe.mc_icon.addChild(_loc13_);
         if(GameWorld.gameUser.playfishCash.value >= totalCost)
         {
            GameWorld.textHandler.setTextField(_loc7_.tf_price,new String(totalCost));
            _loc7_.tf_redPrice.visible = false;
            setButtonMode(_loc7_.mc_buy,true);
            setHandCursor(_loc7_.mc_buy,true);
            _loc7_.mc_buy.mc_content.gotoAndStop("on");
            _loc7_.mc_buy.mc_content.mc_arrow.visible = false;
            _loc7_.mc_buy.addEventListener(MouseEvent.CLICK,onBuyConfirmClick,false,0,true);
            _loc7_.mc_addCash.visible = false;
         }
         else
         {
            GameWorld.textHandler.setTextField(_loc7_.tf_redPrice,new String(totalCost));
            _loc7_.tf_price.visible = false;
            setButtonMode(_loc7_.mc_addCash,true);
            setHandCursor(_loc7_.mc_addCash,true);
            _loc7_.mc_addCash.addEventListener(MouseEvent.CLICK,onAddCashClick,false,0,true);
            _loc7_.mc_buy.mc_content.gotoAndStop("off");
            _loc7_.mc_buy.stop();
            _loc7_.mc_buy.visible = false;
         }
         super(_loc6_,_loc7_.mc_cancel,null);
      }
      
      private function onPurchaseCashIngredientFail(param1:RpcEvent) : void
      {
         GameWorld.error();
      }
      
      private function onAddCashClick(param1:MouseEvent) : void
      {
         remove();
         var _loc2_:WorldBankPaymentProvider = new WorldBankPaymentProvider(WorldBankPaymentProvider.PRODUCT_TYPE_PLAYFISH_CASH);
         _loc2_.show();
      }
      
      private function onBuyConfirmClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldLoadingPopUp = new WorldLoadingPopUp("Purchasing...",WorldLoadingPopUp.PURCHASE_CASH_ITEM);
         var _loc3_:RpcRequestManager = new RpcRequestManager();
         _loc3_.loadingPopUp = _loc2_;
         _loc3_.maxRetryCount = 0;
         var _loc4_:RpcPurchaseCashItemIngredients = _loc3_.purchaseCashItemIngredients(tokens);
         _loc4_.addEventListener(RpcEvent.SUCCESS,onPurchaseCashIngredientSuccess,false,0,true);
         _loc4_.addEventListener(RpcEvent.FAIL,onPurchaseCashIngredientFail,false,0,true);
         _loc3_.commit();
      }
      
      private function onPurchaseCashIngredientSuccess(param1:RpcEvent) : void
      {
         var _loc2_:IngredientItem = null;
         var _loc3_:WorldInfoPopUp = null;
         if(param1.successCode == RpcClient.STATUS_OK)
         {
            GameWorld.cashPanel.showPlayfishCashPopUp(-totalCost);
            for each(_loc2_ in missingIngredients)
            {
               GameWorld.gameUser.addIngredient(_loc2_.itemConfig,1);
               GameWorld.gameUser.getIngredient(_loc2_.itemConfig).lock = true;
            }
            new GameSound("SfxCash",GameSound.TYPE_SOUND).play(1);
            GameWorld.gameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.INGREDIENT_CHANGED));
            remove();
         }
         else
         {
            if(param1.successCode == RpcClient.STATUS_NOT_ENOUGH_CASH)
            {
               _loc3_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("NotEnoughPlayfishCashToBuyItem"));
            }
            else if(param1.successCode == RpcClient.STATUS_INVALID_TOKEN)
            {
               _loc3_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("ErrorBuyingPlayfishCashItem"));
            }
            else if(param1.successCode == RpcClient.STATUS_SHARD_OFFLINE)
            {
               _loc3_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("UserMaintenance"));
            }
            _loc3_.show();
         }
      }
   }
}

