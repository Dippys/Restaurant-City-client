package com.playfish.coretech.billing
{
   public class PFProductType
   {
      
      public static var PLAYFISH_CASH:int = 2000;
      
      public var name:String;
      
      public var mcBankMenuPopup:String;
      
      public var textNumberOf:String;
      
      public var id:int;
      
      public var textAddProduct:String;
      
      public function PFProductType(param1:int, param2:String, param3:String, param4:String, param5:String)
      {
         super();
         this.id = param1;
         this.name = param2;
         this.textAddProduct = param3;
         this.textNumberOf = param4;
         this.mcBankMenuPopup = param5;
      }
   }
}

