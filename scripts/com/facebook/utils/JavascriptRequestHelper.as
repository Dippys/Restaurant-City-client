package com.facebook.utils
{
   import flash.net.URLVariables;
   import flash.utils.getQualifiedClassName;
   
   public class JavascriptRequestHelper
   {
      
      public function JavascriptRequestHelper()
      {
         super();
      }
      
      public static function objectToString(param1:Object) : String
      {
         var _loc3_:String = null;
         var _loc2_:Array = [];
         for(_loc3_ in param1)
         {
            _loc2_.push(_loc3_ + ": " + quote(param1[_loc3_]) + "");
         }
         return "{" + _loc2_.join(", ") + " }";
      }
      
      public static function quote(param1:String) : String
      {
         var _loc2_:RegExp = /[\\"\r\n]/g;
         return "\"" + param1.replace(_loc2_,_quote) + "\"";
      }
      
      public static function formatParams(param1:Array) : String
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc2_:Array = [];
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = getQualifiedClassName(_loc5_);
            switch(_loc6_)
            {
               case "Array":
                  _loc5_ = "[" + _loc5_.join(", ") + "]";
                  break;
               case "Object":
                  _loc5_ = objectToString(_loc5_);
                  break;
               case "String":
                  _loc5_ = "\"" + _loc5_ + "\"";
            }
            _loc2_.push(_loc5_);
            _loc4_++;
         }
         return _loc2_.join(", ");
      }
      
      protected static function _quote(param1:String, ... rest) : String
      {
         switch(param1)
         {
            case "\\":
               return "\\\\";
            case "\r":
               return "\\r";
            case "\n":
               return "\\n";
            case "\"":
               return "\\\"";
            default:
               return null;
         }
      }
      
      public static function formatURLVariables(param1:URLVariables) : String
      {
         var _loc5_:String = null;
         var _loc2_:Object = {
            "method":true,
            "sig":true,
            "api_key":true,
            "call_id":true
         };
         var _loc3_:Boolean = false;
         var _loc4_:Object = {};
         for(_loc5_ in param1)
         {
            if(!_loc2_[_loc5_])
            {
               _loc3_ = true;
               _loc4_[_loc5_] = param1[_loc5_];
            }
         }
         return _loc3_ ? objectToString(_loc4_) : "null";
      }
   }
}

