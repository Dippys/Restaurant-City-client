package away3d.loaders.utils
{
   import away3d.core.utils.Debug;
   import away3d.loaders.data.*;
   import away3d.materials.*;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   
   public dynamic class MaterialLibrary extends Dictionary
   {
      
      public var texturePath:String;
      
      public var loadRequired:Boolean;
      
      private var length:int = 0;
      
      public function MaterialLibrary()
      {
         super();
      }
      
      public function texturesLoaded(param1:TextureLoadQueue) : void
      {
         var images:Array;
         var _materialData:MaterialData = null;
         var _image:TextureLoader = null;
         var loadQueue:TextureLoadQueue = param1;
         loadRequired = false;
         images = loadQueue.images;
         for each(_materialData in this)
         {
            for each(_image in images)
            {
               if(texturePath + _materialData.textureFileName == _image.filename)
               {
                  _materialData.textureBitmap = new BitmapData(_image.width,_image.height,true,16777215);
                  _materialData.textureBitmap.draw(_image);
                  _materialData.material = new BitmapMaterial(_materialData.textureBitmap);
               }
            }
         }
      }
      
      public function addMaterial(param1:String) : MaterialData
      {
         if(this[param1])
         {
            return this[param1];
         }
         ++length;
         var _loc2_:MaterialData = new MaterialData();
         this[_loc2_.name = param1] = _loc2_;
         return _loc2_;
      }
      
      public function getMaterial(param1:String) : MaterialData
      {
         if(this[param1])
         {
            return this[param1];
         }
         Debug.warning("Material \'" + param1 + "\' does not exist");
         return null;
      }
   }
}

