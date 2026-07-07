package away3d.core.project
{
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.draw.*;
   import away3d.core.math.*;
   import away3d.core.render.SpriteRenderSession;
   import away3d.core.utils.*;
   import flash.utils.*;
   
   public class ObjectContainerProjector implements IPrimitiveProvider
   {
      
      private var _vx:Number;
      
      private var _container:ObjectContainer3D;
      
      private var _vz:Number;
      
      private var _cameraViewMatrix:Matrix3D;
      
      private var _view:View3D;
      
      private var _depthPoint:Number3D = new Number3D();
      
      private var _vy:Number;
      
      private var _drawPrimitiveStore:DrawPrimitiveStore;
      
      private var _viewTransformDictionary:Dictionary;
      
      public function ObjectContainerProjector()
      {
         super();
      }
      
      public function get view() : View3D
      {
         return _view;
      }
      
      public function set view(param1:View3D) : void
      {
         _view = param1;
         _drawPrimitiveStore = view.drawPrimitiveStore;
      }
      
      public function primitives(param1:Object3D, param2:Matrix3D, param3:IPrimitiveConsumer) : void
      {
         var _loc5_:Object3D = null;
         _container = param1 as ObjectContainer3D;
         _cameraViewMatrix = _view.camera.viewMatrix;
         _viewTransformDictionary = _view.cameraVarsStore.viewTransformDictionary;
         var _loc4_:Array = _container.children;
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.ownCanvas && _loc5_.visible)
            {
               if(_loc5_.ownSession is SpriteRenderSession)
               {
                  (_loc5_.ownSession as SpriteRenderSession).cacheAsBitmap = true;
               }
               _vx = _loc5_.screenXOffset;
               _vy = _loc5_.screenYOffset;
               if(!isNaN(_loc5_.ownSession.screenZ))
               {
                  _vz = _loc5_.ownSession.screenZ;
               }
               else
               {
                  if(_loc5_.scenePivotPoint.modulo)
                  {
                     _depthPoint.clone(_loc5_.scenePivotPoint);
                     _depthPoint.rotate(_depthPoint,_cameraViewMatrix);
                     _depthPoint.add(_viewTransformDictionary[_loc5_].position,_depthPoint);
                     _vz = _depthPoint.modulo;
                  }
                  else
                  {
                     _vz = _viewTransformDictionary[_loc5_].position.modulo;
                  }
                  if(_loc5_.pushback)
                  {
                     _vz += _loc5_.parentBoundingRadius;
                  }
                  if(_loc5_.pushfront)
                  {
                     _vz -= _loc5_.parentBoundingRadius;
                  }
                  _vz += _loc5_.screenZOffset;
               }
               param3.primitive(_drawPrimitiveStore.createDrawDisplayObject(param1,_vx,_vy,_vz,_container.session,_loc5_.session.getContainer(view)));
            }
         }
      }
   }
}

