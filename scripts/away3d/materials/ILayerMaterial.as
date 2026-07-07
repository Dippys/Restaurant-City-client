package away3d.materials
{
   import away3d.core.draw.DrawTriangle;
   import away3d.core.utils.FaceMaterialVO;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public interface ILayerMaterial extends IMaterial
   {
      
      function renderLayer(param1:DrawTriangle, param2:Sprite, param3:int) : int;
      
      function renderBitmapLayer(param1:DrawTriangle, param2:Rectangle, param3:FaceMaterialVO) : FaceMaterialVO;
   }
}

