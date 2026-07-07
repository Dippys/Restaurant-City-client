package away3d.loaders
{
   import away3d.materials.MovieMaterial;
   import away3d.primitives.Cube;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class LoaderCube extends Loader3D
   {
      
      private var parsingTitle:String;
      
      public var geometryTitle:String;
      
      private var tf:TextFormat;
      
      private var _loadersize:Number;
      
      private var cube:Cube;
      
      private var side:MovieClip;
      
      private var info:TextField;
      
      private var textureTitle:String;
      
      public function LoaderCube(param1:Object = null)
      {
         super(param1);
         side = new MovieClip();
         var _loc2_:Graphics = side.graphics;
         _loc2_.lineStyle(1,16777215);
         _loc2_.drawCircle(100,100,100);
         info = new TextField();
         info.width = 200;
         info.height = 200;
         tf = new TextFormat();
         tf.size = 24;
         tf.color = 65535;
         tf.bold = true;
         info.wordWrap = true;
         side.addChild(info);
         geometryTitle = ini.getString("geometrytitle","Loading Geometry...");
         textureTitle = ini.getString("texturetitle","Loading Texture...");
         parsingTitle = ini.getString("parsingtitle","Parsing Geometry...");
         _loadersize = ini.getNumber("loadersize",200);
         addChild(cube = new Cube({
            "material":new MovieMaterial(side,{
               "transparent":true,
               "smooth":true
            }),
            "width":_loadersize,
            "height":_loadersize,
            "depth":_loadersize
         }));
      }
      
      override protected function notifyError() : void
      {
         super.notifyError();
         if(mode == LOADING_GEOMETRY)
         {
            info.text = geometryTitle + "\n" + IOErrorText;
         }
         else if(mode == PARSING_GEOMETRY)
         {
            info.text = parsingTitle + "\n" + parser;
         }
         else if(mode == LOADING_TEXTURES)
         {
            info.text = textureTitle + "\n" + IOErrorText;
         }
         info.setTextFormat(tf);
         var _loc1_:Graphics = side.graphics;
         _loc1_.beginFill(16711680);
         _loc1_.drawRect(0,0,200,200);
         _loc1_.endFill();
      }
      
      public function set loadersize(param1:Number) : void
      {
         if(_loadersize == param1)
         {
            return;
         }
         _loadersize = param1;
         cube.width = _loadersize;
         cube.depth = _loadersize;
         cube.height = _loadersize;
      }
      
      public function get loadersize() : Number
      {
         return _loadersize;
      }
      
      override protected function notifyProgress() : void
      {
         var _loc1_:Graphics = null;
         super.notifyProgress();
         if(mode == LOADING_GEOMETRY)
         {
            info.text = geometryTitle + "\n" + bytesLoaded + " of " + bytesTotal + " bytes";
         }
         else if(mode == PARSING_GEOMETRY)
         {
            info.text = parsingTitle + "\n" + parser.parsedChunks + " of " + parser.totalChunks + " chunks";
         }
         else if(mode == LOADING_TEXTURES)
         {
            info.text = textureTitle + "\n" + bytesLoaded + " of " + bytesTotal + " bytes";
         }
         info.setTextFormat(tf);
         if(mode == LOADING_GEOMETRY || mode == LOADING_TEXTURES)
         {
            _loc1_ = side.graphics;
            _loc1_.lineStyle(1,8421504);
            _loc1_.drawCircle(100,100,100 * bytesLoaded / bytesTotal);
         }
      }
   }
}

