package away3d.materials
{
   import away3d.core.draw.DrawBillboard;
   
   public interface IBillboardMaterial extends IMaterial
   {
      
      function renderBillboard(param1:DrawBillboard) : void;
   }
}

