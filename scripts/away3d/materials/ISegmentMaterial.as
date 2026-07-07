package away3d.materials
{
   import away3d.core.draw.DrawSegment;
   
   public interface ISegmentMaterial extends IMaterial
   {
      
      function renderSegment(param1:DrawSegment) : void;
   }
}

