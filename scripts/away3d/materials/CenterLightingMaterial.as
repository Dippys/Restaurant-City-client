package away3d.materials
{
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.draw.*;
   import away3d.core.light.DirectionalLight;
   import away3d.core.light.PointLight;
   import away3d.core.math.*;
   import away3d.core.render.*;
   import away3d.core.utils.*;
   import away3d.events.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class CenterLightingMaterial extends EventDispatcher implements ITriangleMaterial
   {
      
      private var pc:Number;
      
      private var green:Number;
      
      private var diff:Number;
      
      private var draw_fall_k:Number = 1;
      
      private var ksr:Number;
      
      private var fx:Number;
      
      private var ksg:Number;
      
      private var _specularTransform:Matrix3D;
      
      protected var ini:Init;
      
      private var kdb:Number;
      
      private var kdg:Number;
      
      private var rf:Number;
      
      private var draw_reflect_k:Number = 1;
      
      private var dfx:Number;
      
      private var dfy:Number;
      
      private var dfz:Number;
      
      private var kdr:Number;
      
      private var persp:Number;
      
      private var v0x:Number;
      
      private var v0y:Number;
      
      private var v0z:Number;
      
      private var _source:Mesh;
      
      private var draw_normal:Boolean = false;
      
      private var rx:Number;
      
      private var ry:Number;
      
      private var rz:Number;
      
      private var sum:Number;
      
      public var shininess:Number = 20;
      
      public var diffuse_brightness:Number = 1;
      
      public var ambient_brightness:Number = 1;
      
      private var blue:Number;
      
      private var v1x:Number;
      
      private var v1y:Number;
      
      private var v1z:Number;
      
      private var ncx:Number;
      
      private var ncy:Number;
      
      private var ncz:Number;
      
      private var cx:Number;
      
      private var v2x:Number;
      
      private var v2y:Number;
      
      private var v2z:Number;
      
      private var df:Number;
      
      private var fade:Number;
      
      private var cz:Number;
      
      private var _diffuseTransform:Matrix3D;
      
      private var _materialupdated:MaterialEvent;
      
      private var cy:Number;
      
      private var red:Number;
      
      private var graphics:Graphics;
      
      arcane var session:AbstractRenderSession;
      
      private var _view:View3D;
      
      private var amb:Number;
      
      private var ffy:Number;
      
      private var spec:Number;
      
      private var nf:Number;
      
      arcane var _id:int;
      
      private var draw_reflect:Boolean = false;
      
      private var draw_fall:Boolean = false;
      
      private var rfx:Number;
      
      private var rfy:Number;
      
      private var rfz:Number;
      
      private var ffx:Number;
      
      private var ffz:Number;
      
      private var nx:Number;
      
      private var d1x:Number;
      
      private var nz:Number;
      
      private var d1z:Number;
      
      private var kag:Number;
      
      private var ny:Number;
      
      private var d1y:Number;
      
      private var zoom:Number;
      
      private var kab:Number;
      
      private var kar:Number;
      
      private var fz:Number;
      
      private var _viewPosition:Number3D;
      
      private var d2x:Number;
      
      private var c0x:Number;
      
      private var c0y:Number;
      
      private var c0z:Number;
      
      public var specular_brightness:Number = 1;
      
      private var focus:Number;
      
      private var pa:Number;
      
      private var d2y:Number;
      
      private var d2z:Number;
      
      private var fy:Number;
      
      private var pdd:Number;
      
      private var pb:Number;
      
      private var ksb:Number;
      
      arcane var _materialDirty:Boolean;
      
      public function CenterLightingMaterial(param1:Object = null)
      {
         super();
         ini = Init.parse(param1);
         shininess = ini.getColor("shininess",20);
      }
      
      public function updateMaterial(param1:Object3D, param2:View3D) : void
      {
         var _loc4_:DirectionalLight = null;
         var _loc5_:Array = null;
         var _loc6_:PointLight = null;
         var _loc3_:Array = param1.lightarray.directionals;
         for each(_loc4_ in _loc3_)
         {
            if(!_loc4_.diffuseTransform[param1] || Boolean(param2.scene.updatedObjects[param1]))
            {
               _loc4_.setDiffuseTransform(param1);
               _materialDirty = true;
            }
            if(!_loc4_.specularTransform[param1])
            {
               _loc4_.specularTransform[param1] = new Dictionary(true);
            }
            if(Boolean(!_loc4_.specularTransform[param1][param2]) || Boolean(param2.scene.updatedObjects[param1]) || param2.updated)
            {
               _loc4_.setSpecularTransform(param1,param2);
               _materialDirty = true;
            }
         }
         _loc5_ = param1.lightarray.points;
         for each(_loc6_ in _loc5_)
         {
            if(Boolean(!_loc6_.viewPositions[param2]) || Boolean(param2.scene.updatedObjects[param1]) || param2.updated)
            {
               _loc6_.setViewPosition(param2);
               _materialDirty = true;
            }
         }
         if(_materialDirty)
         {
            clearFaces(param1,param2);
         }
      }
      
      public function renderTriangle(param1:DrawTriangle) : void
      {
         var _loc2_:DirectionalLight = null;
         var _loc4_:Array = null;
         var _loc5_:PointLight = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Array = null;
         session = param1.source.session;
         focus = param1.view.camera.focus;
         zoom = param1.view.camera.zoom;
         if(param1.endIndex - param1.startIndex > 10)
         {
            _loc6_ = param1.screenIndices[0] * 3;
            _loc7_ = param1.screenIndices[5] * 3;
            _loc8_ = param1.screenIndices[9] * 3;
            v0z = param1.screenVertices[_loc6_ + 2];
            persp = (1 + v0z / focus) / zoom;
            v0x = param1.screenVertices[_loc6_] * persp;
            v0y = param1.screenVertices[_loc6_ + 1] * persp;
            v1z = param1.screenVertices[_loc7_ + 2];
            persp = (1 + v1z / focus) / zoom;
            v1x = param1.screenVertices[_loc7_] * persp;
            v1y = param1.screenVertices[_loc7_ + 1] * persp;
            v2z = param1.screenVertices[_loc8_ + 2];
            persp = (1 + v2z / focus) / zoom;
            v2x = param1.screenVertices[_loc8_] * persp;
            v2y = param1.screenVertices[_loc8_ + 1] * persp;
         }
         else
         {
            v0z = param1.v0z;
            persp = (1 + v0z / focus) / zoom;
            v0x = param1.v0x * persp;
            v0y = param1.v0y * persp;
            v1z = param1.v1z;
            persp = (1 + v1z / focus) / zoom;
            v1x = param1.v1x * persp;
            v1y = param1.v1y * persp;
            v2z = param1.v2z;
            persp = (1 + v2z / focus) / zoom;
            v2x = param1.v2x * persp;
            v2y = param1.v2y * persp;
         }
         d1x = v1x - v0x;
         d1y = v1y - v0y;
         d1z = v1z - v0z;
         d2x = v2x - v0x;
         d2y = v2y - v0y;
         d2z = v2z - v0z;
         pa = d1y * d2z - d1z * d2y;
         pb = d1z * d2x - d1x * d2z;
         pc = d1x * d2y - d1y * d2x;
         pdd = Math.sqrt(pa * pa + pb * pb + pc * pc);
         pa /= pdd;
         pb /= pdd;
         pc /= pdd;
         c0x = (v0x + v1x + v2x) / 3;
         c0y = (v0y + v1y + v2y) / 3;
         c0z = (v0z + v1z + v2z) / 3;
         kar = kag = kab = kdr = kdg = kdb = ksr = ksg = ksb = 0;
         _source = param1.source as Mesh;
         _view = param1.view;
         var _loc3_:Array = param1.source.lightarray.directionals;
         for each(_loc2_ in _loc3_)
         {
            _diffuseTransform = _loc2_.diffuseTransform[_source];
            red = _loc2_.red;
            green = _loc2_.green;
            blue = _loc2_.blue;
            dfx = _diffuseTransform.szx;
            dfy = _diffuseTransform.szy;
            dfz = _diffuseTransform.szz;
            nx = param1.faceVO.face.normal.x;
            ny = param1.faceVO.face.normal.y;
            nz = param1.faceVO.face.normal.z;
            amb = _loc2_.ambient * ambient_brightness;
            kar += red * amb;
            kag += green * amb;
            kab += blue * amb;
            nf = dfx * nx + dfy * ny + dfz * nz;
            if(nf >= 0)
            {
               diff = _loc2_.diffuse * nf * diffuse_brightness;
               kdr += red * diff;
               kdg += green * diff;
               kdb += blue * diff;
               _specularTransform = _loc2_.specularTransform[_source][_view];
               rfx = _specularTransform.szx;
               rfy = _specularTransform.szy;
               rfz = _specularTransform.szz;
               rf = rfx * nx + rfy * ny + rfz * nz;
               spec = _loc2_.specular * Math.pow(rf,shininess) * specular_brightness;
               ksr += red * spec;
               ksg += green * spec;
               ksb += blue * spec;
            }
         }
         _loc4_ = param1.source.lightarray.points;
         for each(_loc5_ in _loc4_)
         {
            red = _loc5_.red;
            green = _loc5_.green;
            blue = _loc5_.blue;
            _viewPosition = _loc5_.viewPositions[param1.view];
            dfx = _viewPosition.x - c0x;
            dfy = _viewPosition.y - c0y;
            dfz = _viewPosition.z - c0z;
            df = Math.sqrt(dfx * dfx + dfy * dfy + dfz * dfz);
            dfx /= df;
            dfy /= df;
            dfz /= df;
            fade = 1 / df / df;
            amb = _loc5_.ambient * fade * ambient_brightness;
            kar += red * amb;
            kag += green * amb;
            kab += blue * amb;
            nf = dfx * pa + dfy * pb + dfz * pc;
            if(nf >= 0)
            {
               diff = _loc5_.diffuse * fade * nf * diffuse_brightness;
               kdr += red * diff;
               kdg += green * diff;
               kdb += blue * diff;
               rfz = dfz - 2 * nf * pc;
               if(rfz >= 0)
               {
                  rfx = dfx - 2 * nf * pa;
                  rfy = dfy - 2 * nf * pb;
                  spec = _loc5_.specular * fade * Math.pow(rfz,shininess) * specular_brightness;
                  ksr += red * spec;
                  ksg += green * spec;
                  ksb += blue * spec;
               }
            }
         }
         renderTri(param1,session,kar,kag,kab,kdr,kdg,kdb,ksr,ksg,ksb);
         if(draw_fall || draw_reflect || draw_normal)
         {
            graphics = session.graphics;
            cz = c0z;
            cx = c0x * zoom / (1 + cz / focus);
            cy = c0y * zoom / (1 + cz / focus);
            if(draw_normal)
            {
               ncz = c0z + 30 * pc;
               ncx = (c0x + 30 * pa) * zoom * focus / (focus + ncz);
               ncy = (c0y + 30 * pb) * zoom * focus / (focus + ncz);
               graphics.lineStyle(1,0,1);
               graphics.moveTo(cx,cy);
               graphics.lineTo(ncx,ncy);
               graphics.moveTo(cx,cy);
               graphics.drawCircle(cx,cy,2);
            }
            if(draw_fall || draw_reflect)
            {
               _loc9_ = param1.source.lightarray.points;
               for each(_loc5_ in _loc9_)
               {
                  red = _loc5_.red;
                  green = _loc5_.green;
                  blue = _loc5_.blue;
                  sum = (red + green + blue) / 255;
                  red /= sum;
                  green /= sum;
                  blue /= sum;
                  dfx = _viewPosition.x - c0x;
                  dfy = _viewPosition.y - c0y;
                  dfz = _viewPosition.z - c0z;
                  df = Math.sqrt(dfx * dfx + dfy * dfy + dfz * dfz);
                  dfx /= df;
                  dfy /= df;
                  dfz /= df;
                  nf = dfx * pa + dfy * pb + dfz * pc;
                  if(nf >= 0)
                  {
                     if(draw_fall)
                     {
                        ffz = c0z + 30 * dfz * (1 - draw_fall_k);
                        ffx = (c0x + 30 * dfx * (1 - draw_fall_k)) * zoom * focus / (focus + ffz);
                        ffy = (c0y + 30 * dfy * (1 - draw_fall_k)) * zoom * focus / (focus + ffz);
                        fz = c0z + 30 * dfz;
                        fx = (c0x + 30 * dfx) * zoom * focus / (focus + fz);
                        fy = (c0y + 30 * dfy) * zoom * focus / (focus + fz);
                        graphics.lineStyle(1,int(red) * 65536 + int(green) * 256 + int(blue),1);
                        graphics.moveTo(ffx,ffy);
                        graphics.lineTo(fx,fy);
                        graphics.moveTo(ffx,ffy);
                     }
                     if(draw_reflect)
                     {
                        rfx = dfx - 2 * nf * pa;
                        rfy = dfy - 2 * nf * pb;
                        rfz = dfz - 2 * nf * pc;
                        rz = c0z - 30 * rfz * draw_reflect_k;
                        rx = (c0x - 30 * rfx * draw_reflect_k) * zoom * focus / (focus + rz);
                        ry = (c0y - 30 * rfy * draw_reflect_k) * zoom * focus / (focus + rz);
                        graphics.lineStyle(1,int(red * 0.5) * 65536 + int(green * 0.5) * 256 + int(blue * 0.5),1);
                        graphics.moveTo(cx,cy);
                        graphics.lineTo(rx,ry);
                        graphics.moveTo(cx,cy);
                     }
                  }
               }
            }
         }
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      protected function renderTri(param1:DrawTriangle, param2:AbstractRenderSession, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number) : void
      {
         throw new Error("Not implemented");
      }
      
      public function addOnMaterialUpdate(param1:Function) : void
      {
         addEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false,0,true);
      }
      
      public function removeOnMaterialUpdate(param1:Function) : void
      {
         removeEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false);
      }
      
      public function clearFaces(param1:Object3D = null, param2:View3D = null) : void
      {
         param1 = param1;
         param2 = param2;
         notifyMaterialUpdate();
      }
      
      arcane function notifyMaterialUpdate() : void
      {
         _materialDirty = false;
         if(!hasEventListener(MaterialEvent.MATERIAL_UPDATED))
         {
            return;
         }
         if(_materialupdated == null)
         {
            _materialupdated = new MaterialEvent(MaterialEvent.MATERIAL_UPDATED,this);
         }
         dispatchEvent(_materialupdated);
      }
      
      public function get visible() : Boolean
      {
         throw new Error("Not implemented");
      }
   }
}

