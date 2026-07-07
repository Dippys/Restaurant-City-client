package away3d.materials
{
   import away3d.containers.View3D;
   import away3d.core.base.Object3D;
   
   public interface IMaterial
   {
      
      function updateMaterial(param1:Object3D, param2:View3D) : void;
      
      function get visible() : Boolean;
      
      function addOnMaterialUpdate(param1:Function) : void;
      
      function removeOnMaterialUpdate(param1:Function) : void;
      
      function get id() : int;
   }
}

