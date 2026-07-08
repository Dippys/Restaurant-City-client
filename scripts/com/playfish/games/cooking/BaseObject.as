package com.playfish.games.cooking
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Matrix;
   import flash.text.*;
   import flash.utils.*;
   
   public dynamic class BaseObject extends Sprite
   {
      
      public static const ALIGN_LEFT:int = 1 << 0;
      
      public static const ALIGN_RIGHT:int = 1 << 1;
      
      public static const ALIGN_HCENTER:int = 1 << 2;
      
      public static const ALIGN_TOP:int = 1 << 3;
      
      public static const ALIGN_BOTTOM:int = 1 << 4;
      
      public static const ALIGN_VCENTER:int = 1 << 5;
      
      public static const FLIP_HORIZONTAL:int = 1;
      
      public static const FLIP_VERTICAL:int = 2;
      
      public var baseObjects:Array = new Array();
      
      public var newObjects:Array = new Array();
      
      private var _drawPriority:int = 0;
      
      protected var content:MovieClip;
      
      public function BaseObject(param1:String = null)
      {
         super();
         if(param1 != null)
         {
            content = Engine.getMovieClip(param1);
            if(content != null)
            {
               addChild(content);
            }
         }
      }
      
      public function addObject(param1:BaseObject) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 != null)
         {
            if(newObjects.indexOf(param1) == -1)
            {
               if(param1.parent != null && param1.parent is BaseObject)
               {
                  BaseObject(param1.parent).removeObject(param1);
               }
               _loc2_ = false;
               _loc3_ = 0;
               while(_loc3_ < newObjects.length)
               {
                  if(param1.drawPriority < newObjects[_loc3_].drawPriority)
                  {
                     _loc4_ = getTimer();
                     addChildAt(param1,getChildIndex(newObjects[_loc3_]));
                     PerfTrace.slow("BaseObject.addObject addChildAt " + param1,_loc4_,5);
                     newObjects.splice(_loc3_,0,param1);
                     _loc2_ = true;
                     break;
                  }
                  _loc3_++;
               }
               if(!_loc2_)
               {
                  newObjects.push(param1);
                  _loc4_ = getTimer();
                  addChild(param1);
                  PerfTrace.slow("BaseObject.addObject addChild " + param1,_loc4_,5);
               }
            }
         }
      }
      
      private function buttonUpListener(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         buttonGotoAndStop(_loc2_,"over");
      }
      
      public function stop() : void
      {
         if(content != null)
         {
            content.stop();
         }
      }
      
      public function get drawPriority() : int
      {
         return _drawPriority;
      }
      
      private function buttonOverListener(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         buttonGotoAndStop(_loc2_,"over");
      }
      
      public function setAlignPosition(param1:Number, param2:Number, param3:int = 0) : void
      {
         if((param3 & ALIGN_RIGHT) != 0)
         {
            x = param1 - width;
         }
         else if((param3 & ALIGN_HCENTER) != 0)
         {
            x = param1 - width / 2;
         }
         else
         {
            x = param1;
         }
         if((param3 & ALIGN_BOTTOM) != 0)
         {
            y = param2 - height;
         }
         else if((param3 & ALIGN_VCENTER) != 0)
         {
            y = param2 - height / 2;
         }
         else
         {
            y = param2;
         }
      }
      
      public function getChildMovieClipInstance(param1:String) : MovieClip
      {
         if(content != null)
         {
            return MovieClip(content[param1]);
         }
         return null;
      }
      
      public function set drawPriority(param1:int) : void
      {
         if(_drawPriority != param1)
         {
            _drawPriority = param1;
            if(parent != null && parent is BaseObject)
            {
               BaseObject(parent).reinsert(this);
            }
         }
      }
      
      public function manipulate(param1:int) : void
      {
         var _loc2_:Matrix = null;
         if(param1 == 0)
         {
            _loc2_ = this.transform.matrix;
            _loc2_.a = 1;
            _loc2_.d = 1;
            this.transform.matrix = _loc2_;
         }
         else if(param1 == FLIP_HORIZONTAL)
         {
            if(scaleX > 0)
            {
               scaleX = -scaleX;
            }
         }
         else if(param1 == FLIP_VERTICAL)
         {
            if(scaleY > 0)
            {
               scaleY = -scaleY;
            }
         }
      }
      
      public function setButtonSequence(param1:MovieClip, param2:String) : void
      {
         param1["buttonSequence"] = param2;
      }
      
      private function buttonGotoAndStop(param1:MovieClip, param2:String) : Boolean
      {
         if(param1 == null || param1["buttonFramesMissing"])
         {
            return false;
         }
         try
         {
            param1.gotoAndStop(param2 + param1["buttonSequence"]);
         }
         catch(e:ArgumentError)
         {
            param1["buttonFramesMissing"] = true;
            return false;
         }
         return true;
      }
      
      private function buttonDownListener(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         buttonGotoAndStop(_loc2_,"down");
      }
      
      public function getContentMC() : MovieClip
      {
         return content;
      }
      
      public function addAndRemoveObjects() : void
      {
         if(baseObjects.length > newObjects.length)
         {
            baseObjects.splice(newObjects.length,baseObjects.length - newObjects.length);
         }
         var _loc1_:int = 0;
         var _loc2_:int = int(newObjects.length);
         while(_loc1_ < _loc2_)
         {
            baseObjects[_loc1_] = newObjects[_loc1_];
            _loc1_++;
         }
      }
      
      public function tickBase(param1:uint) : void
      {
         var _loc4_:BaseObject = null;
         var _loc2_:int = 0;
         var _loc3_:int = int(baseObjects.length);
         while(_loc2_ < _loc3_)
         {
            _loc4_ = baseObjects[_loc2_];
            if(newObjects.indexOf(_loc4_) != -1)
            {
               _loc4_.tickBase(param1);
            }
            _loc2_++;
         }
         tick(param1);
         addAndRemoveObjects();
      }
      
      private function buttonOutListener(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         buttonGotoAndStop(_loc2_,"up");
      }
      
      public function removeObject(param1:BaseObject) : void
      {
         var _loc2_:int = 0;
         if(param1 != null)
         {
            _loc2_ = newObjects.indexOf(param1);
            if(_loc2_ != -1)
            {
               newObjects.splice(_loc2_,1);
               if(param1.parent != null && param1.parent == this)
               {
                  removeChild(param1);
               }
            }
         }
      }
      
      public function tick(param1:uint) : void
      {
      }
      
      public function notifyLanguageUpdate() : void
      {
      }
      
      private function reinsert(param1:BaseObject) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1.parent == this)
         {
            _loc2_ = newObjects.indexOf(param1);
            if(_loc2_ != -1)
            {
               removeChild(param1);
               newObjects.splice(_loc2_,1);
               _loc3_ = 0;
               while(_loc3_ < newObjects.length)
               {
                  if(param1.drawPriority < newObjects[_loc3_].drawPriority && contains(newObjects[_loc3_]))
                  {
                     addChildAt(param1,getChildIndex(newObjects[_loc3_]));
                     newObjects.splice(_loc3_,0,param1);
                     break;
                  }
                  _loc3_++;
               }
               if(_loc3_ >= newObjects.length)
               {
                  newObjects.push(param1);
                  addChild(param1);
               }
            }
         }
      }
      
      public function setHandCursor(param1:MovieClip, param2:Boolean, param3:Boolean = false) : MovieClip
      {
         if(param1)
         {
            param1.useHandCursor = param2;
            param1.mouseChildren = param3;
         }
         return param1;
      }
      
      public function setButtonMode(param1:MovieClip, param2:Boolean, param3:String = "") : void
      {
         if(param1 != null)
         {
            setButtonSequence(param1,param3);
            buttonGotoAndStop(param1,"up");
            if(param2)
            {
               param1.buttonMode = true;
               param1.addEventListener(MouseEvent.MOUSE_UP,buttonUpListener,false,0,true);
               param1.addEventListener(MouseEvent.MOUSE_DOWN,buttonDownListener,false,0,true);
               param1.addEventListener(MouseEvent.ROLL_OVER,buttonOverListener,false,0,true);
               param1.addEventListener(MouseEvent.ROLL_OUT,buttonOutListener,false,0,true);
               param1.addEventListener(MouseEvent.MOUSE_OVER,buttonOverListener,false,0,true);
               param1.addEventListener(MouseEvent.MOUSE_OUT,buttonOutListener,false,0,true);
            }
            else
            {
               param1.buttonMode = false;
               param1.removeEventListener(MouseEvent.MOUSE_UP,buttonUpListener);
               param1.removeEventListener(MouseEvent.MOUSE_DOWN,buttonDownListener);
               param1.removeEventListener(MouseEvent.ROLL_OVER,buttonOverListener);
               param1.removeEventListener(MouseEvent.ROLL_OUT,buttonOutListener);
               param1.removeEventListener(MouseEvent.MOUSE_OVER,buttonOverListener);
               param1.removeEventListener(MouseEvent.MOUSE_OUT,buttonOutListener);
               param1.removeEventListener(MouseEvent.MOUSE_OUT,buttonOutListener);
               setButtonSequence(param1,null);
            }
         }
      }
      
      public function destroy() : void
      {
      }
      
      public function getChildTextFieldInstance(param1:String) : TextField
      {
         if(content != null)
         {
            return TextField(content[param1]);
         }
         return null;
      }
   }
}

