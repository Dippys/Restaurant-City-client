package away3d.cameras.lenses
{
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.clip.*;
   import away3d.core.draw.*;
   import away3d.core.geom.*;
   import away3d.core.math.*;
   
   public class ZoomFocusLens extends AbstractLens implements ILens
   {
      
      private var _length:int;
      
      public function ZoomFocusLens()
      {
         super();
      }
      
      public function getFOV() : Number
      {
         return Math.atan2(_clipTop - _clipBottom,_camera.focus * _camera.zoom + _clipTop * _clipBottom) * toDEGREES;
      }
      
      override public function setView(param1:View3D) : void
      {
         super.setView(param1);
         if(_clipping.minZ == -Infinity)
         {
            _near = -_camera.focus / 2;
         }
         else
         {
            _near = _clipping.minZ;
         }
      }
      
      public function getZoom() : Number
      {
         return ((_clipTop - _clipBottom) / Math.tan(_camera.fov * toRADIANS) - _clipTop * _clipBottom) / _camera.focus;
      }
      
      public function getPerspective(param1:Number) : Number
      {
         return _camera.zoom / (1 + param1 / _camera.focus);
      }
      
      public function getFrustum(param1:Object3D, param2:Matrix3D) : Frustum
      {
         _frustum = _cameraVarsStore.createFrustum(param1);
         _focusOverZoom = _camera.focus / _camera.zoom;
         _zoom2 = _camera.zoom * _camera.zoom;
         _plane = _frustum.planes[Frustum.NEAR];
         _plane.a = 0;
         _plane.b = 0;
         _plane.c = 1;
         _plane.d = -_near;
         _plane.transform(param2);
         _plane = _frustum.planes[Frustum.FAR];
         _plane.a = 0;
         _plane.b = 0;
         _plane.c = -1;
         _plane.d = _far;
         _plane.transform(param2);
         _plane = _frustum.planes[Frustum.LEFT];
         _plane.a = -_clipHeight * _focusOverZoom;
         _plane.b = 0;
         _plane.c = _clipHeight * _clipLeft / _zoom2;
         _plane.d = _plane.c * _camera.focus;
         _plane.transform(param2);
         _plane = _frustum.planes[Frustum.RIGHT];
         _plane.a = _clipHeight * _focusOverZoom;
         _plane.b = 0;
         _plane.c = -_clipHeight * _clipRight / _zoom2;
         _plane.d = _plane.c * _camera.focus;
         _plane.transform(param2);
         _plane = _frustum.planes[Frustum.TOP];
         _plane.a = 0;
         _plane.b = -_clipWidth * _focusOverZoom;
         _plane.c = _clipWidth * _clipTop / _zoom2;
         _plane.d = _plane.c * _camera.focus;
         _plane.transform(param2);
         _plane = _frustum.planes[Frustum.BOTTOM];
         _plane.a = 0;
         _plane.b = _clipWidth * _focusOverZoom;
         _plane.c = -_clipWidth * _clipBottom / _zoom2;
         _plane.d = _plane.c * _camera.focus;
         _plane.transform(param2);
         return _frustum;
      }
      
      public function project(param1:Matrix3D, param2:Array, param3:Array) : void
      {
         _length = 0;
         for each(_vertex in param2)
         {
            _vx = _vertex.x;
            _vy = _vertex.y;
            _vz = _vertex.z;
            _sz = _vx * param1.szx + _vy * param1.szy + _vz * param1.szz + param1.tz;
            if(isNaN(_sz))
            {
               throw new Error("isNaN(sz)");
            }
            if(_sz < _near && _clipping is RectangleClipping)
            {
               param3[_length] = null;
               param3[_length + 1] = null;
               param3[_length + 2] = null;
               _length += 3;
            }
            else
            {
               _persp = _camera.zoom / (1 + _sz / _camera.focus);
               param3[_length] = (_vx * param1.sxx + _vy * param1.sxy + _vz * param1.sxz + param1.tx) * _persp;
               param3[_length + 1] = (_vx * param1.syx + _vy * param1.syy + _vz * param1.syz + param1.ty) * _persp;
               param3[_length + 2] = _sz;
               _length += 3;
            }
         }
      }
   }
}

