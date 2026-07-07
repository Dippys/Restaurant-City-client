package away3d.animators.skin
{
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.base.*;
   
   use namespace arcane;
   
   public class Bone extends ObjectContainer3D
   {
      
      public var joint:ObjectContainer3D;
      
      public var boneId:String;
      
      public function Bone(param1:Object = null, ... rest)
      {
         super(param1);
         addChild(joint = new ObjectContainer3D());
      }
      
      public function set jointRotationX(param1:Number) : void
      {
         joint.rotationX = param1;
      }
      
      public function set jointScaleY(param1:Number) : void
      {
         joint.scaleY = param1;
      }
      
      public function set jointRotationY(param1:Number) : void
      {
         joint.rotationY = param1;
      }
      
      public function set jointRotationZ(param1:Number) : void
      {
         joint.rotationZ = param1;
      }
      
      override public function cloneAll(param1:Object3D = null) : Object3D
      {
         var _loc2_:Bone = param1 as Bone || new Bone();
         _loc2_.removeChild(joint);
         super.cloneAll(_loc2_);
         _loc2_.boneId = boneId;
         _loc2_.joint = _loc2_.children[0];
         return _loc2_;
      }
      
      public function get jointRotationX() : Number
      {
         return joint.rotationX;
      }
      
      public function get jointRotationY() : Number
      {
         return joint.rotationY;
      }
      
      public function get jointRotationZ() : Number
      {
         return joint.rotationZ;
      }
      
      public function set jointScaleX(param1:Number) : void
      {
         joint.scaleX = param1;
      }
      
      public function get jointScaleX() : Number
      {
         return joint.scaleX;
      }
      
      public function get jointScaleY() : Number
      {
         return joint.scaleY;
      }
      
      public function get jointScaleZ() : Number
      {
         return joint.scaleZ;
      }
      
      public function set jointScaleZ(param1:Number) : void
      {
         joint.scaleZ = param1;
      }
      
      override public function clone(param1:Object3D = null) : Object3D
      {
         var _loc2_:Bone = param1 as Bone || new Bone();
         super.clone(_loc2_);
         _loc2_.joint = _loc2_.children[0];
         return _loc2_;
      }
   }
}

