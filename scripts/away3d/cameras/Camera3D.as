package away3d.cameras
{
   import away3d.cameras.lenses.*;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.clip.*;
   import away3d.core.draw.*;
   import away3d.core.math.*;
   import away3d.core.utils.*;
   import away3d.events.CameraEvent;
   
   public class Camera3D extends Object3D
   {
      
      private var _view:View3D;
      
      private var _flipY:Matrix3D = new Matrix3D();
      
      private var _fov:Number = 0;
      
      public var invViewMatrix:Matrix3D = new Matrix3D();
      
      private var _screenIndexStart:int;
      
      private var _clipping:Clipping;
      
      private var _screenVertices:Array = new Array();
      
      private var _clipTop:Number;
      
      private var _clipRight:Number;
      
      private var _cameraVarsStore:CameraVarsStore;
      
      private var _zoom:Number = 10;
      
      protected const toDEGREES:Number = 57.29577951308232;
      
      private var _clipBottom:Number;
      
      private var _drawPrimitiveStore:DrawPrimitiveStore;
      
      private var _zoomDirty:Boolean;
      
      public var maxblur:Number = 150;
      
      private var _clipLeft:Number;
      
      private var _vertices:Array = new Array();
      
      private var _focus:Number;
      
      private var _lens:ILens;
      
      private var _fovDirty:Boolean;
      
      private var _viewMatrix:Matrix3D = new Matrix3D();
      
      public var fixedZoom:Boolean;
      
      public var doflevels:Number = 16;
      
      private var _aperture:Number = 22;
      
      protected const toRADIANS:Number = 0.017453292519943295;
      
      private var _dof:Boolean = false;
      
      private var _cameraupdated:CameraEvent;
      
      public function Camera3D(param1:Object = null)
      {
         super(param1);
         fov = ini.getNumber("fov",_fov);
         focus = ini.getNumber("focus",100);
         zoom = ini.getNumber("zoom",_zoom);
         fixedZoom = ini.getBoolean("fixedZoom",true);
         lens = ini.getObject("lens",AbstractLens) as ILens || new ZoomFocusLens();
         aperture = ini.getNumber("aperture",22);
         maxblur = ini.getNumber("maxblur",150);
         doflevels = ini.getNumber("doflevels",16);
         dof = ini.getBoolean("dof",false);
         var _loc2_:Number3D = ini.getPosition("lookat");
         _flipY.syy = -1;
         if(_loc2_)
         {
            lookAt(_loc2_);
         }
      }
      
      public function unproject(param1:Number, param2:Number) : Number3D
      {
         var _loc3_:Number = focus * zoom / focus;
         var _loc4_:Number3D = new Number3D(param1 / _loc3_,-param2 / _loc3_,focus);
         transform.multiplyVector3x3(_loc4_);
         return _loc4_;
      }
      
      public function set lens(param1:ILens) : void
      {
         if(_lens == param1)
         {
            return;
         }
         _lens = param1;
         notifyCameraUpdate();
      }
      
      public function get lens() : ILens
      {
         return _lens;
      }
      
      public function get aperture() : Number
      {
         return _aperture;
      }
      
      public function pan(param1:Number) : void
      {
         super.yaw(param1);
      }
      
      public function set aperture(param1:Number) : void
      {
         _aperture = param1;
         DofCache.aperture = _aperture;
      }
      
      public function get view() : View3D
      {
         return _view;
      }
      
      public function set fov(param1:Number) : void
      {
         if(_fov == param1)
         {
            return;
         }
         _fov = param1;
         _fovDirty = false;
         _zoomDirty = true;
         notifyCameraUpdate();
      }
      
      public function set zoom(param1:Number) : void
      {
         if(_zoom == param1)
         {
            return;
         }
         _zoom = param1;
         _zoomDirty = false;
         _fovDirty = true;
         notifyCameraUpdate();
      }
      
      private function notifyCameraUpdate() : void
      {
         if(!hasEventListener(CameraEvent.CAMERA_UPDATED))
         {
            return;
         }
         if(_cameraupdated == null)
         {
            _cameraupdated = new CameraEvent(CameraEvent.CAMERA_UPDATED,this);
         }
         dispatchEvent(_cameraupdated);
      }
      
      public function enableDof() : void
      {
         DofCache.doflevels = doflevels;
         DofCache.aperture = aperture;
         DofCache.maxblur = maxblur;
         DofCache.focus = focus;
         DofCache.resetDof(true);
      }
      
      public function get dof() : Boolean
      {
         return _dof;
      }
      
      public function set focus(param1:Number) : void
      {
         _focus = param1;
         DofCache.focus = _focus;
         notifyCameraUpdate();
      }
      
      public function tilt(param1:Number) : void
      {
         super.pitch(param1);
      }
      
      public function get viewMatrix() : Matrix3D
      {
         invViewMatrix.multiply(sceneTransform,_flipY);
         _viewMatrix.inverse(invViewMatrix);
         return _viewMatrix;
      }
      
      public function update() : void
      {
         _view.updateScreenClipping();
         _clipping = _view.screenClipping;
         if(_clipTop != _clipping.maxY || _clipBottom != _clipping.minY || _clipLeft != _clipping.minX || _clipRight != _clipping.maxX)
         {
            if(!_fovDirty && !_zoomDirty)
            {
               if(fixedZoom)
               {
                  _fovDirty = true;
               }
               else
               {
                  _zoomDirty = true;
               }
            }
            _clipTop = _clipping.maxY;
            _clipBottom = _clipping.minY;
            _clipLeft = _clipping.minX;
            _clipRight = _clipping.maxX;
         }
         lens.setView(_view);
         if(_fovDirty)
         {
            _fovDirty = false;
            _fov = lens.getFOV();
         }
         if(_zoomDirty)
         {
            _zoomDirty = false;
            _zoom = lens.getZoom();
         }
      }
      
      public function get fov() : Number
      {
         return _fov;
      }
      
      public function set view(param1:View3D) : void
      {
         if(_view == param1)
         {
            return;
         }
         _view = param1;
         _drawPrimitiveStore = param1.drawPrimitiveStore;
         _cameraVarsStore = param1.cameraVarsStore;
      }
      
      public function get zoom() : Number
      {
         return _zoom;
      }
      
      public function disableDof() : void
      {
         DofCache.resetDof(false);
      }
      
      public function addOnCameraUpdate(param1:Function) : void
      {
         addEventListener(CameraEvent.CAMERA_UPDATED,param1,false,0,false);
      }
      
      public function screen(param1:Object3D, param2:Vertex = null) : ScreenVertex
      {
         if(param2 == null)
         {
            _vertices = param1.center;
         }
         else
         {
            _vertices[0] = param2;
         }
         _cameraVarsStore.createViewTransform(param1).multiply(viewMatrix,param1.sceneTransform);
         _screenVertices.length = 0;
         _lens.project(_cameraVarsStore.viewTransformDictionary[param1],_vertices,_screenVertices);
         return new ScreenVertex(_screenVertices[0],_screenVertices[1],_screenVertices[2]);
      }
      
      public function get focus() : Number
      {
         return _focus;
      }
      
      public function removeOnCameraUpdate(param1:Function) : void
      {
         removeEventListener(CameraEvent.CAMERA_UPDATED,param1,false);
      }
      
      public function set dof(param1:Boolean) : void
      {
         _dof = param1;
         if(_dof)
         {
            enableDof();
         }
         else
         {
            disableDof();
         }
      }
      
      override public function clone(param1:Object3D = null) : Object3D
      {
         var _loc2_:Camera3D = param1 as Camera3D || new Camera3D();
         super.clone(_loc2_);
         _loc2_.zoom = zoom;
         _loc2_.focus = focus;
         _loc2_.lens = lens;
         return _loc2_;
      }
   }
}

