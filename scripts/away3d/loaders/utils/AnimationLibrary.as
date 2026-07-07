package away3d.loaders.utils
{
   import away3d.core.utils.Debug;
   import away3d.loaders.data.*;
   import flash.utils.Dictionary;
   
   public dynamic class AnimationLibrary extends Dictionary
   {
      
      public function AnimationLibrary()
      {
         super();
      }
      
      public function addAnimation(param1:String) : AnimationData
      {
         if(this[param1])
         {
            return this[param1];
         }
         var _loc2_:AnimationData = new AnimationData();
         this[_loc2_.name = param1] = _loc2_;
         return _loc2_;
      }
      
      public function getAnimation(param1:String) : AnimationData
      {
         if(this[param1])
         {
            return this[param1];
         }
         Debug.warning("Animation \'" + param1 + "\' does not exist");
         return null;
      }
   }
}

