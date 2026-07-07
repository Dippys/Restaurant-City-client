package away3d.core.utils
{
   public class Debug
   {
      
      public static var active:Boolean = false;
      
      public static var warningsAsErrors:Boolean = false;
      
      public function Debug()
      {
         super();
      }
      
      public static function warning(param1:Object) : void
      {
         if(warningsAsErrors)
         {
            error(param1);
            return;
         }
         trace("WARNING: " + param1);
      }
      
      public static function trace(param1:Object) : void
      {
         if(active)
         {
            dotrace(param1);
         }
      }
      
      public static function delimiter() : void
      {
      }
      
      public static function clear() : void
      {
      }
      
      public static function error(param1:Object) : void
      {
         trace("ERROR: " + param1);
         throw new Error(param1);
      }
   }
}

function dotrace(param1:Object):void
{
   trace(param1);
}
