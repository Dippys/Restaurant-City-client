package away3d.cameras.lenses
{
   import away3d.containers.View3D;
   import away3d.core.base.Object3D;
   import away3d.core.geom.Frustum;
   import away3d.core.math.Matrix3D;
   
   public interface ILens
   {
      
      function project(param1:Matrix3D, param2:Array, param3:Array) : void;
      
      function get far() : Number;
      
      function getFOV() : Number;
      
      function get near() : Number;
      
      function getZoom() : Number;
      
      function getFrustum(param1:Object3D, param2:Matrix3D) : Frustum;
      
      function getPerspective(param1:Number) : Number;
      
      function setView(param1:View3D) : void;
   }
}

