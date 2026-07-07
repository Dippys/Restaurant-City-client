package away3d.core.utils
{
   import away3d.containers.View3D;
   import away3d.core.base.Object3D;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class FaceMaterialVO
   {
      
      public var invtexturemapping:Matrix;
      
      public var width:int;
      
      public var invalidated:Boolean = true;
      
      public var backface:Boolean = false;
      
      public var texturemapping:Matrix;
      
      public var source:Object3D;
      
      public var color:uint;
      
      public var view:View3D;
      
      public var height:int;
      
      public var cleared:Boolean = true;
      
      public var bitmap:BitmapData;
      
      public var resized:Boolean;
      
      public var updated:Boolean = false;
      
      public function FaceMaterialVO(param1:Object3D = null, param2:View3D = null)
      {
         super();
         this.source = param1;
         this.view = param2;
      }
      
      public function clear() : void
      {
         cleared = true;
         updated = true;
      }
      
      public function resize(param1:Number, param2:Number, param3:Boolean = true) : void
      {
         if(this.width == param1 && this.height == param2)
         {
            return;
         }
         resized = true;
         updated = true;
         this.width = param1;
         this.height = param2;
         this.color = color;
         if(bitmap)
         {
            bitmap.dispose();
         }
         bitmap = new BitmapData(param1,param2,param3,0);
         bitmap.lock();
      }
   }
}

