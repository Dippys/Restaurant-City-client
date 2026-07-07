package com.facebook.utils
{
   import com.facebook.data.FacebookLocation;
   import com.facebook.data.photos.AlbumCollection;
   import com.facebook.data.photos.AlbumData;
   import flash.net.URLVariables;
   
   public class FacebookXMLParserUtils
   {
      
      public function FacebookXMLParserUtils()
      {
         super();
      }
      
      public static function createAlbumCollection(param1:XML, param2:Namespace) : AlbumCollection
      {
         var _loc4_:* = undefined;
         var _loc5_:AlbumData = null;
         var _loc3_:AlbumCollection = new AlbumCollection();
         for each(_loc4_ in param1..param2::album)
         {
            _loc5_ = new AlbumData();
            _loc5_.aid = FacebookXMLParserUtils.toStringValue(_loc4_.param2::aid[0]);
            _loc5_.cover_pid = FacebookXMLParserUtils.toStringValue(_loc4_.param2::cover_pid[0]);
            _loc5_.owner = _loc4_.param2::owner;
            _loc5_.name = _loc4_.param2::name;
            _loc5_.created = FacebookXMLParserUtils.toDate(_loc4_.param2::created);
            _loc5_.modified = FacebookXMLParserUtils.toDate(_loc4_.param2::modified);
            _loc5_.description = _loc4_.param2::description;
            _loc5_.location = _loc4_.param2::location;
            _loc5_.link = _loc4_.param2::link;
            _loc5_.size = _loc4_.param2::size;
            _loc5_.visible = _loc4_.param2::visible;
            _loc3_.addAlbum(_loc5_);
         }
         return _loc3_;
      }
      
      public static function toNumber(param1:XML) : Number
      {
         if(param1 == null)
         {
            return NaN;
         }
         return Number(param1.toString());
      }
      
      public static function toStringValue(param1:XML) : String
      {
         if(param1 == null)
         {
            return null;
         }
         return param1.toString();
      }
      
      public static function toDate(param1:String) : Date
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:String = param1;
         while(_loc2_.length < 13)
         {
            _loc2_ += "0";
         }
         return new Date(Number(_loc2_));
      }
      
      public static function xmlListToObjectArray(param1:XMLList) : Array
      {
         var _loc2_:Array = [];
         if(param1 == null)
         {
            return _loc2_;
         }
         var _loc3_:uint = uint(param1.length());
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.push(xmlToObject(param1[_loc4_]));
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function toUIDArray(param1:XML) : Array
      {
         var _loc2_:Array = [];
         if(param1 == null)
         {
            return _loc2_;
         }
         var _loc3_:XMLList = param1.children();
         var _loc4_:uint = uint(_loc3_.length());
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_.push(toNumber(_loc3_[_loc5_]));
            _loc5_++;
         }
         return _loc2_;
      }
      
      public static function toBoolean(param1:XML) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         return param1.toString() == "1";
      }
      
      public static function createLocation(param1:XML, param2:Namespace) : FacebookLocation
      {
         var _loc3_:FacebookLocation = new FacebookLocation();
         if(param1 == null)
         {
            return _loc3_;
         }
         _loc3_.city = String(param1.param2::city);
         _loc3_.state = String(param1.param2::state);
         _loc3_.country = String(param1.param2::country);
         _loc3_.zip = String(param1.param2::zip);
         _loc3_.street = String(param1.param2::street);
         return _loc3_;
      }
      
      public static function xmlToObject(param1:XML) : Object
      {
         var _loc6_:XML = null;
         var _loc2_:Object = {};
         var _loc3_:XMLList = param1.children();
         var _loc4_:uint = uint(_loc3_.length());
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            _loc2_[_loc6_.localName()] = _loc6_.toString();
            _loc5_++;
         }
         return _loc2_;
      }
      
      public static function xmlToUrlVariables(param1:XMLList) : URLVariables
      {
         var _loc3_:XML = null;
         var _loc2_:URLVariables = new URLVariables();
         for each(_loc3_ in param1)
         {
            _loc2_[_loc3_.key.valueOf()] = _loc3_.value.valueOf();
         }
         return _loc2_;
      }
      
      public static function nodeToObject(param1:XMLList) : Object
      {
         var _loc3_:XML = null;
         var _loc2_:Object = {};
         for each(_loc3_ in param1)
         {
            _loc2_[_loc3_.key.valueOf()] = _loc3_.value.valueOf();
         }
         return _loc2_;
      }
      
      public static function toArray(param1:XML) : Array
      {
         if(param1 == null)
         {
            return null;
         }
         return param1.toString().split(",");
      }
   }
}

