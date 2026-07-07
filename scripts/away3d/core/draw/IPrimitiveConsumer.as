package away3d.core.draw
{
   import away3d.containers.View3D;
   
   public interface IPrimitiveConsumer
   {
      
      function clone() : IPrimitiveConsumer;
      
      function clear(param1:View3D) : void;
      
      function list() : Array;
      
      function primitive(param1:DrawPrimitive) : Boolean;
   }
}

