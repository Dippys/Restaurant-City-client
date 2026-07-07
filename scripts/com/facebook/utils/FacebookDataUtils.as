package com.facebook.utils
{
   import com.adobe.serialization.json.JSON;
   
   public class FacebookDataUtils
   {
      
      public function FacebookDataUtils()
      {
         super();
      }
      
      public static function toJSONValuesArray(param1:Array) : String
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Array = [];
         var _loc3_:Number = param1.length;
         var _loc4_:Number = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.push(com.adobe.serialization.json.JSON.encode(param1[_loc4_]));
            _loc4_++;
         }
         return _loc2_.join(",");
      }
      
      public static function formatDate(param1:String) : Date
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         if(param1 == "" || param1 == null)
         {
            return null;
         }
         var _loc2_:Date = new Date();
         var _loc3_:Array = param1.split(" ");
         if(_loc3_.length == 2)
         {
            _loc4_ = _loc3_[0].split("-");
            _loc5_ = _loc3_[1].split(":");
            _loc2_.setFullYear(_loc4_[0]);
            _loc2_.setMonth(_loc4_[1] - 1);
            _loc2_.setDate(_loc4_[2]);
            _loc2_.setHours(_loc5_[0]);
            _loc2_.setMinutes(_loc5_[1]);
            _loc2_.setSeconds(_loc5_[2]);
         }
         else
         {
            _loc2_.setTime(parseInt(param1) * 1000);
         }
         return _loc2_;
      }
      
      public static function facebookCollectionToJSONArray(param1:FacebookArrayCollection) : String
      {
         if(param1 == null)
         {
            return null;
         }
         return com.adobe.serialization.json.JSON.encode(param1.toArray());
      }
      
      public static function toDateString(param1:Date) : String
      {
         if(param1 == null)
         {
            return null;
         }
         param1.setDate(param1.date + 1);
         return param1 == null ? null : param1.getTime().toString().slice(0,10);
      }
      
      public static function supplantString(param1:String, param2:Object) : String
      {
         var _loc4_:String = null;
         var _loc3_:String = param1;
         for(_loc4_ in param2)
         {
            _loc3_ = _loc3_.replace(new RegExp("\\{" + _loc4_ + "\\}","g"),param2[_loc4_]);
         }
         return _loc3_;
      }
      
      public static function toArrayString(param1:Array) : String
      {
         return param1 == null ? null : param1.join(",");
      }
   }
}

