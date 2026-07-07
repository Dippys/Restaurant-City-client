package away3d.geom
{
   import away3d.arcane;
   import away3d.core.base.Face;
   import away3d.core.base.Mesh;
   import away3d.core.base.UV;
   import away3d.core.base.Vertex;
   import away3d.core.math.Number3D;
   import away3d.materials.ITriangleMaterial;
   
   use namespace arcane;
   
   public class Merge
   {
      
      private var _unicgeometry:Boolean;
      
      private var _objectspace:Boolean;
      
      private var _keepMaterial:Boolean;
      
      public function Merge(param1:Boolean = true, param2:Boolean = false, param3:Boolean = false)
      {
         super();
         _objectspace = param1;
         _unicgeometry = param2;
         _keepMaterial = param3;
      }
      
      public function get unicgeometry() : Boolean
      {
         return _unicgeometry;
      }
      
      public function get objectspace() : Boolean
      {
         return _objectspace;
      }
      
      public function set unicgeometry(param1:Boolean) : void
      {
         _unicgeometry = param1;
      }
      
      public function get keepMaterial() : Boolean
      {
         return _keepMaterial;
      }
      
      public function set objectspace(param1:Boolean) : void
      {
         _objectspace = param1;
      }
      
      public function apply(param1:Mesh, param2:Mesh) : void
      {
         merge(param1,param2);
      }
      
      private function applyPosition(param1:Vertex, param2:Number3D, param3:Number, param4:Number, param5:Number) : Vertex
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = Math.PI / 180;
         var _loc12_:Number = param3 * _loc11_;
         var _loc13_:Number = param4 * _loc11_;
         var _loc14_:Number = param5 * _loc11_;
         var _loc15_:Number = Math.sin(_loc12_);
         var _loc16_:Number = Math.cos(_loc12_);
         var _loc17_:Number = Math.sin(_loc13_);
         var _loc18_:Number = Math.cos(_loc13_);
         var _loc19_:Number = Math.sin(_loc14_);
         var _loc20_:Number = Math.cos(_loc14_);
         _loc6_ = param1.x + param2.x;
         _loc7_ = param1.y + param2.y;
         _loc8_ = param1.z + param2.z;
         _loc10_ = _loc7_;
         _loc7_ = _loc10_ * _loc16_ + _loc8_ * -_loc15_;
         _loc8_ = _loc10_ * _loc15_ + _loc8_ * _loc16_;
         _loc9_ = _loc6_;
         _loc6_ = _loc9_ * _loc18_ + _loc8_ * _loc17_;
         _loc8_ = _loc9_ * -_loc17_ + _loc8_ * _loc18_;
         _loc9_ = _loc6_;
         _loc6_ = _loc9_ * _loc20_ + _loc7_ * -_loc19_;
         _loc7_ = _loc9_ * _loc19_ + _loc7_ * _loc20_;
         param1.setValue(_loc6_,_loc7_,_loc8_);
         return param1;
      }
      
      private function merge(param1:Mesh, param2:Mesh) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Vertex = null;
         var _loc5_:Vertex = null;
         var _loc6_:Vertex = null;
         var _loc7_:UV = null;
         var _loc8_:UV = null;
         var _loc9_:UV = null;
         var _loc10_:Face = null;
         var _loc11_:ITriangleMaterial = null;
         if(_unicgeometry || !_objectspace)
         {
            _loc3_ = 0;
            while(_loc3_ < param2.faces.length)
            {
               _loc10_ = param2.faces[_loc3_];
               _loc4_ = new Vertex(_loc10_.v0.x,_loc10_.v0.y,_loc10_.v0.z);
               _loc5_ = new Vertex(_loc10_.v1.x,_loc10_.v1.y,_loc10_.v1.z);
               _loc6_ = new Vertex(_loc10_.v2.x,_loc10_.v2.y,_loc10_.v2.z);
               _loc7_ = new UV(_loc10_.uv0.u,_loc10_.uv0.v);
               _loc8_ = new UV(_loc10_.uv1.u,_loc10_.uv1.v);
               _loc9_ = new UV(_loc10_.uv2.u,_loc10_.uv2.v);
               if(!_objectspace)
               {
                  _loc4_ = applyPosition(_loc4_,param2.scenePosition,param2.rotationX,param2.rotationY,param2.rotationZ);
                  _loc5_ = applyPosition(_loc5_,param2.scenePosition,param2.rotationX,param2.rotationY,param2.rotationZ);
                  _loc6_ = applyPosition(_loc6_,param2.scenePosition,param2.rotationX,param2.rotationY,param2.rotationZ);
               }
               _loc11_ = _keepMaterial ? param2.material as ITriangleMaterial : param1.material as ITriangleMaterial;
               param1.addFace(new Face(_loc4_,_loc5_,_loc6_,_loc11_,_loc7_,_loc8_,_loc9_));
               _loc3_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < param2.faces.length)
            {
               _loc11_ = _keepMaterial ? param2.material as ITriangleMaterial : param1.material as ITriangleMaterial;
               _loc10_ = param2.faces[_loc3_];
               param1.addFace(new Face(_loc10_.v0,_loc10_.v1,_loc10_.v2,_loc11_,_loc10_.uv0,_loc10_.uv1,_loc10_.uv2));
               _loc3_++;
            }
         }
      }
      
      public function set keepmaterial(param1:Boolean) : void
      {
         _keepMaterial = param1;
      }
   }
}

