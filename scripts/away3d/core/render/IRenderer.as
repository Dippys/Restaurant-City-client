package away3d.core.render
{
   import away3d.containers.View3D;
   
   public interface IRenderer
   {
      
      function toString() : String;
      
      function render(param1:View3D) : void;
   }
}

