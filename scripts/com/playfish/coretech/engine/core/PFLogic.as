package com.playfish.coretech.engine.core
{
   public class PFLogic
   {
      
      public static const szTRUE:String = "true";
      
      public static const szFALSE:String = "false";
      
      public function PFLogic()
      {
         super();
      }
      
      public static function getBoolean(param1:String) : Boolean
      {
         return isTrue(param1);
      }
      
      public static function isFalse(param1:String) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var _loc2_:String = param1.toLowerCase();
         if(_loc2_ == "false" || _loc2_ == "0" || _loc2_ == "no" || _loc2_ == "off")
         {
            return true;
         }
         return false;
      }
      
      public static function isTrue(param1:String) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var _loc2_:String = param1.toLowerCase();
         if(_loc2_ == "true" || _loc2_ == "1" || _loc2_ == "yes" || _loc2_ == "on")
         {
            return true;
         }
         return false;
      }
   }
}

