package away3d.core.project
{
   import away3d.cameras.lenses.*;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.draw.*;
   import away3d.core.math.*;
   import away3d.core.utils.*;
   import away3d.sprites.*;
   import flash.utils.*;
   
   public class DofSpriteProjector implements IPrimitiveProvider
   {
      
      private var _dofsprite:DofSprite2D;
      
      private var _screenVertices:Array;
      
      private var _dofcache:DofCache;
      
      private var _view:View3D;
      
      private var _drawPrimitiveStore:DrawPrimitiveStore;
      
      private var _screenZ:Number;
      
      private var _lens:ILens;
      
      public function DofSpriteProjector()
      {
         super();
      }
      
      public function get view() : View3D
      {
         return _view;
      }
      
      public function set view(param1:View3D) : void
      {
         _view = param1;
         _drawPrimitiveStore = view.drawPrimitiveStore;
      }
      
      public function primitives(param1:Object3D, param2:Matrix3D, param3:IPrimitiveConsumer) : void
      {
         _screenVertices = _drawPrimitiveStore.getScreenVertices(param1.id);
         _dofsprite = param1 as DofSprite2D;
         _lens = _view.camera.lens;
         _lens.project(param2,_dofsprite.center,_screenVertices);
         if(_screenVertices[0] == null)
         {
            return;
         }
         _screenZ = _screenVertices[2] = _screenVertices[2] + _dofsprite.deltaZ;
         _dofcache = DofCache.getDofCache(_dofsprite.bitmap);
         param3.primitive(_drawPrimitiveStore.createDrawScaledBitmap(param1,_screenVertices,_dofsprite.smooth,_dofcache.getBitmap(_screenZ),_dofsprite.scaling * _view.camera.zoom / (1 + _screenZ / _view.camera.focus),_dofsprite.rotation));
      }
   }
}

