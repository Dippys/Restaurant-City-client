package away3d.animators
{
   import away3d.containers.ObjectContainer3D;
   
   public interface IMeshAnimation
   {
      
      function update(param1:Number, param2:Boolean = true) : void;
      
      function clone(param1:ObjectContainer3D) : IMeshAnimation;
   }
}

