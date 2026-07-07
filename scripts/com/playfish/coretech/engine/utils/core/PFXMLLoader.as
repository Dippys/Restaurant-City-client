package com.playfish.coretech.engine.utils.core
{
   import com.playfish.coretech.engine.core.*;
   import flash.events.*;
   import flash.net.*;
   
   public class PFXMLLoader extends PFSingleton implements PFIXMLParser
   {
      
      private var autoInit:Boolean;
      
      private var loader:URLLoader;
      
      private var xmlURL:String;
      
      public function PFXMLLoader(param1:String, param2:Boolean = true)
      {
         super();
         loadFromURL(param1,param2);
      }
      
      public static function getDateAttribute(param1:XML, param2:String) : Date
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Date = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc3_:String = param1.attribute(param2);
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.split(" ");
            _loc5_ = _loc4_[0].split("-");
            if(_loc5_.length == 3)
            {
               _loc6_ = parseInt(_loc5_[0]);
               _loc7_ = parseInt(_loc5_[1]);
               _loc8_ = parseInt(_loc5_[2]);
               _loc9_ = new Date(_loc6_,_loc7_,_loc8_);
               if(_loc4_.length == 2)
               {
                  _loc10_ = _loc4_[1].split(":");
                  _loc11_ = _loc10_.length >= 1 ? int(parseInt(_loc10_[0])) : 0;
                  _loc12_ = _loc10_.length >= 2 ? int(parseInt(_loc10_[1])) : 0;
                  _loc13_ = _loc10_.length >= 3 ? int(parseInt(_loc10_[2])) : 0;
                  _loc9_.setHours(_loc11_,_loc12_,_loc13_);
               }
               return _loc9_;
            }
         }
         throw new PFXMLSyntaxError("Invalid date value in attribute \"" + param2 + "\"");
      }
      
      public static function getBooleanAttribute(param1:XML, param2:String) : Boolean
      {
         var _loc3_:String = param1.attribute(param2);
         if(_loc3_ != null)
         {
            _loc3_ = _loc3_.toLowerCase();
         }
         if(_loc3_ == "true")
         {
            return true;
         }
         if(_loc3_ == "false")
         {
            return false;
         }
         throw new PFXMLSyntaxError("Invalid boolean value in attribute \"" + param2 + "\"");
      }
      
      public static function getElementNames(param1:XML, param2:Array) : Array
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:XML = null;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         var _loc13_:XML = null;
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc9_:int = 0;
         _loc6_ = 0;
         while(_loc6_ < param2.length)
         {
            _loc12_ = param2[_loc6_] as String;
            _loc3_.push(new Array());
            _loc4_.push(new Array());
            _loc5_.push(new Array());
            for each(_loc13_ in param1.elements(_loc12_))
            {
               _loc3_[_loc6_].push(_loc13_);
               _loc5_[_loc6_].push(_loc12_);
               _loc9_++;
            }
            _loc6_++;
         }
         _loc8_ = 0;
         for each(_loc10_ in param1.elements())
         {
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc3_[_loc6_].length)
               {
                  if(_loc10_ == _loc3_[_loc6_][_loc7_])
                  {
                     _loc4_[_loc6_][_loc7_] = _loc8_;
                  }
                  _loc7_++;
               }
               _loc6_++;
            }
            _loc8_++;
         }
         _loc11_ = new Array();
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc4_[_loc6_].length)
               {
                  if(_loc4_[_loc6_][_loc7_] == _loc8_)
                  {
                     _loc11_.push(_loc5_[_loc6_][_loc7_]);
                  }
                  _loc7_++;
               }
               _loc6_++;
            }
            _loc8_++;
         }
         return _loc11_;
      }
      
      public static function getNumberAttribute(param1:XML, param2:String) : Number
      {
         var _loc3_:String = param1.attribute(param2);
         if(_loc3_ != null)
         {
            return new Number(_loc3_);
         }
         throw new PFXMLSyntaxError("Invalid number value in attribute \"" + param2 + "\"");
      }
      
      public static function assertTags(param1:XML, param2:Array) : Boolean
      {
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc3_:XMLList = param1.children();
         for(_loc4_ in _loc3_)
         {
            _loc5_ = 0;
            while(_loc5_ < param2.length)
            {
               if(param1.child(param2[_loc5_]).contains(_loc3_[_loc4_]))
               {
                  break;
               }
               _loc5_++;
            }
            if(_loc5_ == param2.length)
            {
               throw new PFXMLSyntaxError("Unknown tag. Expected one of: [" + param2 + "] in:\n" + param1);
            }
         }
         return true;
      }
      
      private function onFileLoaded(param1:Event = null) : void
      {
         var _loc2_:XML = null;
         if(autoInit)
         {
            _loc2_ = new XML(param1.currentTarget.data);
            initialiseFromXML(_loc2_);
            disposeOfLoader();
         }
      }
      
      public function getLoader() : URLLoader
      {
         return loader;
      }
      
      public function disposeOfLoader() : void
      {
         loader.removeEventListener(Event.COMPLETE,onFileLoaded);
         loader = null;
      }
      
      public function isXMLLoaded() : Boolean
      {
         return loader == null;
      }
      
      public function initialiseFromXML(param1:XML) : void
      {
      }
      
      public function loadFromURL(param1:String, param2:Boolean = true) : void
      {
         this.autoInit = param2;
         this.xmlURL = param1;
         var _loc3_:URLRequest = new URLRequest(param1);
         loader = new URLLoader(_loc3_);
         loader.addEventListener(Event.COMPLETE,onFileLoaded);
      }
   }
}

