package away3d.materials
{
   import away3d.arcane;
   import away3d.containers.View3D;
   import away3d.core.base.Object3D;
   import away3d.core.utils.Init;
   import away3d.events.MouseEvent3D;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   use namespace arcane;
   
   public class MovieMaterial extends TransformBitmapMaterial implements ITriangleMaterial, IUVMaterial
   {
      
      private var _clipRect:Rectangle;
      
      private var _lockH:Number;
      
      public var transparent:Boolean = true;
      
      private var _lockW:Number;
      
      public var autoUpdate:Boolean = true;
      
      private var _bMode:String;
      
      public var interactive:Boolean = false;
      
      private var _colTransform:ColorTransform;
      
      private var _movie:Sprite;
      
      private var t:Matrix;
      
      private var rendered:Boolean;
      
      private var x:Number;
      
      private var y:Number;
      
      public function MovieMaterial(param1:Sprite, param2:Object = null)
      {
         ini = Init.parse(param2);
         _movie = param1;
         transparent = ini.getBoolean("transparent",transparent);
         autoUpdate = ini.getBoolean("autoUpdate",autoUpdate);
         interactive = ini.getBoolean("interactive",interactive);
         _lockW = ini.getNumber("lockW",param1.width);
         _lockH = ini.getNumber("lockH",param1.height);
         arcane::_bitmap = new BitmapData(Math.max(1,_lockW),Math.max(1,_lockH),transparent,transparent ? 16777215 : 0);
         super(arcane::_bitmap,ini);
      }
      
      public function set clipRect(param1:Rectangle) : void
      {
         _clipRect = param1;
      }
      
      public function set lockH(param1:Number) : void
      {
         _lockH = !isNaN(param1) && param1 > 1 ? param1 : _lockH;
         if(_renderBitmap != null)
         {
            _bitmap.dispose();
            _renderBitmap.dispose();
            _bitmap = new BitmapData(Math.max(1,_lockW),Math.max(1,_lockH),transparent,transparent ? 16777215 : 0);
            _renderBitmap = _bitmap.clone();
            update();
         }
      }
      
      override public function get width() : Number
      {
         return _renderBitmap.width;
      }
      
      public function get movie() : Sprite
      {
         return _movie;
      }
      
      public function update() : void
      {
         var _loc1_:Rectangle = null;
         if(_renderBitmap != null)
         {
            notifyMaterialUpdate();
            _loc1_ = _clipRect == null || !rendered ? _renderBitmap.rect : _clipRect;
            if(transparent)
            {
               _renderBitmap.fillRect(_loc1_,16777215);
            }
            if(_alpha != 1 || _color != 16777215)
            {
               _colTransform = _colorTransform;
            }
            else
            {
               _colTransform = movie.transform.colorTransform;
            }
            if(_blendMode != BlendMode.NORMAL)
            {
               _bMode = _blendMode;
            }
            else
            {
               _bMode = movie.blendMode;
            }
            _renderBitmap.draw(movie,new Matrix(movie.scaleX,0,0,movie.scaleY),_colTransform,_bMode,_loc1_);
            if(!rendered)
            {
               rendered = true;
            }
         }
      }
      
      override protected function updateRenderBitmap() : void
      {
      }
      
      override public function updateMaterial(param1:Object3D, param2:View3D) : void
      {
         super.updateMaterial(param1,param2);
         if(autoUpdate)
         {
            update();
         }
         _session = param1.session;
         if(interactive)
         {
            if(!param2._interactiveLayer.contains(movie))
            {
               param2._interactiveLayer.addChild(movie);
               resetInteractiveLayer();
               param1.addOnMouseOver(onMouseOver);
               param1.addOnMouseOut(onMouseOut);
            }
         }
         else if(param2._interactiveLayer.contains(movie))
         {
            param2._interactiveLayer.removeChild(movie);
            param1.removeOnMouseOver(onMouseOver);
            param1.removeOnMouseOut(onMouseOut);
         }
      }
      
      public function get lockW() : Number
      {
         return _lockW;
      }
      
      public function get clipRect() : Rectangle
      {
         return _clipRect;
      }
      
      public function set lockW(param1:Number) : void
      {
         _lockW = !isNaN(param1) && param1 > 1 ? param1 : _lockW;
         if(_renderBitmap != null)
         {
            _bitmap.dispose();
            _renderBitmap.dispose();
            _bitmap = new BitmapData(Math.max(1,_lockW),Math.max(1,_lockH),transparent,transparent ? 16777215 : 0);
            _renderBitmap = _bitmap.clone();
            update();
         }
      }
      
      public function set movie(param1:Sprite) : void
      {
         if(_movie == param1)
         {
            return;
         }
         if(Boolean(_movie) && Boolean(_movie.parent))
         {
            _movie.parent.removeChild(_movie);
         }
         _movie = param1;
         if(!autoUpdate)
         {
            update();
         }
      }
      
      override public function get height() : Number
      {
         return _renderBitmap.height;
      }
      
      private function onMouseOut(param1:MouseEvent3D) : void
      {
         if(param1.material == this)
         {
            param1.object.removeOnMouseMove(onMouseMove);
            resetInteractiveLayer();
         }
      }
      
      private function onMouseMove(param1:MouseEvent3D) : void
      {
         x = param1.uv.u * _renderBitmap.width;
         y = (1 - param1.uv.v) * _renderBitmap.height;
         if(_transform)
         {
            t = _transform.clone();
            t.invert();
            movie.x = param1.screenX - x * t.a - y * t.c - t.tx;
            movie.y = param1.screenY - x * t.b - y * t.d - t.ty;
         }
         else
         {
            movie.x = param1.screenX - x;
            movie.y = param1.screenY - y;
         }
      }
      
      private function onMouseOver(param1:MouseEvent3D) : void
      {
         if(param1.material == this)
         {
            param1.object.addOnMouseMove(onMouseMove);
            onMouseMove(param1);
         }
      }
      
      public function get lockH() : Number
      {
         return _lockH;
      }
      
      private function resetInteractiveLayer() : void
      {
         movie.x = -10000;
         movie.y = -10000;
      }
   }
}

