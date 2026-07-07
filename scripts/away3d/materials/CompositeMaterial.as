package away3d.materials
{
   import away3d.arcane;
   import away3d.containers.View3D;
   import away3d.core.base.Object3D;
   import away3d.core.draw.DrawTriangle;
   import away3d.core.render.AbstractRenderSession;
   import away3d.core.utils.FaceMaterialVO;
   import away3d.core.utils.Init;
   import away3d.events.MaterialEvent;
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   
   use namespace arcane;
   
   public class CompositeMaterial extends EventDispatcher implements ITriangleMaterial, ILayerMaterial
   {
      
      private var _green:Number;
      
      public var blendMode:String;
      
      protected var materials:Array;
      
      private var _blue:Number;
      
      arcane var _source:Object3D;
      
      arcane var _id:int;
      
      arcane var _colorTransformDirty:Boolean;
      
      private var _red:Number;
      
      arcane var _session:AbstractRenderSession;
      
      arcane var _alpha:Number;
      
      arcane var _color:uint;
      
      private var _defaultColorTransform:ColorTransform;
      
      arcane var _colorTransform:ColorTransform;
      
      protected var ini:Init;
      
      public function CompositeMaterial(param1:Object = null)
      {
         var _loc2_:ILayerMaterial = null;
         arcane::_colorTransform = new ColorTransform();
         _defaultColorTransform = new ColorTransform();
         super();
         ini = Init.parse(param1);
         materials = ini.getArray("materials");
         blendMode = ini.getString("blendMode",BlendMode.NORMAL);
         alpha = ini.getNumber("alpha",1,{
            "min":0,
            "max":1
         });
         color = ini.getColor("color",16777215);
         for each(_loc2_ in materials)
         {
            _loc2_.addOnMaterialUpdate(onMaterialUpdate);
         }
         arcane::_colorTransformDirty = true;
      }
      
      public function get visible() : Boolean
      {
         return true;
      }
      
      private function onMaterialUpdate(param1:MaterialEvent) : void
      {
         dispatchEvent(param1);
      }
      
      public function updateMaterial(param1:Object3D, param2:View3D) : void
      {
         var _loc3_:ILayerMaterial = null;
         if(_colorTransformDirty)
         {
            setColorTransform();
         }
         for each(_loc3_ in materials)
         {
            _loc3_.updateMaterial(param1,param2);
         }
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(_alpha == param1)
         {
            return;
         }
         _alpha = param1;
         _colorTransformDirty = true;
      }
      
      public function renderTriangle(param1:DrawTriangle) : void
      {
         var _loc4_:ILayerMaterial = null;
         _source = param1.source;
         _session = _source.session;
         var _loc2_:* = 0;
         var _loc3_:Sprite = _session.layer as Sprite;
         if(Boolean(!_loc3_ || this != _session._material) || Boolean(_colorTransform) || blendMode != BlendMode.NORMAL)
         {
            _loc3_ = _session.getSprite(this,_loc2_++);
            _loc3_.blendMode = blendMode;
         }
         if(_colorTransform)
         {
            _loc3_.transform.colorTransform = _colorTransform;
         }
         else
         {
            _loc3_.transform.colorTransform = _defaultColorTransform;
         }
         for each(_loc4_ in materials)
         {
            _loc2_ = _loc4_.renderLayer(param1,_loc3_,_loc2_);
         }
      }
      
      public function removeOnMaterialUpdate(param1:Function) : void
      {
         removeEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false);
      }
      
      public function set color(param1:uint) : void
      {
         if(_color == param1)
         {
            return;
         }
         _color = param1;
         _red = ((_color & 0xFF0000) >> 16) / 255;
         _green = ((_color & 0xFF00) >> 8) / 255;
         _blue = (_color & 0xFF) / 255;
         _colorTransformDirty = true;
      }
      
      protected function setColorTransform() : void
      {
         _colorTransformDirty = false;
         if(_alpha == 1 && _color == 16777215)
         {
            _colorTransform = null;
            return;
         }
         if(!_colorTransform)
         {
            _colorTransform = new ColorTransform();
         }
         _colorTransform.redMultiplier = _red;
         _colorTransform.greenMultiplier = _green;
         _colorTransform.blueMultiplier = _blue;
         _colorTransform.alphaMultiplier = _alpha;
      }
      
      public function removeMaterial(param1:ILayerMaterial) : void
      {
         var _loc2_:int = materials.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         param1.removeOnMaterialUpdate(onMaterialUpdate);
         materials.splice(_loc2_,1);
      }
      
      public function get alpha() : Number
      {
         return _alpha;
      }
      
      public function renderLayer(param1:DrawTriangle, param2:Sprite, param3:int) : int
      {
         var _loc4_:Sprite = null;
         var _loc5_:ILayerMaterial = null;
         if(!_colorTransform && blendMode == BlendMode.NORMAL)
         {
            _loc4_ = param2;
         }
         else
         {
            _source = param1.source;
            _session = _source.session;
            _loc4_ = _session.getSprite(this,param3++,param2);
            _loc4_.blendMode = blendMode;
            if(_colorTransform)
            {
               _loc4_.transform.colorTransform = _colorTransform;
            }
            else
            {
               _loc4_.transform.colorTransform = _defaultColorTransform;
            }
         }
         for each(_loc5_ in materials)
         {
            param3 = _loc5_.renderLayer(param1,_loc4_,param3);
         }
         return param3;
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      public function addOnMaterialUpdate(param1:Function) : void
      {
         addEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false,0,true);
      }
      
      public function renderBitmapLayer(param1:DrawTriangle, param2:Rectangle, param3:FaceMaterialVO) : FaceMaterialVO
      {
         throw new Error("Not implemented");
      }
      
      public function addMaterial(param1:ILayerMaterial) : void
      {
         param1.addOnMaterialUpdate(onMaterialUpdate);
         materials.push(param1);
      }
   }
}

