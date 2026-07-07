package away3d.cameras.lenses
{
   import away3d.cameras.Camera3D;
   import away3d.containers.View3D;
   import away3d.core.base.Vertex;
   import away3d.core.clip.Clipping;
   import away3d.core.geom.Frustum;
   import away3d.core.geom.Plane3D;
   import away3d.core.math.Matrix3D;
   import away3d.core.utils.CameraVarsStore;
   import away3d.core.utils.DrawPrimitiveStore;
   
   public class AbstractLens
   {
      
      protected var _sw:Number;
      
      protected var _view:View3D;
      
      protected var _sy:Number;
      
      protected var _sx:Number;
      
      protected var _sz:Number;
      
      protected var _near:Number;
      
      protected var _clipping:Clipping;
      
      protected var _frustum:Frustum;
      
      protected var view:Matrix3D = new Matrix3D();
      
      protected var _clipTop:Number;
      
      protected var _clipRight:Number;
      
      protected var _cameraVarsStore:CameraVarsStore;
      
      protected const toDEGREES:Number = 57.29577951308232;
      
      protected var _clipHeight:Number;
      
      protected var _drawPrimitiveStore:DrawPrimitiveStore;
      
      protected var _focusOverZoom:Number;
      
      protected var _clipBottom:Number;
      
      protected var _vertex:Vertex;
      
      protected var _camera:Camera3D;
      
      protected var _zoom2:Number;
      
      protected var _persp:Number;
      
      protected var viewTransform:Matrix3D;
      
      protected var _clipLeft:Number;
      
      protected var _clipWidth:Number;
      
      protected var _plane:Plane3D;
      
      protected var _far:Number;
      
      protected var _vx:Number;
      
      protected var _vz:Number;
      
      protected var _len:Number;
      
      protected var classification:int;
      
      protected var _vy:Number;
      
      protected var _scz:Number;
      
      protected const toRADIANS:Number = 0.017453292519943295;
      
      public function AbstractLens()
      {
         super();
      }
      
      public function setView(param1:View3D) : void
      {
         _view = param1;
         _drawPrimitiveStore = param1.drawPrimitiveStore;
         _cameraVarsStore = param1.cameraVarsStore;
         _camera = param1.camera;
         _clipping = param1.screenClipping;
         _clipTop = _clipping.maxY;
         _clipBottom = _clipping.minY;
         _clipLeft = _clipping.minX;
         _clipRight = _clipping.maxX;
         _clipHeight = _clipBottom - _clipTop;
         _clipWidth = _clipRight - _clipLeft;
         _far = _clipping.maxZ;
      }
      
      public function get near() : Number
      {
         return _near;
      }
      
      public function get far() : Number
      {
         return _far;
      }
   }
}

