package away3d.core.traverse
{
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.clip.*;
   import away3d.core.draw.*;
   import away3d.core.geom.Frustum;
   import away3d.core.light.*;
   import away3d.core.math.*;
   import away3d.core.project.*;
   import away3d.core.render.*;
   import away3d.core.utils.*;
   import away3d.materials.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class PrimitiveTraverser extends Traverser
   {
      
      private var _view:View3D;
      
      private var _viewTransform:Matrix3D;
      
      private var _consumer:IPrimitiveConsumer;
      
      private var _light:ILightProvider;
      
      private var _mouseEnableds:Array = new Array();
      
      private var _clipping:Clipping;
      
      private var _nodeClassification:int;
      
      private var _cameraVarsStore:CameraVarsStore;
      
      private var _projectorDictionary:Dictionary = new Dictionary(true);
      
      private var _mouseEnabled:Boolean;
      
      public function PrimitiveTraverser()
      {
         super();
      }
      
      override public function match(param1:Object3D) : Boolean
      {
         _clipping = _view.clipping;
         if(!param1.visible || _clipping.objectCulling && !_cameraVarsStore.nodeClassificationDictionary[param1])
         {
            return false;
         }
         if(param1 is ILODObject)
         {
            return (param1 as ILODObject).matchLOD(_view.camera);
         }
         return true;
      }
      
      public function set view(param1:View3D) : void
      {
         _view = param1;
         _mouseEnabled = true;
         _mouseEnableds.length = 0;
         _cameraVarsStore = _view.cameraVarsStore;
         _projectorDictionary[ProjectorType.CONVEX_BLOCK] = _view._convexBlockProjector;
         _projectorDictionary[ProjectorType.DIR_SPRITE] = _view._dirSpriteProjector;
         _projectorDictionary[ProjectorType.DOF_SPRITE] = _view._dofSpriteProjector;
         _projectorDictionary[ProjectorType.MESH] = _view._meshProjector;
         _projectorDictionary[ProjectorType.MOVIE_CLIP_SPRITE] = _view._movieClipSpriteProjector;
         _projectorDictionary[ProjectorType.OBJECT_CONTAINER] = _view._objectContainerProjector;
         _projectorDictionary[ProjectorType.SPRITE] = _view._spriteProjector;
      }
      
      override public function enter(param1:Object3D) : void
      {
         _mouseEnableds.push(_mouseEnabled);
      }
      
      public function get view() : View3D
      {
         return _view;
      }
      
      override public function apply(param1:Object3D) : void
      {
         if(param1.session.updated)
         {
            _viewTransform = _cameraVarsStore.viewTransformDictionary[param1];
            _consumer = param1.session.getConsumer(_view);
            if(param1.projectorType)
            {
               (_projectorDictionary[param1.projectorType] as IPrimitiveProvider).primitives(param1,_viewTransform,_consumer);
            }
            if(param1.debugbb && param1.debugBoundingBox.visible)
            {
               param1.debugBoundingBox._session = param1.session;
               if(_clipping.objectCulling)
               {
                  _cameraVarsStore.frustumDictionary[param1.debugBoundingBox] = _cameraVarsStore.frustumDictionary[param1];
                  _nodeClassification = _cameraVarsStore.nodeClassificationDictionary[param1];
                  if(_nodeClassification == Frustum.INTERSECT)
                  {
                     (param1.debugBoundingBox.material as WireframeMaterial).color = 16711680;
                  }
                  else
                  {
                     (param1.debugBoundingBox.material as WireframeMaterial).color = 3355443;
                  }
               }
               _view._meshProjector.primitives(param1.debugBoundingBox,_viewTransform,_consumer);
            }
            if(param1.debugbs && param1.debugBoundingSphere.visible)
            {
               param1.debugBoundingSphere._session = param1.session;
               if(_clipping.objectCulling)
               {
                  _cameraVarsStore.frustumDictionary[param1.debugBoundingSphere] = _cameraVarsStore.frustumDictionary[param1];
                  _nodeClassification = _cameraVarsStore.nodeClassificationDictionary[param1];
                  if(_nodeClassification == Frustum.INTERSECT)
                  {
                     (param1.debugBoundingSphere.material as WireframeMaterial).color = 16711680;
                  }
                  else
                  {
                     (param1.debugBoundingSphere.material as WireframeMaterial).color = 65535;
                  }
               }
               _view._meshProjector.primitives(param1.debugBoundingSphere,_viewTransform,_consumer);
            }
            if(param1 is ILightProvider)
            {
               _light = param1 as ILightProvider;
               if(_light.debug)
               {
                  _light.debugPrimitive._session = param1.session;
                  if(_clipping.objectCulling)
                  {
                     _cameraVarsStore.frustumDictionary[_light.debugPrimitive] = _cameraVarsStore.frustumDictionary[_light];
                  }
                  _view._meshProjector.primitives(_light.debugPrimitive,_viewTransform,_consumer);
               }
            }
         }
         _mouseEnabled = param1._mouseEnabled = _mouseEnabled && param1.mouseEnabled;
      }
      
      override public function leave(param1:Object3D) : void
      {
         _mouseEnabled = _mouseEnableds.pop();
      }
   }
}

