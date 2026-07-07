package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.events.GameEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class WorldIngredientShopPopUp extends WorldPopUp
   {
      
      private static const NUM_INGREDIENTS:int = 3;
      
      public static var shopIngredientItems:Array = new Array();
      
      public static var shopIngredientPrices:Array = new Array();
      
      private var ingredientIndex:int;
      
      public var bought:Boolean = false;
      
      public function WorldIngredientShopPopUp()
      {
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         super(null,null,null);
         var _loc1_:MovieClip = Engine.getMovieClip("IngredientMenuAnim");
         addChild(_loc1_);
         var _loc2_:MovieClip = _loc1_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(_loc2_.tf_title,"TodaysFreshIngredients");
         GameWorld.textHandler.setTextFieldWithId(_loc2_.mc_cashIngredients.mc_content.tf_text,"CashIngredients");
         var _loc3_:int = 0;
         while(_loc3_ < NUM_INGREDIENTS)
         {
            _loc4_ = _loc2_["mc_ingredient" + _loc3_];
            _loc4_.ingredientIndex = _loc3_;
            _loc4_.tf_name.text = shopIngredientItems[_loc3_].name;
            _loc4_.tf_price.text = shopIngredientPrices[_loc3_];
            _loc5_ = ItemChooser.getItemMovieClip(shopIngredientItems[_loc3_]);
            _loc5_.stop();
            _loc4_.mc_base.addChild(_loc5_);
            setButtonMode(_loc4_,true);
            _loc4_.addEventListener(MouseEvent.CLICK,onIngredientClick,false,0,true);
            _loc3_++;
         }
         setButtonMode(_loc2_.mc_cancel,true);
         _loc2_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         setButtonMode(_loc2_.mc_cashIngredients,true);
         _loc2_.mc_cashIngredients.addEventListener(MouseEvent.CLICK,onCashIngredientsClick,false,0,true);
      }
      
      private function onBuyTickClick(param1:MouseEvent) : void
      {
         bought = true;
         var _loc2_:int = int(shopIngredientPrices[ingredientIndex]);
         var _loc3_:Object = shopIngredientItems[ingredientIndex];
         GameWorld.saveProfileHandler.purchaseIngredientItem(_loc3_.id);
         GameWorld.cashPanel.addCoins(-_loc2_,true);
         GameWorld.gameUser.addIngredient(_loc3_,1);
         GameWorld.gameUser.getIngredient(_loc3_).lock = true;
         new GameSound("SfxCash",GameSound.TYPE_SOUND).play(1);
         GameWorld.gameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.INGREDIENT_CHANGED));
      }
      
      private function onIngredientClick(param1:MouseEvent) : void
      {
         var _loc6_:MovieClip = null;
         var _loc7_:WorldPopUp = null;
         ingredientIndex = param1.currentTarget.ingredientIndex;
         var _loc2_:int = int(shopIngredientPrices[ingredientIndex]);
         var _loc3_:Object = shopIngredientItems[ingredientIndex];
         var _loc4_:MovieClip = Engine.getMovieClip("SellPopUpAnim");
         var _loc5_:MovieClip = _loc4_.mc_content;
         ItemChooser.setItemOnIconButton(_loc3_,_loc5_.mc_item);
         _loc5_.mc_item.image.stop();
         if(GameWorld.gameUser.money.value < _loc2_)
         {
            _loc5_.mc_tick.stop();
            _loc5_.mc_tick.visible = false;
            _loc5_.mc_addCoins.toolTip = new ToolTip(_loc5_.mc_addCoins,GameWorld.textHandler.getTextFromId("ToolTipNotEnoughCoins"));
            _loc5_.mc_addCoins.addEventListener(MouseEvent.CLICK,onAddMoneyClick,false,0,true);
            _loc6_ = _loc5_.mc_addCoins;
         }
         else
         {
            _loc5_.mc_addCoins.stop();
            _loc5_.mc_addCoins.visible = false;
            _loc5_.mc_tick.addEventListener(MouseEvent.CLICK,onBuyTickClick,false,0,true);
            _loc6_ = _loc5_.mc_tick;
         }
         _loc5_.mc_cancel.addEventListener(MouseEvent.CLICK,onBuyCancelClick,false,0,true);
         _loc5_.mc_count.visible = false;
         GameWorld.textHandler.setReplaceString("ItemName",_loc3_.name);
         GameWorld.textHandler.setReplaceString("ItemSellPrice",_loc2_.toString());
         GameWorld.textHandler.setTextFieldWithId(_loc5_.tf_text,"BuyGiftItemWithCoins",true);
         _loc7_ = new WorldPopUp(_loc4_,_loc6_,_loc5_.mc_cancel);
         _loc7_.x = GameWorld.CANVAS_CENTER_X;
         _loc7_.y = GameWorld.CANVAS_CENTER_Y;
         _loc7_.show();
      }
      
      private function onCashIngredientsClick(param1:MouseEvent) : void
      {
         remove();
         var _loc2_:WorldCashIngredientShop = new WorldCashIngredientShop();
         _loc2_.show();
      }
      
      private function onAddMoneyClick(param1:MouseEvent) : void
      {
         GameWorld.cashPanel.showAddCoinsPopUp();
      }
      
      private function onBuyCancelClick(param1:MouseEvent) : void
      {
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
         GameWorld.gameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.INGREDIENT_CHANGED));
         if(bought)
         {
            GameWorld.forceAutoSave();
         }
      }
   }
}

