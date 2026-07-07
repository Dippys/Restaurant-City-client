package away3d.primitives
{
   import away3d.arcane;
   import away3d.core.base.*;
   
   use namespace arcane;
   
   public class WireSphere extends AbstractPrimitive
   {
      
      private var grid:Array;
      
      private var _segmentsH:int;
      
      private var _radius:Number;
      
      private var _yUp:Boolean;
      
      private var _segmentsW:int;
      
      public function WireSphere(param1:Object = null)
      {
         super(param1);
         _radius = ini.getNumber("radius",100,{"min":0});
         _segmentsW = ini.getInt("segmentsW",8,{"min":3});
         _segmentsH = ini.getInt("segmentsH",6,{"min":2});
         _yUp = ini.getBoolean("yUp",true);
         type = "WireSphere";
         url = "primitive";
      }
      
      override protected function buildPrimitive() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Vertex = null;
         var _loc12_:Vertex = null;
         var _loc13_:Vertex = null;
         var _loc14_:Vertex = null;
         super.buildPrimitive();
         grid = new Array(_segmentsH + 1);
         var _loc3_:Vertex = _yUp ? createVertex(0,-_radius,0) : createVertex(0,0,-_radius);
         grid[0] = new Array(_segmentsW);
         _loc1_ = 0;
         while(_loc1_ < _segmentsW)
         {
            grid[0][_loc1_] = _loc3_;
            _loc1_++;
         }
         _loc2_ = 1;
         while(_loc2_ < _segmentsH)
         {
            _loc5_ = _loc2_ / _segmentsH * Math.PI;
            _loc6_ = -_radius * Math.cos(_loc5_);
            _loc7_ = _radius * Math.sin(_loc5_);
            grid[_loc2_] = new Array(_segmentsW);
            _loc1_ = 0;
            while(_loc1_ < _segmentsW)
            {
               _loc8_ = 2 * _loc1_ / _segmentsW * Math.PI;
               _loc9_ = _loc7_ * Math.sin(_loc8_);
               _loc10_ = _loc7_ * Math.cos(_loc8_);
               if(_yUp)
               {
                  grid[_loc2_][_loc1_] = createVertex(_loc10_,_loc6_,_loc9_);
               }
               else
               {
                  grid[_loc2_][_loc1_] = createVertex(_loc10_,-_loc9_,_loc6_);
               }
               _loc1_++;
            }
            _loc2_++;
         }
         var _loc4_:Vertex = _yUp ? createVertex(0,_radius,0) : createVertex(0,0,_radius);
         grid[_segmentsH] = new Array(_segmentsW);
         _loc1_ = 0;
         while(_loc1_ < _segmentsW)
         {
            grid[_segmentsH][_loc1_] = _loc4_;
            _loc1_++;
         }
         _loc2_ = 1;
         while(_loc2_ <= _segmentsH)
         {
            _loc1_ = 0;
            while(_loc1_ < _segmentsW)
            {
               _loc11_ = grid[_loc2_][_loc1_];
               _loc12_ = grid[_loc2_][(_loc1_ - 1 + _segmentsW) % _segmentsW];
               _loc13_ = grid[_loc2_ - 1][(_loc1_ - 1 + _segmentsW) % _segmentsW];
               _loc14_ = grid[_loc2_ - 1][_loc1_];
               addSegment(createSegment(_loc11_,_loc14_));
               addSegment(createSegment(_loc12_,_loc13_));
               if(_loc2_ < _segmentsH)
               {
                  addSegment(createSegment(_loc11_,_loc12_));
               }
               _loc1_++;
            }
            _loc2_++;
         }
      }
      
      public function set radius(param1:Number) : void
      {
         if(_radius == param1)
         {
            return;
         }
         _radius = param1;
         _primitiveDirty = true;
      }
      
      public function get segmentsH() : Number
      {
         return _segmentsH;
      }
      
      public function vertex(param1:int, param2:int) : Vertex
      {
         if(_primitiveDirty)
         {
            updatePrimitive();
         }
         return grid[param2][param1];
      }
      
      public function set segmentsW(param1:Number) : void
      {
         if(_segmentsW == param1)
         {
            return;
         }
         _segmentsW = param1;
         _primitiveDirty = true;
      }
      
      public function set yUp(param1:Boolean) : void
      {
         if(_yUp == param1)
         {
            return;
         }
         _yUp = param1;
         _primitiveDirty = true;
      }
      
      public function get radius() : Number
      {
         return _radius;
      }
      
      public function get yUp() : Boolean
      {
         return _yUp;
      }
      
      public function get segmentsW() : Number
      {
         return _segmentsW;
      }
      
      public function set segmentsH(param1:Number) : void
      {
         if(_segmentsH == param1)
         {
            return;
         }
         _segmentsH = param1;
         _primitiveDirty = true;
      }
   }
}

