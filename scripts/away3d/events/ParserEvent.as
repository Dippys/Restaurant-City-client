package away3d.events
{
   import away3d.core.base.Object3D;
   import away3d.loaders.AbstractParser;
   import flash.events.Event;
   
   public class ParserEvent extends Event
   {
      
      public static const PARSE_SUCCESS:String = "parseSuccess";
      
      public static const PARSE_ERROR:String = "parseError";
      
      public static const PARSE_PROGRESS:String = "parseProgress";
      
      public var result:Object3D;
      
      public var parser:AbstractParser;
      
      public function ParserEvent(param1:String, param2:AbstractParser, param3:Object3D)
      {
         super(param1);
         this.parser = param2;
         this.result = param3;
      }
      
      override public function clone() : Event
      {
         return new ParserEvent(type,parser,result);
      }
   }
}

