package away3d.core.light
{
   import away3d.lights.AmbientLight3D;
   import flash.display.BitmapData;
   
   public class AmbientLight extends LightPrimitive
   {
      
      public var light:AmbientLight3D;
      
      public function AmbientLight()
      {
         super();
      }
      
      public function updateAmbientBitmap(param1:Number) : void
      {
         this.ambient = param1;
         ambientBitmap = new BitmapData(256,256,false,int(param1 * red << 16) | int(param1 * green << 8) | int(param1 * blue));
         ambientBitmap.lock();
      }
   }
}

