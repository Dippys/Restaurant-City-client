package com.playfish.games.cooking
{
   import flash.events.*;
   import flash.net.*;
   import flash.utils.ByteArray;
   
   public class NewsletterHandler
   {
      
      public var dates:Array;
      
      public var texts:Array;
      
      public var ids:Array;
      
      public function NewsletterHandler(param1:ByteArray)
      {
         var _loc4_:XML = null;
         ids = new Array();
         texts = new Array();
         dates = new Array();
         super();
         var _loc2_:XML = new XML(param1);
         var _loc3_:XMLList = _loc2_.newsletter;
         for each(_loc4_ in _loc3_)
         {
            texts.push(_loc4_.toString());
            ids.push(_loc4_.attribute("id").toString());
            dates.push(parseDateString(_loc4_.attribute("date").toString()));
         }
      }
      
      private function parseDateString(param1:String) : Date
      {
         var _loc2_:Array = param1.split("/");
         return new Date(_loc2_[2],_loc2_[1] - 1,_loc2_[0]);
      }
      
      public function isRead(param1:int, param2:GameUser) : Boolean
      {
         var _loc3_:int = param2.settings.getValue(GameSettings.TYPE_NEWSLETTER_READ_ID);
         return param1 <= _loc3_;
      }
      
      public function setRead(param1:int, param2:GameUser) : void
      {
         var _loc3_:int = param2.settings.getValue(GameSettings.TYPE_NEWSLETTER_READ_ID);
         if(param1 > _loc3_)
         {
            param2.settings.setValue(GameSettings.TYPE_NEWSLETTER_READ_ID,param1);
         }
      }
   }
}

