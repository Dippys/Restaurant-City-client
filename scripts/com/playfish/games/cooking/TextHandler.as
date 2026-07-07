package com.playfish.games.cooking
{
   import flash.events.*;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   
   public class TextHandler
   {
      
      private static const MAX_REPLACE_DEPTH:int = 3;
      
      private var defaultTextLoader:TextGroup;
      
      private var replaceTexts:Array = new Array();
      
      private var textLoaders:Object = new Object();
      
      public var curLangCode:String;
      
      public function TextHandler()
      {
         super();
      }
      
      public function setReplaceString(param1:String, param2:String) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < replaceTexts.length)
         {
            if(replaceTexts[_loc3_].id == param1)
            {
               replaceTexts[_loc3_].replaceText = param2;
               return;
            }
            _loc3_++;
         }
         var _loc4_:Object = new Object();
         _loc4_.id = param1;
         _loc4_.replaceText = param2;
         replaceTexts.push(_loc4_);
      }
      
      public function load(param1:String, param2:ByteArray, param3:Boolean = false) : TextGroup
      {
         var _loc4_:TextGroup = new TextGroup(param2,param1);
         textLoaders[_loc4_.langCode] = _loc4_;
         if(param3)
         {
            defaultTextLoader = _loc4_;
         }
         return _loc4_;
      }
      
      public function getTextFromId(param1:String, param2:int = 0) : String
      {
         var _loc3_:TextGroup = defaultTextLoader;
         if(textLoaders[curLangCode])
         {
            _loc3_ = textLoaders[curLangCode];
         }
         var _loc4_:String = null;
         var _loc5_:int = _loc3_.textId.indexOf(param1);
         if(Boolean(_loc5_ == -1) && Boolean(defaultTextLoader) && _loc3_ != defaultTextLoader)
         {
            _loc3_ = defaultTextLoader;
            _loc5_ = defaultTextLoader.textId.indexOf(param1);
         }
         if(_loc5_ != -1)
         {
            _loc4_ = getText(_loc3_.textBody[_loc5_],param2);
         }
         else
         {
            _loc4_ = replaceGameString(param1);
         }
         if(_loc4_ != null)
         {
            return _loc4_.replace(/\\n/g,"\n");
         }
         return null;
      }
      
      public function getText(param1:String, param2:int = 0) : String
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         if(param2++ >= MAX_REPLACE_DEPTH)
         {
            return param1;
         }
         var _loc3_:int = 0;
         do
         {
            _loc4_ = param1.indexOf("%",_loc3_);
            _loc5_ = null;
            if(_loc4_ != -1)
            {
               _loc6_ = param1.indexOf("%",_loc4_ + 1);
               if(_loc6_ != -1)
               {
                  _loc5_ = param1.substring(_loc4_ + 1,_loc6_);
                  _loc7_ = getTextFromId(_loc5_,param2);
                  if(_loc7_ == null)
                  {
                     _loc7_ = _loc5_;
                  }
                  param1 = param1.substring(0,_loc4_) + _loc7_ + param1.substring(_loc6_ + 1);
                  _loc3_ = _loc4_ + _loc7_.length;
               }
            }
         }
         while(_loc5_ != null);
         return param1;
      }
      
      public function setTextField(param1:TextField, param2:String, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc5_:TextFormat = null;
         var _loc6_:* = 0;
         if(param3)
         {
            param1.htmlText = param2;
         }
         else
         {
            param1.text = param2;
         }
         if(param4)
         {
            _loc5_ = param1.defaultTextFormat;
            _loc6_ = 12;
            if(_loc5_.size)
            {
               _loc6_ = int(_loc5_.size);
            }
            while(param1.textWidth > param1.width || param1.scrollH > 0)
            {
               _loc6_--;
               _loc5_.size = _loc6_;
               param1.scrollH = 0;
               param1.setTextFormat(_loc5_);
               param1.defaultTextFormat = _loc5_;
            }
         }
         if(!param3)
         {
            param1.mouseEnabled = false;
         }
      }
      
      public function setTextFieldWithId(param1:TextField, param2:String, param3:Boolean = false) : void
      {
         setTextField(param1,getTextFromId(param2),param3);
      }
      
      protected function replaceGameString(param1:String) : String
      {
         var _loc2_:Number = 0;
         while(_loc2_ < replaceTexts.length)
         {
            if(replaceTexts[_loc2_].id == param1)
            {
               return replaceTexts[_loc2_].replaceText;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function setFontSize(param1:TextField, param2:int) : void
      {
         var _loc3_:TextFormat = param1.defaultTextFormat;
         if(int(_loc3_.size) != param2)
         {
            _loc3_.size = param2;
            param1.setTextFormat(_loc3_);
            param1.defaultTextFormat = _loc3_;
         }
      }
   }
}

