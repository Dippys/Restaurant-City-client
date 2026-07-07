package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import com.playfish.rpc.share.NetworkUid;
   import flash.display.*;
   import flash.events.MouseEvent;
   
   public class WorldSackEmployee extends WorldPopUp
   {
      
      private var parentPopUp:WorldPopUp;
      
      private var user:GameUserEmployee;
      
      private var restaurant:WorldRestaurantPlay;
      
      private var tickBox:MovieClip;
      
      public function WorldSackEmployee(param1:GameUserEmployee, param2:WorldRestaurantPlay, param3:WorldPopUp)
      {
         super(null,null,null);
         this.user = param1;
         this.restaurant = param2;
         this.parentPopUp = param3;
         var _loc4_:MovieClip = Engine.getMovieClip("SackPanelPopup");
         addChild(_loc4_);
         var _loc5_:MovieClip = _loc4_.mc_content;
         if(param1.gameUser.fullName != null)
         {
            _loc5_.tf_name.text = param1.gameUser.fullName;
         }
         else
         {
            _loc5_.tf_name.text = "";
         }
         var _loc6_:DisplayObject = GameWorld.getUserFaceImage(param1.gameUser);
         if(_loc6_)
         {
            _loc5_.mc_frame.mc_face.addChild(_loc6_);
         }
         if(GameWorld.gameUser.money.value < -GameWorld.FIRE_EMPLOYEE_PENALTY)
         {
            setButtonMode(_loc5_.mc_tick,false);
            _loc5_.mc_tick.gotoAndStop("grey");
            _loc5_.mc_tick.toolTip = new ToolTip(_loc5_.mc_tick,GameWorld.textHandler.getTextFromId("ToolTipNotEnoughCoins"));
         }
         else
         {
            setButtonMode(_loc5_.mc_tick,true);
            _loc5_.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick);
         }
         setButtonMode(_loc5_.mc_cancel,true);
         _loc5_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick);
         tickBox = _loc5_.mc_tickBox;
         tickBox.buttonMode = true;
         tickBox.addEventListener(MouseEvent.CLICK,onTickBoxClick);
         tickBox.gotoAndStop("tick");
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:AvatarItem = null;
         var _loc6_:InventoryUserItem = null;
         if(GameWorld.gameUser.money.value + GameWorld.FIRE_EMPLOYEE_PENALTY > 0)
         {
            remove();
            GameWorld.saveProfileHandler.addFiredEmployees(user,tickBox.currentLabel == "tick");
            GameWorld.cashPanel.addCoins(GameWorld.FIRE_EMPLOYEE_PENALTY);
            _loc2_ = GameWorld.gameUser.employeeUsers.indexOf(user);
            GameWorld.gameUser.employeeUsers.splice(_loc2_,1);
            --GameWorld.gameUser.employeeCount.value;
            GameWorld.hiredFriendsPanel.removeHiredUser(user);
            if(!NetworkUid.areEqual(GameWorld.gameUser.userInfo.id,user.gameUser.userInfo.id))
            {
               _loc3_ = GameWorld.gameUser.getAvatarItems(user.gameUser.userInfo.id);
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = _loc3_[_loc4_];
                  if(_loc5_.itemConfig.cost == 0)
                  {
                     GameWorld.saveProfileHandler.sellItem(_loc5_,1,false);
                  }
                  else
                  {
                     _loc6_ = new InventoryUserItem(_loc5_.itemConfig,_loc5_.getOwnedItem());
                     GameWorld.gameUser.addInventoryItem(_loc6_);
                     GameWorld.saveProfileHandler.moveItem(_loc6_,false);
                  }
                  GameWorld.gameUser.removeUsedAvatarItem(_loc5_.serverUid);
                  _loc4_++;
               }
            }
            if(restaurant != null)
            {
               restaurant.onFireUser(user);
            }
            GameWorld.forceAutoSave();
         }
      }
      
      private function onTickBoxClick(param1:MouseEvent) : void
      {
         Debug.out("onTickBoxClick");
         if(tickBox.currentLabel == "tick")
         {
            tickBox.gotoAndStop("untick");
         }
         else
         {
            tickBox.gotoAndStop("tick");
         }
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
         if(parentPopUp != null)
         {
            parentPopUp.show();
         }
      }
   }
}

