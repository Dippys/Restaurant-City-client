package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.events.GameEvent;
   import com.playfish.games.cooking.rpc.*;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.*;
   import flash.events.MouseEvent;
   
   public class WorldCashIngredientShop extends WorldPopUp
   {
      
      private static const DEFAULT_INGREDIENT_CASH_PRICE:int = 8;
      
      private static const BUTTONS_PER_PAGE:int = 12;
      
      private var selectedIngredientItemConfig:Object;
      
      private var buttons:Array;
      
      private var allIngredientItemConfigs:Array;
      
      private var sceneContent:MovieClip;
      
      private var curPage:int = 0;
      
      public function WorldCashIngredientShop()
      {
         var _loc3_:MovieClip = null;
         buttons = new Array();
         allIngredientItemConfigs = new Array();
         super(null,null,null);
         var _loc1_:MovieClip = Engine.getMovieClip("IngredientMenuAnim2");
         addChild(_loc1_);
         sceneContent = _loc1_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_title,"CashIngredients");
         var _loc2_:int = 0;
         while(_loc2_ < BUTTONS_PER_PAGE)
         {
            _loc3_ = sceneContent["mc_ingredient" + _loc2_];
            buttons.push(_loc3_);
            _loc2_++;
         }
         allIngredientItemConfigs = GameWorld.ingredientItemDatabase.getItems("Ingredient");
         allIngredientItemConfigs = allIngredientItemConfigs.sortOn(["cash","rarity","name"]);
         setButtonMode(sceneContent.mc_cancel,true);
         sceneContent.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         setButtonMode(sceneContent.mc_left,true);
         sceneContent.mc_left.addEventListener(MouseEvent.CLICK,onLeftClick,false,0,true);
         setButtonMode(sceneContent.mc_right,true);
         sceneContent.mc_right.addEventListener(MouseEvent.CLICK,onRightClick,false,0,true);
         setPage(0);
      }
      
      private function setIngredientOnButton(param1:Object, param2:MovieClip) : void
      {
         param2.ingredientItemConfig = param1;
         param2.ingredient = ItemChooser.getItemMovieClip(param1);
         param2.ingredient.stop();
         param2.mc_base.addChild(param2.ingredient);
         GameWorld.textHandler.setTextField(param2.tf_name,param1.name);
         GameWorld.textHandler.setTextField(param2.tf_price,param1.cash);
         if(param1.cash < DEFAULT_INGREDIENT_CASH_PRICE)
         {
            param2.mc_priceOld.visible = true;
            GameWorld.textHandler.setTextField(param2.mc_priceOld.tf_price,DEFAULT_INGREDIENT_CASH_PRICE.toString());
         }
         else
         {
            param2.mc_priceOld.visible = false;
         }
         param2.tf_name.visible = true;
         param2.tf_price.visible = true;
         param2.mc_cashIcon.visible = true;
      }
      
      private function onLeftClick(param1:MouseEvent) : void
      {
         if(curPage > 0)
         {
            --curPage;
            setPage(curPage);
         }
      }
      
      private function onPurchaseCashIngredientSuccess(param1:RpcEvent) : void
      {
         var _loc2_:WorldInfoPopUp = null;
         if(param1.successCode == RpcClient.STATUS_OK)
         {
            GameWorld.cashPanel.showPlayfishCashPopUp(-selectedIngredientItemConfig.cash);
            GameWorld.gameUser.addIngredient(selectedIngredientItemConfig,1);
            GameWorld.gameUser.getIngredient(selectedIngredientItemConfig).lock = true;
            new GameSound("SfxCash",GameSound.TYPE_SOUND).play(1);
            GameWorld.gameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.INGREDIENT_CHANGED));
         }
         else
         {
            if(param1.successCode == RpcClient.STATUS_NOT_ENOUGH_CASH)
            {
               _loc2_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("NotEnoughPlayfishCashToBuyItem"));
            }
            else if(param1.successCode == RpcClient.STATUS_INVALID_TOKEN)
            {
               _loc2_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("ErrorBuyingPlayfishCashItem"));
            }
            else if(param1.successCode == RpcClient.STATUS_SHARD_OFFLINE)
            {
               _loc2_ = new WorldInfoPopUp(GameWorld.textHandler.getTextFromId("UserMaintenance"));
            }
            _loc2_.show();
         }
      }
      
      private function onPurchaseCashIngredientTickClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldLoadingPopUp = new WorldLoadingPopUp("Purchasing...",WorldLoadingPopUp.PURCHASE_CASH_ITEM);
         var _loc3_:RpcRequestManager = new RpcRequestManager();
         _loc3_.loadingPopUp = _loc2_;
         _loc3_.maxRetryCount = 0;
         var _loc4_:RpcPurchaseCashItemIngredients = _loc3_.purchaseCashItemIngredients([selectedIngredientItemConfig.hash]);
         _loc4_.addEventListener(RpcEvent.SUCCESS,onPurchaseCashIngredientSuccess,false,0,true);
         _loc4_.addEventListener(RpcEvent.FAIL,onPurchaseCashIngredientFail,false,0,true);
         _loc3_.commit();
      }
      
      private function onRightClick(param1:MouseEvent) : void
      {
         if(curPage < getMaxPage() - 1)
         {
            ++curPage;
            setPage(curPage);
         }
      }
      
      private function setPage(param1:int) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc2_:int = param1 * buttons.length;
         var _loc3_:int = 0;
         while(_loc3_ < buttons.length)
         {
            _loc4_ = buttons[_loc3_];
            if(_loc4_.ingredient)
            {
               _loc4_.mc_base.removeChild(_loc4_.ingredient);
               _loc4_.ingredient = null;
            }
            _loc5_ = _loc2_ + _loc3_;
            if(_loc5_ < allIngredientItemConfigs.length)
            {
               _loc6_ = allIngredientItemConfigs[_loc5_];
               setButtonMode(_loc4_,true);
               setIngredientOnButton(_loc6_,_loc4_);
               _loc4_.addEventListener(MouseEvent.CLICK,onIngredientClick,false,0,true);
            }
            else
            {
               setButtonMode(_loc4_,false);
               _loc4_.gotoAndStop("up");
               _loc4_.tf_name.visible = false;
               _loc4_.tf_price.visible = false;
               _loc4_.mc_priceOld.visible = false;
               _loc4_.mc_cashIcon.visible = false;
               _loc4_.removeEventListener(MouseEvent.CLICK,onIngredientClick);
            }
            _loc3_++;
         }
         if(param1 == 0)
         {
            setButtonMode(sceneContent.mc_left,false);
            sceneContent.mc_left.gotoAndStop("disabled");
            sceneContent.mc_left.mouseEnabled = false;
         }
         else if(sceneContent.mc_left.currentLabel == "disabled")
         {
            setButtonMode(sceneContent.mc_left,true);
            sceneContent.mc_left.mouseEnabled = true;
         }
         if(param1 == getMaxPage() - 1)
         {
            setButtonMode(sceneContent.mc_right,false);
            sceneContent.mc_right.gotoAndStop("disabled");
            sceneContent.mc_right.mouseEnabled = false;
         }
         else if(sceneContent.mc_right.currentLabel == "disabled")
         {
            setButtonMode(sceneContent.mc_right,true);
            sceneContent.mc_right.mouseEnabled = true;
         }
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
         var _loc2_:WorldIngredientShopPopUp = new WorldIngredientShopPopUp();
         _loc2_.show();
      }
      
      private function onAddCoinsClick(param1:MouseEvent) : void
      {
         remove();
         GameWorld.cashPanel.showAddPlayfishCashPopUp();
      }
      
      private function onPurchaseCashIngredientFail(param1:RpcEvent) : void
      {
         GameWorld.error();
      }
      
      private function getMaxPage() : int
      {
         return Math.ceil(allIngredientItemConfigs.length / BUTTONS_PER_PAGE);
      }
      
      private function onIngredientClick(param1:MouseEvent) : void
      {
         var _loc4_:WorldPopUp = null;
         selectedIngredientItemConfig = param1.currentTarget.ingredientItemConfig;
         var _loc2_:MovieClip = Engine.getMovieClip("PfCashIngredientConfirmAnim");
         var _loc3_:MovieClip = _loc2_.mc_content;
         _loc3_.mc_icon.stop();
         setIngredientOnButton(selectedIngredientItemConfig,_loc3_.mc_icon);
         GameWorld.textHandler.setReplaceString("ItemName",selectedIngredientItemConfig.name);
         GameWorld.textHandler.setReplaceString("ItemPrice",selectedIngredientItemConfig.cash);
         GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_text,"BuyItemWithPlayfishCash",true);
         if(GameWorld.gameUser.playfishCash.value >= selectedIngredientItemConfig.cash)
         {
            _loc3_.mc_addCoins.stop();
            _loc3_.mc_addCoins.visible = false;
            _loc3_.mc_tick.addEventListener(MouseEvent.CLICK,onPurchaseCashIngredientTickClick,false,0,true);
            _loc4_ = new WorldPopUp(_loc2_,_loc3_.mc_tick,_loc3_.mc_cancel);
         }
         else
         {
            _loc3_.mc_tick.stop();
            _loc3_.mc_tick.visible = false;
            _loc3_.mc_addCoins.toolTip = new ToolTip(_loc3_.mc_addCoins,GameWorld.textHandler.getTextFromId("ToolTipNotEnoughPlayfishCash"));
            _loc3_.mc_addCoins.addEventListener(MouseEvent.CLICK,onAddCoinsClick,false,0,true);
            _loc4_ = new WorldPopUp(_loc2_,_loc3_.mc_addCoins,_loc3_.mc_cancel);
         }
         _loc4_.show();
      }
   }
}

