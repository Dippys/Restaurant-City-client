package com.playfish.coretech.engine.core
{
   public class PFString
   {
      
      public static const vowelPattern:RegExp = /[AEIOU]+/i;
      
      public function PFString()
      {
         super();
      }
      
      public static function toSQLString(param1:String) : String
      {
         var _loc2_:RegExp = /['"]/g;
         return param1.replace(_loc2_,"\\$&");
      }
      
      public static function replaceAllLazyFunc(param1:String, param2:*, param3:Function) : String
      {
         if(param1 == null)
         {
            return null;
         }
         if(param2 is String)
         {
            param2 = new RegExp(param2,"g");
         }
         if(param1.search(param2) != -1)
         {
            return param1.replace(param2,param3());
         }
         return param1;
      }
      
      public static function trimFront(param1:String, param2:String) : String
      {
         param2 = stringToCharacter(param2);
         if(param1.charAt(0) == param2)
         {
            param1 = trimFront(param1.substring(1),param2);
         }
         return param1;
      }
      
      public static function fillZeros(param1:String, param2:int) : String
      {
         while(param1.length < param2)
         {
            param1 = "0" + param1;
         }
         return param1;
      }
      
      public static function trim(param1:String, param2:String = " ") : String
      {
         return trimBack(trimFront(param1,param2),param2);
      }
      
      public static function isVowel(param1:String) : Boolean
      {
         return param1 != null && param1.search(vowelPattern) == 0;
      }
      
      public static function replaceAll(param1:String, param2:*, param3:Object) : String
      {
         if(param1 == null)
         {
            return null;
         }
         if(param2 is String)
         {
            param2 = new RegExp(param2,"g");
         }
         return param1.replace(param2,param3);
      }
      
      public static function trimBack(param1:String, param2:String) : String
      {
         param2 = stringToCharacter(param2);
         if(param1.charAt(param1.length - 1) == param2)
         {
            param1 = trimBack(param1.substring(0,param1.length - 1),param2);
         }
         return param1;
      }
      
      public static function removeSpaces(param1:String) : String
      {
         return param1.split(" ").join("");
      }
      
      public static function capitalise(param1:String) : String
      {
         if(param1 == null)
         {
            return null;
         }
         return param1.substr(0,1).toUpperCase() + param1.substring(1);
      }
      
      public static function isNullOrEmpty(param1:String) : Boolean
      {
         return param1 == null || param1 == "";
      }
      
      public static function intToString(param1:int, param2:String = null, param3:String = null) : String
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         var _loc4_:String = "";
         if(param2 == null)
         {
            param2 = PFLocaleNumeric.getSeparator();
         }
         if(param3 == null)
         {
            param3 = PFLocaleNumeric.getGrouping();
         }
         if(param3 == "3;-1")
         {
            while(param1 >= 1000)
            {
               _loc5_ = param1 % 1000;
               _loc6_ = _loc5_ < 100 ? (_loc5_ < 10 ? "00" : "0") : "";
               _loc4_ = _loc6_ + String(_loc5_) + _loc4_;
               _loc4_ = param2 + _loc4_;
               param1 /= 1000;
            }
            _loc4_ = String(param1) + _loc4_;
         }
         else
         {
            _loc7_ = param3.split(";");
            _loc8_ = new Array(1,10,100,1000,10000);
            _loc9_ = 0;
            PFDebug.assert(false,"Please write this code!");
         }
         return _loc4_;
      }
      
      public static function stringToCharacter(param1:String) : String
      {
         if(param1.length == 1)
         {
            return param1;
         }
         return param1.slice(0,1);
      }
      
      public static function splitAndTrim(param1:String, param2:String = ",") : Array
      {
         var _loc4_:String = null;
         var _loc3_:Array = new Array();
         if(!PFString.isNullOrEmpty(param1))
         {
            for each(_loc4_ in param1.split(param2))
            {
               _loc3_.push(PFString.trim(_loc4_));
            }
         }
         return _loc3_;
      }
   }
}

