package away3d.core.stats
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class StaticTextField extends TextField
   {
      
      public var defaultText:String;
      
      public function StaticTextField(param1:String = null, param2:TextFormat = null)
      {
         super();
         defaultTextFormat = param2 ? param2 : new TextFormat("Verdana",10,0);
         selectable = false;
         mouseEnabled = false;
         mouseWheelEnabled = false;
         autoSize = "left";
         tabEnabled = false;
         if(param1)
         {
            this.htmlText = param1;
         }
      }
   }
}

