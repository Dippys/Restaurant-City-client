package away3d.animators.data
{
   public class AnimationGroup
   {
      
      public var playlist:Array;
      
      public var loop:Boolean;
      
      public var fps:uint;
      
      public var loopLast:Boolean;
      
      public function AnimationGroup(param1:Array = null, param2:Boolean = false)
      {
         super();
         this.playlist = param1;
         this.loopLast = param2;
      }
   }
}

