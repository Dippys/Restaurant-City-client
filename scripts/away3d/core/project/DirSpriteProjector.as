package away3d.core.project
{
   import away3d.cameras.lenses.*;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.draw.*;
   import away3d.core.math.*;
   import away3d.core.utils.*;
   import away3d.sprites.*;
   import flash.display.*;
   import flash.utils.*;
   
   public class DirSpriteProjector implements IPrimitiveProvider
   {
      
      private var _index:int;
      
      private var _view:View3D;
      
      private var _bitmaps:Dictionary;
      
      private var _screenVertices:Array;
      
      private var _drawPrimitiveStore:DrawPrimitiveStore;
      
      private var _dirsprite:DirSprite2D;
      
      private var _vertices:Array;
      
      private var _centerScreenVertices:Array = new Array();
      
      private var _lens:ILens;
      
      public function DirSpriteProjector()
      {
         super();
      }
      
      public function set view(param1:View3D) : void
      {
         _view = param1;
         _drawPrimitiveStore = view.drawPrimitiveStore;
      }
      
      public function get view() : View3D
      {
         return _view;
      }
      
      public function primitives(param1:Object3D, param2:Matrix3D, param3:IPrimitiveConsumer) : void
      {
         var _loc6_:Number = NaN;
         _screenVertices = _drawPrimitiveStore.getScreenVertices(param1.id);
         _dirsprite = param1 as DirSprite2D;
         _vertices = _dirsprite.vertices;
         _bitmaps = _dirsprite.bitmaps;
         _lens = _view.camera.lens;
         if(_vertices.length == 0)
         {
            return;
         }
         var _loc4_:Number = Infinity;
         var _loc5_:BitmapData = null;
         _lens.project(param2,_vertices,_screenVertices);
         _index = _screenVertices.length / 3;
         while(_index--)
         {
            _loc6_ = Number(_screenVertices[_index * 3 + 2]);
            if(_loc6_ < _loc4_)
            {
               _loc4_ = _loc6_;
               _loc5_ = _bitmaps[_vertices[_index]];
            }
         }
         if(_loc5_ == null)
         {
            return;
         }
         _centerScreenVertices.length = 0;
         _lens.project(param2,_dirsprite.center,_centerScreenVertices);
         if(_centerScreenVertices[0] == null)
         {
            return;
         }
         _centerScreenVertices[2] += _dirsprite.deltaZ;
         param3.primitive(_drawPrimitiveStore.createDrawScaledBitmap(param1,_centerScreenVertices,_dirsprite.smooth,_loc5_,_dirsprite.scaling * _view.camera.zoom / (1 + _screenVertices[2] / _view.camera.focus),_dirsprite.rotation));
      }
   }
}

