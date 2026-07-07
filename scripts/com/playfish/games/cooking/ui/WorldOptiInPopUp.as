package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class WorldOptiInPopUp extends WorldPopUp
   {
      
      private var tickBoxYes:MovieClip;
      
      private var prevSetting:Boolean;
      
      private var tickBoxNo:MovieClip;
      
      public function WorldOptiInPopUp()
      {
         super(null,null,null);
         var _loc1_:MovieClip = Engine.getMovieClip("OptInMenuAnim");
         addChild(_loc1_);
         var _loc2_:MovieClip = _loc1_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(_loc2_.tf_text,"JoinGourmetClubText");
         GameWorld.textHandler.setTextFieldWithId(_loc2_.tf_yes,"Yes");
         GameWorld.textHandler.setTextFieldWithId(_loc2_.tf_no,"No");
         tickBoxYes = _loc2_.mc_tickBoxYes;
         tickBoxYes.buttonMode = true;
         tickBoxYes.stop();
         tickBoxYes.addEventListener(MouseEvent.MOUSE_DOWN,onTickBoxYesMouseDown,false,0,true);
         tickBoxNo = _loc2_.mc_tickBoxNo;
         tickBoxNo.buttonMode = true;
         tickBoxNo.stop();
         tickBoxNo.addEventListener(MouseEvent.MOUSE_DOWN,onTickBoxNoMouseDown,false,0,true);
         setButtonMode(_loc2_.mc_tick,true);
         _loc2_.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
         prevSetting = GameWorld.gameUser.userInfo.isInStreet;
         if(prevSetting)
         {
            tickBoxYes.gotoAndStop("tick");
            tickBoxNo.gotoAndStop("untick");
         }
         else
         {
            tickBoxNo.gotoAndStop("tick");
            tickBoxYes.gotoAndStop("untick");
         }
      }
      
      private function onTickBoxYesMouseDown(param1:MouseEvent) : void
      {
         tickBoxYes.gotoAndStop("tick");
         tickBoxNo.gotoAndStop("untick");
      }
      
      private function onTickBoxNoMouseDown(param1:MouseEvent) : void
      {
         tickBoxYes.gotoAndStop("untick");
         tickBoxNo.gotoAndStop("tick");
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         remove();
         var _loc2_:Boolean = tickBoxYes.currentLabel == "tick";
         if(_loc2_ != prevSetting)
         {
            GameWorld.gameUser.userInfo.isInStreet = _loc2_;
            GameWorld.forceAutoSave();
         }
      }
   }
}

