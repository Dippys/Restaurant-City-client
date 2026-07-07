package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.MovieClip;
   
   public class WorldLoadingPopUp extends WorldPopUp
   {
      
      public static const GIFTING:int = 1;
      
      public static const SAVING:int = 2;
      
      public static const QUIZ:int = 3;
      
      public static const TRADING:int = 4;
      
      public static const MESSAGE:int = 5;
      
      public static const ENTERING:int = 6;
      
      public static const SECURE_TRADE:int = 7;
      
      public static const RANDOM_STREET:int = 8;
      
      public static const RATING:int = 9;
      
      public static const GOURMET_STREET:int = 10;
      
      public static const PHOTO:int = 11;
      
      public static const PURCHASE_CASH_ITEM:int = 12;
      
      private var scene:MovieClip;
      
      public function WorldLoadingPopUp(param1:String, param2:int)
      {
         super(null,null,null);
         scene = Engine.getMovieClip("PleaseWait");
         addChild(scene);
         var _loc3_:MovieClip = scene.mc_content;
         _loc3_.mc_icon.gotoAndStop(param2);
         GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_pleaseWait,"PleaseWait");
         if(param1 != null)
         {
            GameWorld.textHandler.setTextField(_loc3_.tf_text,param1);
         }
      }
      
      override public function show() : void
      {
         if(activePopUp.indexOf(this) == -1)
         {
            super.show();
            scene.gotoAndPlay("in");
         }
      }
   }
}

