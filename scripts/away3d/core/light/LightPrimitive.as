package away3d.core.light
{
   import flash.display.BitmapData;
   
   public class LightPrimitive
   {
      
      public var green:Number;
      
      public var specular:Number;
      
      public var red:Number;
      
      public var radius:Number;
      
      public var ambient:Number;
      
      public var specularBitmap:BitmapData;
      
      public var blue:Number;
      
      public var ambientBitmap:BitmapData;
      
      public var diffuse:Number;
      
      public var diffuseBitmap:BitmapData;
      
      public var ambientDiffuseBitmap:BitmapData;
      
      public var fallOff:Number;
      
      public function LightPrimitive()
      {
         super();
      }
   }
}

