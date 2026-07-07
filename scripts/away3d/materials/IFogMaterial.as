package away3d.materials
{
   import away3d.core.draw.DrawFog;
   
   public interface IFogMaterial extends ITriangleMaterial
   {
      
      function renderFog(param1:DrawFog) : void;
      
      function set alpha(param1:Number) : void;
      
      function clone() : IFogMaterial;
      
      function get alpha() : Number;
   }
}

