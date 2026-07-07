package away3d.materials
{
   import away3d.core.draw.DrawTriangle;
   
   public interface ITriangleMaterial extends IMaterial
   {
      
      function renderTriangle(param1:DrawTriangle) : void;
   }
}

