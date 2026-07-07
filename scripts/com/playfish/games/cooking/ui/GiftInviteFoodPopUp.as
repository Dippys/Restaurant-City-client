package com.playfish.games.cooking.ui
{
   import com.playfish.external.*;
   import com.playfish.games.cooking.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class GiftInviteFoodPopUp extends WorldPopUp
   {
      
      public function GiftInviteFoodPopUp()
      {
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc7_:MovieClip = null;
         super(null,null,null);
         var _loc1_:MovieClip = Engine.getMovieClip("GiftInvitePopupAnim");
         addChild(_loc1_);
         var _loc2_:MovieClip = _loc1_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(_loc2_.tf_title,"SendFreeSnacksToYourFriends");
         var _loc3_:Array = GameWorld.perkItemDatabase.getItems("Employee");
         var _loc4_:int = 0;
         while(_loc4_ < 4)
         {
            _loc5_ = _loc2_["mc_icon" + _loc4_];
            if(_loc5_)
            {
               _loc6_ = 0;
               if(_loc3_[_loc4_].unlockLevel)
               {
                  _loc6_ = int(_loc3_[_loc4_].unlockLevel);
               }
               if(GameWorld.gameUser.level.value >= _loc6_)
               {
                  setButtonMode(_loc5_,true);
                  _loc5_.mc_content.mc_base.stop();
                  _loc5_.addEventListener(MouseEvent.CLICK,onFoodIconClick,false,0,true);
                  _loc5_.mc_content.tf_unlock.visible = false;
               }
               else
               {
                  setButtonMode(_loc5_,false);
                  _loc5_.mc_content.mc_base.gotoAndStop("red");
                  GameWorld.textHandler.setReplaceString("level",_loc6_.toString());
                  GameWorld.textHandler.setTextFieldWithId(_loc5_.mc_content.tf_unlock,"UnlocksAtLevel");
               }
               _loc5_.mc_content.tf_name.text = _loc3_[_loc4_].name;
               _loc5_.mc_content.tf_name.mouseEnabled = false;
               _loc5_.mc_content.tf_unlock.mouseEnabled = false;
               _loc5_.itemConfig = _loc3_[_loc4_];
               _loc7_ = Engine.getMovieClip(_loc3_[_loc4_].className);
               _loc7_.stop();
               _loc7_.x = _loc5_.mc_content.mc_item.x;
               _loc7_.y = _loc5_.mc_content.mc_item.y;
               _loc7_.scaleX = 1.5;
               _loc7_.scaleY = 1.5;
               _loc5_.mc_content.addChildAt(_loc7_,_loc5_.mc_content.getChildIndex(_loc5_.mc_content.mc_item));
               _loc5_.mc_content.mc_item.stop();
               _loc5_.mc_content.mc_item.visible = false;
            }
            _loc4_++;
         }
         setButtonMode(_loc2_.mc_cancel,true);
         _loc2_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
      }
      
      private function onFoodIconClick(param1:MouseEvent) : void
      {
         Engine.setFullScreen(false);
         Engine.instance.setParameter("pf_gift_url","popup:addInviteStickersIFrame");
         var _loc2_:ExternalPage = new ExternalPage("gift");
         _loc2_.show(String(param1.currentTarget.itemConfig.id),GameWorld.gameUser.userInfo.id.networkUid);
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
      }
   }
}

