package com.playfish.games.cooking.ui.bank
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   
   public class WorldWhatIsPlayFishCash extends WorldPopUp
   {
      
      private var backToBank:Boolean;
      
      public function WorldWhatIsPlayFishCash(param1:Boolean)
      {
         super(null,null,null);
         this.backToBank = param1;
         var _loc2_:MovieClip = Engine.getMovieClip("WhatIsPlayfishCashPopup");
         addChild(_loc2_);
         var _loc3_:MovieClip = _loc2_.mc_content;
         setButtonMode(_loc3_.mc_addPlayfishCash,true);
         setButtonMode(_loc3_.mc_cancel,true);
         _loc3_.mc_addPlayfishCash.addEventListener(MouseEvent.CLICK,onAddCashClick,false,0,true);
         _loc3_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
      }
      
      private function onAddCashClick(param1:MouseEvent) : void
      {
         remove();
         var _loc2_:WorldBankPaymentProvider = new WorldBankPaymentProvider(WorldBankPaymentProvider.PRODUCT_TYPE_PLAYFISH_CASH);
         _loc2_.show();
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldBankPaymentProvider = null;
         remove();
         if(backToBank)
         {
            _loc2_ = new WorldBankPaymentProvider(WorldBankPaymentProvider.PRODUCT_TYPE_PLAYFISH_CASH);
            _loc2_.show();
         }
      }
   }
}

