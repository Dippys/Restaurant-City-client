package away3d.core.render
{
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.clip.*;
   import away3d.core.draw.*;
   import away3d.core.light.*;
   import away3d.events.*;
   import away3d.materials.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class AbstractRenderSession extends EventDispatcher
   {
      
      public var filters:Array;
      
      private var b2:Number;
      
      arcane var _spriteActive:Array;
      
      private var _v0:ScreenVertex;
      
      private var _v1:ScreenVertex;
      
      private var _v2:ScreenVertex;
      
      private var _shapeActives:Dictionary = new Dictionary(true);
      
      private var c2:Number;
      
      arcane var _renderSource:Object3D;
      
      private var _renderer:IPrimitiveConsumer;
      
      private var _dictionary:Dictionary;
      
      private var v0x:Number;
      
      private var v0y:Number;
      
      private var _spriteLayers:Dictionary = new Dictionary(true);
      
      arcane var _shapeActive:Array;
      
      public var layer:DisplayObject;
      
      private var _consumer:IPrimitiveConsumer;
      
      private var _array:Array;
      
      arcane var _spriteStore:Array;
      
      private var v1y:Number;
      
      arcane var _shapeStore:Array;
      
      private var a:Number;
      
      private var c:Number;
      
      private var d:Number;
      
      private var d2:Number;
      
      private var b:Number;
      
      private var m:Matrix = new Matrix();
      
      protected var i:int;
      
      public var primitives:Array;
      
      private var v1x:Number;
      
      private var v2y:Number;
      
      public var alpha:Number = 1;
      
      private var v2x:Number;
      
      private var _shapeLayers:Dictionary = new Dictionary(true);
      
      arcane var _level:int = -1;
      
      arcane var _material:IMaterial;
      
      private var _sessionupdated:SessionEvent;
      
      public var priconsumers:Dictionary = new Dictionary(true);
      
      private var _renderers:Dictionary = new Dictionary(true);
      
      public var graphics:Graphics;
      
      private var tx:Number;
      
      private var ty:Number;
      
      public var screenZ:Number;
      
      public var sessions:Array = new Array();
      
      arcane var _layerDirty:Boolean;
      
      arcane var _shape:Shape;
      
      public var blendMode:String;
      
      private var area:Number;
      
      private var _lightShapeLayer:Dictionary;
      
      private var _spriteActives:Dictionary = new Dictionary(true);
      
      private var _lightShapeLayers:Dictionary = new Dictionary(true);
      
      arcane var _containers:Dictionary = new Dictionary(true);
      
      private var _spriteStores:Dictionary = new Dictionary(true);
      
      public var parent:AbstractRenderSession;
      
      public var updated:Boolean;
      
      private var _index0:int;
      
      private var _index2:int;
      
      private var _index1:int;
      
      private var _spriteLayer:Dictionary;
      
      private var _shapeLayer:Dictionary;
      
      arcane var _sprite:Sprite;
      
      private var _defaultColorTransform:ColorTransform = new ColorTransform();
      
      private var a2:Number;
      
      private var _shapeStores:Dictionary = new Dictionary(true);
      
      public var consumer:IPrimitiveConsumer;
      
      public function AbstractRenderSession()
      {
         super();
      }
      
      public function addOnSessionUpdate(param1:Function) : void
      {
         addEventListener(SessionEvent.SESSION_UPDATED,param1,false,0,false);
      }
      
      protected function createShape(param1:Sprite) : Shape
      {
         if(_shapeStore.length)
         {
            _shapeActive.push(_shape = _shapeStore.pop());
         }
         else
         {
            _shapeActive.push(_shape = new Shape());
         }
         param1.addChild(_shape);
         _layerDirty = true;
         return _shape;
      }
      
      public function renderFogColor(param1:Clipping, param2:int, param3:Number) : void
      {
         if(_layerDirty)
         {
            createLayer();
         }
         graphics.lineStyle();
         graphics.beginFill(param2,param3);
         graphics.drawRect(param1.minX,param1.minY,param1.maxX - param1.minX,param1.maxY - param1.minY);
         graphics.endFill();
      }
      
      public function getShapeLayer(param1:View3D) : Dictionary
      {
         if(!_shapeLayers[param1])
         {
            return _shapeLayers[param1] = new Dictionary(true);
         }
         return _shapeLayers[param1];
      }
      
      public function addChildSession(param1:AbstractRenderSession) : void
      {
         if(sessions.indexOf(param1) != -1)
         {
            return;
         }
         sessions.push(param1);
         param1.addOnSessionUpdate(onSessionUpdate);
         param1.parent = this;
      }
      
      arcane function internalAddSceneSession(param1:AbstractRenderSession) : void
      {
         sessions = [param1];
         param1.addOnSessionUpdate(onSessionUpdate);
      }
      
      arcane function notifySessionUpdate() : void
      {
         if(!hasEventListener(SessionEvent.SESSION_UPDATED))
         {
            return;
         }
         if(!_sessionupdated)
         {
            _sessionupdated = new SessionEvent(SessionEvent.SESSION_UPDATED,this);
         }
         dispatchEvent(_sessionupdated);
      }
      
      public function getLightShape(param1:ILayerMaterial, param2:int, param3:Sprite, param4:LightPrimitive) : Shape
      {
         if(!(_dictionary = _lightShapeLayer[param1]))
         {
            _dictionary = _lightShapeLayer[param1] = new Dictionary(true);
         }
         if(!(_array = _dictionary[param4]))
         {
            _array = _dictionary[param4] = [];
         }
         if(_level >= param2 && Boolean(_array.length))
         {
            _shape = _array[0];
         }
         else
         {
            _level = param2;
            _array.unshift(_shape = createShape(param3));
         }
         return _shape;
      }
      
      public function renderTriangleBitmapMask(param1:BitmapData, param2:Number, param3:Number, param4:Number, param5:Array, param6:Array, param7:Number, param8:Number, param9:Boolean, param10:Boolean, param11:Graphics = null) : void
      {
         if(_layerDirty)
         {
            createLayer();
         }
         _index0 = param6[param7] * 3;
         _index1 = param6[param7 + 1] * 3;
         _index2 = param6[param7 + 2] * 3;
         a2 = (v1x = param5[_index1]) - (v0x = param5[_index0]);
         b2 = (v1y = param5[_index1 + 1]) - (v0y = param5[_index0 + 1]);
         c2 = (v2x = param5[_index2]) - v0x;
         d2 = (v2y = param5[_index2 + 1]) - v0y;
         m.identity();
         m.scale(param4,param4);
         m.translate(param2,param3);
         if(param11)
         {
            param11.lineStyle();
            param11.moveTo(v0x,v0y);
            param11.beginBitmapFill(param1,m,param10,param9 && v0x * (d2 - b2) - v1x * d2 + v2x * b2 > 400);
            param11.lineTo(v1x,v1y);
            param11.lineTo(v2x,v2y);
            param11.endFill();
         }
         else
         {
            graphics.lineStyle();
            graphics.moveTo(v0x,v0y);
            graphics.beginBitmapFill(param1,m,param10,param9 && v0x * (d2 - b2) - v1x * d2 + v2x * b2 > 400);
            graphics.lineTo(v1x,v1y);
            graphics.lineTo(v2x,v2y);
            graphics.endFill();
         }
      }
      
      public function removeOnSessionUpdate(param1:Function) : void
      {
         removeEventListener(SessionEvent.SESSION_UPDATED,param1,false);
      }
      
      public function clearRenderers() : void
      {
         _renderers = new Dictionary(true);
      }
      
      public function renderTriangleColor(param1:int, param2:Number, param3:Array, param4:Array, param5:Array, param6:Number, param7:Number, param8:Graphics = null) : void
      {
         if(!param8 && _layerDirty)
         {
            createLayer();
         }
         var _loc9_:Graphics = param8 ? param8 : graphics;
         if(param7 - param6 > 3)
         {
            _loc9_.lineStyle();
            _loc9_.beginFill(param1,param2);
            while(param6 < param7)
            {
               _index0 = param5[param6] * 3;
               switch(param4[param6++])
               {
                  case "M":
                     _loc9_.moveTo(param3[_index0],param3[_index0 + 1]);
                     break;
                  case "L":
                     _loc9_.lineTo(param3[_index0],param3[_index0 + 1]);
                     break;
                  case "C":
                     _index1 = param5[param6++] * 3;
                     _loc9_.curveTo(param3[_index0],param3[_index0 + 1],param3[_index1],param3[_index1 + 1]);
               }
            }
            _loc9_.endFill();
         }
         else
         {
            _index0 = param5[param6] * 3;
            _index1 = param5[param6 + 1] * 3;
            _index2 = param5[param6 + 2] * 3;
            _loc9_.lineStyle();
            _loc9_.moveTo(param3[_index0],param3[_index0 + 1]);
            _loc9_.beginFill(param1,param2);
            _loc9_.lineTo(param3[_index1],param3[_index1 + 1]);
            _loc9_.lineTo(param3[_index2],param3[_index2 + 1]);
            _loc9_.endFill();
         }
      }
      
      public function clear(param1:View3D) : void
      {
         var _loc2_:AbstractRenderSession = null;
         var _loc3_:Array = null;
         var _loc4_:Dictionary = null;
         updated = param1.updated || param1.forceUpdate || Boolean(param1.scene.updatedSessions[this]);
         for each(_loc2_ in sessions)
         {
            _loc2_.clear(param1);
         }
         if(updated)
         {
            _consumer = getConsumer(param1);
            _spriteLayer = getSpriteLayer(param1);
            for each(_loc3_ in _spriteLayer)
            {
               _loc3_.length = 0;
            }
            _shapeLayer = getShapeLayer(param1);
            for each(_loc3_ in _shapeLayer)
            {
               _loc3_.length = 0;
            }
            _lightShapeLayer = getLightShapeLayer(param1);
            for each(_loc4_ in _lightShapeLayer)
            {
               for each(_loc3_ in _loc4_)
               {
                  _loc3_.length = 0;
               }
            }
            _level = -1;
            _material = null;
            _shapeStore = getShapeStore(param1);
            _shapeActive = getShapeActive(param1);
            i = _shapeActive.length;
            while(i--)
            {
               _shape = _shapeActive.pop();
               _shape.graphics.clear();
               _shape.filters = [];
               _shape.blendMode = BlendMode.NORMAL;
               _shape.transform.colorTransform = _defaultColorTransform;
               _shapeStore.push(_shape);
            }
            _spriteStore = getSpriteStore(param1);
            _spriteActive = getSpriteActive(param1);
            i = _spriteActive.length;
            while(i--)
            {
               _sprite = _spriteActive.pop();
               _sprite.graphics.clear();
               _sprite.filters = [];
               while(_sprite.numChildren)
               {
                  _sprite.removeChildAt(0);
               }
               _spriteStore.push(_sprite);
            }
            _consumer.clear(param1);
         }
      }
      
      protected function onSessionUpdate(param1:SessionEvent) : void
      {
         dispatchEvent(param1);
      }
      
      public function getSpriteLayer(param1:View3D) : Dictionary
      {
         if(!_spriteLayers[param1])
         {
            return _spriteLayers[param1] = new Dictionary(true);
         }
         return _spriteLayers[param1];
      }
      
      public function renderBitmap(param1:BitmapData, param2:ScreenVertex, param3:Boolean = false) : void
      {
         if(_layerDirty)
         {
            createLayer();
         }
         m.identity();
         m.tx = param2.x - param1.width / 2;
         m.ty = param2.y - param1.height / 2;
         graphics.lineStyle();
         graphics.beginBitmapFill(param1,m,false,param3);
         graphics.drawRect(param2.x - param1.width / 2,param2.y - param1.height / 2,param1.width,param1.height);
         graphics.endFill();
      }
      
      public function getConsumer(param1:View3D) : IPrimitiveConsumer
      {
         if(_renderers[param1])
         {
            return _renderers[param1];
         }
         if(_renderer)
         {
            return _renderers[param1] = _renderer.clone();
         }
         if(parent)
         {
            return _renderers[param1] = parent.getConsumer(param1).clone();
         }
         return _renderers[param1] = (param1.session.renderer as IPrimitiveConsumer).clone();
      }
      
      public function clone() : AbstractRenderSession
      {
         throw new Error("Not implemented");
      }
      
      public function addDisplayObject(param1:DisplayObject) : void
      {
         throw new Error("Not implemented");
      }
      
      public function set renderer(param1:IPrimitiveConsumer) : void
      {
         var _loc2_:AbstractRenderSession = null;
         if(_renderer == param1)
         {
            return;
         }
         _renderer = param1;
         clearRenderers();
         for each(_loc2_ in sessions)
         {
            _loc2_.clearRenderers();
         }
      }
      
      public function removeChildSession(param1:AbstractRenderSession) : void
      {
         param1.removeOnSessionUpdate(onSessionUpdate);
         var _loc2_:int = sessions.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         sessions.splice(_loc2_,1);
      }
      
      public function renderTriangleLineFill(param1:Number, param2:int, param3:Number, param4:int, param5:Number, param6:Array, param7:Array, param8:Array, param9:int, param10:int) : void
      {
         if(_layerDirty)
         {
            createLayer();
         }
         if(param5 > 0)
         {
            graphics.lineStyle(param1,param4,param5);
         }
         else
         {
            graphics.lineStyle();
         }
         if(param3 > 0)
         {
            graphics.beginFill(param2,param3);
         }
         if(param10 - param9 > 3)
         {
            while(param9 < param10)
            {
               _index0 = param8[param9] * 3;
               switch(param7[param9++])
               {
                  case "M":
                     graphics.moveTo(param6[_index0],param6[_index0 + 1]);
                     break;
                  case "L":
                     graphics.lineTo(param6[_index0],param6[_index0 + 1]);
                     break;
                  case "C":
                     _index1 = param8[param9++] * 3;
                     graphics.curveTo(param6[_index0],param6[_index0 + 1],param6[_index1],param6[_index1 + 1]);
               }
            }
         }
         else
         {
            _index0 = param8[param9] * 3;
            _index1 = param8[param9 + 1] * 3;
            _index2 = param8[param9 + 2] * 3;
            graphics.moveTo(v0x = param6[_index0],v0y = param6[_index0 + 1]);
            graphics.lineTo(param6[_index1],param6[_index1 + 1]);
            graphics.lineTo(param6[_index2],param6[_index2 + 1]);
            if(param5 > 0)
            {
               graphics.lineTo(v0x,v0y);
            }
         }
         if(param3 > 0)
         {
            graphics.endFill();
         }
      }
      
      private function onObjectSessionUpdate(param1:Object3DEvent) : void
      {
         notifySessionUpdate();
      }
      
      public function clearChildSessions() : void
      {
         var _loc1_:AbstractRenderSession = null;
         for each(_loc1_ in sessions)
         {
            _loc1_.removeOnSessionUpdate(onSessionUpdate);
         }
         sessions.length = 0;
      }
      
      private function getSpriteActive(param1:View3D) : Array
      {
         if(!_spriteActives[param1])
         {
            return _spriteActives[param1] = [];
         }
         return _spriteActives[param1];
      }
      
      arcane function internalRemoveSceneSession(param1:AbstractRenderSession) : void
      {
         sessions = [];
         param1.removeOnSessionUpdate(onSessionUpdate);
      }
      
      public function render(param1:View3D) : void
      {
         var _loc2_:AbstractRenderSession = null;
         for each(_loc2_ in sessions)
         {
            _loc2_.render(param1);
         }
         if(updated)
         {
            (getConsumer(param1) as IRenderer).render(param1);
         }
      }
      
      public function renderTriangleBitmap(param1:BitmapData, param2:Matrix, param3:Array, param4:Array, param5:Number, param6:Number, param7:Boolean, param8:Boolean, param9:Graphics = null) : void
      {
         if(!param9 && _layerDirty)
         {
            createLayer();
         }
         _index0 = param4[param5] * 3;
         _index1 = param4[param5 + 1] * 3;
         _index2 = param4[param5 + 2] * 3;
         a2 = (v1x = param3[_index1]) - (v0x = param3[_index0]);
         b2 = (v1y = param3[_index1 + 1]) - (v0y = param3[_index0 + 1]);
         c2 = (v2x = param3[_index2]) - v0x;
         d2 = (v2y = param3[_index2 + 1]) - v0y;
         m.a = (a = param2.a) * a2 + (b = param2.b) * c2;
         m.b = a * b2 + b * d2;
         m.c = (c = param2.c) * a2 + (d = param2.d) * c2;
         m.d = c * b2 + d * d2;
         m.tx = (tx = param2.tx) * a2 + (ty = param2.ty) * c2 + v0x;
         m.ty = tx * b2 + ty * d2 + v0y;
         area = v0x * (d2 - b2) - v1x * d2 + v2x * b2;
         if(area < 0)
         {
            area = -area;
         }
         if(param9)
         {
            param9.lineStyle();
            param9.moveTo(v0x,v0y);
            param9.beginBitmapFill(param1,m,param8,param7 && area > 400);
            param9.lineTo(v1x,v1y);
            param9.lineTo(v2x,v2y);
            param9.endFill();
         }
         else
         {
            graphics.lineStyle();
            graphics.moveTo(v0x,v0y);
            graphics.beginBitmapFill(param1,m,param8,param7 && area > 400);
            graphics.lineTo(v1x,v1y);
            graphics.lineTo(v2x,v2y);
            graphics.endFill();
         }
      }
      
      public function getLightShapeLayer(param1:View3D) : Dictionary
      {
         if(!_lightShapeLayers[param1])
         {
            return _lightShapeLayers[param1] = new Dictionary(true);
         }
         return _lightShapeLayers[param1];
      }
      
      public function renderBillboardColor(param1:int, param2:Number, param3:DrawBillboard) : void
      {
         if(_layerDirty)
         {
            createLayer();
         }
         if(param3.rotation != 0)
         {
            graphics.beginFill(param1,param2);
            graphics.moveTo(param3.topleftx,param3.toplefty);
            graphics.lineTo(param3.toprightx,param3.toprighty);
            graphics.lineTo(param3.bottomrightx,param3.bottomrighty);
            graphics.lineTo(param3.bottomleftx,param3.bottomlefty);
            graphics.lineTo(param3.topleftx,param3.toplefty);
            graphics.endFill();
         }
         else
         {
            graphics.beginFill(param1,param2);
            graphics.drawRect(param3.minX,param3.minY,param3.maxX - param3.minX,param3.maxY - param3.minY);
            graphics.endFill();
         }
      }
      
      arcane function internalRemoveOwnSession(param1:Object3D) : void
      {
         param1.removeEventListener(Object3DEvent.SESSION_UPDATED,onObjectSessionUpdate);
      }
      
      public function get renderer() : IPrimitiveConsumer
      {
         return _renderer;
      }
      
      public function getContainer(param1:View3D) : DisplayObject
      {
         throw new Error("Not implemented");
      }
      
      public function renderLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:Number) : void
      {
         if(_layerDirty)
         {
            createLayer();
         }
         graphics.lineStyle(param5,param6,param7);
         graphics.moveTo(param1,param2);
         graphics.lineTo(param3,param4);
      }
      
      private function getShapeStore(param1:View3D) : Array
      {
         if(!_shapeStores[param1])
         {
            return _shapeStores[param1] = [];
         }
         return _shapeStores[param1];
      }
      
      private function getShapeActive(param1:View3D) : Array
      {
         if(!_shapeActives[param1])
         {
            return _shapeActives[param1] = [];
         }
         return _shapeActives[param1];
      }
      
      public function getSprite(param1:ILayerMaterial, param2:int, param3:Sprite = null) : Sprite
      {
         if(!(_array = _spriteLayer[param1]))
         {
            _array = _spriteLayer[param1] = [];
         }
         if(!param3 && param1 != _material)
         {
            _level = -1;
            _material = param1;
         }
         if(_level >= param2 && Boolean(_array.length))
         {
            _sprite = _array[0];
         }
         else
         {
            _level = param2;
            _array.unshift(_sprite = createSprite(param3));
         }
         return _sprite;
      }
      
      protected function createLayer() : void
      {
         throw new Error("Not implemented");
      }
      
      public function renderTriangleLine(param1:Number, param2:int, param3:Number, param4:Array, param5:Array, param6:Array, param7:Number, param8:Number) : void
      {
         if(_layerDirty)
         {
            createLayer();
         }
         graphics.lineStyle(param1,param2,param3);
         if(param8 - param7 > 3)
         {
            while(param7 < param8)
            {
               _index0 = param6[param7] * 3;
               switch(param5[param7++])
               {
                  case "M":
                     graphics.moveTo(param4[_index0],param4[_index0 + 1]);
                     break;
                  case "L":
                     graphics.lineTo(param4[_index0],param4[_index0 + 1]);
                     break;
                  case "C":
                     _index1 = param6[param7++] * 3;
                     graphics.curveTo(param4[_index0],param4[_index0 + 1],param4[_index1],param4[_index1 + 1]);
               }
            }
         }
         else
         {
            _index0 = param6[param7] * 3;
            _index1 = param6[param7 + 1] * 3;
            _index2 = param6[param7 + 2] * 3;
            graphics.moveTo(v0x = param4[_index0],v0y = param4[_index0 + 1]);
            graphics.lineTo(param4[_index1],param4[_index1 + 1]);
            graphics.lineTo(param4[_index2],param4[_index2 + 1]);
            graphics.lineTo(v0x,v0y);
         }
      }
      
      public function renderScaledBitmap(param1:DrawScaledBitmap, param2:BitmapData, param3:Matrix, param4:Boolean = false) : void
      {
         if(_layerDirty)
         {
            createLayer();
         }
         graphics.lineStyle();
         if(param1.rotation != 0)
         {
            graphics.beginBitmapFill(param2,param3,false,param4);
            graphics.moveTo(param1.topleftx,param1.toplefty);
            graphics.lineTo(param1.toprightx,param1.toprighty);
            graphics.lineTo(param1.bottomrightx,param1.bottomrighty);
            graphics.lineTo(param1.bottomleftx,param1.bottomlefty);
            graphics.lineTo(param1.topleftx,param1.toplefty);
            graphics.endFill();
         }
         else
         {
            graphics.beginBitmapFill(param2,param3,false,param4);
            graphics.drawRect(param1.minX,param1.minY,param1.maxX - param1.minX,param1.maxY - param1.minY);
            graphics.endFill();
         }
      }
      
      public function getTotalFaces(param1:View3D) : int
      {
         var _loc3_:AbstractRenderSession = null;
         var _loc2_:int = int(getConsumer(param1).list().length);
         for each(_loc3_ in sessions)
         {
            _loc2_ += _loc3_.getTotalFaces(param1);
         }
         return _loc2_;
      }
      
      protected function createSprite(param1:Sprite = null) : Sprite
      {
         throw new Error("Not implemented");
      }
      
      private function getSpriteStore(param1:View3D) : Array
      {
         if(!_spriteStores[param1])
         {
            return _spriteStores[param1] = [];
         }
         return _spriteStores[param1];
      }
      
      public function renderBillboardBitmap(param1:BitmapData, param2:DrawBillboard, param3:Boolean) : void
      {
         if(_layerDirty)
         {
            createLayer();
         }
         if(param2.rotation != 0)
         {
            graphics.beginBitmapFill(param1,param2.mapping,false,param3);
            graphics.moveTo(param2.topleftx,param2.toplefty);
            graphics.lineTo(param2.toprightx,param2.toprighty);
            graphics.lineTo(param2.bottomrightx,param2.bottomrighty);
            graphics.lineTo(param2.bottomleftx,param2.bottomlefty);
            graphics.lineTo(param2.topleftx,param2.toplefty);
            graphics.endFill();
         }
         else
         {
            graphics.beginBitmapFill(param1,param2.mapping,false,param3);
            graphics.drawRect(param2.minX,param2.minY,param2.maxX - param2.minX,param2.maxY - param2.minY);
            graphics.endFill();
         }
      }
      
      public function getShape(param1:ILayerMaterial, param2:int, param3:Sprite) : Shape
      {
         if(!(_array = _shapeLayer[param1]))
         {
            _array = _shapeLayer[param1] = [];
         }
         if(_level >= param2 && Boolean(_array.length))
         {
            _shape = _array[0];
         }
         else
         {
            _level = param2;
            _array.unshift(_shape = createShape(param3));
         }
         return _shape;
      }
      
      arcane function internalAddOwnSession(param1:Object3D) : void
      {
         param1.addEventListener(Object3DEvent.SESSION_UPDATED,onObjectSessionUpdate);
      }
   }
}

