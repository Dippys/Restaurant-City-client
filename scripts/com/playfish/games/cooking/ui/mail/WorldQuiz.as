package com.playfish.games.cooking.ui.mail
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.rpc.RpcEvent;
   import com.playfish.games.cooking.rpc.RpcReplyQuiz;
   import com.playfish.games.cooking.rpc.RpcRequestManager;
   import com.playfish.games.cooking.tutorials.TutorialQuiz;
   import com.playfish.games.cooking.ui.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class WorldQuiz extends WorldPopUp
   {
      
      private static const NUM_DIFFICULTY_LEVELS:int = 5;
      
      private static const INGREDIENTS_RARITY_WEIGHT:Array = [50,30,15,5,1];
      
      private static const QUIZ_TYPE_TEXT_QUESTION:int = 0;
      
      private static const QUIZ_TYPE_IMAGE_QUESTION:int = 1;
      
      private var timer:int;
      
      private var difficultyLevel:int;
      
      private var scene:MovieClip;
      
      private var sceneContent:MovieClip;
      
      private var answerCorrect:Boolean;
      
      private var clockTimer:int = 10000;
      
      private var answered:Boolean = false;
      
      private var choiceButtons:Array;
      
      private var mailClient:WorldMail;
      
      private var coinReward:int = 0;
      
      private var ingredientReward:Object;
      
      private var mailId:int;
      
      private var timeUpMovieClip:MovieClip;
      
      private var replyQuizOK:Boolean = false;
      
      private var quizType:int = 0;
      
      public function WorldQuiz(param1:int, param2:WorldMail)
      {
         var _loc7_:XML = null;
         var _loc8_:MovieClip = null;
         var _loc9_:Boolean = false;
         var _loc10_:XMLList = null;
         var _loc11_:MovieClip = null;
         var _loc12_:MovieClip = null;
         var _loc13_:MovieClip = null;
         choiceButtons = new Array();
         super(null,null,null);
         this.mailId = param1;
         this.mailClient = param2;
         scene = Engine.getMovieClip("DailyQuizPopUpAnim");
         addChild(scene);
         sceneContent = scene.mc_content;
         sceneContent.tf_clock.text = getClockSecs();
         difficultyLevel = 1;
         var _loc3_:ItemDatabase = GameWorld.quizItemDatabase;
         var _loc4_:Array = _loc3_.getItems("Quiz" + difficultyLevel);
         var _loc5_:Object = _loc4_[Engine.rnd(0,_loc4_.length)];
         Debug.out("quiz length=" + _loc4_.length);
         sceneContent.tf_question.text = _loc5_.question;
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_title,"DailyFoodQuiz");
         if(_loc5_.image)
         {
            quizType = QUIZ_TYPE_IMAGE_QUESTION;
            _loc8_ = Engine.getMovieClip(_loc5_.image);
            _loc8_.stop();
            _loc8_.scaleX = 1.5;
            _loc8_.scaleY = 1.5;
            sceneContent.mc_questionImage.addChild(_loc8_);
         }
         else
         {
            quizType = QUIZ_TYPE_TEXT_QUESTION;
            sceneContent.mc_questionImage.visible = false;
         }
         var _loc6_:int = 0;
         for each(_loc7_ in _loc5_.children)
         {
            _loc10_ = _loc7_.attribute("correct");
            if((Boolean(_loc10_)) && _loc10_.toString() == "true")
            {
               _loc9_ = true;
            }
            else
            {
               _loc9_ = false;
            }
            _loc11_ = sceneContent["mc_choice" + _loc6_];
            _loc12_ = sceneContent["mc_button" + _loc6_];
            if(_loc5_.image)
            {
               if(_loc11_)
               {
                  _loc11_.stop();
                  _loc11_.visible = false;
               }
               if(_loc12_)
               {
                  setButtonMode(_loc12_,true);
                  _loc12_.mc_content.gotoAndStop(1);
                  _loc12_.mc_content.tf_answer.text = _loc7_.attribute("text");
                  _loc12_.mc_content.tf_answer.mouseEnabled = false;
                  _loc12_.correct = _loc9_;
                  _loc12_.addEventListener(MouseEvent.CLICK,onChoiceClick,false,0,true);
                  choiceButtons.push(_loc12_);
               }
            }
            else
            {
               if(_loc12_)
               {
                  _loc12_.stop();
                  _loc12_.visible = false;
               }
               if(_loc11_)
               {
                  setButtonMode(_loc11_,true);
                  _loc11_.mc_content.stop();
                  _loc13_ = Engine.getMovieClip(_loc7_.attribute("image"));
                  _loc13_.stop();
                  _loc13_.scaleX = 1.5;
                  _loc13_.scaleY = 1.5;
                  _loc11_.mc_content.addChild(_loc13_);
                  _loc11_.mc_content.tf_answer.text = _loc7_.attribute("text");
                  _loc11_.mc_content.tf_answer.mouseEnabled = false;
                  _loc11_.correct = _loc9_;
                  _loc11_.addEventListener(MouseEvent.CLICK,onChoiceClick,false,0,true);
                  choiceButtons.push(_loc11_);
               }
            }
            _loc6_++;
         }
         if(GameWorld.gameUser.settings.getValue(GameSettings.TYPE_QUIZ_TUTORIAL_STEP) == 0)
         {
            new TutorialQuiz(this);
            scene.stop();
         }
      }
      
      private function getClockSecs() : int
      {
         return Math.ceil(clockTimer / 1000);
      }
      
      public function onChoiceClick(param1:MouseEvent) : void
      {
         answered = true;
         endQuiz();
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         if(_loc2_.correct)
         {
            answerCorrect = true;
            if(quizType == QUIZ_TYPE_TEXT_QUESTION)
            {
               _loc2_.gotoAndStop("correct");
            }
            else
            {
               _loc2_.mc_content.gotoAndStop("correct");
               sceneContent.mc_questionImage.addChild(Engine.getMovieClip("CorrectIconAnim"));
            }
            ingredientReward = getIngredientReward();
         }
         else
         {
            answerCorrect = false;
            if(quizType == QUIZ_TYPE_TEXT_QUESTION)
            {
               _loc2_.gotoAndStop("incorrect");
            }
            else
            {
               _loc2_.mc_content.gotoAndStop("wrong");
               sceneContent.mc_questionImage.addChild(Engine.getMovieClip("IncorrectIconAnim"));
            }
         }
         timer = 2000;
      }
      
      private function endQuiz() : void
      {
         var _loc1_:Number = 0;
         while(_loc1_ < choiceButtons.length)
         {
            setButtonMode(choiceButtons[_loc1_],false);
            choiceButtons[_loc1_].removeEventListener(MouseEvent.CLICK,onChoiceClick);
            _loc1_++;
         }
      }
      
      private function getIngredientReward() : Object
      {
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         while(_loc2_ < INGREDIENTS_RARITY_WEIGHT.length)
         {
            _loc1_ += INGREDIENTS_RARITY_WEIGHT[_loc2_];
            _loc2_++;
         }
         var _loc3_:int = 1;
         var _loc4_:Number = Engine.rnd(0,_loc1_);
         _loc2_ = 0;
         while(_loc2_ < INGREDIENTS_RARITY_WEIGHT.length)
         {
            if(_loc4_ < INGREDIENTS_RARITY_WEIGHT[_loc2_])
            {
               _loc3_ = _loc2_ + 1;
               break;
            }
            _loc4_ -= INGREDIENTS_RARITY_WEIGHT[_loc2_];
            _loc2_++;
         }
         var _loc5_:Array = GameWorld.ingredientItemDatabase.getItems("Ingredient");
         var _loc6_:Array = new Array();
         _loc2_ = 0;
         while(_loc2_ < _loc5_.length)
         {
            if(_loc5_[_loc2_].rarity == _loc3_ && !_loc5_[_loc2_].noQuiz)
            {
               _loc6_.push(_loc5_[_loc2_]);
            }
            _loc2_++;
         }
         Debug.out("quiz item rarity=" + _loc3_ + " validItems.length=" + _loc6_.length);
         return _loc6_[Engine.rnd(0,_loc6_.length)];
      }
      
      private function onReplyQuizSuccess(param1:RpcEvent) : void
      {
         var _loc5_:MovieClip = null;
         Debug.out("onReplyQuizSuccess");
         var _loc2_:RpcReplyQuiz = RpcReplyQuiz(param1.currentTarget);
         coinReward = _loc2_.coinReward;
         GameWorld.cashPanel.addCoins(coinReward);
         if(ingredientReward)
         {
            GameWorld.gameUser.addIngredient(ingredientReward,1);
            GameWorld.gameUser.getIngredient(ingredientReward).lock = true;
         }
         var _loc3_:MovieClip = Engine.getMovieClip("QuizWinnings");
         _loc3_.mc_icon.removeChildAt(0);
         if(ingredientReward != null)
         {
            _loc3_.gotoAndPlay("win");
            _loc5_ = Engine.getMovieClip(ingredientReward.className);
            _loc5_.stop();
            _loc3_.mc_icon.addChild(_loc5_);
            _loc3_.tf_name.text = ingredientReward.name;
            _loc3_.mc_rarity.gotoAndStop(ingredientReward.rarity);
         }
         else
         {
            _loc3_.gotoAndStop("lose");
            _loc3_.mc_icon.visible = false;
         }
         setButtonMode(_loc3_.mc_tick,true);
         _loc3_.mc_tick.addEventListener(MouseEvent.CLICK,onItemPopUpTickClick,false,0,true);
         var _loc4_:WorldPopUp = new WorldPopUp(_loc3_,_loc3_.mc_tick,null);
         _loc4_.show();
      }
      
      private function onRetryCancel() : void
      {
         if(mailClient)
         {
            mailClient.show();
         }
      }
      
      override public function tick(param1:uint) : void
      {
         if(answered)
         {
            timer -= param1;
            if(timer <= 0)
            {
               remove();
               showResultPopUp();
            }
         }
         else if(timeUpMovieClip != null)
         {
            if(timeUpMovieClip.currentFrame >= timeUpMovieClip.totalFrames)
            {
               scene.removeChild(timeUpMovieClip);
               remove();
               showResultPopUp();
            }
         }
         else if(scene.currentLabel == "idle")
         {
            if(clockTimer > 0)
            {
               clockTimer = Math.max(0,clockTimer - param1);
               sceneContent.tf_clock.text = getClockSecs();
               if(clockTimer == 0)
               {
                  timeUpMovieClip = Engine.getMovieClip("TimesUpAnim");
                  scene.addChild(timeUpMovieClip);
                  endQuiz();
               }
            }
         }
      }
      
      private function onItemPopUpTickClick(param1:MouseEvent) : void
      {
         if(mailClient)
         {
            mailClient.show();
         }
      }
      
      private function showResultPopUp() : void
      {
         var _loc1_:RpcRequestManager = new RpcRequestManager();
         _loc1_.loadingPopUp = new WorldLoadingPopUp("Verifying...",WorldLoadingPopUp.QUIZ);
         _loc1_.retryText = GameWorld.textHandler.getTextFromId("QuizResultRetryText");
         _loc1_.retryCancelCallBack = onRetryCancel;
         var _loc2_:RpcReplyQuiz = _loc1_.replyQuiz(mailId,ingredientReward,answerCorrect);
         _loc2_.addEventListener(RpcEvent.SUCCESS,onReplyQuizSuccess);
         _loc1_.commit();
      }
      
      public function unpause() : void
      {
         scene.play();
      }
   }
}

