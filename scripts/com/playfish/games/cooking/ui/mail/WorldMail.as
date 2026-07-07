package com.playfish.games.cooking.ui.mail
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.tutorials.TutorialMailClient;
   import com.playfish.games.cooking.ui.*;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.*;
   import flash.events.MouseEvent;
   
   public class WorldMail extends WorldPopUp
   {
      
      private var mailButtons:Array;
      
      private var scene:MovieClip;
      
      private var sceneContent:MovieClip;
      
      private var curPage:int = 0;
      
      private var numButtonsPerPage:int;
      
      private var maxPage:int;
      
      private var gameUser:GameUser;
      
      public function WorldMail()
      {
         var _loc2_:MovieClip = null;
         mailButtons = new Array();
         super(null,null,null);
         this.gameUser = GameWorld.gameUser;
         scene = Engine.getMovieClip("MailClientPopUpAnim");
         addChild(scene);
         sceneContent = scene.mc_content;
         var _loc1_:int = 0;
         while(true)
         {
            _loc2_ = sceneContent["mc_mail" + _loc1_];
            if(!_loc2_)
            {
               break;
            }
            mailButtons.push(_loc2_);
            _loc2_.mc_content.stop();
            _loc1_++;
         }
         numButtonsPerPage = _loc1_;
         maxPage = Math.max(0,Math.ceil(gameUser.mailItems.length / numButtonsPerPage) - 1);
         refresh();
         setButtonMode(sceneContent.mc_back,true);
         setButtonMode(sceneContent.mc_write,true);
         sceneContent.mc_back.addEventListener(MouseEvent.CLICK,onBackClick,false,0,true);
         sceneContent.mc_write.addEventListener(MouseEvent.CLICK,onWriteClick,false,0,true);
         if(gameUser.settings.getValue(GameSettings.TYPE_MAIL_CLIENT_TUTORIAL_STEP) == 0)
         {
            new TutorialMailClient(this);
         }
      }
      
      public function setPage(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:MailItem = null;
         var _loc6_:String = null;
         var _loc7_:GameUser = null;
         if(param1 != curPage || param2)
         {
            curPage = param1;
            _loc3_ = curPage * numButtonsPerPage;
            _loc4_ = 0;
            while(_loc4_ < mailButtons.length)
            {
               if(_loc3_ < gameUser.mailItems.length)
               {
                  setButtonMode(mailButtons[_loc4_],true);
                  _loc5_ = gameUser.mailItems[_loc3_];
                  mailButtons[_loc4_].mailItem = _loc5_;
                  mailButtons[_loc4_].mc_content.tf_date.text = toDateString(_loc5_.mailObject.sendDate);
                  mailButtons[_loc4_].mc_content.tf_name.visible = true;
                  mailButtons[_loc4_].mc_content.tf_date.visible = true;
                  mailButtons[_loc4_].mc_content.mc_daysLeft.visible = false;
                  if(_loc5_.newsletterId != -1)
                  {
                     _loc6_ = "newsletter";
                  }
                  else
                  {
                     _loc6_ = MailItem.MAIL_TYPE_FRAME_LABEL[_loc5_.type];
                  }
                  if(_loc5_.type != RpcClient.MAIL_TYPE_QUIZZ)
                  {
                     if(_loc5_.mailObject.read)
                     {
                        _loc6_ += "open";
                     }
                     else
                     {
                        _loc6_ += "close";
                     }
                     if(_loc5_.mailObject.read || _loc5_.type == RpcClient.MAIL_TYPE_SECURECHANGE)
                     {
                        if(_loc5_.newsletterId == -1)
                        {
                           GameWorld.textHandler.setReplaceString("days",_loc5_.mailObject.deleteTime.toString());
                           GameWorld.textHandler.setTextFieldWithId(mailButtons[_loc4_].mc_content.mc_daysLeft.tf_days,"NumberOfDaysLeft");
                           mailButtons[_loc4_].mc_content.mc_daysLeft.visible = true;
                        }
                     }
                  }
                  mailButtons[_loc4_].mc_content.gotoAndStop(_loc6_);
                  if(_loc5_.newsletterId != -1)
                  {
                     GameWorld.textHandler.setTextFieldWithId(mailButtons[_loc4_].mc_content.tf_name,"Newsletter");
                  }
                  else if(_loc5_.type == RpcClient.MAIL_TYPE_PLAYFISH)
                  {
                     mailButtons[_loc4_].mc_content.tf_name.text = "Playfish";
                  }
                  else if(_loc5_.type == RpcClient.MAIL_TYPE_QUIZZ)
                  {
                     GameWorld.textHandler.setTextFieldWithId(mailButtons[_loc4_].mc_content.tf_name,"MailFoodQuiz");
                  }
                  else if(_loc5_.type == RpcClient.MAIL_TYPE_CASH)
                  {
                     GameWorld.textHandler.setTextFieldWithId(mailButtons[_loc4_].mc_content.tf_name,"MailCoins");
                  }
                  else if(_loc5_.mailObject.senderId)
                  {
                     _loc7_ = GameWorld.getGameUserWithId(_loc5_.mailObject.senderId);
                     if(_loc7_ != null)
                     {
                        mailButtons[_loc4_].mc_content.tf_name.text = _loc7_.firstName;
                     }
                     else
                     {
                        mailButtons[_loc4_].mc_content.tf_name.text = _loc5_.mailObject.senderId.toString();
                     }
                  }
                  mailButtons[_loc4_].addEventListener(MouseEvent.CLICK,onMailClick,false,0,true);
               }
               else
               {
                  setButtonMode(mailButtons[_loc4_],false);
                  mailButtons[_loc4_].mailItem = null;
                  mailButtons[_loc4_].mc_content.gotoAndStop("empty");
                  mailButtons[_loc4_].mc_content.tf_name.visible = false;
                  mailButtons[_loc4_].mc_content.tf_date.visible = false;
                  mailButtons[_loc4_].mc_content.mc_daysLeft.visible = false;
                  mailButtons[_loc4_].removeEventListener(MouseEvent.CLICK,onMailClick);
               }
               _loc3_++;
               _loc4_++;
            }
            if(curPage <= 0)
            {
               setButtonMode(sceneContent.mc_left,false);
               sceneContent.mc_left.gotoAndStop("disabled");
               sceneContent.mc_left.removeEventListener(MouseEvent.CLICK,onLeftClick);
            }
            else
            {
               setButtonMode(sceneContent.mc_left,true);
               sceneContent.mc_left.addEventListener(MouseEvent.CLICK,onLeftClick,false,0,true);
            }
            if(curPage >= maxPage)
            {
               setButtonMode(sceneContent.mc_right,false);
               sceneContent.mc_right.gotoAndStop("disabled");
               sceneContent.mc_right.removeEventListener(MouseEvent.CLICK,onRightClick);
            }
            else
            {
               setButtonMode(sceneContent.mc_right,true);
               sceneContent.mc_right.addEventListener(MouseEvent.CLICK,onRightClick,false,0,true);
            }
         }
      }
      
      override public function show() : void
      {
         super.show();
         scene.gotoAndPlay(1);
      }
      
      private function onLeftClick(param1:MouseEvent) : void
      {
         setPage(Math.max(0,curPage - 1));
      }
      
      private function onWriteClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldWriteMessage = null;
         remove();
         _loc2_ = new WorldWriteMessage(null,null,this);
         _loc2_.x = GameWorld.CANVAS_CENTER_X;
         _loc2_.y = GameWorld.CANVAS_CENTER_Y;
         _loc2_.show();
      }
      
      public function toDateString(param1:Date) : String
      {
         return param1.getDate() + "/" + (param1.getMonth() + 1) + "/" + param1.getFullYear();
      }
      
      private function onRightClick(param1:MouseEvent) : void
      {
         setPage(Math.min(maxPage,curPage + 1));
      }
      
      private function onBackClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      private function onMailClick(param1:MouseEvent) : void
      {
         var _loc2_:MailItem = null;
         var _loc3_:NewspaperMail = null;
         var _loc4_:WorldQuiz = null;
         var _loc5_:WorldReadMessage = null;
         var _loc6_:WorldMailPlayfish = null;
         var _loc7_:WorldMailTradeIngredient = null;
         var _loc8_:WorldMailCoinBagPopUp = null;
         var _loc9_:WorldMailTradeAcceptPopUp = null;
         var _loc10_:GiftInviteFoodMail = null;
         _loc2_ = MailItem(param1.currentTarget.mailItem);
         if(_loc2_.newsletterId != -1)
         {
            remove();
            _loc3_ = new NewspaperMail(_loc2_,this);
            _loc3_.show();
         }
         else if(_loc2_.type == RpcClient.MAIL_TYPE_QUIZZ)
         {
            remove();
            _loc4_ = new WorldQuiz(_loc2_.mailObject.id,this);
            _loc4_.x = GameWorld.CANVAS_CENTER_X;
            _loc4_.y = GameWorld.CANVAS_CENTER_Y;
            _loc4_.show();
            gameUser.removeMailItem(_loc2_);
            refresh();
         }
         else if(_loc2_.type == RpcClient.MAIL_TYPE_EMAIL || _loc2_.type == RpcClient.MAIL_TYPE_GIFT)
         {
            remove();
            _loc5_ = new WorldReadMessage(_loc2_,this);
            _loc5_.x = GameWorld.CANVAS_CENTER_X;
            _loc5_.y = GameWorld.CANVAS_CENTER_Y;
            _loc5_.show();
            if(!_loc2_.mailObject.read)
            {
               _loc2_.mailObject.read = true;
               _loc2_.mailObject.deleteTime = MailItem.MAX_MAIL_RETAIN_DAYS - 1;
               refresh();
               GameWorld.saveProfileHandler.addOpenedMail(_loc2_);
            }
         }
         else if(_loc2_.type == RpcClient.MAIL_TYPE_PLAYFISH)
         {
            remove();
            _loc6_ = new WorldMailPlayfish(_loc2_,this);
            _loc6_.show();
            if(!_loc2_.mailObject.read)
            {
               _loc2_.mailObject.read = true;
               _loc2_.mailObject.deleteTime = MailItem.MAX_MAIL_RETAIN_DAYS - 1;
               refresh();
               GameWorld.saveProfileHandler.addOpenedMail(_loc2_);
            }
         }
         else if(_loc2_.type == RpcClient.MAIL_TYPE_SECURECHANGE)
         {
            remove();
            _loc7_ = new WorldMailTradeIngredient(_loc2_,this);
            _loc7_.x = GameWorld.CANVAS_CENTER_X;
            _loc7_.y = GameWorld.CANVAS_CENTER_Y;
            _loc7_.show();
         }
         else if(_loc2_.type == RpcClient.MAIL_TYPE_CASH)
         {
            remove();
            _loc8_ = new WorldMailCoinBagPopUp(_loc2_,this);
            _loc8_.x = GameWorld.CANVAS_CENTER_X;
            _loc8_.y = GameWorld.CANVAS_CENTER_Y;
            _loc8_.show();
         }
         else if(_loc2_.type == RpcClient.MAIL_TYPE_SECUREECHANGE_OK)
         {
            remove();
            _loc9_ = new WorldMailTradeAcceptPopUp(_loc2_,this);
            _loc9_.x = GameWorld.CANVAS_CENTER_X;
            _loc9_.y = GameWorld.CANVAS_CENTER_Y;
            _loc9_.show();
         }
         else if(_loc2_.type == RpcClient.MAIL_TYPE_GIFT_INVITE)
         {
            remove();
            _loc10_ = new GiftInviteFoodMail(_loc2_,this);
            _loc10_.show();
         }
         if(WorldRestaurantPlay.instance != null)
         {
            WorldRestaurantPlay.instance.refreshMails();
         }
      }
      
      public function refresh() : void
      {
         setPage(curPage,true);
         GameWorld.textHandler.setReplaceString("MailCount",gameUser.getNewMailItems().length.toString());
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_inbox,"InboxMailCount");
      }
   }
}

