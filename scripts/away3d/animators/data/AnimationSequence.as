package away3d.animators.data
{
   public class AnimationSequence
   {
      
      public var prefix:String;
      
      public var loop:Boolean;
      
      public var fps:Number;
      
      public var smooth:Boolean;
      
      public function AnimationSequence(param1:String, param2:Boolean = true, param3:Boolean = false, param4:Number = 3)
      {
         super();
         this.prefix = param1 == null ? "" : param1;
         this.smooth = param2;
         this.loop = param3;
         this.fps = param4;
         if(this.prefix == "")
         {
            trace("Prefix is null, this might cause enter endless loop");
         }
      }
   }
}

