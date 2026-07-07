package away3d.core.draw
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class DrawScaledBitmap extends DrawPrimitive
   {
      
      private var cos:Number;
      
      public var bottomleftx:Number;
      
      private var sinh:Number;
      
      public var bottomlefty:Number;
      
      public var toplefty:Number;
      
      private var pointMapping:Matrix;
      
      private var sinw:Number;
      
      public var topleftx:Number;
      
      public var smooth:Boolean;
      
      public var bitmap:BitmapData;
      
      private var height:Number;
      
      private var cosh:Number;
      
      public var vx:Number;
      
      public var vy:Number;
      
      public var vz:Number;
      
      private var width:Number;
      
      public var bottomrightx:Number;
      
      public var bottomrighty:Number;
      
      public var scale:Number;
      
      private var mapping:Matrix = new Matrix();
      
      private var cosw:Number;
      
      private var sin:Number;
      
      public var toprightx:Number;
      
      public var toprighty:Number;
      
      public var rotation:Number;
      
      public function DrawScaledBitmap()
      {
         super();
      }
      
      override public function render() : void
      {
         source.session.renderScaledBitmap(this,bitmap,mapping,smooth);
      }
      
      override public function contains(param1:Number, param2:Number) : Boolean
      {
         if(rotation != 0)
         {
            if(topleftx * (param2 - toprighty) + toprightx * (toplefty - param2) + param1 * (toprighty - toplefty) > 0.001)
            {
               return false;
            }
            if(toprightx * (param2 - bottomrighty) + bottomrightx * (toprighty - param2) + param1 * (bottomrighty - toprighty) > 0.001)
            {
               return false;
            }
            if(bottomrightx * (param2 - bottomlefty) + bottomleftx * (bottomrighty - param2) + param1 * (bottomlefty - bottomrighty) > 0.001)
            {
               return false;
            }
            if(bottomleftx * (param2 - toplefty) + topleftx * (bottomlefty - param2) + param1 * (toplefty - bottomlefty) > 0.001)
            {
               return false;
            }
         }
         if(!bitmap.transparent)
         {
            return true;
         }
         pointMapping = mapping.clone();
         pointMapping.invert();
         var _loc3_:Point = pointMapping.transformPoint(new Point(param1,param2));
         if(_loc3_.x < 0)
         {
            _loc3_.x = 0;
         }
         if(_loc3_.y < 0)
         {
            _loc3_.y = 0;
         }
         if(_loc3_.x >= bitmap.width)
         {
            _loc3_.x = bitmap.width - 1;
         }
         if(_loc3_.y >= bitmap.height)
         {
            _loc3_.y = bitmap.height - 1;
         }
         var _loc4_:uint = bitmap.getPixel32(int(_loc3_.x),int(_loc3_.y));
         return uint(_loc4_ >> 24) > 128;
      }
      
      override public function clear() : void
      {
         bitmap = null;
      }
      
      override public function calc() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         screenZ = vz;
         minZ = screenZ;
         maxZ = screenZ;
         width = bitmap.width * scale;
         height = bitmap.height * scale;
         if(rotation != 0)
         {
            cos = Math.cos(rotation * Math.PI / 180);
            sin = Math.sin(rotation * Math.PI / 180);
            cosw = cos * width / 2;
            cosh = cos * height / 2;
            sinw = sin * width / 2;
            sinh = sin * height / 2;
            topleftx = vx - cosw - sinh;
            toplefty = vy + sinw - cosh;
            toprightx = vx + cosw - sinh;
            toprighty = vy - sinw - cosh;
            bottomleftx = vx - cosw + sinh;
            bottomlefty = vy + sinw + cosh;
            bottomrightx = vx + cosw + sinh;
            bottomrighty = vy - sinw + cosh;
            _loc1_ = [];
            _loc1_.push(topleftx);
            _loc1_.push(toprightx);
            _loc1_.push(bottomleftx);
            _loc1_.push(bottomrightx);
            minX = 100000;
            maxX = -100000;
            for each(_loc2_ in _loc1_)
            {
               if(minX > _loc2_)
               {
                  minX = _loc2_;
               }
               if(maxX < _loc2_)
               {
                  maxX = _loc2_;
               }
            }
            _loc3_ = [];
            _loc3_.push(toplefty);
            _loc3_.push(toprighty);
            _loc3_.push(bottomlefty);
            _loc3_.push(bottomrighty);
            minY = 100000;
            maxY = -100000;
            for each(_loc4_ in _loc3_)
            {
               if(minY > _loc4_)
               {
                  minY = _loc4_;
               }
               if(maxY < _loc4_)
               {
                  maxY = _loc4_;
               }
            }
            mapping.a = scale * cos;
            mapping.b = -scale * sin;
            mapping.c = scale * sin;
            mapping.d = scale * cos;
            mapping.tx = topleftx;
            mapping.ty = toplefty;
         }
         else
         {
            topleftx = vx - width / 2;
            toplefty = vy - height / 2;
            toprightx = topleftx + width;
            toprighty = toplefty;
            bottomleftx = topleftx;
            bottomlefty = toplefty + height;
            bottomrightx = toprightx;
            bottomrighty = bottomlefty;
            minX = topleftx;
            minY = toplefty;
            maxX = bottomrightx;
            maxY = bottomrighty;
            mapping.a = mapping.d = scale;
            mapping.c = mapping.b = 0;
            mapping.tx = topleftx;
            mapping.ty = toplefty;
         }
      }
   }
}

