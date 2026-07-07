package com.playfish.games.cooking
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class FullScreenTextFieldHandler
   {
      
      private static var textFields:Array = new Array();
      
      private static var banners:Array = new Array();
      
      public function FullScreenTextFieldHandler()
      {
         super();
      }
      
      public static function unlockTextFieldInFullScreenMode(param1:TextField) : void
      {
         var _loc2_:int = textFields.indexOf(param1);
         if(_loc2_ != -1)
         {
            param1.parent.removeChild(banners[_loc2_]);
            param1.alpha = 1;
            banners.splice(_loc2_,1);
            textFields.splice(_loc2_,1);
         }
      }
      
      public static function lockTextFieldInFullScreenMode(param1:TextField) : void
      {
         var _loc2_:MovieClip = null;
         if(textFields.indexOf(param1) == -1)
         {
            _loc2_ = Engine.getMovieClip("FullscreenTextPopup");
            GameWorld.textHandler.setTextFieldWithId(_loc2_.tf_text,"TextLockedInFullscreen");
            _loc2_.x = param1.x + param1.width / 2;
            _loc2_.y = param1.y + param1.height / 2;
            param1.parent.addChildAt(_loc2_,param1.parent.getChildIndex(param1) + 1);
            param1.alpha = 0.5;
            textFields.push(param1);
            banners.push(_loc2_);
         }
      }
   }
}

