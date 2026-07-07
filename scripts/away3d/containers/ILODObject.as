package away3d.containers
{
   import away3d.cameras.Camera3D;
   
   public interface ILODObject
   {
      
      function matchLOD(param1:Camera3D) : Boolean;
   }
}

