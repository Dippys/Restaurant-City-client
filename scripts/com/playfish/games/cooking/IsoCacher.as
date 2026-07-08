package com.playfish.games.cooking
{
   import away3d.containers.View3D;
   import away3d.core.base.Object3D;
   import away3d.core.math.Number3D;
   import away3d.lights.DirectionalLight3D;
   import com.playfish.games.cooking.ui.WorldPopUp;
   import flash.display.*;
   import flash.events.Event;
   import flash.geom.*;
   import flash.utils.*;
   
   public class IsoCacher
   {
      
      private var callback:Function;
      
      private var isoMode:Boolean;
      
      private var model:Object3D;
      
      private var view:View3D;
      
      private var curYaw:Number = 0;
      
      private var light:DirectionalLight3D;
      
      private var resolutionBoost:Number;
      
      public function IsoCacher(param1:Avatar3D, param2:Function, param3:Boolean = true, param4:Boolean = true, param5:int = 0)
      {
         super();
         this.model = param1.model;
         this.callback = param2;
         this.isoMode = param4;
         view = GameWorld.view3d;
         light = GameWorld.light;
         reset();
         setRotation(param5);
         resolutionBoost = 1;
         if(param3)
         {
            view.addEventListener(Event.ENTER_FRAME,onEnterFrame,false,0,true);
         }
         else
         {
            cache();
         }
      }
      
      public function setRotation(param1:Number) : void
      {
         model.yaw(curYaw - param1);
         curYaw = param1;
      }
      
      public function destroy() : void
      {
         if(view != null)
         {
            if(model.parent == view.scene)
            {
               view.scene.removeChild(model);
            }
            view.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
            if(view.parent == Engine.instance)
            {
               Engine.instance.stage.removeChild(view);
            }
            view = null;
         }
      }
      
      private function cache() : void
      {
         var _loc1_:* = undefined;
         do
         {
            _loc1_ = renderShape();
         }
         while(callback(_loc1_));
         destroy();
      }
      
      private function reset() : void
      {
         view.visible = false;
         view.x = 320;
         view.y = 480;
         view.scene.addChild(model);
         Engine.instance.stage.addChild(view);
         if(isoMode)
         {
            view.camera.x = 0;
            view.camera.y = 0;
            view.camera.z = -80000;
            view.camera.lookAt(new Number3D(0,0,0));
            model.lookAt(Number3D.FORWARD);
            model.pitch(-30);
         }
         else
         {
            view.camera.x = 0;
            view.camera.y = 0;
            view.camera.z = -55000;
            view.camera.lookAt(new Number3D(0,0,0));
            model.lookAt(Number3D.FORWARD);
         }
         light.position = new Number3D(-100000,9000,-84000);
         light.lookAt(new Number3D(0,0,0));
      }
      
      private function renderShape() : Object
      {
         view.visible = true;
         view.render();
         var _loc1_:DisplayObjectContainer = view.session.getContainer(view) as DisplayObjectContainer;
         var _loc2_:DisplayObject = _loc1_.getChildAt(0);
         var _loc3_:Rectangle = _loc2_.getRect(null);
         var _loc6_:Rectangle = _loc2_.getRect(_loc2_);
         var _loc4_:BitmapData = new BitmapData(Math.max(1,_loc3_.width),Math.max(1,_loc3_.height),true,0);
         _loc4_.draw(_loc2_,new Matrix(1,0,0,1,-_loc6_.left,-_loc6_.top));
         view.clear();
         view.visible = false;
         var _loc5_:Object = new Object();
         _loc5_.bitmapData = _loc4_;
         _loc5_.x = _loc3_.left;
         _loc5_.y = _loc3_.top;
         return _loc5_;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         if(model.parent != view.scene)
         {
            reset();
            setRotation(curYaw);
         }
         if(WorldPopUp.activePopUp.length == 0)
         {
            _loc2_ = getTimer();
            do
            {
               _loc3_ = renderShape();
               if(!callback(_loc3_))
               {
                  break;
               }
            }
            while(getTimer() - _loc2_ < 15);
         }
      }
      
      public function setResolutionBoost(param1:Number) : void
      {
         resolutionBoost = param1;
      }
   }
}

