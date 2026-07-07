package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ClearRoomConfirmPopUp extends WorldPopUp
   {
      
      private var scene:MovieClip;
      
      private var restaurant:WorldRestaurantEditor;
      
      public function ClearRoomConfirmPopUp(param1:WorldRestaurantEditor)
      {
         super(null,null,null);
         this.restaurant = param1;
         scene = Engine.getMovieClip("ClearRoomPopupAnimation");
         addChild(scene);
         var _loc2_:MovieClip = scene.mc_content;
         setButtonMode(_loc2_.mc_tick,true);
         setButtonMode(_loc2_.mc_cancel,true);
         _loc2_.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
         _loc2_.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         remove();
         restaurant.removeAllItemsToInventory();
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
      }
   }
}

