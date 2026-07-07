package away3d.events
{
   import away3d.core.base.Animation;
   import flash.events.Event;
   
   public class AnimationEvent extends Event
   {
      
      public static const CYCLE:String = "cycle";
      
      public static const SEQUENCE_UPDATE:String = "sequenceUpdate";
      
      public static const SEQUENCE_DONE:String = "sequenceDone";
      
      public var animation:Animation;
      
      public function AnimationEvent(param1:String, param2:Animation)
      {
         super(param1);
         this.animation = param2;
      }
      
      override public function clone() : Event
      {
         return new AnimationEvent(type,animation);
      }
   }
}

