package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.GameWorld;
   import com.playfish.games.cooking.WorldRestaurantEditor;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class RestaurantLayoutChooser
   {
      
      private static const NUM_LAYOUT_BUTTONS:int = 3;
      
      private var layoutButtons:Array;
      
      private var curLayoutIndex:int = -1;
      
      private var restaurantEditor:WorldRestaurantEditor;
      
      public function RestaurantLayoutChooser(param1:MovieClip, param2:WorldRestaurantEditor)
      {
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         layoutButtons = new Array(NUM_LAYOUT_BUTTONS);
         super();
         this.restaurantEditor = param2;
         var _loc3_:int = 0;
         while(_loc3_ < NUM_LAYOUT_BUTTONS)
         {
            _loc4_ = param1["mc_layout" + _loc3_];
            if(_loc4_)
            {
               _loc4_.mc_content.stop();
               _loc4_.mc_content.gotoAndStop(2);
               _loc4_.mc_content.tf_number.text = (_loc3_ + 1).toString();
               _loc4_.mc_content.tf_number.mouseEnabled = false;
               layoutButtons[_loc3_] = _loc4_;
               _loc5_ = getLayoutUnlockLevel(_loc3_);
               if(_loc5_ != -1 && _loc5_ <= param2.gameUser.level.value)
               {
                  _loc4_.mc_content.mc_level.visible = false;
                  setClickableLayoutButton(_loc3_);
               }
               else
               {
                  param2.setButtonMode(_loc4_,false);
                  _loc4_.mc_content.mc_level.tf_level.text = _loc5_;
                  GameWorld.textHandler.setReplaceString("level",_loc5_.toString());
                  _loc4_.tooltip = new ToolTip(_loc4_,GameWorld.textHandler.getTextFromId("UnlocksAtLevel"),true);
               }
            }
            _loc3_++;
         }
         setSelectedLayoutButton(param2.activeRoomIndex / 2);
         param2.setButtonMode(param1.mc_up,true);
         param2.setButtonMode(param1.mc_down,true);
         param1.mc_up.visible = false;
         param1.mc_down.visible = false;
         if(GameWorld.LEVEL_THRESHOLDS[param2.gameUser.level.value].layouts <= 1)
         {
            param1.visible = false;
         }
      }
      
      private function onLayoutClicked(param1:MouseEvent) : void
      {
         var _loc2_:int = layoutButtons.indexOf(param1.currentTarget);
         restaurantEditor.setLayout(_loc2_);
         setSelectedLayoutButton(_loc2_);
      }
      
      private function setSelectedLayoutButton(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         if(curLayoutIndex != -1)
         {
            setClickableLayoutButton(curLayoutIndex);
            curLayoutIndex = -1;
         }
         curLayoutIndex = param1;
         if(curLayoutIndex != -1)
         {
            _loc2_ = layoutButtons[curLayoutIndex];
            restaurantEditor.setButtonMode(_loc2_,false);
            _loc2_.gotoAndStop("up");
            _loc2_.mc_content.gotoAndStop(1);
            _loc2_.removeEventListener(MouseEvent.CLICK,onLayoutClicked);
            if(_loc2_.tooltip)
            {
               _loc2_.tooltip.destroy();
               _loc2_.tooltip = null;
            }
         }
      }
      
      private function setClickableLayoutButton(param1:int) : void
      {
         var _loc2_:MovieClip = layoutButtons[param1];
         if(_loc2_.tooltip)
         {
            _loc2_.tooltip.destroy();
            _loc2_.tooltip = null;
         }
         GameWorld.textHandler.setReplaceString("LayoutIndex",(param1 + 1).toString());
         _loc2_.tooltip = new ToolTip(_loc2_,GameWorld.textHandler.getTextFromId("SwitchToLayoutNumber"),true);
         restaurantEditor.setButtonMode(_loc2_,true);
         _loc2_.mc_content.gotoAndStop(2);
         _loc2_.addEventListener(MouseEvent.CLICK,onLayoutClicked,false,0,true);
      }
      
      private function getLayoutUnlockLevel(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < GameWorld.LEVEL_THRESHOLDS.length)
         {
            if(GameWorld.LEVEL_THRESHOLDS[_loc2_].layouts > param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
   }
}

