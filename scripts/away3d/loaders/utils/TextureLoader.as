package away3d.loaders.utils
{
   import flash.display.Loader;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class TextureLoader extends Loader
   {
      
      private var _filename:String;
      
      public function TextureLoader()
      {
         super();
      }
      
      override public function load(param1:URLRequest, param2:LoaderContext = null) : void
      {
         _filename = param1.url;
         super.load(param1,param2);
      }
      
      public function get filename() : String
      {
         return _filename;
      }
   }
}

