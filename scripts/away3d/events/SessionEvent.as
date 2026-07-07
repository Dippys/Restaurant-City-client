package away3d.events
{
   import away3d.core.render.AbstractRenderSession;
   import flash.events.Event;
   
   public class SessionEvent extends Event
   {
      
      public static const SESSION_UPDATED:String = "sessionUpdated";
      
      public var session:AbstractRenderSession;
      
      public function SessionEvent(param1:String, param2:AbstractRenderSession)
      {
         super(param1);
         this.session = param2;
      }
      
      override public function clone() : Event
      {
         return new SessionEvent(type,session);
      }
   }
}

