package com.playfish.games.cooking.actors
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.WorldIngredientShopPopUp;
   import com.playfish.games.cooking.ui.bank.*;
   import com.playfish.rpc.share.Pricepoint;
   import flash.events.MouseEvent;
   
   public class Billboard extends RestaurantActor
   {
      
      private var pricepoint:Pricepoint;
      
      public function Billboard(param1:int, param2:int, param3:WorldRestaurant)
      {
         var _loc6_:Pricepoint = null;
         var _loc7_:String = null;
         super("RestaurantBillBoard",param3);
         setTilePosition(param1,param2);
         content.mc_billboard.gotoAndStop("generic");
         addEventListener(MouseEvent.CLICK,onClick,false,0,true);
         setButtonMode(content,true);
         setHandCursor(content,true);
         var _loc4_:Array = WorldBankPaymentProvider.getPricepoints(WorldBankPaymentProvider.PRODUCT_TYPE_PLAYFISH_CASH,Pricepoint.PAYMENT_PROVIDER_TRIALPAY_CURRENCY);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            if(Boolean(_loc6_.clientData) && _loc6_.clientData["type"] == "offer")
            {
               _loc7_ = Engine.instance.getParameter("pf_user_country").toLowerCase();
               if(_loc7_ == "us")
               {
                  this.pricepoint = _loc6_;
                  content.mc_billboard.gotoAndStop("proflowers");
               }
               else if(_loc7_ == "uk" || _loc7_ == "gb")
               {
                  this.pricepoint = _loc6_;
                  content.mc_billboard.gotoAndStop("serenataflowers");
               }
               break;
            }
            _loc5_++;
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldBankPaymentAgreement = null;
         var _loc3_:WorldIngredientShopPopUp = null;
         if(!restaurant.moveGesture)
         {
            if(pricepoint)
            {
               _loc2_ = new WorldBankPaymentAgreement(pricepoint,WorldBankPaymentAgreement.BACK_TO_NONE);
               _loc2_.show();
            }
            else
            {
               _loc3_ = new WorldIngredientShopPopUp();
               _loc3_.show();
            }
         }
      }
   }
}

