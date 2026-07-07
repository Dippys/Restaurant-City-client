package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.events.*;
   import flash.display.*;
   import flash.events.*;
   
   public class WorldEmployeePopUp extends WorldPopUp
   {
      
      public var contentPanel:MovieClip;
      
      private var scene:MovieClip;
      
      private var perkItemChooser:ItemChooser;
      
      public var curUser:GameUserEmployee;
      
      private var restaurant:WorldRestaurantPlay;
      
      private var faceImage:DisplayObject;
      
      public function WorldEmployeePopUp(param1:GameUserEmployee, param2:WorldRestaurantPlay)
      {
         super(null,null,null);
         this.restaurant = param2;
         scene = Engine.getMovieClip("EmployeeInstructionPanelPopup");
         addChild(scene);
         contentPanel = scene.mc_content;
         GameWorld.textHandler.setTextFieldWithId(contentPanel.mc_cook.tf_text,"JobChef");
         GameWorld.textHandler.setTextFieldWithId(contentPanel.mc_waitor.tf_text,"JobWaiter");
         GameWorld.textHandler.setTextFieldWithId(contentPanel.mc_cleaner.tf_text,"JobCleaner");
         GameWorld.textHandler.setTextFieldWithId(contentPanel.mc_rest.tf_text,"RestEmployee");
         GameWorld.textHandler.setTextFieldWithId(contentPanel.mc_fire.tf_text,"SackEmployee");
         perkItemChooser = new ItemChooser(GameWorld.perkItemDatabase,GameWorld.gameUser,contentPanel);
         perkItemChooser.addEventListener(ItemChooserEvent.EVENT_ITEM_MOUSE_DOWN,onItemClicked);
         perkItemChooser.setGroup(GameWorld.perkItemDatabase.getGroup("Employee"));
         contentPanel.tf_itemText.visible = false;
         setButtonMode(contentPanel.mc_giftFood,true);
         contentPanel.mc_giftFood.addEventListener(MouseEvent.CLICK,onGiftClick,false,0,true);
         contentPanel.mc_giftFood.toolTip = new ToolTip(contentPanel.mc_giftFood,GameWorld.textHandler.getTextFromId("SendFreeFoodToFriends"),false,true);
         if(!GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_GIFT_INVITE_FOOD))
         {
            contentPanel.mc_giftFood.mc_new.visible = false;
         }
         setButtonMode(contentPanel.mc_fire,true);
         setButtonMode(contentPanel.mc_cancel,true);
         setButtonMode(contentPanel.mc_prev,true);
         setButtonMode(contentPanel.mc_next,true);
         contentPanel.mc_cancel.addEventListener(MouseEvent.CLICK,onButtonCancelClick,false,0,true);
         contentPanel.mc_fire.addEventListener(MouseEvent.CLICK,onButtonFireClick,false,0,true);
         contentPanel.mc_prev.addEventListener(MouseEvent.CLICK,onButtonPrevClick,false,0,true);
         contentPanel.mc_next.addEventListener(MouseEvent.CLICK,onButtonNextClick,false,0,true);
         setUser(param1);
      }
      
      private function onButtonFireClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldSackEmployee = null;
         remove();
         _loc2_ = new WorldSackEmployee(curUser,restaurant,this);
         _loc2_.x = GameWorld.CANVAS_CENTER_X;
         _loc2_.y = GameWorld.CANVAS_CENTER_Y;
         _loc2_.show();
      }
      
      private function onButtonCleanerClick(param1:MouseEvent) : void
      {
         curUser.job = GameUserEmployee.JOB_CLEANER;
         GameWorld.gameUser.refreshBedStatusForRestingEmployees();
         setJob(GameUserEmployee.JOB_CLEANER);
         if(restaurant != null)
         {
            restaurant.onHireUser(curUser);
         }
      }
      
      override public function show() : void
      {
         super.show();
         safeGotoAndPlay(scene,"in");
      }
      
      private function safeGotoAndPlay(param1:MovieClip, param2:String) : void
      {
         try
         {
            param1.gotoAndPlay(param2);
         }
         catch(e:ArgumentError)
         {
            Debug.out("WorldEmployeePopUp missing frame label: " + param2);
            param1.gotoAndStop(1);
         }
      }
      
      public function setUser(param1:GameUserEmployee) : void
      {
         this.curUser = param1;
         if(curUser.gameUser.fullName != null)
         {
            contentPanel.tf_name.text = curUser.gameUser.fullName;
         }
         else
         {
            contentPanel.tf_name.text = "";
         }
         contentPanel.mc_happiness.tf_happiness.mouseEnabled = false;
         contentPanel.mc_happiness.gotoAndStop(1);
         if(faceImage != null)
         {
            contentPanel.mc_frame.mc_face.removeChild(faceImage);
            faceImage = null;
         }
         faceImage = GameWorld.getUserFaceImage(curUser.gameUser);
         if(faceImage != null)
         {
            contentPanel.mc_frame.mc_face.addChild(faceImage);
         }
         refreshHappiness();
         setJob(curUser.job);
         contentPanel.mc_avatar.removeChildAt(0);
         contentPanel.mc_avatar.addChild(curUser.gameUser.getAvatarFrame());
         if(contentPanel.mc_outfit.toolTip == null)
         {
            contentPanel.mc_outfit.toolTip = new ToolTip(contentPanel.mc_outfit,GameWorld.textHandler.getTextFromId("ToolTipChangeEmployeeOutfit"),false,true);
            setButtonMode(contentPanel.mc_outfit,true);
            contentPanel.mc_outfit.addEventListener(MouseEvent.CLICK,onOutfitClick,false,0,true);
         }
         contentPanel.mc_outfit.mc_new.mouseEnabled = false;
         if(!GameWorld.firstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_EMPLOYEE_OUTFIT))
         {
            contentPanel.mc_outfit.mc_new.visible = false;
         }
         if(param1.gameUser != GameWorld.gameUser && param1.gameUser.userInfo.playCount > 0 && GameWorld.isFriendUser(param1.gameUser))
         {
            contentPanel.mc_restaurant.visible = true;
            GameWorld.textHandler.setReplaceString("friend",curUser.gameUser.firstName);
            if(contentPanel.mc_restaurant.toolTip == null)
            {
               contentPanel.mc_restaurant.toolTip = new ToolTip(contentPanel.mc_restaurant,GameWorld.textHandler.getTextFromId("ToolTipFriendsRestaurant"));
               setButtonMode(contentPanel.mc_restaurant,true);
               contentPanel.mc_restaurant.addEventListener(MouseEvent.CLICK,onRestaurantClick,false,0,true);
            }
            else
            {
               contentPanel.mc_restaurant.toolTip.text = GameWorld.textHandler.getTextFromId("ToolTipFriendsRestaurant");
            }
         }
         else
         {
            contentPanel.mc_restaurant.visible = false;
         }
      }
      
      private function refreshHappiness() : void
      {
         contentPanel.mc_happiness.tf_happiness.text = curUser.getTimeLeft();
         GameWorld.hiredFriendsPanel.setHappinessIcon(contentPanel.mc_happiness.mc_happinessIcon,curUser);
      }
      
      private function onButtonCancelClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      private function onGiftClick(param1:MouseEvent) : void
      {
         var _loc2_:GiftInviteFoodPopUp = new GiftInviteFoodPopUp();
         _loc2_.show();
         GameWorld.setFirstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_GIFT_INVITE_FOOD);
         if(contentPanel.mc_giftFood)
         {
            contentPanel.mc_giftFood.mc_new.visible = false;
         }
      }
      
      private function onButtonWaitorClick(param1:MouseEvent) : void
      {
         curUser.job = GameUserEmployee.JOB_WAITOR;
         GameWorld.gameUser.refreshBedStatusForRestingEmployees();
         setJob(GameUserEmployee.JOB_WAITOR);
         if(restaurant != null)
         {
            restaurant.onHireUser(curUser);
         }
      }
      
      private function onButtonRestClick(param1:MouseEvent) : void
      {
         curUser.job = GameUserEmployee.JOB_REST;
         GameWorld.gameUser.refreshBedStatusForRestingEmployees();
         setJob(GameUserEmployee.JOB_REST);
         if(restaurant != null)
         {
            restaurant.onHireUser(curUser);
         }
      }
      
      private function onButtonNextClick(param1:MouseEvent) : void
      {
         var _loc2_:int = GameWorld.gameUser.employeeUsers.indexOf(curUser);
         var _loc3_:int = _loc2_ + 1;
         if(_loc3_ >= GameWorld.gameUser.employeeUsers.length)
         {
            _loc3_ -= GameWorld.gameUser.employeeUsers.length;
         }
         setUser(GameWorld.gameUser.employeeUsers[_loc3_]);
         safeGotoAndPlay(scene,"right");
      }
      
      private function onOutfitClick(param1:MouseEvent) : void
      {
         remove();
         if(WorldRestaurantPlay.instance != null)
         {
            WorldRestaurantPlay.instance.destroy();
         }
         GameWorld.fadeToWorld(new WorldCustomiseAvatar(curUser.gameUser,GameWorld.gameUser));
         GameWorld.setFirstTimeAccess(GameWorld.FIRST_TIME_ACCESS_BIT_EMPLOYEE_OUTFIT);
      }
      
      private function onButtonPrevClick(param1:MouseEvent) : void
      {
         var _loc2_:int = GameWorld.gameUser.employeeUsers.indexOf(curUser);
         var _loc3_:int = _loc2_ - 1;
         if(_loc3_ < 0)
         {
            _loc3_ += GameWorld.gameUser.employeeUsers.length;
         }
         setUser(GameWorld.gameUser.employeeUsers[_loc3_]);
         safeGotoAndPlay(scene,"left");
      }
      
      private function onRestaurantClick(param1:MouseEvent) : void
      {
         remove();
         if(WorldRestaurantPlay.instance != null)
         {
            WorldRestaurantPlay.instance.destroy();
         }
         GameWorld.fadeToWorld(new WorldStreet(curUser.gameUser,false));
      }
      
      private function onButtonCookClick(param1:MouseEvent) : void
      {
         curUser.job = GameUserEmployee.JOB_COOK;
         GameWorld.gameUser.refreshBedStatusForRestingEmployees();
         setJob(GameUserEmployee.JOB_COOK);
         if(restaurant != null)
         {
            restaurant.onHireUser(curUser);
         }
      }
      
      private function onItemClicked(param1:ItemChooserEvent) : void
      {
         var _loc3_:PerkItem = null;
         var _loc2_:InventoryUserItem = GameWorld.gameUser.getInventoryItem(param1.itemConfig);
         if(_loc2_ != null || GameWorld.gameUser.money.value >= param1.itemConfig.cost)
         {
            _loc3_ = new PerkItem(param1.itemConfig);
            curUser.addPerk(_loc3_);
            if(_loc2_ == null)
            {
               GameWorld.cashPanel.addCoins(-param1.itemConfig.cost);
               GameWorld.saveProfileHandler.purchasePerkItem(_loc3_);
            }
            else
            {
               GameWorld.saveProfileHandler.consumeItem(_loc3_.itemConfig.id);
               GameWorld.gameUser.removeInventoryItem(_loc2_);
            }
            if(_loc3_.workTime > 0)
            {
               contentPanel.mc_happiness.gotoAndPlay("anim");
            }
            perkItemChooser.refresh();
            GameWorld.hiredFriendsPanel.setPerksForUser(curUser);
            refreshHappiness();
            new GameSound("SfxCash",GameSound.TYPE_SOUND).play(1);
         }
      }
      
      private function setJob(param1:int) : void
      {
         var _loc2_:Array = [null,contentPanel.mc_cook,contentPanel.mc_waitor,contentPanel.mc_rest,contentPanel.mc_cleaner];
         var _loc3_:Array = [null,onButtonCookClick,onButtonWaitorClick,onButtonRestClick,onButtonCleanerClick];
         var _loc4_:Number = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_])
            {
               if(_loc4_ == param1)
               {
                  setButtonMode(_loc2_[_loc4_],false);
                  _loc2_[_loc4_].removeEventListener(MouseEvent.CLICK,_loc3_[_loc4_]);
                  _loc2_[_loc4_].gotoAndStop("selected");
               }
               else
               {
                  setButtonMode(_loc2_[_loc4_],true);
                  _loc2_[_loc4_].addEventListener(MouseEvent.CLICK,_loc3_[_loc4_]);
               }
            }
            _loc4_++;
         }
         GameWorld.hiredFriendsPanel.refreshUserJob(curUser);
      }
      
      override public function tick(param1:uint) : void
      {
         refreshHappiness();
      }
   }
}

