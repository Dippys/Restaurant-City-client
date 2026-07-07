package away3d.core.draw
{
   import away3d.arcane;
   import away3d.core.base.*;
   import away3d.core.utils.FaceVO;
   import away3d.materials.*;
   import flash.geom.Matrix;
   
   use namespace arcane;
   
   public class DrawTriangle extends DrawPrimitive
   {
      
      private var _u1:Number;
      
      private var _y:Number;
      
      private var _vertexCount:uint;
      
      private var bzf:Number;
      
      private var axf:Number;
      
      private var _u0:Number;
      
      private var det:Number;
      
      public var screenCommands:Array;
      
      private var _v0:Number;
      
      private var _v1:Number;
      
      private var _v2:Number;
      
      private var faz:Number;
      
      private var materialHeight:Number;
      
      private var av:Number;
      
      private var ax:Number;
      
      private var ay:Number;
      
      private var az:Number;
      
      private var au:Number;
      
      private var ayf:Number;
      
      public var v0y:Number;
      
      public var v0z:Number;
      
      private var _areaSign:Number;
      
      private var azf:Number;
      
      private var bu:Number;
      
      private var bv:Number;
      
      private var bx:Number;
      
      private var by:Number;
      
      private var bz:Number;
      
      private var fcz:Number;
      
      public var v1y:Number;
      
      public var v1z:Number;
      
      private var uv01:UV;
      
      private var fbz:Number;
      
      public var v1x:Number;
      
      public var material:ITriangleMaterial;
      
      private var cv:Number;
      
      private var cx:Number;
      
      private var cy:Number;
      
      private var cz:Number;
      
      private var _invtexmapping:Matrix = new Matrix();
      
      private var da:Number;
      
      private var db:Number;
      
      private var dc:Number;
      
      private var cu:Number;
      
      private var uv12:UV;
      
      public var v0x:Number;
      
      public var v2x:Number;
      
      public var v2y:Number;
      
      public var reverseArea:Boolean;
      
      public var startIndex:int;
      
      private var cxf:Number;
      
      public var area:Number;
      
      public var v2z:Number;
      
      public var screenIndices:Array;
      
      public var screenVertices:Array;
      
      private var uv20:UV;
      
      public var uv0:UV;
      
      public var uv2:UV;
      
      private var cyf:Number;
      
      private var _vertex:int;
      
      public var endIndex:int;
      
      public var uv1:UV;
      
      public var backface:Boolean = false;
      
      private var czf:Number;
      
      private var bxf:Number;
      
      private var _index:int;
      
      public var faceVO:FaceVO;
      
      private var focus:Number;
      
      private var materialWidth:Number;
      
      private var byf:Number;
      
      private var _x:Number;
      
      private var _z:Number;
      
      private var _u2:Number;
      
      public function DrawTriangle()
      {
         super();
      }
      
      final public function transformUV(param1:IUVMaterial) : Matrix
      {
         materialWidth = param1.width;
         materialHeight = param1.height;
         if(uv0 == null || uv1 == null || uv2 == null)
         {
            return null;
         }
         _u0 = materialWidth * uv0._u;
         _u1 = materialWidth * uv1._u;
         _u2 = materialWidth * uv2._u;
         _v0 = materialHeight * (1 - uv0._v);
         _v1 = materialHeight * (1 - uv1._v);
         _v2 = materialHeight * (1 - uv2._v);
         if(_u0 == _u1 && _v0 == _v1 || _u0 == _u2 && _v0 == _v2)
         {
            if(_u0 > 0.05)
            {
               _u0 -= 0.05;
            }
            else
            {
               _u0 += 0.05;
            }
            if(_v0 > 0.07)
            {
               _v0 -= 0.07;
            }
            else
            {
               _v0 += 0.07;
            }
         }
         if(_u2 == _u1 && _v2 == _v1)
         {
            if(_u2 > 0.04)
            {
               _u2 -= 0.04;
            }
            else
            {
               _u2 += 0.04;
            }
            if(_v2 > 0.06)
            {
               _v2 -= 0.06;
            }
            else
            {
               _v2 += 0.06;
            }
         }
         _invtexmapping.a = _u1 - _u0;
         _invtexmapping.b = _v1 - _v0;
         _invtexmapping.c = _u2 - _u0;
         _invtexmapping.d = _v2 - _v0;
         if(param1 is BitmapMaterialContainer)
         {
            _invtexmapping.tx = _u0 - faceVO.bitmapRect.x;
            _invtexmapping.ty = _v0 - faceVO.bitmapRect.y;
         }
         else
         {
            _invtexmapping.tx = _u0;
            _invtexmapping.ty = _v0;
         }
         return _invtexmapping;
      }
      
      final override public function contains(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(_vertexCount > 3)
         {
            _loc3_ = false;
            _loc4_ = startIndex;
            _loc5_ = endIndex - 1;
            while(_loc4_ < endIndex)
            {
               if(screenCommands[_loc4_] == DrawingCommand.CURVE)
               {
                  _loc4_++;
               }
               _loc7_ = Number(screenVertices[(_loc10_ = screenIndices[_loc4_] * 3) + 1]);
               if(_loc7_ > param2 != (_loc9_ = Number(screenVertices[(_loc11_ = screenIndices[_loc5_] * 3) + 1])) > param2 && param1 < ((_loc8_ = Number(screenVertices[_loc11_])) - (_loc6_ = Number(screenVertices[_loc10_]))) * (param2 - _loc7_) / (_loc9_ - _loc7_) + _loc6_)
               {
                  _loc3_ = !_loc3_;
               }
               _loc5_ = _loc4_++;
               if(screenCommands[_loc4_] == DrawingCommand.MOVE)
               {
                  _loc5_ = _loc4_++;
               }
            }
            return _loc3_;
         }
         if((v0x * (param2 - v1y) + v1x * (v0y - param2) + param1 * (v1y - v0y)) * _areaSign < -0.001)
         {
            return false;
         }
         if((v0x * (v2y - param2) + param1 * (v0y - v2y) + v2x * (param2 - v0y)) * _areaSign < -0.001)
         {
            return false;
         }
         if((param1 * (v2y - v1y) + v1x * (param2 - v2y) + v2x * (v1y - param2)) * _areaSign < -0.001)
         {
            return false;
         }
         return true;
      }
      
      override public function calc() : void
      {
         _index = screenIndices[startIndex] * 3;
         v0x = screenVertices[_index];
         v0y = screenVertices[_index + 1];
         v0z = screenVertices[_index + 2];
         _index = screenIndices[startIndex + 1] * 3;
         v1x = screenVertices[_index];
         v1y = screenVertices[_index + 1];
         v1z = screenVertices[_index + 2];
         _index = screenIndices[startIndex + 2] * 3;
         v2x = screenVertices[_index];
         v2y = screenVertices[_index + 1];
         v2z = screenVertices[_index + 2];
         _vertexCount = endIndex - startIndex;
         if(_vertexCount > 3)
         {
            screenZ = 0;
            _index = endIndex;
            minX = Infinity;
            maxX = -Infinity;
            minY = Infinity;
            maxY = -Infinity;
            minZ = Infinity;
            maxZ = -Infinity;
            while(_index-- > startIndex)
            {
               _vertex = screenIndices[_index] * 3;
               _x = screenVertices[_vertex];
               _y = screenVertices[_vertex + 1];
               _z = screenVertices[_vertex + 2];
               if(minX > _x)
               {
                  minX = _x;
               }
               if(maxX < _x)
               {
                  maxX = _x;
               }
               if(minY > _y)
               {
                  minY = _y;
               }
               if(maxY < _y)
               {
                  maxY = _y;
               }
               if(minZ > _z)
               {
                  minZ = _z;
               }
               if(maxZ < _z)
               {
                  maxZ = _z;
               }
               screenZ += _z;
            }
            screenZ /= _vertexCount;
         }
         else
         {
            if(v0x > v1x)
            {
               if(v0x > v2x)
               {
                  maxX = v0x;
               }
               else
               {
                  maxX = v2x;
               }
            }
            else if(v1x > v2x)
            {
               maxX = v1x;
            }
            else
            {
               maxX = v2x;
            }
            if(v0x < v1x)
            {
               if(v0x < v2x)
               {
                  minX = v0x;
               }
               else
               {
                  minX = v2x;
               }
            }
            else if(v1x < v2x)
            {
               minX = v1x;
            }
            else
            {
               minX = v2x;
            }
            if(v0y > v1y)
            {
               if(v0y > v2y)
               {
                  maxY = v0y;
               }
               else
               {
                  maxY = v2y;
               }
            }
            else if(v1y > v2y)
            {
               maxY = v1y;
            }
            else
            {
               maxY = v2y;
            }
            if(v0y < v1y)
            {
               if(v0y < v2y)
               {
                  minY = v0y;
               }
               else
               {
                  minY = v2y;
               }
            }
            else if(v1y < v2y)
            {
               minY = v1y;
            }
            else
            {
               minY = v2y;
            }
            if(v0z > v1z)
            {
               if(v0z > v2z)
               {
                  maxZ = v0z;
               }
               else
               {
                  maxZ = v2z;
               }
            }
            else if(v1z > v2z)
            {
               maxZ = v1z;
            }
            else
            {
               maxZ = v2z;
            }
            if(v0z < v1z)
            {
               if(v0z < v2z)
               {
                  minZ = v0z;
               }
               else
               {
                  minZ = v2z;
               }
            }
            else if(v1z < v2z)
            {
               minZ = v1z;
            }
            else
            {
               minZ = v2z;
            }
            screenZ = (v0z + v1z + v2z) / 3;
         }
         area = 0.5 * (v0x * (v2y - v1y) + v1x * (v0y - v2y) + v2x * (v1y - v0y));
         if(area > 0)
         {
            _areaSign = 1;
         }
         else
         {
            _areaSign = -1;
         }
      }
      
      arcane function fivepointcut(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:UV, param11:UV, param12:UV, param13:UV, param14:UV) : Array
      {
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc15_:int = screenVertices.length / 3;
         var _loc16_:int = int(screenIndices[param1]);
         var _loc17_:int = int(screenIndices[param5]);
         var _loc18_:int = int(screenIndices[param9]);
         if(ScreenVertex.distanceSqr(screenVertices[_loc16_ * 3],screenVertices[_loc16_ * 3 + 1],param6,param7) < ScreenVertex.distanceSqr(param2,param3,screenVertices[_loc18_ * 3],screenVertices[_loc18_ * 3 + 1]))
         {
            _loc19_ = int(screenIndices.length);
            screenIndices[screenIndices.length] = _loc16_;
            screenIndices[screenIndices.length] = _loc15_;
            screenIndices[screenIndices.length] = _loc15_ + 1;
            _loc20_ = int(screenIndices.length);
            screenIndices[screenIndices.length] = _loc15_;
            screenIndices[screenIndices.length] = _loc17_;
            screenIndices[screenIndices.length] = _loc15_ + 1;
            _loc21_ = int(screenIndices.length);
            screenIndices[screenIndices.length] = _loc16_;
            screenIndices[screenIndices.length] = _loc15_ + 1;
            screenIndices[screenIndices.length] = _loc18_;
            _loc22_ = int(screenIndices.length);
            screenVertices[screenVertices.length] = param2;
            screenVertices[screenVertices.length] = param3;
            screenVertices[screenVertices.length] = param4;
            screenVertices[screenVertices.length] = param6;
            screenVertices[screenVertices.length] = param7;
            screenVertices[screenVertices.length] = param8;
            return [create(source,faceVO,material,screenVertices,screenIndices,screenCommands,_loc19_,_loc20_,param10,param11,param13,true),create(source,faceVO,material,screenVertices,screenIndices,screenCommands,_loc20_,_loc21_,param11,param12,param13,true),create(source,faceVO,material,screenVertices,screenIndices,screenCommands,_loc21_,_loc22_,param10,param13,param14,true)];
         }
         _loc23_ = int(screenIndices.length);
         screenIndices[screenIndices.length] = _loc16_;
         screenIndices[screenIndices.length] = _loc15_;
         screenIndices[screenIndices.length] = _loc18_;
         _loc24_ = int(screenIndices.length);
         screenIndices[screenIndices.length] = _loc15_;
         screenIndices[screenIndices.length] = _loc17_;
         screenIndices[screenIndices.length] = _loc15_ + 1;
         _loc25_ = int(screenIndices.length);
         screenIndices[screenIndices.length] = _loc15_;
         screenIndices[screenIndices.length] = _loc15_ + 1;
         screenIndices[screenIndices.length] = _loc18_;
         _loc26_ = int(screenIndices.length);
         screenVertices[screenVertices.length] = param2;
         screenVertices[screenVertices.length] = param3;
         screenVertices[screenVertices.length] = param4;
         screenVertices[screenVertices.length] = param6;
         screenVertices[screenVertices.length] = param7;
         screenVertices[screenVertices.length] = param8;
         return [create(source,faceVO,material,screenVertices,screenIndices,screenCommands,_loc23_,_loc24_,param10,param11,param14,true),create(source,faceVO,material,screenVertices,screenIndices,screenCommands,_loc24_,_loc25_,param11,param12,param13,true),create(source,faceVO,material,screenVertices,screenIndices,screenCommands,_loc25_,_loc26_,param11,param13,param14,true)];
      }
      
      override public function clear() : void
      {
         uv0 = null;
         uv1 = null;
         uv2 = null;
      }
      
      override public function toString() : String
      {
         var _loc1_:String = "";
         if(material is WireColorMaterial)
         {
            switch((material as WireColorMaterial).color)
            {
               case 65280:
                  _loc1_ = "green";
                  break;
               case 16776960:
                  _loc1_ = "yellow";
                  break;
               case 16711680:
                  _loc1_ = "red";
                  break;
               case 255:
                  _loc1_ = "blue";
            }
         }
         return "T{" + _loc1_ + int(area) + " screenZ = " + num(screenZ) + ", minZ = " + num(minZ) + ", maxZ = " + num(maxZ) + " }";
      }
      
      private function num(param1:Number) : Number
      {
         return int(param1 * 1000) / 1000;
      }
      
      public function getUV(param1:Number, param2:Number) : UV
      {
         if(uv0 == null)
         {
            return null;
         }
         if(uv1 == null)
         {
            return null;
         }
         if(uv2 == null)
         {
            return null;
         }
         au = uv0._u;
         av = uv0._v;
         bu = uv1._u;
         bv = uv1._v;
         cu = uv2._u;
         cv = uv2._v;
         focus = view.camera.focus;
         ax = v0x;
         ay = v0y;
         az = v0z;
         bx = v1x;
         by = v1y;
         bz = v1z;
         cx = v2x;
         cy = v2y;
         cz = v2z;
         if(ax == param1 && ay == param2)
         {
            return uv0;
         }
         if(bx == param1 && by == param2)
         {
            return uv1;
         }
         if(cx == param1 && cy == param2)
         {
            return uv2;
         }
         azf = az / focus;
         bzf = bz / focus;
         czf = cz / focus;
         faz = 1 + azf;
         fbz = 1 + bzf;
         fcz = 1 + czf;
         axf = ax * faz - param1 * azf;
         bxf = bx * fbz - param1 * bzf;
         cxf = cx * fcz - param1 * czf;
         ayf = ay * faz - param2 * azf;
         byf = by * fbz - param2 * bzf;
         cyf = cy * fcz - param2 * czf;
         det = axf * (byf - cyf) + bxf * (cyf - ayf) + cxf * (ayf - byf);
         da = param1 * (byf - cyf) + bxf * (cyf - param2) + cxf * (param2 - byf);
         db = axf * (param2 - cyf) + param1 * (cyf - ayf) + cxf * (ayf - param2);
         dc = axf * (byf - param2) + bxf * (param2 - ayf) + param1 * (ayf - byf);
         return new UV((da * au + db * bu + dc * cu) / det,(da * av + db * bv + dc * cv) / det);
      }
      
      override public function render() : void
      {
         material.renderTriangle(this);
      }
      
      final override public function quarter(param1:Number) : Array
      {
         if(area > -20 && area < 20)
         {
            return null;
         }
         var _loc2_:int = screenVertices.length / 3;
         var _loc3_:int = int(screenIndices.length);
         screenIndices[screenIndices.length] = screenIndices[startIndex];
         screenIndices[screenIndices.length] = _loc2_;
         screenIndices[screenIndices.length] = _loc2_ + 2;
         var _loc4_:int = int(screenIndices.length);
         screenIndices[screenIndices.length] = screenIndices[startIndex + 1];
         screenIndices[screenIndices.length] = _loc2_ + 1;
         screenIndices[screenIndices.length] = _loc2_;
         var _loc5_:int = int(screenIndices.length);
         screenIndices[screenIndices.length] = screenIndices[startIndex + 2];
         screenIndices[screenIndices.length] = _loc2_ + 2;
         screenIndices[screenIndices.length] = _loc2_ + 1;
         var _loc6_:int = int(screenIndices.length);
         screenIndices[screenIndices.length] = _loc2_;
         screenIndices[screenIndices.length] = _loc2_ + 1;
         screenIndices[screenIndices.length] = _loc2_ + 2;
         var _loc7_:int = int(screenIndices.length);
         ScreenVertex.median(startIndex,startIndex + 1,screenVertices,screenIndices,param1);
         ScreenVertex.median(startIndex + 1,startIndex + 2,screenVertices,screenIndices,param1);
         ScreenVertex.median(startIndex + 2,startIndex,screenVertices,screenIndices,param1);
         uv01 = UV.median(uv0,uv1);
         uv12 = UV.median(uv1,uv2);
         uv20 = UV.median(uv2,uv0);
         return [create(source,faceVO,material,screenVertices,screenIndices,screenCommands,_loc3_,_loc4_,uv0,uv01,uv20,true),create(source,faceVO,material,screenVertices,screenIndices,screenCommands,_loc4_,_loc5_,uv1,uv12,uv01,true),create(source,faceVO,material,screenVertices,screenIndices,screenCommands,_loc5_,_loc6_,uv2,uv20,uv12,true),create(source,faceVO,material,screenVertices,screenIndices,screenCommands,_loc6_,_loc7_,uv01,uv12,uv20,true)];
      }
      
      final public function distanceToCenter(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = (v0x + v1x + v2x) / 3;
         var _loc4_:Number = (v0y + v1y + v2y) / 3;
         return Math.sqrt((_loc3_ - param1) * (_loc3_ - param1) + (_loc4_ - param2) * (_loc4_ - param2));
      }
      
      final override public function getZ(param1:Number, param2:Number) : Number
      {
         focus = view.camera.focus;
         if(_vertexCount > 3)
         {
            return screenZ;
         }
         ax = v0x;
         ay = v0y;
         az = v0z;
         bx = v1x;
         by = v1y;
         bz = v1z;
         cx = v2x;
         cy = v2y;
         cz = v2z;
         if(ax == param1 && ay == param2)
         {
            return az;
         }
         if(bx == param1 && by == param2)
         {
            return bz;
         }
         if(cx == param1 && cy == param2)
         {
            return cz;
         }
         azf = az / focus;
         bzf = bz / focus;
         czf = cz / focus;
         faz = 1 + azf;
         fbz = 1 + bzf;
         fcz = 1 + czf;
         axf = ax * faz - param1 * azf;
         bxf = bx * fbz - param1 * bzf;
         cxf = cx * fcz - param1 * czf;
         ayf = ay * faz - param2 * azf;
         byf = by * fbz - param2 * bzf;
         cyf = cy * fcz - param2 * czf;
         det = axf * (byf - cyf) + bxf * (cyf - ayf) + cxf * (ayf - byf);
         da = param1 * (byf - cyf) + bxf * (cyf - param2) + cxf * (param2 - byf);
         db = axf * (param2 - cyf) + param1 * (cyf - ayf) + cxf * (ayf - param2);
         dc = axf * (byf - param2) + bxf * (param2 - ayf) + param1 * (ayf - byf);
         return (da * az + db * bz + dc * cz) / det;
      }
   }
}

