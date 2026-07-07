package away3d.core.utils
{
   import flash.display.BitmapData;
   import flash.filters.BlurFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   
   public class DofCache
   {
      
      public static var focus:Number;
      
      public static var aperture:Number = 22;
      
      public static var maxblur:Number = 150;
      
      public static var doflevels:Number = 16;
      
      public static var usedof:Boolean = false;
      
      private static var caches:Dictionary = new Dictionary();
      
      private var minBitmap:BitmapData;
      
      private var maxBitmap:BitmapData;
      
      private var bitmaps:Array;
      
      private var levels:Number;
      
      public function DofCache(param1:Number, param2:BitmapData)
      {
         var _loc6_:BlurFilter = null;
         var _loc7_:int = 0;
         var _loc8_:BitmapData = null;
         super();
         this.levels = param1;
         var _loc3_:Matrix = new Matrix();
         var _loc4_:Point = new Point(0,0);
         bitmaps = new Array(param1);
         var _loc5_:Number = 0;
         while(_loc5_ < param1)
         {
            _loc6_ = new BlurFilter(2 + maxblur * _loc5_ / param1,2 + maxblur * _loc5_ / param1,4);
            _loc3_.identity();
            _loc7_ = param2.width * (1 + _loc5_ / (param1 / 2));
            _loc3_.translate(-param2.width / 2,-param2.height / 2);
            _loc3_.translate(_loc7_ / 2,_loc7_ / 2);
            _loc8_ = new BitmapData(_loc7_,_loc7_,true,0);
            _loc8_.draw(param2,_loc3_);
            _loc8_.applyFilter(_loc8_,_loc8_.rect,_loc4_,_loc6_);
            bitmaps[_loc5_] = _loc8_;
            _loc5_++;
         }
         minBitmap = bitmaps[0];
         maxBitmap = bitmaps[bitmaps.length - 1];
      }
      
      public static function resetDof(param1:Boolean) : void
      {
         var _loc2_:DofCache = null;
         usedof = param1;
         for each(_loc2_ in caches)
         {
            if(!param1)
            {
               _loc2_ = new DofCache(1,_loc2_.bitmaps[0]);
            }
            else
            {
               _loc2_ = new DofCache(doflevels,_loc2_.bitmaps[0]);
            }
         }
      }
      
      public static function getDofCache(param1:BitmapData) : DofCache
      {
         if(caches[param1] == null)
         {
            if(!usedof)
            {
               caches[param1] = new DofCache(1,param1);
            }
            else
            {
               caches[param1] = new DofCache(doflevels,param1);
            }
         }
         return caches[param1];
      }
      
      public function getBitmap(param1:Number) : BitmapData
      {
         var _loc2_:Number = focus - param1;
         if(focus - param1 < 0)
         {
            _loc2_ = -_loc2_;
         }
         _loc2_ /= aperture;
         _loc2_ = Math.floor(_loc2_);
         if(_loc2_ > levels - 1)
         {
            return maxBitmap;
         }
         if(_loc2_ < 0)
         {
            return minBitmap;
         }
         return bitmaps[_loc2_];
      }
   }
}

