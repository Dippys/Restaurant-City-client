package away3d.core.light
{
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.math.*;
   import away3d.events.*;
   import away3d.lights.*;
   import flash.display.*;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.*;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class DirectionalLight extends LightPrimitive
   {
      
      private var halfTransform:away3d.core.math.Matrix3D = new away3d.core.math.Matrix3D();
      
      public var ambientColorTransform:ColorTransform;
      
      private var mod:Number;
      
      private var _green:Number;
      
      private var _light:DirectionalLight3D;
      
      private var _shape:Shape = new Shape();
      
      public var diffuseTransform:Dictionary;
      
      private var _szx:Number;
      
      private var _szy:Number;
      
      private var _blue:Number;
      
      private var _szz:Number;
      
      public var normalMatrixSpecularTransform:Dictionary = new Dictionary(true);
      
      private var cameraTransform:away3d.core.math.Matrix3D;
      
      private var nx:Number;
      
      private var ny:Number;
      
      private var _red:Number;
      
      private var halfVector:Number3D = new Number3D();
      
      private var cameraDirection:Number3D = new Number3D();
      
      private var _matrix:Matrix = new Matrix();
      
      public var normalMatrixDiffuseTransform:Dictionary = new Dictionary(true);
      
      public var diffuseColorTransform:ColorTransform;
      
      private var _normalMatrix:ColorMatrixFilter = new ColorMatrixFilter();
      
      public var specularTransform:Dictionary;
      
      private var transform:away3d.core.math.Matrix3D = new away3d.core.math.Matrix3D();
      
      private var direction:Number3D = new Number3D();
      
      public function DirectionalLight()
      {
         super();
      }
      
      public function setNormalMatrixSpecularTransform(param1:Object3D, param2:View3D, param3:Number, param4:Number) : void
      {
         if(!normalMatrixSpecularTransform[param1])
         {
            normalMatrixSpecularTransform[param1] = new Dictionary(true);
         }
         _red = (red * 2 + param4) * param3;
         _green = (green * 2 + param4) * param3;
         _blue = (blue * 2 + param4) * param3;
         _szx = specularTransform[param1][param2].szx;
         _szy = -specularTransform[param1][param2].szy;
         _szz = specularTransform[param1][param2].szz;
         _normalMatrix.matrix = [_szx * _red,_green * _szy,_blue * _szz,0,-_red * 127 * (_szx + _szy + _szz) - 127 * param4 * param3,_szx * _red,_green * _szy,_blue * _szz,0,-_green * 127 * (_szx + _szy + _szz) - 127 * param4 * param3,_szx * _red,_green * _szy,_blue * _szz,0,-_blue * 127 * (_szx + _szy + _szz) - 127 * param4 * param3,0,0,0,1,0];
         normalMatrixSpecularTransform[param1][param2] = _normalMatrix.clone();
      }
      
      public function setDiffuseTransform(param1:Object3D) : void
      {
         if(!diffuseTransform[param1])
         {
            diffuseTransform[param1] = new away3d.core.math.Matrix3D();
         }
         diffuseTransform[param1].multiply3x3(transform,param1.sceneTransform);
         diffuseTransform[param1].normalize(diffuseTransform[param1]);
      }
      
      public function updateAmbientBitmap() : void
      {
         ambientBitmap = new BitmapData(256,256,false,int(ambient * red * 255 << 16) | int(ambient * green * 255 << 8) | int(ambient * blue * 255));
         ambientBitmap.lock();
         ambientColorTransform = new ColorTransform(1,1,1,1,ambient * red * 255,ambient * green * 255,ambient * blue * 255,0);
      }
      
      public function clearTransform() : void
      {
         diffuseTransform = new Dictionary(true);
         specularTransform = new Dictionary(true);
         normalMatrixDiffuseTransform = new Dictionary(true);
         normalMatrixSpecularTransform = new Dictionary(true);
      }
      
      public function get light() : DirectionalLight3D
      {
         return _light;
      }
      
      public function setSpecularTransform(param1:Object3D, param2:View3D) : void
      {
         cameraTransform = param2.camera.transform;
         cameraDirection.x = -cameraTransform.sxz;
         cameraDirection.y = -cameraTransform.syz;
         cameraDirection.z = -cameraTransform.szz;
         halfVector.add(cameraDirection,direction);
         halfVector.normalize();
         nx = halfVector.x;
         ny = halfVector.y;
         mod = Math.sqrt(nx * nx + ny * ny);
         halfTransform.rotationMatrix(-ny / mod,nx / mod,0,Math.acos(-halfVector.z));
         if(!specularTransform[param1][param2])
         {
            specularTransform[param1][param2] = new away3d.core.math.Matrix3D();
         }
         specularTransform[param1][param2].multiply3x3(halfTransform,param1.sceneTransform);
         specularTransform[param1][param2].normalize(specularTransform[param1][param2]);
      }
      
      public function updateDirection(param1:Object3DEvent) : void
      {
         direction.x = _light.x;
         direction.y = _light.y;
         direction.z = _light.z;
         direction.normalize();
         nx = direction.x;
         ny = direction.y;
         mod = Math.sqrt(nx * nx + ny * ny);
         transform.rotationMatrix(ny / mod,-nx / mod,0,-Math.acos(-direction.z));
         clearTransform();
      }
      
      public function setNormalMatrixDiffuseTransform(param1:Object3D) : void
      {
         _red = red * 2 * diffuse;
         _green = green * 2 * diffuse;
         _blue = blue * 2 * diffuse;
         _szx = diffuseTransform[param1].szx;
         _szy = -diffuseTransform[param1].szy;
         _szz = diffuseTransform[param1].szz;
         _normalMatrix.matrix = [_szx * _red,_green * _szy,_blue * _szz,0,-_red * 127 * (_szx + _szy + _szz),_szx * _red,_green * _szy,_blue * _szz,0,-_green * 127 * (_szx + _szy + _szz),_szx * _red,_green * _szy,_blue * _szz,0,-_blue * 127 * (_szx + _szy + _szz),0,0,0,1,0];
         normalMatrixDiffuseTransform[param1] = _normalMatrix.clone();
      }
      
      public function updateAmbientDiffuseBitmap() : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         ambientDiffuseBitmap = new BitmapData(256,256,false,0);
         ambientDiffuseBitmap.lock();
         _matrix.createGradientBox(256,256,0,0,0);
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:* = 15;
         while(_loc4_--)
         {
            _loc5_ = _loc4_ * diffuse / 14 + ambient;
            if(_loc5_ > 1)
            {
               _loc5_ = 1;
            }
            _loc6_ = _loc4_ * diffuse / 14 + ambient;
            if(_loc6_ > 1)
            {
               _loc6_ = 1;
            }
            _loc7_ = _loc4_ * diffuse / 14 + ambient;
            if(_loc7_ > 1)
            {
               _loc7_ = 1;
            }
            _loc1_.push(_loc5_ * red * 255 << 16 | _loc6_ * green * 255 << 8 | _loc7_ * blue * 255);
            _loc2_.push(1);
            _loc3_.push(int(30 + 225 * 2 * Math.acos(_loc4_ / 14) / Math.PI));
         }
         _shape.graphics.clear();
         _shape.graphics.beginGradientFill(GradientType.LINEAR,_loc1_,_loc2_,_loc3_,_matrix);
         _shape.graphics.drawRect(0,0,256,256);
         ambientDiffuseBitmap.draw(_shape);
      }
      
      public function set light(param1:DirectionalLight3D) : void
      {
         _light = param1;
         param1.addOnSceneTransformChange(updateDirection);
      }
      
      public function updateDiffuseBitmap() : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         diffuseBitmap = new BitmapData(256,256,false,0);
         diffuseBitmap.lock();
         _matrix.createGradientBox(256,256,0,0,0);
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:* = 15;
         while(_loc4_--)
         {
            _loc5_ = _loc4_ * diffuse / 14;
            if(_loc5_ > 1)
            {
               _loc5_ = 1;
            }
            _loc6_ = _loc4_ * diffuse / 14;
            if(_loc6_ > 1)
            {
               _loc6_ = 1;
            }
            _loc7_ = _loc4_ * diffuse / 14;
            if(_loc7_ > 1)
            {
               _loc7_ = 1;
            }
            _loc1_.push(_loc5_ * red * 255 << 16 | _loc6_ * green * 255 << 8 | _loc7_ * blue * 255);
            _loc2_.push(1);
            _loc3_.push(int(30 + 225 * 2 * Math.acos(_loc4_ / 14) / Math.PI));
         }
         _shape.graphics.clear();
         _shape.graphics.beginGradientFill(GradientType.LINEAR,_loc1_,_loc2_,_loc3_,_matrix);
         _shape.graphics.drawRect(0,0,256,256);
         diffuseBitmap.draw(_shape);
         diffuseColorTransform = new ColorTransform(diffuse * red,diffuse * green,diffuse * blue,1,0,0,0,0);
      }
      
      public function updateSpecularBitmap() : void
      {
         specularBitmap = new BitmapData(512,512,false,0);
         specularBitmap.lock();
         _matrix.createGradientBox(512,512,0,0,0);
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:* = 15;
         while(_loc4_--)
         {
            _loc1_.push((_loc4_ * specular * red * 255 / 14 << 16) + (_loc4_ * specular * green * 255 / 14 << 8) + _loc4_ * specular * blue * 255 / 14);
            _loc2_.push(1);
            _loc3_.push(int(30 + 225 * 2 * Math.acos(Math.pow(_loc4_ / 14,1 / 20)) / Math.PI));
         }
         _shape.graphics.clear();
         _shape.graphics.beginGradientFill(GradientType.RADIAL,_loc1_,_loc2_,_loc3_,_matrix);
         _shape.graphics.drawCircle(255,255,255);
         specularBitmap.draw(_shape);
      }
   }
}

