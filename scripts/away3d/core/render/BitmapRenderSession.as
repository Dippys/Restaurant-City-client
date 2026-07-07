package away3d.core.render
{
   import away3d.arcane;
   import away3d.containers.View3D;
   import flash.display.*;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class BitmapRenderSession extends AbstractRenderSession
   {
      
      private var _bitmapContainers:Dictionary = new Dictionary(true);
      
      private var _container:Sprite;
      
      private var _height:int;
      
      private var _cm:Matrix;
      
      private var _scale:Number;
      
      private var layers:Array = new Array();
      
      private var _bitmapContainer:Bitmap;
      
      private var _cx:Number;
      
      private var _cy:Number;
      
      private var _width:int;
      
      private var _bitmapheight:int;
      
      private var _base:BitmapData;
      
      private var _bitmapwidth:int;
      
      public function BitmapRenderSession(param1:Number = 2)
      {
         super();
         if(_scale <= 0)
         {
            throw new Error("scale cannot be negative or zero");
         }
         _scale = param1;
      }
      
      override public function clear(param1:View3D) : void
      {
         super.clear(param1);
         if(updated)
         {
            _base = getBitmapData(param1);
            _cx = _bitmapContainer.x = param1.screenClipping.minX;
            _cy = _bitmapContainer.y = param1.screenClipping.minY;
            _bitmapContainer.scaleX = _scale;
            _bitmapContainer.scaleY = _scale;
            _cm = new Matrix();
            _cm.scale(1 / _scale,1 / _scale);
            _cm.translate(-param1.screenClipping.minX / _scale,-param1.screenClipping.minY / _scale);
            _base.lock();
            _base.fillRect(_base.rect,0);
            layers.length = 0;
            _layerDirty = true;
            layer = null;
         }
         if(Boolean(filters) && Boolean(filters.length) || Boolean(_bitmapContainer.filters) && Boolean(_bitmapContainer.filters.length))
         {
            _bitmapContainer.filters = filters;
         }
         _bitmapContainer.alpha = alpha || 1;
         _bitmapContainer.blendMode = blendMode || BlendMode.NORMAL;
      }
      
      override public function addDisplayObject(param1:DisplayObject) : void
      {
         layers.push(param1);
         param1.visible = true;
         _layerDirty = true;
      }
      
      override public function getContainer(param1:View3D) : DisplayObject
      {
         _bitmapContainer = getBitmapContainer(param1);
         if(!_containers[param1])
         {
            _container = _containers[param1] = new Sprite();
            _container.addChild(_bitmapContainer);
            return _container;
         }
         return _containers[param1];
      }
      
      override protected function createSprite(param1:Sprite = null) : Sprite
      {
         if(_spriteStore.length)
         {
            _spriteActive.push(_sprite = _spriteStore.pop());
         }
         else
         {
            _spriteActive.push(_sprite = new Sprite());
         }
         if(param1)
         {
            param1.addChild(_sprite);
         }
         else
         {
            layers.push(_sprite);
         }
         _layerDirty = true;
         return _sprite;
      }
      
      public function getBitmapContainer(param1:View3D) : Bitmap
      {
         if(!_bitmapContainers[param1])
         {
            return _bitmapContainers[param1] = new Bitmap();
         }
         return _bitmapContainers[param1];
      }
      
      override public function clone() : AbstractRenderSession
      {
         return new BitmapRenderSession(_scale);
      }
      
      override public function render(param1:View3D) : void
      {
         var _loc2_:DisplayObject = null;
         super.render(param1);
         if(updated)
         {
            for each(_loc2_ in layers)
            {
               _base.draw(_loc2_,_cm,_loc2_.transform.colorTransform,_loc2_.blendMode,_base.rect);
            }
            _base.unlock();
         }
      }
      
      public function getBitmapData(param1:View3D) : BitmapData
      {
         _container = getContainer(param1) as Sprite;
         if(!_bitmapContainer.bitmapData)
         {
            _bitmapwidth = int((_width = param1.screenClipping.maxX - param1.screenClipping.minX) / _scale);
            _bitmapheight = int((_height = param1.screenClipping.maxY - param1.screenClipping.minY) / _scale);
            return _bitmapContainer.bitmapData = new BitmapData(_bitmapwidth,_bitmapheight,true,0);
         }
         return _bitmapContainer.bitmapData;
      }
      
      override protected function createLayer() : void
      {
         if(_shapeStore.length)
         {
            _shapeActive.push(_shape = _shapeStore.pop());
         }
         else
         {
            _shapeActive.push(_shape = new Shape());
         }
         layer = _shape;
         graphics = _shape.graphics;
         layers.push(_shape);
         _layerDirty = false;
      }
   }
}

