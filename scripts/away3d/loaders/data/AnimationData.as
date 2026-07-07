package away3d.loaders.data
{
   import away3d.animators.IMeshAnimation;
   import away3d.containers.ObjectContainer3D;
   import away3d.core.base.Object3D;
   import flash.utils.Dictionary;
   
   public class AnimationData
   {
      
      public static const VERTEX_ANIMATION:String = "vertexAnimation";
      
      public static const SKIN_ANIMATION:String = "skinAnimation";
      
      public var start:Number = Infinity;
      
      public var animation:IMeshAnimation;
      
      public var channels:Dictionary = new Dictionary(true);
      
      public var name:String;
      
      public var end:Number = 0;
      
      public var animationType:String = "skinAnimation";
      
      public function AnimationData()
      {
         super();
      }
      
      public function clone(param1:Object3D) : AnimationData
      {
         var _loc2_:AnimationData = param1.animationLibrary.addAnimation(name);
         _loc2_.start = start;
         _loc2_.end = end;
         _loc2_.animationType = animationType;
         _loc2_.animation = animation.clone(param1 as ObjectContainer3D);
         return _loc2_;
      }
   }
}

