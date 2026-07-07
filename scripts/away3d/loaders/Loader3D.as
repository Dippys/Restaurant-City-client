package away3d.loaders
{
   import away3d.arcane;
   import away3d.containers.ObjectContainer3D;
   import away3d.core.base.Mesh;
   import away3d.core.base.Object3D;
   import away3d.core.utils.IClonable;
   import away3d.core.utils.Init;
   import away3d.events.Loader3DEvent;
   import away3d.events.ParserEvent;
   import away3d.loaders.data.ContainerData;
   import away3d.loaders.data.MaterialData;
   import away3d.loaders.utils.TextureLoadQueue;
   import away3d.loaders.utils.TextureLoader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   use namespace arcane;
   
   public class Loader3D extends ObjectContainer3D
   {
      
      public var autoLoadTextures:Boolean;
      
      private var _IOErrorText:String;
      
      private var _bytesLoaded:int;
      
      private var _loadsuccess:Loader3DEvent;
      
      public var parser:AbstractParser;
      
      public var mode:String;
      
      public const LOADING_GEOMETRY:String = "loading_geometry";
      
      private var _bytesTotal:int;
      
      public const COMPLETE:String = "complete";
      
      public const PARSING_GEOMETRY:String = "parsing_geometry";
      
      private var _urlloader:URLLoader;
      
      public var containerData:ContainerData;
      
      private var _loadQueue:TextureLoadQueue;
      
      private var _object:Object3D;
      
      public var texturePath:String;
      
      private var _loaderror:Loader3DEvent;
      
      private var _result:Object3D;
      
      public var url:String;
      
      private var _loadprogress:Loader3DEvent;
      
      public const LOADING_TEXTURES:String = "loading_textures";
      
      public function Loader3D(param1:Object = null)
      {
         super(param1);
         texturePath = ini.getString("texturePath","");
         autoLoadTextures = ini.getBoolean("autoLoadTextures",true);
         ini.removeFromCheck();
      }
      
      arcane static function loadGeometry(param1:String, param2:Class, param3:Object) : Loader3D
      {
         var _loc4_:Init = Init.parse(param3);
         var _loc5_:Class = _loc4_.getObject("loader") as Class || LoaderCube;
         var _loc6_:Loader3D = new _loc5_(_loc4_);
         _loc6_.loadGeometry(param1,new param2(_loc4_) as AbstractParser);
         return _loc6_;
      }
      
      arcane static function parseGeometry(param1:*, param2:Class, param3:Object) : Loader3D
      {
         var _loc4_:Init = Init.parse(param3);
         var _loc5_:Class = _loc4_.getObject("loader") as Class || LoaderCube;
         var _loc6_:Loader3D = new _loc5_(_loc4_);
         _loc6_.parseGeometry(param1,new param2(_loc4_) as AbstractParser);
         return _loc6_;
      }
      
      public function removeOnSuccess(param1:Function) : void
      {
         removeEventListener(Loader3DEvent.LOAD_SUCCESS,param1,false);
      }
      
      public function addOnSuccess(param1:Function) : void
      {
         addEventListener(Loader3DEvent.LOAD_SUCCESS,param1,false,0,true);
      }
      
      public function addOnError(param1:Function) : void
      {
         addEventListener(Loader3DEvent.LOAD_ERROR,param1,false,0,true);
      }
      
      protected function onTextureProgress(param1:ProgressEvent) : void
      {
         _bytesLoaded = param1.bytesLoaded;
         _bytesTotal = param1.bytesTotal;
         notifyProgress();
         dispatchEvent(param1);
      }
      
      protected function onTextureComplete(param1:Event) : void
      {
         materialLibrary.texturesLoaded(_loadQueue);
         notifySuccess();
      }
      
      protected function notifyProgress() : void
      {
         if(!_loadprogress)
         {
            _loadprogress = new Loader3DEvent(Loader3DEvent.LOAD_PROGRESS,this);
         }
         dispatchEvent(_loadprogress);
      }
      
      protected function onGeometryError(param1:IOErrorEvent) : void
      {
         _IOErrorText = param1.text;
         notifyError();
      }
      
      public function get bytesTotal() : int
      {
         return _bytesTotal;
      }
      
      public function get handle() : Object3D
      {
         return _result || this;
      }
      
      protected function onParserProgress(param1:ParserEvent) : void
      {
         notifyProgress();
      }
      
      protected function onTextureError(param1:IOErrorEvent) : void
      {
         _IOErrorText = param1.text;
         notifyError();
      }
      
      private function initTexturePath() : void
      {
         var _loc1_:Array = null;
         if(texturePath == "" && Boolean(url))
         {
            _loc1_ = url.split("/");
            _loc1_.pop();
            texturePath = _loc1_.length > 0 ? _loc1_.join("/") + "/" : _loc1_.join("/");
         }
      }
      
      protected function onParserComplete(param1:ParserEvent) : void
      {
         _object = param1.result;
         materialLibrary = _object.materialLibrary;
         if(Boolean(materialLibrary) && Boolean(autoLoadTextures) && materialLibrary.loadRequired)
         {
            materialLibrary.texturePath = texturePath;
            loadTextures();
         }
         else
         {
            notifySuccess();
         }
      }
      
      protected function notifyError() : void
      {
         if(!_loaderror)
         {
            _loaderror = new Loader3DEvent(Loader3DEvent.LOAD_ERROR,this);
         }
         dispatchEvent(_loaderror);
      }
      
      protected function onGeometryProgress(param1:ProgressEvent) : void
      {
         _bytesLoaded = param1.bytesLoaded;
         _bytesTotal = param1.bytesTotal;
         notifyProgress();
      }
      
      protected function onGeometryComplete(param1:Event) : void
      {
         parseGeometry(_urlloader.data,parser);
      }
      
      public function get IOErrorText() : String
      {
         return _IOErrorText;
      }
      
      public function get bytesLoaded() : int
      {
         return _bytesLoaded;
      }
      
      protected function onParserError(param1:ParserEvent) : void
      {
         notifyError();
      }
      
      private function registerURL(param1:Object3D) : void
      {
         var _loc2_:Object3D = null;
         if(param1 is ObjectContainer3D)
         {
            for each(_loc2_ in (param1 as ObjectContainer3D).children)
            {
               registerURL(_loc2_);
            }
         }
         else if(param1 is Mesh)
         {
            (param1 as Mesh).url = url;
         }
      }
      
      private function loadTextures() : void
      {
         var _loc1_:MaterialData = null;
         var _loc2_:URLRequest = null;
         var _loc3_:TextureLoader = null;
         mode = LOADING_TEXTURES;
         _loadQueue = new TextureLoadQueue();
         for each(_loc1_ in materialLibrary)
         {
            if(_loc1_.materialType == MaterialData.TEXTURE_MATERIAL && !_loc1_.material)
            {
               _loc2_ = new URLRequest(texturePath + _loc1_.textureFileName);
               _loc3_ = new TextureLoader();
               _loadQueue.addItem(_loc3_,_loc2_);
            }
         }
         _loadQueue.addEventListener(IOErrorEvent.IO_ERROR,onTextureError);
         _loadQueue.addEventListener(ProgressEvent.PROGRESS,onTextureProgress);
         _loadQueue.addEventListener(Event.COMPLETE,onTextureComplete);
         _loadQueue.start();
      }
      
      public function removeOnProgress(param1:Function) : void
      {
         removeEventListener(Loader3DEvent.LOAD_PROGRESS,param1,false);
      }
      
      public function parseGeometry(param1:*, param2:AbstractParser) : void
      {
         mode = PARSING_GEOMETRY;
         initTexturePath();
         this.parser = param2;
         param2.addOnSuccess(onParserComplete);
         param2.addOnError(onParserError);
         param2.addOnProgress(onParserProgress);
         param2.parse(param1);
      }
      
      public function removeOnError(param1:Function) : void
      {
         removeEventListener(Loader3DEvent.LOAD_ERROR,param1,false);
      }
      
      public function addOnProgressr(param1:Function) : void
      {
         addEventListener(Loader3DEvent.LOAD_PROGRESS,param1,false,0,true);
      }
      
      protected function notifySuccess() : void
      {
         mode = COMPLETE;
         ini.addForCheck();
         _result = _object;
         _result.transform = transform;
         _result.name = name;
         _result.ownCanvas = ownCanvas;
         _result.renderer = renderer;
         _result.filters = filters.concat();
         _result.blendMode = blendMode;
         _result.alpha = alpha;
         _result.visible = visible;
         _result.mouseEnabled = mouseEnabled;
         _result.useHandCursor = useHandCursor;
         _result.pushback = pushback;
         _result.pushfront = pushfront;
         _result.screenZOffset = screenZOffset;
         _result.pivotPoint = pivotPoint;
         _result.extra = extra is IClonable ? (extra as IClonable).clone() : extra;
         if(parent != null)
         {
            _result.parent = parent;
            parent = null;
         }
         registerURL(_result);
         if(!_loadsuccess)
         {
            _loadsuccess = new Loader3DEvent(Loader3DEvent.LOAD_SUCCESS,this);
         }
         dispatchEvent(_loadsuccess);
      }
      
      public function loadGeometry(param1:String, param2:AbstractParser) : void
      {
         mode = LOADING_GEOMETRY;
         initTexturePath();
         this.url = param1;
         this.parser = param2;
         _urlloader = new URLLoader();
         _urlloader.dataFormat = param2.binary ? URLLoaderDataFormat.BINARY : URLLoaderDataFormat.TEXT;
         _urlloader.addEventListener(IOErrorEvent.IO_ERROR,onGeometryError);
         _urlloader.addEventListener(ProgressEvent.PROGRESS,onGeometryProgress);
         _urlloader.addEventListener(Event.COMPLETE,onGeometryComplete);
         _urlloader.load(new URLRequest(param1));
      }
   }
}

