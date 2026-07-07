package away3d.core.utils
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class ValueObject extends EventDispatcher
   {
      
      private static var changed:Event;
      
      public function ValueObject()
      {
         super();
      }
      
      public function addOnChange(param1:Function) : void
      {
         addEventListener("changed",param1,false,0,true);
      }
      
      protected function notifyChange() : void
      {
         if(!hasEventListener("changed"))
         {
            return;
         }
         if(changed == null)
         {
            changed = new Event("changed");
         }
         dispatchEvent(changed);
      }
      
      public function removeOnChange(param1:Function) : void
      {
         removeEventListener("changed",param1,false);
      }
   }
}

