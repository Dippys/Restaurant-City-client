package com.playfish.games.cooking.debug
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.rpc.RpcGetPricepoints;
   import flash.events.MouseEvent;
   
   public class DebugTogglePaymentCountry extends DebugEntryToggle
   {
      
      public function DebugTogglePaymentCountry()
      {
         super("Toggle the payment country",null);
      }
      
      override public function getButton() : Object
      {
         texts = ["uk","us","it","es"];
         textIndex = texts.indexOf(Engine.instance.getParameterString("pf_user_country"));
         if(textIndex == -1)
         {
            textIndex = 0;
         }
         return toggle;
      }
      
      override protected function onLeftClick(param1:MouseEvent) : void
      {
         super.onLeftClick(param1);
         var _loc2_:String = texts[textIndex];
         Engine.instance.setParameter("pf_user_country",_loc2_);
         Engine.instance.debugExtra = _loc2_;
         var _loc3_:RpcGetPricepoints = new RpcGetPricepoints(_loc2_);
         _loc3_.commit();
      }
      
      override protected function onRightClick(param1:MouseEvent) : void
      {
         super.onRightClick(param1);
         var _loc2_:String = texts[textIndex];
         Engine.instance.setParameter("pf_user_country",_loc2_);
         Engine.instance.debugExtra = _loc2_;
         var _loc3_:RpcGetPricepoints = new RpcGetPricepoints(_loc2_);
         _loc3_.commit();
      }
      
      override public function isAvailable() : Boolean
      {
         return true;
      }
   }
}

