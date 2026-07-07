package away3d.core.filter
{
   import away3d.cameras.Camera3D;
   import away3d.containers.Scene3D;
   import away3d.core.clip.Clipping;
   
   public interface IPrimitiveFilter
   {
      
      function filter(param1:Array, param2:Scene3D, param3:Camera3D, param4:Clipping) : Array;
   }
}

