package away3d.animators.data
{
   public class AnimationFrame
   {
      
      public var frame:Number;
      
      public var time:uint;
      
      public var sort:String;
      
      public function AnimationFrame(param1:Number, param2:String = null)
      {
         super();
         this.frame = param1;
         this.sort = param2;
      }
   }
}

