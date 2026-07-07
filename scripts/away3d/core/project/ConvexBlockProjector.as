package away3d.core.project
{
   import away3d.blockers.*;
   import away3d.cameras.*;
   import away3d.cameras.lenses.*;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.block.*;
   import away3d.core.draw.*;
   import away3d.core.math.*;
   import away3d.core.utils.*;
   import flash.utils.*;
   
   public class ConvexBlockProjector implements IBlockerProvider, IPrimitiveProvider
   {
      
      private var _points:Array = [];
      
      private var _view:View3D;
      
      private var _baseIndex:Number;
      
      private var _camera:Camera3D;
      
      private var _pointsN:Array = [];
      
      private var _pointsS:Array = [];
      
      private var _index:int;
      
      private var _vertices:Array;
      
      private var _lens:ILens;
      
      private var _screenVertices:Array;
      
      private var _convexBlock:ConvexBlock;
      
      private var _baseX:Number;
      
      private var _baseY:Number;
      
      private var _i:int;
      
      private var _screenX:Number;
      
      private var _screenY:Number;
      
      private var _baseZ:Number;
      
      private var _s:String;
      
      private var _p:String;
      
      private var _drawPrimitiveStore:DrawPrimitiveStore;
      
      public function ConvexBlockProjector()
      {
         super();
      }
      
      private function cross(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Number
      {
         return (param3 - param1) * (param6 - param2) - (param5 - param1) * (param4 - param2);
      }
      
      public function set view(param1:View3D) : void
      {
         _view = param1;
         _drawPrimitiveStore = _view.drawPrimitiveStore;
      }
      
      public function get view() : View3D
      {
         return _view;
      }
      
      public function primitives(param1:Object3D, param2:Matrix3D, param3:IPrimitiveConsumer) : void
      {
         _convexBlock = param1 as ConvexBlock;
         if(_convexBlock.debug)
         {
            param3.primitive(_drawPrimitiveStore.blockerDictionary[param1]);
         }
      }
      
      public function blockers(param1:Object3D, param2:Matrix3D, param3:IBlockerConsumer) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         _screenVertices = _drawPrimitiveStore.getScreenVertices(param1.id);
         _convexBlock = param1 as ConvexBlock;
         _camera = _view.camera;
         _lens = _camera.lens;
         _vertices = _convexBlock.vertices;
         if(_vertices.length < 3)
         {
            return;
         }
         _points.length = 0;
         _pointsN.length = 0;
         _pointsS.length = 0;
         _baseX = Infinity;
         _baseY = Infinity;
         _baseZ = Infinity;
         _p = "";
         _lens.project(param2,_vertices,_screenVertices);
         _index = _screenVertices.length / 3;
         while(_index--)
         {
            _screenX = _screenVertices[_index * 3];
            _screenY = _screenVertices[_index * 3 + 1];
            if(_baseY > _screenY || _baseY == _screenY && _baseX > _screenX)
            {
               _baseX = _screenX;
               _baseY = _screenY;
               _baseZ = _screenVertices[_index * 3 + 2];
               _baseIndex = _index;
            }
            _points[_points.length] = _baseX;
            _points[_points.length] = _baseY;
            _points[_points.length] = _baseZ;
         }
         _index = _points.length / 3;
         while(_index--)
         {
            _pointsN[_index] = (_points[_index * 3] - _baseX) / (_points[_index * 3 + 1] - _baseY);
         }
         _pointsN[_baseIndex] = -Infinity;
         _pointsN = _pointsN.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
         _index = 0;
         while(_index < _pointsN.length)
         {
            _i = _pointsN[_index] * 3;
            _pointsS[_pointsS.length] = _points[_i];
            _pointsS[_pointsS.length] = _points[_i + 1];
            _pointsS[_pointsS.length] = _points[_i + 2];
            ++_index;
         }
         var _loc4_:Array = [_pointsS[0],_pointsS[1],_pointsS[2],_pointsS[3],_pointsS[4],_pointsS[5]];
         _i = 2;
         while(_i < _pointsS.length)
         {
            _loc6_ = int(_loc4_.length);
            _loc5_ = cross(_loc4_[_loc6_ - 6],_loc4_[_loc6_ - 5],_loc4_[_loc6_ - 3],_loc4_[_loc6_ - 2],_pointsS[_i * 3],_pointsS[_i * 3 + 1]);
            while(_loc5_ > 0)
            {
               _loc4_.pop();
               _loc4_.pop();
               _loc4_.pop();
               if(_loc4_.length == 6)
               {
                  break;
               }
               _loc6_ = int(_loc4_.length);
               _loc5_ = cross(_loc4_[_loc6_ - 6],_loc4_[_loc6_ - 5],_loc4_[_loc6_ - 3],_loc4_[_loc6_ - 2],_pointsS[_i * 3],_pointsS[_i * 3 + 1]);
            }
            _loc4_.push(_pointsS[_i * 3],_pointsS[_i * 3 + 1],_pointsS[_i * 3 + 2]);
            ++_i;
         }
         _loc6_ = int(_loc4_.length);
         _loc5_ = cross(_loc4_[_loc6_ - 6],_loc4_[_loc6_ - 5],_loc4_[_loc6_ - 3],_loc4_[_loc6_ - 2],_loc4_[0],_loc4_[1]);
         if(_loc5_ > 0)
         {
            _loc4_.pop();
            _loc4_.pop();
            _loc4_.pop();
         }
         param3.blocker(_drawPrimitiveStore.createConvexBlocker(param1,_loc4_));
      }
   }
}

