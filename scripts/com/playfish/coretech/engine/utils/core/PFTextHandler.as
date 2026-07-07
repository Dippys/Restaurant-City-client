package com.playfish.coretech.engine.utils.core
{
   import com.playfish.coretech.engine.core.*;
   import flash.net.*;
   import flash.xml.*;
   
   public class PFTextHandler extends PFXMLLoader
   {
      
      public static var instance:PFTextHandler;
      
      public static var textMappings:Object;
      
      private static const MINIMUM_FONT_SIZE:uint = 12;
      
      public static var langCode:String = "en";
      
      public function PFTextHandler(param1:String, param2:Boolean = true)
      {
         super(param1,param2);
         instance = this;
         textMappings = new Object();
      }
      
      public static function isLanguageLoaded(param1:String) : Boolean
      {
         return textMappings != null && textMappings[param1] != null;
      }
      
      override public function initialiseFromXML(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         for each(_loc2_ in param1..content)
         {
            textMappings[_loc2_.@lang] = new Object();
            for each(_loc3_ in _loc2_..text)
            {
               if(PFDebug.DEBUG)
               {
                  PFDebug.assert(textMappings[_loc2_.@lang][_loc3_.@id] == null,"Duplicate language entry! langCode: " + _loc2_.@lang + ", textId: " + _loc3_.@id);
               }
               _loc4_ = _loc3_.toString();
               _loc5_ = int(_loc3_.@maxLength);
               if(PFDebug.DEBUG)
               {
                  PFDebug.assert(_loc4_.length <= _loc5_,"Translation too long! langCode: " + _loc2_.@lang + ", textId: " + _loc3_.@id + ", length: " + _loc4_.length + ", max: " + _loc5_);
                  PFDebug.assert(_loc4_.length > 0,"String is empty, textId: " + _loc3_.@id + ", langCode: " + _loc2_.@lang);
               }
               textMappings[_loc2_.@lang][_loc3_.@id] = _loc4_;
            }
            if(PFDebug.DEBUG && _loc2_.@lang != "en")
            {
               _loc6_ = textMappings["en"];
               if(_loc6_ != null)
               {
                  _loc7_ = textMappings[_loc2_.@lang];
                  _loc8_ = new Array();
                  _loc9_ = new Array();
                  for(_loc10_ in _loc6_)
                  {
                     if(!_loc7_[_loc10_])
                     {
                        _loc8_.push(_loc10_);
                     }
                  }
                  for(_loc10_ in _loc7_)
                  {
                     if(!_loc6_[_loc10_])
                     {
                        _loc9_.push(_loc10_);
                     }
                  }
                  if(_loc8_.length > 0)
                  {
                     PFDebug.warning("Language " + _loc2_.@lang + " has missing text ids compared to english: " + _loc8_);
                  }
                  if(_loc9_.length > 0)
                  {
                     PFDebug.warning("Language " + _loc2_.@lang + " has additional text ids compared to english: " + _loc9_);
                  }
               }
            }
         }
      }
   }
}

