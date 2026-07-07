package away3d.core.render
{
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.clip.*;
   import away3d.events.*;
   import flash.display.*;
   import flash.geom.*;
   
   use namespace arcane;
   
   public class SpriteRenderSession extends AbstractRenderSession
   {
      
      private var _container:Sprite;
      
      public var cacheAsBitmap:Boolean;
      
      private var _clip:Clipping;
      
      public function SpriteRenderSession()
      {
         super();
      }
      
      override protected function onSessionUpdate(param1:SessionEvent) : void
      {
         super.onSessionUpdate(param1);
         cacheAsBitmap = false;
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
            _container.addChild(_sprite);
            layer = _sprite;
         }
         _layerDirty = true;
         return _sprite;
      }
      
      override public function addDisplayObject(param1:DisplayObject) : void
      {
         _container.addChild(param1);
         param1.visible = true;
         layer = null;
         _level = -1;
         _layerDirty = true;
      }
      
      override public function getContainer(param1:View3D) : DisplayObject
      {
         if(!_containers[param1])
         {
            return _containers[param1] = new Sprite();
         }
         return _containers[param1];
      }
      
      override public function clear(param1:View3D) : void
      {
         super.clear(param1);
         _container = getContainer(param1) as Sprite;
         if(updated)
         {
            layer = _container;
            graphics = _container.graphics;
            if(this == param1.session)
            {
               _clip = param1.screenClipping;
               _container.scrollRect = new Rectangle(_clip.minX - 1,_clip.minY - 1,_clip.maxX - _clip.minX + 2,_clip.maxY - _clip.minY + 2);
               _container.x = _clip.minX - 1;
               _container.y = _clip.minY - 1;
            }
            _container.cacheAsBitmap = false;
            graphics.clear();
            while(_container.numChildren)
            {
               _container.removeChildAt(0);
            }
         }
         else
         {
            _container.cacheAsBitmap = cacheAsBitmap;
         }
         if(Boolean(filters) && Boolean(filters.length) || Boolean(_container.filters) && Boolean(_container.filters.length))
         {
            _container.filters = filters;
         }
         _container.alpha = alpha;
         _container.blendMode = blendMode || BlendMode.NORMAL;
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
         _container.addChild(_shape);
         _layerDirty = false;
         _level = -1;
      }
      
      override public function clone() : AbstractRenderSession
      {
         return new SpriteRenderSession();
      }
   }
}

