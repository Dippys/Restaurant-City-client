package away3d.core.clip
{
   import away3d.arcane;
   import away3d.containers.View3D;
   import away3d.core.base.Mesh;
   import away3d.core.draw.DrawPrimitive;
   import away3d.core.utils.CameraVarsStore;
   import away3d.core.utils.Init;
   import away3d.events.ClippingEvent;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   use namespace arcane;
   
   public class Clipping extends EventDispatcher
   {
      
      private var _view:View3D;
      
      private var _maX:Number;
      
      private var _stageHeight:Number;
      
      private var _stageWidth:Number;
      
      private var _maY:Number;
      
      private var _minY:Number;
      
      private var _minZ:Number;
      
      private var _minX:Number;
      
      arcane var _cameraVarsStore:CameraVarsStore;
      
      private var _clippingClone:Clipping;
      
      private var _zeroPoint:Point = new Point(0,0);
      
      private var _screenupdated:ClippingEvent;
      
      private var _maxX:Number;
      
      private var _maxY:Number;
      
      private var _maxZ:Number;
      
      protected var ini:Init;
      
      private var _globalPoint:Point;
      
      arcane var _objectCulling:Boolean;
      
      private var _clippingupdated:ClippingEvent;
      
      private var _miX:Number;
      
      private var _miY:Number;
      
      private var _stage:Stage;
      
      public function Clipping(param1:Object = null)
      {
         super();
         ini = Init.parse(param1) as Init;
         minX = ini.getNumber("minX",-Infinity);
         minY = ini.getNumber("minY",-Infinity);
         minZ = ini.getNumber("minZ",-Infinity);
         maxX = ini.getNumber("maxX",Infinity);
         maxY = ini.getNumber("maxY",Infinity);
         maxZ = ini.getNumber("maxZ",Infinity);
      }
      
      public function set minZ(param1:Number) : void
      {
         if(_minZ == param1)
         {
            return;
         }
         _minZ = param1;
         notifyClippingUpdate();
      }
      
      public function set minY(param1:Number) : void
      {
         if(_minY == param1)
         {
            return;
         }
         _minY = param1;
         notifyClippingUpdate();
      }
      
      public function screen(param1:Sprite, param2:Number, param3:Number) : Clipping
      {
         if(!_clippingClone)
         {
            _clippingClone = clone();
            _clippingClone.addOnClippingUpdate(onScreenUpdate);
         }
         _stage = param1.stage;
         if(_stage.scaleMode == StageScaleMode.NO_SCALE)
         {
            _stageWidth = _stage.stageWidth;
            _stageHeight = _stage.stageHeight;
         }
         else if(_stage.scaleMode == StageScaleMode.EXACT_FIT)
         {
            _stageWidth = param2;
            _stageHeight = param3;
         }
         else if(_stage.scaleMode == StageScaleMode.SHOW_ALL)
         {
            if(_stage.stageWidth / param2 < _stage.stageHeight / param3)
            {
               _stageWidth = param2;
               _stageHeight = _stage.stageHeight * _stageWidth / _stage.stageWidth;
            }
            else
            {
               _stageHeight = param3;
               _stageWidth = _stage.stageWidth * _stageHeight / _stage.stageHeight;
            }
         }
         else if(_stage.scaleMode == StageScaleMode.NO_BORDER)
         {
            if(_stage.stageWidth / param2 > _stage.stageHeight / param3)
            {
               _stageWidth = param2;
               _stageHeight = _stage.stageHeight * _stageWidth / _stage.stageWidth;
            }
            else
            {
               _stageHeight = param3;
               _stageWidth = _stage.stageWidth * _stageHeight / _stage.stageHeight;
            }
         }
         if(_stage.align == StageAlign.TOP_LEFT)
         {
            _zeroPoint.x = 0;
            _zeroPoint.y = 0;
            _globalPoint = param1.globalToLocal(_zeroPoint);
            _maX = (_miX = _globalPoint.x) + _stageWidth;
            _maY = (_miY = _globalPoint.y) + _stageHeight;
         }
         else if(_stage.align == StageAlign.TOP_RIGHT)
         {
            _zeroPoint.x = param2;
            _zeroPoint.y = 0;
            _globalPoint = param1.globalToLocal(_zeroPoint);
            _miX = (_maX = _globalPoint.x) - _stageWidth;
            _maY = (_miY = _globalPoint.y) + _stageHeight;
         }
         else if(_stage.align == StageAlign.BOTTOM_LEFT)
         {
            _zeroPoint.x = 0;
            _zeroPoint.y = param3;
            _globalPoint = param1.globalToLocal(_zeroPoint);
            _maX = (_miX = _globalPoint.x) + _stageWidth;
            _miY = (_maY = _globalPoint.y) - _stageHeight;
         }
         else if(_stage.align == StageAlign.BOTTOM_RIGHT)
         {
            _zeroPoint.x = param2;
            _zeroPoint.y = param3;
            _globalPoint = param1.globalToLocal(_zeroPoint);
            _miX = (_maX = _globalPoint.x) - _stageWidth;
            _miY = (_maY = _globalPoint.y) - _stageHeight;
         }
         else if(_stage.align == StageAlign.TOP)
         {
            _zeroPoint.x = param2 / 2;
            _zeroPoint.y = 0;
            _globalPoint = param1.globalToLocal(_zeroPoint);
            _miX = _globalPoint.x - _stageWidth / 2;
            _maX = _globalPoint.x + _stageWidth / 2;
            _maY = (_miY = _globalPoint.y) + _stageHeight;
         }
         else if(_stage.align == StageAlign.BOTTOM)
         {
            _zeroPoint.x = param2 / 2;
            _zeroPoint.y = param3;
            _globalPoint = param1.globalToLocal(_zeroPoint);
            _miX = _globalPoint.x - _stageWidth / 2;
            _maX = _globalPoint.x + _stageWidth / 2;
            _miY = (_maY = _globalPoint.y) - _stageHeight;
         }
         else if(_stage.align == StageAlign.LEFT)
         {
            _zeroPoint.x = 0;
            _zeroPoint.y = param3 / 2;
            _globalPoint = param1.globalToLocal(_zeroPoint);
            _maX = (_miX = _globalPoint.x) + _stageWidth;
            _miY = _globalPoint.y - _stageHeight / 2;
            _maY = _globalPoint.y + _stageHeight / 2;
         }
         else if(_stage.align == StageAlign.RIGHT)
         {
            _zeroPoint.x = param2;
            _zeroPoint.y = param3 / 2;
            _globalPoint = param1.globalToLocal(_zeroPoint);
            _miX = (_maX = _globalPoint.x) - _stageWidth;
            _miY = _globalPoint.y - _stageHeight / 2;
            _maY = _globalPoint.y + _stageHeight / 2;
         }
         else
         {
            _zeroPoint.x = param2 / 2;
            _zeroPoint.y = param3 / 2;
            _globalPoint = param1.globalToLocal(_zeroPoint);
            _miX = _globalPoint.x - _stageWidth / 2;
            _maX = _globalPoint.x + _stageWidth / 2;
            _miY = _globalPoint.y - _stageHeight / 2;
            _maY = _globalPoint.y + _stageHeight / 2;
         }
         if(_minX > _miX)
         {
            _clippingClone.minX = _minX;
         }
         else
         {
            _clippingClone.minX = _miX;
         }
         if(_maxX < _maX)
         {
            _clippingClone.maxX = _maxX;
         }
         else
         {
            _clippingClone.maxX = _maX;
         }
         if(_minY > _miY)
         {
            _clippingClone.minY = _minY;
         }
         else
         {
            _clippingClone.minY = _miY;
         }
         if(_maxY < _maY)
         {
            _clippingClone.maxY = _maxY;
         }
         else
         {
            _clippingClone.maxY = _maY;
         }
         _clippingClone.minZ = _minZ;
         _clippingClone.maxZ = _maxZ;
         _clippingClone.objectCulling = _objectCulling;
         return _clippingClone;
      }
      
      public function removeOnScreenUpdate(param1:Function) : void
      {
         removeEventListener(ClippingEvent.SCREEN_UPDATED,param1,false);
      }
      
      public function set minX(param1:Number) : void
      {
         if(_minX == param1)
         {
            return;
         }
         _minX = param1;
         notifyClippingUpdate();
      }
      
      public function removeOnClippingUpdate(param1:Function) : void
      {
         removeEventListener(ClippingEvent.CLIPPING_UPDATED,param1,false);
      }
      
      public function checkElements(param1:Mesh, param2:Array, param3:Array, param4:Array, param5:Array, param6:Array, param7:Array, param8:Array) : void
      {
         throw new Error("Not implemented");
      }
      
      public function get view() : View3D
      {
         return _view;
      }
      
      public function addOnClippingUpdate(param1:Function) : void
      {
         addEventListener(ClippingEvent.CLIPPING_UPDATED,param1,false,0,false);
      }
      
      override public function toString() : String
      {
         return "{minX:" + minX + " maxX:" + maxX + " minY:" + minY + " maxY:" + maxY + " minZ:" + minZ + " maxZ:" + maxZ + "}";
      }
      
      private function notifyScreenUpdate() : void
      {
         if(!hasEventListener(ClippingEvent.SCREEN_UPDATED))
         {
            return;
         }
         if(_screenupdated == null)
         {
            _screenupdated = new ClippingEvent(ClippingEvent.SCREEN_UPDATED,this);
         }
         dispatchEvent(_screenupdated);
      }
      
      public function checkPrimitive(param1:DrawPrimitive) : Boolean
      {
         return true;
      }
      
      public function get minX() : Number
      {
         return _minX;
      }
      
      public function get minY() : Number
      {
         return _minY;
      }
      
      public function get minZ() : Number
      {
         return _minZ;
      }
      
      public function set view(param1:View3D) : void
      {
         _view = param1;
         _cameraVarsStore = view.cameraVarsStore;
      }
      
      private function onScreenUpdate(param1:ClippingEvent) : void
      {
         notifyScreenUpdate();
      }
      
      public function clone(param1:Clipping = null) : Clipping
      {
         var _loc2_:Clipping = param1 || new Clipping();
         _loc2_.minX = minX;
         _loc2_.minY = minY;
         _loc2_.minZ = minZ;
         _loc2_.maxX = maxX;
         _loc2_.maxY = maxY;
         _loc2_.maxZ = maxZ;
         _loc2_.objectCulling = objectCulling;
         _loc2_._cameraVarsStore = _cameraVarsStore;
         return _loc2_;
      }
      
      private function notifyClippingUpdate() : void
      {
         if(!hasEventListener(ClippingEvent.CLIPPING_UPDATED))
         {
            return;
         }
         if(_clippingupdated == null)
         {
            _clippingupdated = new ClippingEvent(ClippingEvent.CLIPPING_UPDATED,this);
         }
         dispatchEvent(_clippingupdated);
      }
      
      public function set maxX(param1:Number) : void
      {
         if(_maxX == param1)
         {
            return;
         }
         _maxX = param1;
         notifyClippingUpdate();
      }
      
      public function set objectCulling(param1:Boolean) : void
      {
         _objectCulling = param1;
      }
      
      public function set maxY(param1:Number) : void
      {
         if(_maxY == param1)
         {
            return;
         }
         _maxY = param1;
         notifyClippingUpdate();
      }
      
      public function set maxZ(param1:Number) : void
      {
         if(_maxZ == param1)
         {
            return;
         }
         _maxZ = param1;
         notifyClippingUpdate();
      }
      
      public function addOnScreenUpdate(param1:Function) : void
      {
         addEventListener(ClippingEvent.SCREEN_UPDATED,param1,false,0,false);
      }
      
      public function get objectCulling() : Boolean
      {
         return _objectCulling;
      }
      
      public function rect(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
      {
         if(this.maxX < param1)
         {
            return false;
         }
         if(this.minX > param3)
         {
            return false;
         }
         if(this.maxY < param2)
         {
            return false;
         }
         if(this.minY > param4)
         {
            return false;
         }
         return true;
      }
      
      public function get maxY() : Number
      {
         return _maxY;
      }
      
      public function get maxZ() : Number
      {
         return _maxZ;
      }
      
      public function get maxX() : Number
      {
         return _maxX;
      }
   }
}

