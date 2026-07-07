package com.playfish.coretech.engine.core
{
   public class PFLocaleNumeric
   {
      
      public function PFLocaleNumeric()
      {
         super();
      }
      
      public static function initialize(param1:String) : void
      {
      }
      
      public static function getGrouping() : String
      {
         return "3;-1";
      }
      
      public static function intToString(param1:int) : String
      {
         return PFString.intToString(param1,getSeparator(),getGrouping());
      }
      
      public static function getDecimalPoint() : String
      {
         return ".";
      }
      
      public static function getSeparator() : String
      {
         return ",";
      }
   }
}

