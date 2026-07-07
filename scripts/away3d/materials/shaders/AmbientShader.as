package away3d.materials.shaders
{
   import away3d.arcane;
   import away3d.containers.View3D;
   import away3d.core.base.Object3D;
   import away3d.core.draw.DrawTriangle;
   import away3d.core.light.AmbientLight;
   import away3d.core.light.DirectionalLight;
   import away3d.core.utils.FaceMaterialVO;
   import flash.display.Sprite;
   
   use namespace arcane;
   
   public class AmbientShader extends AbstractShader
   {
      
      public var color:uint;
      
      public function AmbientShader(param1:Object = null)
      {
         super(param1);
      }
      
      override public function updateMaterial(param1:Object3D, param2:View3D) : void
      {
      }
      
      protected function clearFaces(param1:Object3D, param2:View3D) : void
      {
         var _loc3_:FaceMaterialVO = null;
         notifyMaterialUpdate();
         for each(_loc3_ in _faceDictionary)
         {
            if(param1 == _loc3_.source)
            {
               if(!_loc3_.cleared)
               {
                  _loc3_.clear();
               }
            }
         }
      }
      
      override public function renderLayer(param1:DrawTriangle, param2:Sprite, param3:int) : int
      {
         var _loc5_:AmbientLight = null;
         super.renderLayer(param1,param2,param3);
         var _loc4_:Array = param1.source.lightarray.ambients;
         for each(_loc5_ in _loc4_)
         {
            if(_lights.numLights > 1)
            {
               _shape = _session.getLightShape(this,param3++,param2,_loc5_);
               _shape.blendMode = blendMode;
               _graphics = _shape.graphics;
            }
            else
            {
               _graphics = param2.graphics;
            }
            _source.session.renderTriangleBitmap(_loc5_.ambientBitmap,_mapping,param1.screenVertices,param1.screenIndices,param1.startIndex,param1.endIndex,smooth,false,_graphics);
         }
         if(debug)
         {
            param1.source.session.renderTriangleLine(0,255,1,param1.screenVertices,param1.screenCommands,param1.screenIndices,param1.startIndex,param1.endIndex);
         }
         return param3;
      }
      
      override protected function renderShader(param1:DrawTriangle) : void
      {
         var _loc3_:AmbientLight = null;
         var _loc4_:Array = null;
         var _loc5_:DirectionalLight = null;
         var _loc2_:Array = _source.lightarray.ambients;
         for each(_loc3_ in _loc2_)
         {
            _faceMaterialVO.bitmap.draw(_loc3_.ambientBitmap,null,null,blendMode);
         }
         _loc4_ = _source.lightarray.directionals;
         for each(_loc5_ in _loc4_)
         {
            _faceMaterialVO.bitmap.draw(_loc5_.ambientBitmap,null,null,blendMode);
         }
      }
   }
}

