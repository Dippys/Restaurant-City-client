package away3d.core.draw
{
   import away3d.core.clip.Clipping;
   import away3d.materials.IFogMaterial;
   
   public class DrawFog extends DrawPrimitive
   {
      
      public var clip:Clipping;
      
      public var material:IFogMaterial;
      
      public function DrawFog()
      {
         super();
      }
      
      override public function render() : void
      {
         material.renderFog(this);
      }
   }
}

