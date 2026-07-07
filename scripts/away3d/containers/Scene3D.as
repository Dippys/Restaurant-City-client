package away3d.containers
{
   import away3d.arcane;
   import away3d.core.base.*;
   import away3d.core.math.*;
   import away3d.core.traverse.*;
   import away3d.core.utils.*;
   import away3d.events.*;
   import flash.events.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class Scene3D extends ObjectContainer3D
   {
      
      private var _projtraverser:ProjectionTraverser;
      
      public var physics:IPhysicsScene;
      
      private var _lighttraverser:LightTraverser;
      
      private var _mesh:Mesh;
      
      public var updateLight:Boolean;
      
      private var _sessiontraverser:SessionTraverser;
      
      private var _objects:Array;
      
      public var updatedObjects:Dictionary;
      
      public var viewDictionary:Dictionary;
      
      public var geometries:Dictionary;
      
      public var meshes:Dictionary;
      
      public var tickTraverser:TickTraverser;
      
      public var autoUpdate:Boolean;
      
      public var updatedSessions:Dictionary;
      
      private var _currentView:View3D;
      
      public function Scene3D(... rest)
      {
         var _loc2_:Object = null;
         var _loc4_:Object = null;
         var _loc6_:Object3D = null;
         _objects = new Array();
         _projtraverser = new ProjectionTraverser();
         _sessiontraverser = new SessionTraverser();
         _lighttraverser = new LightTraverser();
         viewDictionary = new Dictionary(true);
         tickTraverser = new TickTraverser();
         var _loc3_:Array = [];
         for each(_loc4_ in rest)
         {
            if(_loc4_ is Object3D)
            {
               _loc3_.push(_loc4_);
            }
            else
            {
               _loc2_ = _loc4_;
            }
         }
         if(_loc2_)
         {
            _loc2_["ownCanvas"] = true;
            _loc2_["ownLights"] = true;
         }
         else
         {
            _loc2_ = {
               "ownCanvas":true,
               "ownLights":true
            };
         }
         super(_loc2_);
         autoUpdate = ini.getBoolean("autoUpdate",true);
         updateLight = ini.getBoolean("updateLight",true);
         var _loc5_:Object = ini.getObject("physics");
         if(_loc5_ is IPhysicsScene)
         {
            physics = _loc5_ as IPhysicsScene;
         }
         if(_loc5_ is Boolean)
         {
            if(_loc5_ == true)
            {
               physics = null;
            }
         }
         if(_loc5_ is Object)
         {
            physics = null;
         }
         for each(_loc6_ in _loc3_)
         {
            addChild(_loc6_);
         }
      }
      
      override public function get sceneTransform() : Matrix3D
      {
         if(_transformDirty)
         {
            _sceneTransformDirty = true;
         }
         if(_sceneTransformDirty)
         {
            notifySceneTransformChange();
         }
         return transform;
      }
      
      public function updateTime(param1:int = -1) : void
      {
         if(param1 == -1)
         {
            param1 = getTimer();
         }
         tickTraverser.now = param1;
         traverse(tickTraverser);
         if(physics != null)
         {
            physics.updateTime(param1);
         }
      }
      
      arcane function clearId(param1:int) : void
      {
         delete _objects[param1];
      }
      
      private function onUpdate(param1:ViewEvent) : void
      {
         if(autoUpdate)
         {
            if(Boolean(_currentView) && _currentView != param1.view)
            {
               Debug.warning("Multiple views detected! Should consider switching to manual update");
            }
            _currentView = param1.view;
            update();
         }
      }
      
      arcane function setId(param1:Object3D) : void
      {
         var _loc2_:int = 0;
         while(_objects[_loc2_])
         {
            _loc2_++;
         }
         _objects[_loc2_] = param1;
         param1._id = _loc2_;
      }
      
      arcane function internalRemoveView(param1:View3D) : void
      {
         param1.removeEventListener(ViewEvent.UPDATE_SCENE,onUpdate);
      }
      
      arcane function internalAddView(param1:View3D) : void
      {
         param1.addEventListener(ViewEvent.UPDATE_SCENE,onUpdate);
      }
      
      public function update() : void
      {
         var _loc1_:View3D = null;
         var _loc2_:Array = null;
         var _loc3_:Geometry = null;
         var _loc4_:Object = null;
         updatedObjects = new Dictionary(true);
         updatedSessions = new Dictionary(true);
         meshes = new Dictionary(true);
         geometries = new Dictionary(true);
         if(updateLight)
         {
            traverse(_lighttraverser);
         }
         for each(_loc1_ in viewDictionary)
         {
            _loc1_.camera.update();
            _loc1_.blockers = new Dictionary(true);
            _loc1_.drawPrimitiveStore.blockerDictionary = new Dictionary(true);
            _loc1_.cameraVarsStore.reset();
            _loc1_.blockerarray.clip = _loc1_.screenClipping;
            _projtraverser.view = _loc1_;
            traverse(_projtraverser);
         }
         for(_loc4_ in meshes)
         {
            _mesh = _loc4_ as Mesh;
            _loc2_ = meshes[_mesh];
            for each(_loc1_ in _loc2_)
            {
               _mesh.updateMaterials(_mesh,_loc1_);
            }
         }
         for each(_loc3_ in geometries)
         {
            _loc3_.updateElements();
         }
         traverse(_sessiontraverser);
      }
   }
}

