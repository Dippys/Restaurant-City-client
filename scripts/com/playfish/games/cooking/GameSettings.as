package com.playfish.games.cooking
{
   import flash.utils.ByteArray;
   
   public class GameSettings
   {
      
      public static const DATA_VERSION:int = 1;
      
      public static const TYPE_QUIZ_TUTORIAL_STEP:int = 0;
      
      public static const TYPE_MAIL_CLIENT_TUTORIAL_STEP:int = 1;
      
      public static const TYPE_RECIPE_MENU_TUTORIAL_STEP:int = 2;
      
      public static const TYPE_STREET_TUTORIAL_STEP:int = 3;
      
      public static const TYPE_FIRST_TIME_ACCESS:int = 4;
      
      public static const TYPE_FIRST_TIME_ACCESS_2:int = 5;
      
      public static const TYPE_NEWSLETTER_READ_ID:int = 6;
      
      private var data:Array = [0,0,0,0,0,0,0];
      
      public function GameSettings()
      {
         super();
      }
      
      public function loadBytes(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         if(param1.bytesAvailable > 0)
         {
            _loc2_ = param1.readByte();
            if(_loc2_ == DATA_VERSION)
            {
               _loc3_ = int(param1.bytesAvailable);
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  data[_loc4_] = param1.readByte();
                  _loc4_++;
               }
            }
         }
      }
      
      public function getValue(param1:int) : int
      {
         return data[param1];
      }
      
      public function getBytes() : ByteArray
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeByte(DATA_VERSION);
         var _loc2_:Number = 0;
         while(_loc2_ < data.length)
         {
            _loc1_.writeByte(data[_loc2_]);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function setValue(param1:int, param2:int) : void
      {
         data[param1] = param2;
      }
   }
}

