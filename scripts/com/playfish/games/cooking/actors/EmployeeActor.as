package com.playfish.games.cooking.actors
{
   import com.playfish.games.cooking.*;
   import flash.display.*;
   import flash.text.TextField;
   
   public class EmployeeActor extends AvatarActor
   {
      
      public static const EMOTION_NEED_FOOD:int = 0;
      
      public static const EMOTION_NEED_JOB:int = 1;
      
      public static const EMOTION_NEED_STOVE:int = 2;
      
      private static var EMOTION_NAMES:Array = ["SpeechBubbleNeedFood","SpeechBubbleNeedJob","SpeechBubbleNeedStove"];
      
      private static var EMOTION_TEXTS:Array = ["NeedFoodOrRest","NeedJob","NeedStove"];
      
      public var employeeUser:GameUserEmployee;
      
      public var prevWorkTime:int = -1;
      
      public var emotionType:int = -1;
      
      private var emotion:GameObject;
      
      public function EmployeeActor(param1:int, param2:int, param3:GameUserEmployee, param4:WorldRestaurantPlay, param5:Array)
      {
         this.employeeUser = param3;
         super(param1,param2,param3.gameUser,param4,param5,true);
         setAnimation(param5[0]);
         var _loc6_:AnimatedObject = new AnimatedObject("SpeechBubbleAnimPortrait");
         var _loc7_:DisplayObject = GameWorld.getUserFaceImage(user);
         if(_loc7_ != null)
         {
            _loc6_.getChildMovieClipInstance("mc_portrait").mc_face.addChild(_loc7_);
         }
         var _loc8_:TextField = _loc6_.getChildMovieClipInstance("mc_name").tf_name;
         _loc8_.text = user.firstName;
         addMouseOverBadge(_loc6_);
         addSelectionEffect("EmployeeSelection");
         updateStatus();
         show();
      }
      
      public function setDead() : void
      {
         restaurantPlay.refreshRestaurantClosedState();
      }
      
      override public function updateStatus() : void
      {
         if(prevWorkTime != 0 && employeeUser.workTime == 0)
         {
            setDead();
         }
         else if(prevWorkTime == 0 && employeeUser.workTime > 0)
         {
            onRevive();
         }
         prevWorkTime = employeeUser.workTime;
         GameWorld.hiredFriendsPanel.setHappinessIcon(badge.getChildMovieClipInstance("mc_happiness"),employeeUser);
      }
      
      public function onRevive() : void
      {
         restaurantPlay.refreshRestaurantClosedState();
      }
      
      public function setEmotion(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         if(param1 != emotionType)
         {
            if(emotion)
            {
               removeObject(emotion);
               emotionType = -1;
            }
            if(param1 != -1)
            {
               emotionType = param1;
               emotion = new GameObject("SpeechBubbleAnim");
               _loc2_ = emotion.getChildMovieClipInstance("mc_content");
               _loc2_.removeChildAt(0);
               _loc3_ = Engine.getMovieClip(EMOTION_NAMES[param1]);
               _loc3_.mouseChildren = false;
               _loc3_.buttonMode = true;
               GameWorld.textHandler.setTextFieldWithId(_loc3_.mc_content.tf_text,EMOTION_TEXTS[param1]);
               _loc2_.addChild(_loc3_);
               emotion.y = -WorldRestaurant.tileHeight - 30;
               emotion.numLoops = 1;
               addObject(emotion);
            }
         }
      }
      
      override public function tick(param1:uint) : void
      {
         super.tick(param1);
         updateStatus();
      }
   }
}

