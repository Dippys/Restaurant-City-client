package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   
   public class WorldHireEmployeePopUp extends WorldPopUp
   {
      
      private var hireScreen:WorldHire;
      
      private var userToHire:GameUser;
      
      private var tickBox:MovieClip;
      
      public function WorldHireEmployeePopUp(param1:WorldHire, param2:GameUser)
      {
         super(null,null,null);
         this.hireScreen = param1;
         this.userToHire = param2;
         var _loc3_:MovieClip = Engine.getMovieClip("HirePanelPopup");
         addChild(_loc3_);
         var _loc4_:MovieClip = _loc3_.mc_content;
         _loc4_.tf_name.text = param2.fullName;
         var _loc5_:DisplayObject = GameWorld.getUserFaceImage(param2);
         if(_loc5_)
         {
            _loc4_.mc_frame.mc_face.addChild(_loc5_);
         }
         setButtonMode(_loc4_.mc_tick,true);
         setButtonMode(_loc4_.mc_cancel,true);
         _loc4_.mc_tick.addEventListener(MouseEvent.CLICK,onHireTickClick,false,0,true);
         _loc4_.mc_cancel.addEventListener(MouseEvent.CLICK,onHireCancelClick,false,0,true);
         tickBox = _loc4_.mc_tickBox;
         tickBox.buttonMode = true;
         tickBox.addEventListener(MouseEvent.CLICK,onHireTickBoxClick,false,0,true);
         tickBox.gotoAndStop("tick");
      }
      
      private function onHireTickClick(param1:MouseEvent) : void
      {
         GameWorld.hireUser(userToHire,tickBox.currentLabel == "tick");
         GameWorld.addGourmetPoints(GameWorld.GOURMET_POINTS_HIRE_EMPLOYEE);
         hireScreen.removeUser(userToHire);
         remove();
      }
      
      private function onHireCancelClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      private function onHireTickBoxClick(param1:MouseEvent) : void
      {
         if(tickBox.currentLabel == "tick")
         {
            tickBox.gotoAndStop("untick");
         }
         else
         {
            tickBox.gotoAndStop("tick");
         }
      }
   }
}

