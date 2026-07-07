package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class BuyOutsideAreaExpansionPopUp extends WorldPopUp
   {
      
      private var restaurant:WorldRestaurant;
      
      private var outsideAreaItem:OutsideAreaSizeItem;
      
      private var cashOnly:Boolean = false;
      
      public function BuyOutsideAreaExpansionPopUp(param1:OutsideAreaSizeItem, param2:WorldRestaurant)
      {
         super(null,null,null);
         this.restaurant = param2;
         this.outsideAreaItem = param1;
         if(Boolean(param1.itemConfig.cash) && param1.itemConfig.cash > 0)
         {
            cashOnly = true;
         }
         var _loc3_:MovieClip = Engine.getMovieClip("OutsideAreaPopupAnim");
         addChild(_loc3_);
         var _loc4_:MovieClip = _loc3_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(_loc4_.tf_text,"BuyOutsideAreaExpansion");
         if(cashOnly)
         {
            GameWorld.textHandler.setReplaceString("coins",param1.itemConfig.cash);
            GameWorld.textHandler.setReplaceString("OldPrice",(int(param1.itemConfig.cash) * 2).toString());
            GameWorld.textHandler.setReplaceString("NowPrice",GameWorld.textHandler.getTextFromId("NumberOfPlayfishCash"));
         }
         else
         {
            GameWorld.textHandler.setReplaceString("coins",param1.itemConfig.cost);
            GameWorld.textHandler.setReplaceString("OldPrice",(int(param1.itemConfig.cost) * 2).toString());
            GameWorld.textHandler.setReplaceString("NowPrice",GameWorld.textHandler.getTextFromId("NumberOfCoins"));
         }
         GameWorld.textHandler.setTextFieldWithId(_loc4_.tf_points,"OutsideAreaExpansionNowPrice");
         GameWorld.textHandler.setTextFieldWithId(_loc4_.tf_saleText,"BuyOutsideAreaExpansionSale");
         setButtonMode(_loc4_.mc_cancel,true);
         _loc4_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         if(!GameWorld.isItemAffordable(param1.itemConfig))
         {
            _loc4_.mc_tick.stop();
            _loc4_.mc_tick.visible = false;
            setButtonMode(_loc4_.mc_addCoins,true);
            if(cashOnly)
            {
               _loc4_.mc_addCoins.toolTip = new ToolTip(_loc4_.mc_addCoins,GameWorld.textHandler.getTextFromId("ToolTipNotEnoughPlayfishCash"));
            }
            else
            {
               _loc4_.mc_addCoins.toolTip = new ToolTip(_loc4_.mc_addCoins,GameWorld.textHandler.getTextFromId("ToolTipNotEnoughCoins"));
            }
            _loc4_.mc_addCoins.addEventListener(MouseEvent.CLICK,onAddCoinsClick,false,0,true);
         }
         else
         {
            _loc4_.mc_addCoins.stop();
            _loc4_.mc_addCoins.visible = false;
            setButtonMode(_loc4_.mc_tick,true);
            _loc4_.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
         }
      }
      
      private function onPurchaseCashItemCancel(param1:int) : void
      {
      }
      
      private function onAddCoinsClick(param1:MouseEvent) : void
      {
         remove();
         if(cashOnly)
         {
            GameWorld.cashPanel.showAddPlayfishCashPopUp();
         }
         else
         {
            GameWorld.cashPanel.showAddCoinsPopUp();
         }
      }
      
      private function onOutsideAreaSizeChange() : void
      {
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         var _loc2_:PurchaseCashItemConfirmPopUp = null;
         if(cashOnly)
         {
            _loc2_ = new PurchaseCashItemConfirmPopUp(outsideAreaItem,onPurchaseCashItemSuccess,onPurchaseCashItemCancel);
            _loc2_.show();
         }
         else
         {
            remove();
            GameWorld.cashPanel.addCoins(-outsideAreaItem.itemConfig.cost);
            GameWorld.saveProfileHandler.purchaseItem(outsideAreaItem);
            GameWorld.gameUser.addOutsideAreaSizeItem(outsideAreaItem);
            restaurant.setOutsideAreaSize(outsideAreaItem.sizeX,outsideAreaItem.sizeY);
            restaurant.paintOutsideAreaFloorMap();
         }
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      private function onPurchaseCashItemSuccess(param1:int) : void
      {
         remove();
         GameWorld.cashPanel.showPlayfishCashPopUp(-outsideAreaItem.itemConfig.cash);
         GameWorld.gameUser.addOutsideAreaSizeItem(outsideAreaItem);
         restaurant.setOutsideAreaSize(outsideAreaItem.sizeX,outsideAreaItem.sizeY);
         restaurant.paintOutsideAreaFloorMap();
      }
   }
}

