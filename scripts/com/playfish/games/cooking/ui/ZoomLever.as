package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class ZoomLever
   {
      
      public static var zoomLevel:int = 1;
      
      private var scene:MovieClip;
      
      private var LEVER_ZOOM_SCALE:Array = [1.4,1,0.6];
      
      private var restaurant:WorldRestaurant;
      
      private var LEVER_POSITION:Array = [-20,0,20];
      
      public function ZoomLever(param1:MovieClip, param2:WorldRestaurant)
      {
         super();
         this.scene = param1;
         this.restaurant = param2;
         param1.mc_lever.buttonMode = true;
         param1.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,0,true);
         param1.mc_lever.addEventListener(MouseEvent.MOUSE_DOWN,onLeverMouseDown,false,0,true);
         param2.addEventListener(MouseEvent.MOUSE_UP,onLeverMouseUp,false,0,true);
         param2.addEventListener(MouseEvent.ROLL_OUT,onLeverMouseUp,false,0,true);
         setZoomLevel(zoomLevel,true);
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         setLeverPosition(scene.mouseY);
      }
      
      private function onLeverMouseMove(param1:MouseEvent) : void
      {
         setLeverPosition(scene.mouseY);
      }
      
      public function setZoomLevel(param1:int, param2:Boolean) : void
      {
         zoomLevel = Math.min(Math.max(0,param1),LEVER_ZOOM_SCALE.length - 1);
         scene.mc_lever.y = LEVER_POSITION[zoomLevel];
         restaurant.zoom(LEVER_ZOOM_SCALE[zoomLevel],param2);
      }
      
      private function setLeverPosition(param1:Number) : void
      {
         var _loc5_:Number = NaN;
         var _loc2_:Number = 1000;
         var _loc3_:int = -1;
         var _loc4_:int = 0;
         while(_loc4_ < LEVER_POSITION.length)
         {
            _loc5_ = Math.abs(param1 - LEVER_POSITION[_loc4_]);
            if(_loc5_ < _loc2_)
            {
               _loc2_ = _loc5_;
               _loc3_ = _loc4_;
            }
            _loc4_++;
         }
         if(_loc3_ != -1)
         {
            setZoomLevel(_loc3_,false);
         }
      }
      
      private function onLeverMouseUp(param1:MouseEvent) : void
      {
         restaurant.removeEventListener(MouseEvent.MOUSE_MOVE,onLeverMouseMove);
      }
      
      private function onLeverMouseDown(param1:MouseEvent) : void
      {
         restaurant.addEventListener(MouseEvent.MOUSE_MOVE,onLeverMouseMove,false,0,true);
         param1.stopImmediatePropagation();
      }
   }
}

