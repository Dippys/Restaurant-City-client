package away3d.sprites
{
   import away3d.core.base.*;
   import away3d.core.project.*;
   import away3d.core.utils.*;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   
   public class DirSprite2D extends Object3D
   {
      
      public var deltaZ:Number;
      
      private var _bitmaps:Dictionary;
      
      public var scaling:Number;
      
      public var smooth:Boolean;
      
      private var _vertices:Array;
      
      public var rotation:Number;
      
      public function DirSprite2D(param1:Object = null)
      {
         var _loc3_:Init = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:BitmapData = null;
         _vertices = [];
         _bitmaps = new Dictionary(true);
         super(param1);
         scaling = ini.getNumber("scaling",1,{"min":0});
         rotation = ini.getNumber("rotation",0);
         smooth = ini.getBoolean("smooth",false);
         deltaZ = ini.getNumber("deltaZ",0);
         var _loc2_:Array = ini.getArray("bitmaps");
         for each(_loc3_ in _loc2_)
         {
            _loc3_ = Init.parse(_loc3_);
            _loc4_ = _loc3_.getNumber("x",0);
            _loc5_ = _loc3_.getNumber("y",0);
            _loc6_ = _loc3_.getNumber("z",0);
            _loc7_ = _loc3_.getBitmap("bitmap");
            add(_loc4_,_loc5_,_loc6_,_loc7_);
         }
         projectorType = ProjectorType.DIR_SPRITE;
      }
      
      public function add(param1:Number, param2:Number, param3:Number, param4:BitmapData) : void
      {
         var _loc6_:Vertex = null;
         if(param4)
         {
            for each(_loc6_ in _vertices)
            {
               if(_loc6_.x == param1 && _loc6_.y == param2 && _loc6_.z == param3)
               {
                  Debug.warning("Same base point for two bitmaps: " + _loc6_);
                  return;
               }
            }
         }
         var _loc5_:Vertex = new Vertex(param1,param2,param3);
         _vertices.push(_loc5_);
         _bitmaps[_loc5_] = param4;
      }
      
      public function get bitmaps() : Dictionary
      {
         return _bitmaps;
      }
      
      public function get vertices() : Array
      {
         return _vertices;
      }
   }
}

