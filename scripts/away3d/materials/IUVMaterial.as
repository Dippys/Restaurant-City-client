package away3d.materials
{
   import away3d.containers.View3D;
   import away3d.core.base.Object3D;
   import away3d.core.utils.FaceMaterialVO;
   import away3d.core.utils.FaceVO;
   import flash.display.BitmapData;
   
   public interface IUVMaterial extends IMaterial
   {
      
      function getFaceMaterialVO(param1:FaceVO, param2:Object3D = null, param3:View3D = null) : FaceMaterialVO;
      
      function getPixel32(param1:Number, param2:Number) : uint;
      
      function get height() : Number;
      
      function clearFaces(param1:Object3D = null, param2:View3D = null) : void;
      
      function invalidateFaces(param1:Object3D = null, param2:View3D = null) : void;
      
      function get width() : Number;
      
      function get bitmap() : BitmapData;
   }
}

