package away3d.containers
{
   import away3d.animators.skin.*;
   import away3d.arcane;
   import away3d.core.base.*;
   import away3d.core.math.*;
   import away3d.core.project.*;
   import away3d.core.traverse.*;
   import away3d.core.utils.Debug;
   import away3d.events.*;
   import away3d.loaders.data.*;
   import away3d.loaders.utils.*;
   
   use namespace arcane;
   
   public class ObjectContainer3D extends Object3D
   {
      
      private var _children:Array;
      
      public function ObjectContainer3D(... rest)
      {
         var _loc2_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object3D = null;
         _children = [];
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
         super(_loc2_);
         projectorType = ProjectorType.OBJECT_CONTAINER;
         for each(_loc5_ in _loc3_)
         {
            addChild(_loc5_);
         }
      }
      
      public function addChildren(... rest) : void
      {
         var _loc2_:Object3D = null;
         for each(_loc2_ in rest)
         {
            addChild(_loc2_);
         }
      }
      
      arcane function internalRemoveChild(param1:Object3D) : void
      {
         var _loc2_:int = children.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         param1.removeOnTransformChange(onChildChange);
         param1.removeOnDimensionsChange(onChildChange);
         _children.splice(_loc2_,1);
         notifyDimensionsChange();
         if(Boolean(session) && !param1.ownCanvas)
         {
            session.internalRemoveOwnSession(param1);
         }
         _sessionDirty = true;
      }
      
      public function getBoneByName(param1:String) : Bone
      {
         var _loc2_:Bone = null;
         var _loc3_:Object3D = null;
         for each(_loc3_ in children)
         {
            if(_loc3_ is Bone)
            {
               _loc2_ = _loc3_ as Bone;
               if(_loc2_.name)
               {
                  if(_loc2_.name == param1)
                  {
                     return _loc2_;
                  }
               }
               if(_loc2_.boneId)
               {
                  if(_loc2_.boneId == param1)
                  {
                     return _loc2_;
                  }
               }
            }
            if(_loc3_ is ObjectContainer3D)
            {
               _loc2_ = (_loc3_ as ObjectContainer3D).getBoneByName(param1);
               if(_loc2_)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public function get children() : Array
      {
         return _children;
      }
      
      override public function applyRotations() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc16_:Object3D = null;
         var _loc6_:Number = Math.PI / 180;
         var _loc7_:Number = rotationX * _loc6_;
         var _loc8_:Number = rotationY * _loc6_;
         var _loc9_:Number = rotationZ * _loc6_;
         var _loc10_:Number = Math.sin(_loc7_);
         var _loc11_:Number = Math.cos(_loc7_);
         var _loc12_:Number = Math.sin(_loc8_);
         var _loc13_:Number = Math.cos(_loc8_);
         var _loc14_:Number = Math.sin(_loc9_);
         var _loc15_:Number = Math.cos(_loc9_);
         for each(_loc16_ in children)
         {
            _loc1_ = _loc16_.x;
            _loc2_ = _loc16_.y;
            _loc3_ = _loc16_.z;
            _loc5_ = _loc2_;
            _loc2_ = _loc5_ * _loc11_ + _loc3_ * -_loc10_;
            _loc3_ = _loc5_ * _loc10_ + _loc3_ * _loc11_;
            _loc4_ = _loc1_;
            _loc1_ = _loc4_ * _loc13_ + _loc3_ * _loc12_;
            _loc3_ = _loc4_ * -_loc12_ + _loc3_ * _loc13_;
            _loc4_ = _loc1_;
            _loc1_ = _loc4_ * _loc15_ + _loc2_ * -_loc14_;
            _loc2_ = _loc4_ * _loc14_ + _loc2_ * _loc15_;
            _loc16_.moveTo(_loc1_,_loc2_,_loc3_);
         }
         rotationX = 0;
         rotationY = 0;
         rotationZ = 0;
      }
      
      public function getChildByName(param1:String) : Object3D
      {
         var _loc2_:Object3D = null;
         var _loc3_:Object3D = null;
         for each(_loc3_ in children)
         {
            if(_loc3_.name)
            {
               if(_loc3_.name == param1)
               {
                  return _loc3_;
               }
            }
            if(_loc3_ is ObjectContainer3D)
            {
               _loc2_ = (_loc3_ as ObjectContainer3D).getChildByName(param1);
               if(_loc2_)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public function cloneAll(param1:Object3D = null) : Object3D
      {
         var _loc3_:ObjectContainer3D = null;
         var _loc4_:Object3D = null;
         var _loc6_:AnimationData = null;
         var _loc7_:MaterialData = null;
         var _loc2_:ObjectContainer3D = param1 as ObjectContainer3D || new ObjectContainer3D();
         super.clone(_loc2_);
         for each(_loc4_ in children)
         {
            if(_loc4_ is Bone)
            {
               _loc3_ = new Bone();
               _loc2_.addChild(_loc3_);
               (_loc4_ as Bone).cloneAll(_loc3_);
            }
            else if(_loc4_ is ObjectContainer3D)
            {
               _loc3_ = new ObjectContainer3D();
               _loc2_.addChild(_loc3_);
               (_loc4_ as ObjectContainer3D).cloneAll(_loc3_);
            }
            else if(_loc4_ is Mesh)
            {
               _loc2_.addChild((_loc4_ as Mesh).cloneAll());
            }
            else
            {
               _loc2_.addChild(_loc4_.clone());
            }
         }
         if(animationLibrary)
         {
            _loc2_.animationLibrary = new AnimationLibrary();
            for each(_loc6_ in animationLibrary)
            {
               _loc6_.clone(_loc2_);
            }
         }
         if(materialLibrary)
         {
            _loc2_.materialLibrary = new MaterialLibrary();
            for each(_loc7_ in materialLibrary)
            {
               _loc7_.clone(_loc2_);
            }
         }
         var _loc5_:ObjectContainer3D = _loc2_;
         while(_loc5_.parent)
         {
            _loc5_ = _loc5_.parent;
         }
         if(_loc2_ == _loc5_)
         {
            cloneBones(_loc2_,_loc5_);
         }
         return _loc2_;
      }
      
      private function onChildChange(param1:Object3DEvent) : void
      {
         notifyDimensionsChange();
      }
      
      public function centerMeshes() : void
      {
         var _loc1_:Object3D = null;
         for each(_loc1_ in children)
         {
            _loc1_.centerPivot();
         }
      }
      
      override public function traverse(param1:Traverser) : void
      {
         var _loc2_:Object3D = null;
         if(param1.match(this))
         {
            param1.enter(this);
            param1.apply(this);
            for each(_loc2_ in children)
            {
               _loc2_.traverse(param1);
            }
            param1.leave(this);
         }
      }
      
      override public function centerPivot() : void
      {
         var _loc1_:Object3D = null;
         for each(_loc1_ in children)
         {
            _loc1_.centerPivot();
         }
         super.centerPivot();
      }
      
      override protected function updateDimensions() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number3D = null;
         var _loc5_:Object3D = null;
         var _loc1_:Array = _children.concat();
         if(_loc1_.length)
         {
            if(_scaleX < 0)
            {
               _boundingScale = -_scaleX;
            }
            else
            {
               _boundingScale = _scaleX;
            }
            if(_scaleY < 0 && _boundingScale < -_scaleY)
            {
               _boundingScale = -_scaleY;
            }
            else if(_boundingScale < _scaleY)
            {
               _boundingScale = _scaleY;
            }
            if(_scaleZ < 0 && _boundingScale < -_scaleZ)
            {
               _boundingScale = -_scaleZ;
            }
            else if(_boundingScale < _scaleZ)
            {
               _boundingScale = _scaleZ;
            }
            _loc2_ = 0;
            _loc4_ = new Number3D();
            for each(_loc5_ in _loc1_)
            {
               _loc4_.sub(_loc5_.position,_pivotPoint);
               _loc3_ = _loc4_.modulo + _loc5_.parentBoundingRadius;
               if(_loc2_ < _loc3_)
               {
                  _loc2_ = _loc3_;
               }
            }
            _boundingRadius = _loc2_;
            _loc1_.sortOn("parentmaxX",Array.DESCENDING | Array.NUMERIC);
            _maxX = _loc1_[0].parentmaxX;
            _loc1_.sortOn("parentminX",Array.NUMERIC);
            _minX = _loc1_[0].parentminX;
            _loc1_.sortOn("parentmaxY",Array.DESCENDING | Array.NUMERIC);
            _maxY = _loc1_[0].parentmaxY;
            _loc1_.sortOn("parentminY",Array.NUMERIC);
            _minY = _loc1_[0].parentminY;
            _loc1_.sortOn("parentmaxZ",Array.DESCENDING | Array.NUMERIC);
            _maxZ = _loc1_[0].parentmaxZ;
            _loc1_.sortOn("parentminZ",Array.NUMERIC);
            _minZ = _loc1_[0].parentminZ;
         }
         super.updateDimensions();
      }
      
      override public function applyPosition(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Object3D = null;
         var _loc8_:Number3D = null;
         for each(_loc7_ in children)
         {
            _loc4_ = _loc7_.x;
            _loc5_ = _loc7_.y;
            _loc6_ = _loc7_.z;
            _loc7_.moveTo(_loc4_ - param1,_loc5_ - param2,_loc6_ - param3);
         }
         _loc8_ = new Number3D(param1,param2,param3);
         _loc8_.rotate(_loc8_,_transform);
         _loc8_.add(_loc8_,position);
         moveTo(_loc8_.x,_loc8_.y,_loc8_.z);
      }
      
      public function removeChild(param1:Object3D) : void
      {
         if(param1 == null)
         {
            throw new Error("ObjectContainer3D.removeChild(null)");
         }
         if(param1.parent != this)
         {
            return;
         }
         param1.parent = null;
      }
      
      private function cloneBones(param1:ObjectContainer3D, param2:ObjectContainer3D) : void
      {
         var _loc4_:Object3D = null;
         var _loc5_:Geometry = null;
         var _loc6_:Array = null;
         var _loc7_:Bone = null;
         var _loc8_:SkinController = null;
         var _loc9_:Bone = null;
         var _loc3_:Array = param1.children;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ is ObjectContainer3D)
            {
               (_loc4_ as ObjectContainer3D).cloneBones(_loc4_ as ObjectContainer3D,param2);
            }
            else if(_loc4_ is Mesh)
            {
               _loc5_ = (_loc4_ as Mesh).geometry;
               _loc6_ = _loc5_.skinControllers;
               for each(_loc8_ in _loc6_)
               {
                  _loc9_ = param2.getBoneByName(_loc8_.name);
                  if(_loc9_)
                  {
                     _loc8_.joint = _loc9_.joint;
                     if(!(_loc9_.parent.parent is Bone))
                     {
                        _loc7_ = _loc9_;
                     }
                  }
                  else
                  {
                     Debug.warning("no joint found for " + _loc8_.name);
                  }
               }
               for each(_loc8_ in _loc6_)
               {
                  _loc8_.inverseTransform = _loc4_.parent.inverseSceneTransform;
               }
            }
         }
      }
      
      public function removeChildByName(param1:String) : void
      {
         removeChild(getChildByName(param1));
      }
      
      public function addChild(param1:Object3D) : void
      {
         if(param1 == null)
         {
            throw new Error("ObjectContainer3D.addChild(null)");
         }
         param1.parent = this;
      }
      
      override public function clone(param1:Object3D = null) : Object3D
      {
         var _loc3_:Object3D = null;
         var _loc2_:ObjectContainer3D = param1 as ObjectContainer3D || new ObjectContainer3D();
         super.clone(_loc2_);
         for each(_loc3_ in children)
         {
            if(!(_loc3_ is Bone))
            {
               _loc2_.addChild(_loc3_.clone());
            }
         }
         return _loc2_;
      }
      
      arcane function internalAddChild(param1:Object3D) : void
      {
         _children.push(param1);
         param1.addOnTransformChange(onChildChange);
         param1.addOnDimensionsChange(onChildChange);
         notifyDimensionsChange();
         if(Boolean(_session) && !param1.ownCanvas)
         {
            session.internalAddOwnSession(param1);
         }
         _sessionDirty = true;
      }
   }
}

