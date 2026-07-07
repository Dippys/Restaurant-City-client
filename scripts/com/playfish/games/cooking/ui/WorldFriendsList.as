package com.playfish.games.cooking.ui
{
   import com.playfish.external.ExternalPage;
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.events.FriendListEvent;
   import com.playfish.games.cooking.utils.RandomBasket;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class WorldFriendsList extends BaseWorld
   {
      
      private static const NUMBER_OF_VISIBLE_BARS:int = 7;
      
      private static const NUMBER_OF_BARS_BETWEEN_INVITE_BAR:int = 6;
      
      private var allBars:Array;
      
      private var barGap:Number;
      
      private var friendUsers:Array;
      
      private var scene:MovieClip;
      
      private var barLayer:Sprite;
      
      private var inviteFriends:Array;
      
      private var sort:Boolean = true;
      
      private var inviteBars:Array;
      
      private var inviteFriendBasket:RandomBasket;
      
      private var scrollPanel:ScrollPanel;
      
      private var friendBars:Array;
      
      public function WorldFriendsList(param1:Array, param2:Boolean = true)
      {
         var _loc9_:MovieClip = null;
         super();
         this.sort = param2;
         scene = Engine.getMovieClip("FriendsBar2");
         addChild(scene);
         var _loc3_:Number = Number(scene.mc_bar5.x);
         var _loc4_:Number = Number(scene.mc_bar5.y);
         barGap = scene.mc_bar0.x - scene.mc_bar1.x;
         var _loc5_:int = 0;
         while(_loc5_ < NUMBER_OF_VISIBLE_BARS)
         {
            scene["mc_bar" + _loc5_].stop();
            scene["mc_bar" + _loc5_].visible = false;
            _loc5_++;
         }
         if(param2)
         {
            friendUsers = GameWorld.sortUsers(param1,GameWorld.compareUserPointAscending);
         }
         else
         {
            friendUsers = param1;
         }
         barLayer = new Sprite();
         scene.addChild(barLayer);
         barLayer.x = _loc3_;
         barLayer.y = _loc4_;
         var _loc6_:MovieClip = Engine.getMovieClip("EmployeeBarButtonLayer");
         scene.addChild(_loc6_);
         allBars = new Array();
         friendBars = new Array();
         var _loc7_:* = int(friendUsers.length);
         var _loc8_:Number = 0;
         _loc5_ = 0;
         while(_loc5_ < friendUsers.length)
         {
            _loc9_ = Engine.getMovieClip("FriendListPanel");
            setButtonMode(_loc9_,true);
            if(param2)
            {
               _loc9_.mc_content.tf_rank.text = _loc7_;
               _loc7_--;
            }
            else
            {
               _loc9_.mc_content.tf_rank.visible = false;
            }
            _loc9_.mc_content.tf_rank.mouseEnabled = false;
            _loc9_.mc_content.tf_level.text = friendUsers[_loc5_].level.value;
            _loc9_.mc_content.tf_level.mouseEnabled = false;
            _loc9_.mc_content.tf_point.text = friendUsers[_loc5_].getGourmetPoints();
            _loc9_.mc_content.tf_point.mouseEnabled = false;
            _loc9_.mc_content.tf_name.text = friendUsers[_loc5_].firstName;
            _loc9_.mc_content.tf_name.mouseEnabled = false;
            setBanner(friendUsers[_loc5_],_loc9_.mc_content.mc_banner);
            _loc9_.user = friendUsers[_loc5_];
            _loc9_.x = _loc8_;
            _loc9_.y = 0;
            barLayer.addChild(_loc9_);
            friendBars.push(_loc9_);
            _loc9_.addEventListener(MouseEvent.CLICK,onBarClicked,false,0,true);
            _loc8_ += barGap;
            _loc5_++;
         }
         scrollPanel = new ScrollPanel(barLayer,this,_loc6_.mc_left,_loc6_.mc_right);
         addObject(scrollPanel);
         scrollPanel.keyboardEnabled = false;
         refresh();
         scrollPanel.focus(_loc3_ + _loc8_ - barGap,true);
      }
      
      private function createInviteBars() : void
      {
         var _loc2_:GameUser = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         inviteFriends = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < GameWorld.bestFriendUsers.length)
         {
            _loc2_ = GameWorld.bestFriendUsers[_loc1_];
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
         if(inviteFriends.length > 0)
         {
            inviteBars = new Array();
            inviteFriendBasket = new RandomBasket();
            _loc3_ = Math.ceil(friendUsers.length / NUMBER_OF_BARS_BETWEEN_INVITE_BAR);
            _loc1_ = 0;
            while(_loc1_ < _loc3_)
            {
               _loc4_ = Engine.getMovieClip("InviteFriendListPanel2");
               setButtonMode(_loc4_,true);
               GameWorld.textHandler.setTextFieldWithId(_loc4_.mc_content.tf_invite,"InviteHeader");
               setInviteBar(_loc4_);
               _loc4_.addEventListener(MouseEvent.CLICK,onInviteClicked,false,0,true);
               barLayer.addChild(_loc4_);
               inviteBars.push(_loc4_);
               _loc1_++;
            }
         }
      }
      
      private function setInviteBar(param1:MovieClip) : void
      {
         if(inviteFriendBasket.length() == 0)
         {
            inviteFriendBasket.addItemArray(inviteFriends);
         }
         var _loc2_:GameUser = GameUser(inviteFriendBasket.getNextItem());
         param1.user = _loc2_;
         param1.mc_content.tf_name.text = _loc2_.firstName;
         param1.mc_content.tf_name.mouseEnabled = false;
         if(param1.faceImage)
         {
            param1.mc_content.mc_frame.mc_face.removeChild(param1.faceImage);
            param1.faceImage = null;
         }
         param1.faceImage = GameWorld.getUserFaceImage(_loc2_);
         if(param1.faceImage != null)
         {
            param1.mc_content.mc_frame.mc_face.addChild(param1.faceImage);
         }
      }
      
      public function refresh() : void
      {
         var _loc3_:Array = null;
         var _loc4_:Number = NaN;
         var _loc5_:MovieClip = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         if(sort)
         {
            _loc3_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < friendBars.length)
            {
               _loc5_ = friendBars[_loc4_];
               _loc6_ = 0;
               while(_loc6_ < _loc3_.length)
               {
                  if(_loc5_.user.gourmetPoints.value < _loc3_[_loc6_].user.gourmetPoints.value)
                  {
                     _loc3_.splice(_loc6_,0,_loc5_);
                     break;
                  }
                  _loc6_++;
               }
               if(_loc6_ == _loc3_.length)
               {
                  _loc3_.push(_loc5_);
               }
               _loc4_++;
            }
            friendBars = _loc3_;
         }
         allBars.splice(0,allBars.length);
         _loc4_ = 0;
         while(_loc4_ < friendBars.length)
         {
            _loc5_ = friendBars[_loc4_];
            _loc5_.mc_content.tf_rank.text = friendBars.length - _loc4_;
            _loc5_.mc_content.tf_level.text = friendBars[_loc4_].user.level.value;
            _loc5_.mc_content.tf_point.text = friendBars[_loc4_].user.getGourmetPoints();
            allBars.push(friendBars[_loc4_]);
            _loc4_++;
         }
         if(inviteBars == null)
         {
            createInviteBars();
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < inviteBars.length)
            {
               setInviteBar(inviteBars[_loc4_]);
               _loc4_++;
            }
         }
         if(inviteBars != null)
         {
            _loc4_ = 0;
            while(_loc4_ < inviteBars.length)
            {
               _loc7_ = friendBars.length - _loc4_ * NUMBER_OF_BARS_BETWEEN_INVITE_BAR;
               allBars.splice(_loc7_,0,inviteBars[_loc4_]);
               _loc4_++;
            }
         }
         var _loc1_:Number = 0;
         _loc4_ = 0;
         while(_loc4_ < allBars.length)
         {
            _loc5_ = allBars[_loc4_];
            _loc5_.x = _loc1_;
            _loc1_ += barGap;
            _loc4_++;
         }
         var _loc2_:Number = Number(scene.mc_bar5.x);
         scrollPanel.setBounds(_loc2_,_loc2_ + _loc1_ - barGap,barGap * 5);
         scrollPanel.setScrollStep(barGap);
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc5_:GameUser = null;
         var _loc2_:int = Math.max(Math.floor(-barLayer.x / barGap) - 1,0);
         var _loc3_:int = Math.min(_loc2_ + NUMBER_OF_VISIBLE_BARS + 1,allBars.length - 1);
         var _loc4_:int = _loc2_;
         while(_loc4_ <= _loc3_)
         {
            _loc5_ = allBars[_loc4_].user;
            if(_loc5_ != null)
            {
               if(allBars[_loc4_] != null && allBars[_loc4_].faceImage == null)
               {
                  allBars[_loc4_].faceImage = GameWorld.getUserFaceImage(_loc5_);
                  if(allBars[_loc4_].faceImage)
                  {
                     allBars[_loc4_].mc_content.mc_frame.mc_face.addChild(allBars[_loc4_].faceImage);
                  }
               }
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < allBars.length)
         {
            setIconAlpha(allBars[_loc4_]);
            _loc4_++;
         }
      }
      
      private function onBarClicked(param1:MouseEvent) : void
      {
         if(!scrollPanel.moveGesture)
         {
            if(hasEventListener(FriendListEvent.USER_CLICKED))
            {
               dispatchEvent(new FriendListEvent("user_clicked",param1.currentTarget.user));
            }
         }
      }
      
      private function setIconAlpha(param1:MovieClip) : void
      {
         var _loc2_:Rectangle = param1.getBounds(this);
         if(_loc2_.left < 0)
         {
            param1.alpha = Math.max(0,1 + _loc2_.left / (barGap / 2));
         }
         else if(_loc2_.right >= GameWorld.CANVAS_WIDTH)
         {
            param1.alpha = Math.max(0,1 - (_loc2_.right - GameWorld.CANVAS_WIDTH) / (barGap / 2));
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
      
      public function getSceneHeight() : Number
      {
         return scene.height;
      }
      
      private function setBanner(param1:GameUser, param2:MovieClip) : void
      {
         var _loc4_:MovieClip = null;
         var _loc3_:UserItem = param1.getUsedBuildingBannerItem();
         if(_loc3_ != null)
         {
            _loc4_ = Engine.getMovieClip(_loc3_.itemConfig.className);
            _loc4_.tf_name.text = param1.bannerText;
            _loc4_.tf_name.mouseEnabled = false;
            param2.removeChildAt(0);
            param2.addChild(_loc4_);
         }
         else
         {
            param2.tf_name.text = param1.bannerText;
            param2.tf_name.mouseEnabled = false;
         }
      }
      
      private function onInviteClicked(param1:MouseEvent) : void
      {
         var _loc2_:ExternalPage = null;
         if(!scrollPanel.moveGesture)
         {
            _loc2_ = GameWorld.onInviteClicked();
            setInviteBar(MovieClip(param1.currentTarget));
         }
      }
   }
}

