package com.playfish.games.cooking.ui
{
   import com.playfish.external.ExternalPage;
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.events.ItemChooserEvent;
   import com.playfish.games.cooking.rpc.*;
   import com.playfish.games.cooking.utils.RandomBasket;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.utils.*;
   
   public class WorldHiredFriendsPanel extends BaseObject
   {
      
      private static const NUMBER_OF_BARS_BETWEEN_INVITE_BAR:int = 3;
      
      private static const MAX_BARS:int = 9;
      
      private var scrollLayer:ScrollPanel;
      
      private var scene:MovieClip;
      
      private var inviteIcons:Array = new Array();
      
      private var friendIcons:Array = new Array();
      
      private var iconGap:Number;
      
      private var emptyLockedIcons:Array = new Array();
      
      public var curJobPanel:MovieClip;
      
      private var inviteFriendBasket:RandomBasket = new RandomBasket();
      
      private var emptyHireIcons:Array = new Array();
      
      private var buttonLayer:MovieClip;
      
      private var inviteFriends:Array;
      
      private var emptyIcons:Array = new Array();
      
      private var curIcon:MovieClip;
      
      private var perkItemChooser:ItemChooser;
      
      private var gameUser:GameUser;
      
      private var iconLayer:Sprite;
      
      public var curPopUp:WorldPopUp;
      
      private var iconsPerScreen:int = 7;
      
      private var employeeUsers:Array = new Array();
      
      public function WorldHiredFriendsPanel(param1:GameUser, param2:int)
      {
         var _loc3_:int = 0;
         var _loc4_:int = getTimer();
         PerfTrace.mark("WorldHiredFriendsPanel begin employees=" + param1.employeeUsers.length + " max=" + param2);
         super();
         this.gameUser = param1;
         scene = Engine.getMovieClip("EmployeeBar2");
         PerfTrace.slow("WorldHiredFriendsPanel EmployeeBar2",_loc4_,5);
         addChild(scene);
         _loc4_ = getTimer();
         buttonLayer = Engine.getMovieClip("EmployeeBarButtonLayer");
         iconLayer = new Sprite();
         iconLayer.x = scene.mc_icon0.x;
         iconLayer.y = scene.mc_icon0.y;
         addChild(iconLayer);
         scrollLayer = new ScrollPanel(iconLayer,this,buttonLayer.mc_left,buttonLayer.mc_right);
         scrollLayer.keyboardEnabled = false;
         addObject(scrollLayer);
         addChild(buttonLayer);
         PerfTrace.slow("WorldHiredFriendsPanel layers/buttons",_loc4_,5);
         _loc4_ = getTimer();
         iconGap = scene.mc_icon2.x - scene.mc_icon1.x;
         _loc3_ = 0;
         while(_loc3_ < iconsPerScreen)
         {
            scene["mc_icon" + _loc3_].stop();
            scene["mc_icon" + _loc3_].visible = false;
            _loc3_++;
         }
         setButtonMode(buttonLayer.mc_left,true);
         setButtonMode(buttonLayer.mc_right,true);
         _loc3_ = 0;
         while(_loc3_ < param1.employeeUsers.length)
         {
            addHiredUser(param1.employeeUsers[_loc3_],false);
            _loc3_++;
         }
         PerfTrace.slow("WorldHiredFriendsPanel hired users",_loc4_,5);
         _loc4_ = getTimer();
         refresh();
         PerfTrace.slow("WorldHiredFriendsPanel refresh",_loc4_,5);
         PerfTrace.mark("WorldHiredFriendsPanel end");
      }
      
      private function createInviteBars() : void
      {
         var _loc1_:int = 0;
         var _loc2_:GameUser = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         inviteFriends = new Array();
         if(GameWorld.isUserInSplitTestingGroupA(GameWorld.gameUser))
         {
            Debug.out("split test group A - random top 20 friends");
            _loc1_ = 0;
            while(_loc1_ < GameWorld.bestFriendUsers.length)
            {
               _loc2_ = GameWorld.bestFriendUsers[_loc1_];
               Debug.out("best friend i=" + _loc1_ + " is " + _loc2_.firstName);
               if(_loc2_.userInfo.playCount == 0)
               {
                  inviteFriends.push(_loc2_);
               }
               if(inviteFriends.length >= 20)
               {
                  break;
               }
               _loc1_++;
            }
         }
         else
         {
            Debug.out("split test group B - random friends");
            _loc1_ = 0;
            while(_loc1_ < GameWorld.bestFriendUsers.length)
            {
               _loc2_ = GameWorld.bestFriendUsers[_loc1_];
               if(_loc2_.userInfo.playCount == 0)
               {
                  inviteFriends.push(_loc2_);
               }
               _loc1_++;
            }
         }
         if(inviteFriends.length > 0)
         {
            inviteFriendBasket = new RandomBasket();
            _loc3_ = 2;
            _loc1_ = 0;
            while(_loc1_ < _loc3_)
            {
               _loc4_ = Engine.getMovieClip("EmployeeContainerButtonInvite");
               setButtonMode(_loc4_,true);
               setInviteIcon(_loc4_);
               _loc4_.addEventListener(MouseEvent.CLICK,onInviteClick,false,0,true);
               _loc4_.cashAsBitmap = true;
               iconLayer.addChild(_loc4_);
               inviteIcons.push(_loc4_);
               _loc1_++;
            }
         }
      }
      
      private function onButtonCancelClick(param1:MouseEvent) : void
      {
         curPopUp.remove();
         curPopUp = null;
         curJobPanel = null;
      }
      
      public function refreshUserJob(param1:GameUserEmployee) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = employeeUsers.indexOf(param1);
         if(_loc3_ != -1)
         {
            _loc2_ = friendIcons[_loc3_].mc_content;
         }
         if(_loc2_)
         {
            switch(param1.job)
            {
               case GameUserEmployee.JOB_COOK:
                  _loc2_.gotoAndStop("cook");
                  break;
               case GameUserEmployee.JOB_WAITOR:
                  _loc2_.gotoAndStop("waitor");
                  break;
               case GameUserEmployee.JOB_REST:
                  _loc2_.gotoAndStop("rest");
                  break;
               case GameUserEmployee.JOB_CLEANER:
                  _loc2_.gotoAndStop("cleaner");
                  break;
               default:
                  _loc2_.gotoAndStop("nothing");
            }
         }
      }
      
      private function onInviteClick(param1:MouseEvent) : void
      {
         var ep:ExternalPage = null;
         var e:MouseEvent = param1;
         if(!scrollLayer.moveGesture)
         {
            ep = GameWorld.onInviteClicked();
            GameWorld.rpcClient.recordGameEvent(RpcClient.GAME_EVENT_BUTTON_CLICK,"invite",function():void
            {
            },function():void
            {
            });
            setInviteIcon(MovieClip(e.currentTarget));
         }
      }
      
      private function setInviteIcon(param1:MovieClip) : void
      {
         if(inviteFriendBasket.length() == 0)
         {
            inviteFriendBasket.addItemArray(inviteFriends);
         }
         var _loc2_:GameUser = GameUser(inviteFriendBasket.getNextItem());
         param1.mc_content.tf_name.text = _loc2_.firstName;
         param1.mc_content.tf_name.mouseEnabled = false;
         GameWorld.textHandler.setTextFieldWithId(param1.mc_content.tf_invite,"InviteHeader");
         if(param1.face)
         {
            param1.mc_content.mc_frame.mc_face.removeChild(param1.face);
            param1.face = null;
         }
         param1.face = GameWorld.getUserFaceImage(_loc2_);
         if(param1.face != null)
         {
            param1.mc_content.mc_frame.mc_face.addChild(param1.face);
         }
      }
      
      public function setPerksOnJobPanel(param1:Array, param2:MovieClip) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:PerkItem = null;
         var _loc3_:Number = 0;
         while(_loc3_ < 3)
         {
            _loc4_ = param2["mc_perk" + _loc3_];
            if(_loc4_)
            {
               if(_loc4_.perk)
               {
                  _loc4_.removeChild(_loc4_.perk);
                  _loc4_.perk = null;
                  _loc4_.tf_duration.text = 0;
               }
               _loc5_ = param1[_loc3_];
               if(param1[_loc3_] != null)
               {
                  _loc4_.gotoAndPlay("working");
                  _loc4_.perk = Engine.getMovieClip(_loc5_.itemConfig.className);
                  _loc4_.perk.width = _loc4_.mc_container.width;
                  _loc4_.perk.scaleY = _loc4_.perk.scaleX;
                  _loc4_.perk.x = _loc4_.mc_container.x;
                  _loc4_.perk.y = _loc4_.mc_container.y;
                  _loc4_.perkItem = _loc5_;
                  _loc4_.addChild(_loc4_.perk);
                  _loc4_.tf_duration.text = _loc5_.duration.toFixed(1);
               }
               else
               {
                  _loc4_.tf_duration.text = "0";
                  _loc4_.gotoAndStop("idle");
               }
            }
            _loc3_++;
         }
      }
      
      private function removeAllEmptyIcons() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         while(_loc1_ < emptyIcons.length)
         {
            _loc2_ = emptyIcons[_loc1_];
            iconLayer.removeChild(_loc2_);
            _loc2_.removeEventListener(MouseEvent.CLICK,onHireIconClick);
            if(_loc2_.glowEffect)
            {
               _loc2_.glowEffect.remove();
               _loc2_.glowEffect = null;
            }
            _loc1_++;
         }
         emptyIcons.splice(0,emptyIcons.length);
         emptyHireIcons.splice(0,emptyHireIcons.length);
         emptyLockedIcons.splice(0,emptyLockedIcons.length);
      }
      
      public function getSceneHeight() : Number
      {
         return scene.height;
      }
      
      public function setPerksForUser(param1:GameUserEmployee) : void
      {
         var _loc2_:MovieClip = friendIcons[employeeUsers.indexOf(param1)];
         if(_loc2_)
         {
            setPerksOnJobPanel(param1.activePerks,_loc2_);
         }
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:GameUserEmployee = null;
         var _loc2_:Number = 0;
         while(_loc2_ < friendIcons.length)
         {
            setIconAlpha(friendIcons[_loc2_]);
            updatePerksOnPanel(friendIcons[_loc2_]);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < emptyIcons.length)
         {
            setIconAlpha(emptyIcons[_loc2_]);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < inviteIcons.length)
         {
            setIconAlpha(inviteIcons[_loc2_]);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < employeeUsers.length)
         {
            _loc3_ = friendIcons[_loc2_].mc_content;
            _loc4_ = employeeUsers[_loc2_];
            _loc3_.tf_happiness.text = _loc4_.getTimeLeft();
            setHappinessIcon(_loc3_.mc_happiness,_loc4_);
            _loc2_++;
         }
      }
      
      public function refreshInviteIcons() : void
      {
         var _loc1_:int = 0;
         if(inviteIcons.length == 0)
         {
            createInviteBars();
            if(inviteIcons.length > 0)
            {
               refresh();
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < inviteIcons.length)
            {
               setInviteIcon(inviteIcons[_loc1_]);
               _loc1_++;
            }
         }
      }
      
      public function removeHiredUser(param1:GameUserEmployee, param2:Boolean = true) : void
      {
         var _loc3_:int = employeeUsers.indexOf(param1);
         iconLayer.removeChild(friendIcons[_loc3_]);
         friendIcons.splice(_loc3_,1);
         employeeUsers.splice(_loc3_,1);
         if(param2)
         {
            refresh();
         }
      }
      
      private function setIconAlpha(param1:MovieClip) : void
      {
         var _loc2_:Rectangle = param1.getBounds(this);
         if(_loc2_.left < 0)
         {
            param1.alpha = Math.max(0,1 + _loc2_.left / (iconGap / 2));
         }
         else if(_loc2_.right >= GameWorld.CANVAS_WIDTH)
         {
            param1.alpha = Math.max(0,1 - (_loc2_.right - GameWorld.CANVAS_WIDTH) / (iconGap / 2));
         }
         else
         {
            param1.alpha = 1;
         }
         if(param1.alpha <= 0)
         {
            param1.visible = false;
         }
         else
         {
            param1.visible = true;
         }
      }
      
      public function hide() : void
      {
         scrollLayer.visible = false;
         buttonLayer.visible = false;
         iconLayer.visible = false;
      }
      
      private function addEmptyIcon() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = friendIcons.length + emptyIcons.length;
         if(emptyIcons[_loc1_] == null)
         {
            if(_loc1_ < GameWorld.maxEmployees)
            {
               _loc2_ = Engine.getMovieClip("EmptyEmployeeContainerButton");
               setButtonMode(_loc2_,true);
               GameWorld.textHandler.setTextFieldWithId(_loc2_.mc_content.tf_text,"ToolTipHireFriends");
               _loc2_.addEventListener(MouseEvent.CLICK,onHireIconClick,false,0,true);
               _loc2_.glowEffect = new GlowEffect(_loc2_,16777215,0.1,0.8);
               emptyHireIcons.push(_loc2_);
            }
            else
            {
               _loc2_ = Engine.getMovieClip("EmployeeContainerUnlock");
               GameWorld.textHandler.setReplaceString("level",getUnlockLevelForEmployee(_loc1_ + 1).toString());
               GameWorld.textHandler.setTextFieldWithId(_loc2_.tf_text,"UnlocksAtLevel");
               emptyLockedIcons.push(_loc2_);
            }
            _loc2_.cacheAsBitmap = true;
            iconLayer.addChild(_loc2_);
            emptyIcons.push(_loc2_);
         }
      }
      
      public function addHiredUser(param1:GameUserEmployee, param2:Boolean = true) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:DisplayObject = null;
         if(employeeUsers.length < GameWorld.maxEmployees)
         {
            _loc3_ = Engine.getMovieClip("EmployeeContainerButton");
            setButtonMode(_loc3_,true);
            friendIcons.push(_loc3_);
            iconLayer.addChild(_loc3_);
            employeeUsers.push(param1);
            _loc4_ = _loc3_.mc_content;
            _loc4_.tf_name.text = param1.gameUser.firstName;
            _loc4_.tf_name.mouseEnabled = false;
            refreshUserJob(param1);
            _loc5_ = GameWorld.getUserFaceImage(param1.gameUser);
            if(_loc5_ != null)
            {
               _loc4_.mc_frame.mc_face.addChild(_loc5_);
            }
            _loc4_.user = param1;
            _loc4_.addEventListener(MouseEvent.CLICK,onIconClick);
            setPerksOnJobPanel(param1.activePerks,_loc3_);
            refreshUser(param1.gameUser);
            _loc3_.cacheAsBitmap = true;
            if(param2)
            {
               refresh();
            }
         }
      }
      
      public function updatePerksOnPanel(param1:MovieClip) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:Number = 0;
         while(_loc2_ < 3)
         {
            _loc3_ = param1["mc_perk" + _loc2_];
            if(Boolean(_loc3_) && Boolean(_loc3_.perkItem))
            {
               _loc3_.tf_duration.text = _loc3_.perkItem.duration.toFixed(1);
            }
            _loc2_++;
         }
      }
      
      private function getUnlockLevelForEmployee(param1:int) : int
      {
         var _loc3_:Object = null;
         var _loc2_:int = 0;
         while(_loc2_ < GameWorld.LEVEL_THRESHOLDS.length)
         {
            _loc3_ = GameWorld.LEVEL_THRESHOLDS[_loc2_];
            if(int(_loc3_.employees) >= param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function refreshUser(param1:GameUser) : void
      {
         var _loc2_:GameUserEmployee = null;
         var _loc3_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:DisplayObject = null;
         var _loc4_:int = 0;
         while(_loc4_ < employeeUsers.length)
         {
            if(param1 == employeeUsers[_loc4_].gameUser)
            {
               _loc2_ = employeeUsers[_loc4_];
               _loc3_ = friendIcons[_loc4_];
               break;
            }
            _loc4_++;
         }
         if(_loc2_ != null)
         {
            _loc5_ = _loc3_.mc_content;
            if(param1.firstName != null)
            {
               _loc5_.tf_name.text = param1.firstName;
            }
            else
            {
               _loc5_.tf_name.text = "";
            }
            _loc5_.tf_happiness.text = _loc2_.getTimeLeft();
            setHappinessIcon(_loc5_.mc_happiness,_loc2_);
            _loc6_ = param1.getAvatarFrame();
            _loc5_.mc_avatar.removeChildAt(0);
            _loc5_.mc_avatar.addChild(_loc6_);
         }
      }
      
      public function refresh() : void
      {
         removeAllEmptyIcons();
         var _loc1_:int = MAX_BARS - friendIcons.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            addEmptyIcon();
            _loc2_++;
         }
         var _loc3_:Array = new Array().concat(emptyHireIcons).concat(friendIcons).concat(emptyLockedIcons);
         if(inviteIcons.length == 0)
         {
            createInviteBars();
         }
         if(inviteIcons.length >= 1)
         {
            _loc3_.splice(0,0,inviteIcons[0]);
         }
         if(inviteIcons.length >= 2)
         {
            _loc3_.splice(emptyHireIcons.length + friendIcons.length + 1,0,inviteIcons[1]);
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            _loc3_[_loc2_].x = _loc2_ * iconGap;
            _loc2_++;
         }
         scrollLayer.setBounds(scene.mc_icon0.x,scene.mc_icon0.x + (_loc3_.length - 1) * iconGap,iconGap * (iconsPerScreen - 1));
         scrollLayer.setScrollStep(iconGap);
      }
      
      private function onHireIconClick(param1:MouseEvent) : void
      {
         if(!scrollLayer.moveGesture && !(Engine.curWorld is WorldHire))
         {
            if(WorldRestaurantPlay.instance != null)
            {
               WorldRestaurantPlay.instance.destroy();
            }
            GameWorld.fadeToWorld(new WorldHire());
         }
      }
      
      public function showJobPanel(param1:GameUserEmployee) : void
      {
         var _loc2_:WorldEmployeePopUp = new WorldEmployeePopUp(param1,WorldRestaurantPlay.instance);
         _loc2_.x = GameWorld.CANVAS_CENTER_X;
         _loc2_.y = GameWorld.CANVAS_CENTER_Y;
         _loc2_.show();
      }
      
      private function onIconClick(param1:MouseEvent) : void
      {
         if(!scrollLayer.moveGesture)
         {
            showJobPanel(param1.currentTarget.user);
         }
      }
      
      private function onRestaurantItemClicked(param1:ItemChooserEvent) : void
      {
         if(WorldRestaurantPlay.instance != null)
         {
         }
      }
      
      private function getStatString(param1:Number) : String
      {
         if(param1 >= 100)
         {
            return param1.toFixed(0);
         }
         return param1.toFixed(1);
      }
      
      public function show() : void
      {
         scrollLayer.visible = true;
         buttonLayer.visible = true;
         iconLayer.visible = true;
      }
      
      public function setHappinessIcon(param1:MovieClip, param2:GameUserEmployee) : void
      {
         var _loc3_:Number = GameUserEmployee.MAX_WORK_TIME / (param1.totalFrames - 1);
         var _loc4_:int = Math.floor(param2.workTime / _loc3_) + 1;
         var _loc5_:int = Math.min(_loc4_ + 1,param1.totalFrames);
         if(int(param1.currentFrame) != _loc5_)
         {
            param1.gotoAndStop(_loc5_);
         }
      }
   }
}

