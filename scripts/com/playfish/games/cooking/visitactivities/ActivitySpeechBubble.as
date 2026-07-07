package com.playfish.games.cooking.visitactivities
{
   import com.playfish.games.cooking.Engine;
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.WorldRestaurantPlay;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ActivitySpeechBubble
   {
      
      public static const STATE_FREEZE:int = 0;
      
      public static const STATE_IN:int = 1;
      
      public static const STATE_IDLE:int = 2;
      
      public static const STATE_OUT:int = 3;
      
      public static const STATE_THANKS:int = 4;
      
      public static const STATE_DISAPPEAR:int = 5;
      
      public static const STATE_FINISH:int = 6;
      
      public static const STRING_REPLACE:String = "activityReward";
      
      public static const POSITION_X:int = 450;
      
      public static const POSITION_Y:int = -205;
      
      public var timer:int = 1000;
      
      public var readyToBegin:Boolean = false;
      
      public var popUp:MovieClip;
      
      public var speechBubble:MovieClip;
      
      public var state:int = 0;
      
      public var userContainer:MovieClip;
      
      public var restaurant:WorldRestaurantPlay;
      
      public function ActivitySpeechBubble(param1:WorldRestaurantPlay, param2:String)
      {
         super();
         this.restaurant = param1;
         popUp = Engine.getMovieClip("VisitTextPopup");
         popUp.x = POSITION_X;
         popUp.y = POSITION_Y;
         userContainer = popUp.mc_usercontainer;
         speechBubble = popUp.mc_speech;
         var _loc3_:DisplayObject = GameWorld.getUserFaceImage(param1.gameUser);
         if(_loc3_ != null)
         {
            userContainer.mc_frame.mc_face.addChild(_loc3_);
         }
         userContainer.tf_name.visible = false;
         var _loc4_:TextField = speechBubble.tf_text;
         GameWorld.textHandler.setTextFieldWithId(_loc4_,param2,true);
         GameWorld.textHandler.setReplaceString(STRING_REPLACE,getRewardText());
         userContainer.gotoAndStop(1);
         param1.uiButton.addChild(popUp);
      }
      
      public function retract() : void
      {
         state = STATE_OUT;
         popUp.gotoAndPlay(20);
      }
      
      private function getVisitReward() : int
      {
         return GameWorld.getVisitRewardAmount();
      }
      
      public function begin() : void
      {
         readyToBegin = true;
      }
      
      public function setState(param1:int) : void
      {
         this.state = param1;
      }
      
      private function getRewardText() : String
      {
         var _loc1_:int = getVisitReward();
         if(_loc1_ == 1)
         {
            return "this coin";
         }
         return "these " + _loc1_ + " coins";
      }
      
      public function tick(param1:uint) : void
      {
         var _loc2_:TextField = null;
         if(restaurant.silentTick)
         {
            return;
         }
         if(state == STATE_FREEZE)
         {
            popUp.gotoAndStop(1);
            if(timer < 0)
            {
               begin();
            }
            else
            {
               timer -= param1;
            }
            if(readyToBegin)
            {
               popUp.gotoAndPlay(1);
               state = STATE_IN;
               timer = 2500;
            }
         }
         else if(state == STATE_IN)
         {
            if(popUp.currentFrame == 9)
            {
               state = STATE_IDLE;
            }
         }
         else if(state == STATE_IDLE)
         {
            popUp.gotoAndStop(10);
         }
         else if(state == STATE_OUT)
         {
            if(popUp.currentFrame == 9)
            {
               state = STATE_THANKS;
            }
            if(popUp.currentFrame == 28)
            {
               _loc2_ = speechBubble.tf_text;
               GameWorld.textHandler.setTextFieldWithId(_loc2_,"ActivityThanks",true);
               popUp.gotoAndPlay(1);
               restaurant.activityCompleted();
            }
         }
         else if(state == STATE_THANKS)
         {
            if(timer > 0)
            {
               popUp.gotoAndStop(10);
               timer -= param1;
            }
            else
            {
               state = STATE_DISAPPEAR;
            }
         }
         else if(state == STATE_DISAPPEAR)
         {
            popUp.gotoAndPlay(20);
            state = STATE_FINISH;
         }
         else if(state == STATE_FINISH)
         {
            if(popUp.currentFrame == 35)
            {
               popUp.visible = false;
               popUp.gotoAndStop(1);
               restaurant.removeVisitActivity();
            }
         }
      }
   }
}

