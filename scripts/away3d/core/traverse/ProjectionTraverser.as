package away3d.core.traverse
{
   import away3d.arcane;
   import away3d.cameras.*;
   import away3d.cameras.lenses.*;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.clip.*;
   import away3d.core.geom.*;
   import away3d.core.math.*;
   import away3d.core.project.*;
   import away3d.core.utils.*;
   
   use namespace arcane;
   
   public class ProjectionTraverser extends Traverser
   {
      
      private var _view:View3D;
      
      private var _camera:Camera3D;
      
      private var _mesh:Mesh;
      
      private var _viewTransform:Matrix3D;
      
      private var _lens:ILens;
      
      private var _clipping:Clipping;
      
      private var _frustum:Frustum;
      
      private var _nodeClassification:int;
      
      private var _cameraViewMatrix:Matrix3D;
      
      private var _cameraVarsStore:CameraVarsStore;
      
      public function ProjectionTraverser()
      {
         super();
      }
      
      override public function match(param1:Object3D) : Boolean
      {
         if(!param1.visible)
         {
            return false;
         }
         _viewTransform = _cameraVarsStore.createViewTransform(param1);
         _viewTransform.multiply(_cameraViewMatrix,param1.sceneTransform);
         if(_clipping.objectCulling)
         {
            _frustum = _lens.getFrustum(param1,_viewTransform);
            if(param1 is Scene3D || _cameraVarsStore.nodeClassificationDictionary[param1.parent] == Frustum.INTERSECT)
            {
               if(param1.pivotZero)
               {
                  _nodeClassification = _cameraVarsStore.nodeClassificationDictionary[param1] = _frustum.classifyRadius(param1.boundingRadius);
               }
               else
               {
                  _nodeClassification = _cameraVarsStore.nodeClassificationDictionary[param1] = _frustum.classifySphere(param1.pivotPoint,param1.boundingRadius);
               }
            }
            else
            {
               _nodeClassification = _cameraVarsStore.nodeClassificationDictionary[param1] = _cameraVarsStore.nodeClassificationDictionary[param1.parent];
            }
            if(_nodeClassification == Frustum.OUT)
            {
               param1.updateObject();
               return false;
            }
         }
         if(param1 is ILODObject)
         {
            return (param1 as ILODObject).matchLOD(_camera);
         }
         return true;
      }
      
      public function set view(param1:View3D) : void
      {
         _view = param1;
         _cameraVarsStore = param1.cameraVarsStore;
         _clipping = param1.clipping;
         _camera = param1.camera;
         _lens = _camera.lens;
         _cameraViewMatrix = _camera.viewMatrix;
         if(param1.statsOpen)
         {
            param1.statsPanel.clearObjects();
         }
      }
      
      override public function enter(param1:Object3D) : void
      {
         if(_view.statsOpen && param1 is Mesh)
         {
            _view.statsPanel.addObject(param1 as Mesh);
         }
      }
      
      public function get view() : View3D
      {
         return _view;
      }
      
      override public function apply(param1:Object3D) : void
      {
         if(param1.projectorType == ProjectorType.CONVEX_BLOCK)
         {
            _view.blockers[param1] = param1;
         }
         if(_mesh = param1 as Mesh)
         {
            if(!_view.scene.meshes[param1])
            {
               _view.scene.meshes[param1] = [];
            }
            _view.scene.meshes[param1].push(_view);
            _view.scene.geometries[_mesh.geometry] = _mesh.geometry;
         }
      }
      
      override public function leave(param1:Object3D) : void
      {
         param1.updateObject();
      }
   }
}

