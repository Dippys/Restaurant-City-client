package away3d.core.base
{
   public class AnimationTransition
   {
      
      private var _interpolate:Number;
      
      private var _steps:Number = 0.1;
      
      private var _refFrame:Array;
      
      private var _geom:Geometry;
      
      private var _transitionvalue:Number = 10;
      
      public function AnimationTransition(param1:Geometry)
      {
         super();
         _interpolate = 1;
         _geom = param1;
         setRef();
      }
      
      public function get interpolate() : Number
      {
         return _interpolate;
      }
      
      public function update() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(_interpolate < 1)
         {
            _loc1_ = 1 - _interpolate;
            _loc2_ = int(_refFrame.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _geom.vertices[_loc3_].x = _refFrame[_loc3_].x * _loc1_ + _geom.vertices[_loc3_].x * _interpolate;
               _geom.vertices[_loc3_].y = _refFrame[_loc3_].y * _loc1_ + _geom.vertices[_loc3_].y * _interpolate;
               _geom.vertices[_loc3_].z = _refFrame[_loc3_].z * _loc1_ + _geom.vertices[_loc3_].z * _interpolate;
               _loc3_++;
            }
            _interpolate += _steps;
         }
      }
      
      private function updateRef() : void
      {
         var _loc1_:int = int(_refFrame.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _refFrame[_loc2_].x = _geom.vertices[_loc2_].x;
            _refFrame[_loc2_].y = _geom.vertices[_loc2_].y;
            _refFrame[_loc2_].z = _geom.vertices[_loc2_].z;
            _loc2_++;
         }
      }
      
      public function reset() : void
      {
         updateRef();
         _interpolate = _steps;
      }
      
      private function setRef() : void
      {
         _refFrame = [];
         var _loc1_:int = int(_geom.vertices.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _refFrame.push(new Vertex(_geom.vertices[_loc2_].x,_geom.vertices[_loc2_].y,_geom.vertices[_loc2_].z));
            _loc2_++;
         }
      }
      
      public function set transitionValue(param1:Number) : void
      {
         _transitionvalue = param1 < 1 ? 1 : param1;
         _steps = 1 / param1;
      }
      
      public function get transitionValue() : Number
      {
         return _transitionvalue;
      }
   }
}

