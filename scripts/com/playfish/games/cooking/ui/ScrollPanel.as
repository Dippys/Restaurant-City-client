package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.utils.*;
   
   public class ScrollPanel extends BaseObject
   {
      
      private static var ORIENTATION_HORIZONTAL:int = 0;
      
      private static var ORIENTATION_VERTICAL:int = 1;
      
      private static const SCROLL_SPEED:Number = 1;
      
      private static const MAX_SCROLL_SPEED:Number = 3;
      
      private static const SCROLL_SPEED_INCREASE_TIME:int = 1500;
      
      private var focusX:Number = -1;
      
      private var panel:Sprite;
      
      private var leftButtonFast:MovieClip;
      
      private var leftButton:MovieClip;
      
      private var leftPressed:Boolean = false;
      
      public var scrollSpeedX:Number = 0;
      
      private var viewWidth:Number = GameWorld.CANVAS_WIDTH;
      
      private var mouseParent:Sprite;
      
      private var leftBound:Number = 0;
      
      public var moveGesture:Boolean = false;
      
      public var scrollEnabled:Boolean = true;
      
      private var rightBound:Number = 0;
      
      private var scrollSpeedIncreaseTimer:int = 0;
      
      private var step:Number = 0;
      
      private var prevScrollTime:int = 0;
      
      private var orientation:int;
      
      private var prevScrollMouseY:Number = 0;
      
      private var snapDirection:int;
      
      public var accelerationX:Number = 0.2;
      
      private var prevScrollMouseX:Number = 0;
      
      public var keyboardEnabled:Boolean = true;
      
      private var totalWidth:Number;
      
      private var rightPressed:Boolean = false;
      
      private var rightButtonFast:MovieClip;
      
      private var rightButton:MovieClip;
      
      private var mouseHeld:Boolean = false;
      
      public function ScrollPanel(param1:Sprite, param2:Sprite, param3:MovieClip = null, param4:MovieClip = null, param5:MovieClip = null, param6:MovieClip = null)
      {
         super();
         this.panel = param1;
         this.mouseParent = param2;
         if(param2)
         {
            param2.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,0,true);
            param2.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,0,true);
            param2.addEventListener(MouseEvent.ROLL_OUT,onMouseUp,false,0,true);
         }
         setButtons(param3,param4,param5,param6);
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         param1 = 50;
         scrollSpeedIncreaseTimer += param1;
         var _loc2_:Boolean = false;
         if(rightPressed || keyboardEnabled && Engine.isKeyPressed(Engine.KEY_RIGHT))
         {
            focusX = -1;
            _loc2_ = true;
            if(scrollSpeedX > 0)
            {
               scrollSpeedX = -scrollSpeedX;
            }
            else
            {
               scrollSpeedX = Math.max(-getCurrentMaxScrollSpeed(),scrollSpeedX - accelerationX);
            }
         }
         else if(leftPressed || keyboardEnabled && Engine.isKeyPressed(Engine.KEY_LEFT))
         {
            focusX = -1;
            _loc2_ = true;
            if(scrollSpeedX < 0)
            {
               scrollSpeedX = -scrollSpeedX;
            }
            else
            {
               scrollSpeedX = Math.min(getCurrentMaxScrollSpeed(),scrollSpeedX + accelerationX);
            }
         }
         else
         {
            scrollSpeedIncreaseTimer = 0;
         }
         if(scrollSpeedX > 0)
         {
            snapDirection = 1;
         }
         else if(scrollSpeedX < 0)
         {
            snapDirection = -1;
         }
         var _loc3_:Number = panel.x;
         if(focusX != -1)
         {
            _loc3_ = leftBound - focusX;
            if(_loc3_ >= leftBound)
            {
               _loc3_ = leftBound;
            }
            else if(_loc3_ + totalWidth < leftBound + viewWidth)
            {
               _loc3_ = leftBound + viewWidth - totalWidth;
            }
         }
         else if(!mouseHeld && !_loc2_)
         {
            if(step != 0 && Math.abs(scrollSpeedX) <= 0.8)
            {
               if(snapDirection > 0)
               {
                  _loc3_ = Math.ceil((_loc3_ - leftBound) / step) * step + leftBound;
               }
               else if(snapDirection < 0)
               {
                  _loc3_ = Math.floor((_loc3_ - leftBound) / step) * step + leftBound;
               }
            }
            if(_loc3_ >= leftBound)
            {
               _loc3_ = leftBound;
            }
            else if(_loc3_ + totalWidth < leftBound + viewWidth)
            {
               _loc3_ = leftBound + viewWidth - totalWidth;
            }
         }
         if(_loc3_ != panel.x)
         {
            scrollSpeedX = (_loc3_ - panel.x) / 50 / 4;
            if(Math.abs(_loc3_ - panel.x) < step)
            {
               scrollSpeedX = Math.max(Math.min(scrollSpeedX,0.8),-0.8);
            }
            if(Math.abs(scrollSpeedX) < 0.01)
            {
               focusX = -1;
               scrollSpeedX = 0;
               snapDirection = 0;
               panel.x = _loc3_;
            }
            else
            {
               panel.x += scrollSpeedX * param1;
            }
         }
         else
         {
            focusX = -1;
            if(scrollSpeedX != 0)
            {
               if(!mouseHeld)
               {
                  panel.x += scrollSpeedX * param1;
                  if(panel.x >= leftBound)
                  {
                     panel.x = leftBound;
                  }
                  else if(panel.x + totalWidth < leftBound + viewWidth)
                  {
                     panel.x = leftBound + viewWidth - totalWidth;
                  }
               }
               if(!_loc2_)
               {
                  _loc4_ = Engine.getAngle(0,0,scrollSpeedX,0);
                  _loc5_ = -0.25 * Math.cos(_loc4_);
                  if(scrollSpeedX > 0)
                  {
                     scrollSpeedX = Math.max(0,scrollSpeedX + _loc5_);
                  }
                  else if(scrollSpeedX < 0)
                  {
                     scrollSpeedX = Math.min(0,scrollSpeedX + _loc5_);
                  }
                  if(scrollSpeedX == 0)
                  {
                  }
               }
            }
         }
         setupLeftButton(leftButton);
         setupRightButton(rightButton);
         setupLeftButton(leftButtonFast);
         setupRightButton(rightButtonFast);
      }
      
      public function setBounds(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         this.leftBound = param1;
         this.rightBound = param2;
         this.viewWidth = param3;
         totalWidth = param2 - param1;
         if(totalWidth < param3)
         {
            _loc4_ = (param3 - totalWidth) / 2;
            this.viewWidth = totalWidth;
            this.leftBound += _loc4_;
            this.rightBound -= _loc4_;
         }
      }
      
      public function setButtons(param1:MovieClip, param2:MovieClip, param3:MovieClip = null, param4:MovieClip = null) : void
      {
         this.leftButton = param1;
         this.rightButton = param2;
         this.leftButtonFast = param3;
         this.rightButtonFast = param4;
         if(param1)
         {
            param1.addEventListener(MouseEvent.MOUSE_DOWN,onLeftDown,false,0,true);
            param1.addEventListener(MouseEvent.MOUSE_UP,onLeftUp,false,0,true);
            param1.addEventListener(MouseEvent.MOUSE_OUT,onLeftUp,false,0,true);
         }
         if(param2)
         {
            param2.addEventListener(MouseEvent.MOUSE_DOWN,onRightDown,false,0,true);
            param2.addEventListener(MouseEvent.MOUSE_UP,onRightUp,false,0,true);
            param2.addEventListener(MouseEvent.MOUSE_OUT,onRightUp,false,0,true);
         }
         if(param3)
         {
            param3.addEventListener(MouseEvent.MOUSE_DOWN,onLeftFastDown,false,0,true);
            param3.addEventListener(MouseEvent.MOUSE_UP,onLeftUp,false,0,true);
            param3.addEventListener(MouseEvent.MOUSE_OUT,onLeftUp,false,0,true);
         }
         if(param4)
         {
            param4.addEventListener(MouseEvent.MOUSE_DOWN,onRightFastDown,false,0,true);
            param4.addEventListener(MouseEvent.MOUSE_UP,onRightUp,false,0,true);
            param4.addEventListener(MouseEvent.MOUSE_OUT,onRightUp,false,0,true);
         }
      }
      
      private function setupRightButton(param1:MovieClip) : void
      {
         if(param1)
         {
            if(Math.floor(panel.x) <= Math.ceil(leftBound + viewWidth - totalWidth))
            {
               if(param1.currentLabel != "disabled")
               {
                  setButtonMode(param1,false);
                  param1.gotoAndStop("disabled");
               }
            }
            else if(param1.currentLabel == "disabled")
            {
               setButtonMode(param1,true);
            }
         }
      }
      
      private function onLeftUp(param1:MouseEvent) : void
      {
         leftPressed = false;
      }
      
      private function onRightDown(param1:MouseEvent) : void
      {
         rightPressed = true;
         param1.currentTarget.gotoAndStop("down");
         param1.stopImmediatePropagation();
      }
      
      private function setValue(param1:Number) : void
      {
      }
      
      private function onLeftDown(param1:MouseEvent) : void
      {
         leftPressed = true;
         param1.currentTarget.gotoAndStop("down");
         param1.stopImmediatePropagation();
      }
      
      public function setScrollStep(param1:Number) : void
      {
         this.step = param1;
      }
      
      private function onLeftFastDown(param1:MouseEvent) : void
      {
         leftPressed = true;
         scrollSpeedIncreaseTimer = SCROLL_SPEED_INCREASE_TIME * 3;
         scrollSpeedX = MAX_SCROLL_SPEED;
         param1.currentTarget.gotoAndStop("down");
         param1.stopImmediatePropagation();
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         focusX = -1;
         moveGesture = false;
         mouseHeld = true;
         prevScrollMouseX = mouseX;
         prevScrollMouseY = mouseY;
         prevScrollTime = getTimer();
         if(mouseParent)
         {
            mouseParent.addEventListener(MouseEvent.MOUSE_MOVE,onWorldMouseMove,false,0,true);
         }
         param1.stopImmediatePropagation();
      }
      
      private function getCurrentMaxScrollSpeed() : Number
      {
         return Math.min(MAX_SCROLL_SPEED,Math.floor(scrollSpeedIncreaseTimer / SCROLL_SPEED_INCREASE_TIME) * SCROLL_SPEED + SCROLL_SPEED);
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         mouseHeld = false;
         if(mouseParent)
         {
            mouseParent.removeEventListener(MouseEvent.MOUSE_MOVE,onWorldMouseMove);
         }
      }
      
      private function onRightFastDown(param1:MouseEvent) : void
      {
         rightPressed = true;
         scrollSpeedIncreaseTimer = SCROLL_SPEED_INCREASE_TIME * 3;
         scrollSpeedX = -MAX_SCROLL_SPEED;
         param1.currentTarget.gotoAndStop("down");
         param1.stopImmediatePropagation();
      }
      
      public function focus(param1:int, param2:Boolean = false) : void
      {
         if(param2)
         {
            panel.x = leftBound - param1;
            if(panel.x >= leftBound)
            {
               panel.x = leftBound;
            }
            else if(panel.x + totalWidth < leftBound + viewWidth)
            {
               panel.x = leftBound + viewWidth - totalWidth;
            }
         }
         else
         {
            focusX = param1;
         }
      }
      
      private function onWorldMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(scrollEnabled)
         {
            _loc2_ = getTimer() - prevScrollTime;
            prevScrollTime = getTimer();
            _loc3_ = mouseX - prevScrollMouseX;
            _loc4_ = mouseY - prevScrollMouseY;
            scrollSpeedX = Math.max(-2.4,Math.min(2.4,_loc3_ / _loc2_));
            panel.x += _loc3_;
            prevScrollMouseX = mouseX;
            if(Math.abs(_loc3_) >= 4 || Math.abs(_loc4_) >= 4)
            {
               moveGesture = true;
            }
         }
      }
      
      public function isScrolling() : Boolean
      {
         return Math.abs(scrollSpeedX) >= 1;
      }
      
      private function setupLeftButton(param1:MovieClip) : void
      {
         if(param1)
         {
            if(Math.floor(panel.x) >= Math.floor(leftBound))
            {
               if(param1.currentLabel != "disabled")
               {
                  setButtonMode(param1,false);
                  param1.gotoAndStop("disabled");
               }
            }
            else if(param1.currentLabel == "disabled")
            {
               setButtonMode(param1,true);
            }
         }
      }
      
      private function onRightUp(param1:MouseEvent) : void
      {
         rightPressed = false;
      }
   }
}

