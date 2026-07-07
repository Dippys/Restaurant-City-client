package away3d.materials
{
   import away3d.arcane;
   import away3d.containers.View3D;
   import away3d.core.base.Object3D;
   import away3d.core.draw.DrawBillboard;
   import away3d.core.draw.DrawFog;
   import away3d.core.draw.DrawTriangle;
   import away3d.core.utils.Cast;
   import away3d.core.utils.Init;
   import away3d.events.MaterialEvent;
   import flash.events.EventDispatcher;
   
   use namespace arcane;
   
   public class ColorMaterial extends EventDispatcher implements ITriangleMaterial, IFogMaterial, IBillboardMaterial
   {
      
      private var _alpha:Number;
      
      protected var ini:Init;
      
      private var _color:uint;
      
      private var _materialDirty:Boolean;
      
      private var _materialupdated:MaterialEvent;
      
      arcane var _id:int;
      
      public function ColorMaterial(param1:* = null, param2:Object = null)
      {
         super();
         if(param1 == null)
         {
            param1 = "random";
         }
         this.color = Cast.trycolor(param1);
         ini = Init.parse(param2);
         _alpha = ini.getNumber("alpha",1,{
            "min":0,
            "max":1
         });
      }
      
      arcane function notifyMaterialUpdate() : void
      {
         if(!hasEventListener(MaterialEvent.MATERIAL_UPDATED))
         {
            return;
         }
         if(_materialupdated == null)
         {
            _materialupdated = new MaterialEvent(MaterialEvent.MATERIAL_UPDATED,this);
         }
         dispatchEvent(_materialupdated);
      }
      
      public function removeOnMaterialUpdate(param1:Function) : void
      {
         removeEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false);
      }
      
      public function set alpha(param1:Number) : void
      {
         if(_alpha == param1)
         {
            return;
         }
         _alpha = param1;
         _materialDirty = true;
      }
      
      public function renderTriangle(param1:DrawTriangle) : void
      {
         param1.source.session.renderTriangleColor(_color,_alpha,param1.screenVertices,param1.screenCommands,param1.screenIndices,param1.startIndex,param1.endIndex);
      }
      
      public function set color(param1:uint) : void
      {
         if(_color == param1)
         {
            return;
         }
         _color = param1;
         _materialDirty = true;
      }
      
      public function renderBillboard(param1:DrawBillboard) : void
      {
         param1.source.session.renderBillboardColor(_color,_alpha,param1);
      }
      
      public function updateMaterial(param1:Object3D, param2:View3D) : void
      {
         if(_materialDirty)
         {
            _materialDirty = false;
            notifyMaterialUpdate();
         }
      }
      
      public function clone() : IFogMaterial
      {
         return new ColorMaterial(_color,{"alpha":_alpha});
      }
      
      public function get alpha() : Number
      {
         return _alpha;
      }
      
      public function renderFog(param1:DrawFog) : void
      {
         param1.source.session.renderFogColor(param1.clip,_color,_alpha);
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      public function addOnMaterialUpdate(param1:Function) : void
      {
         addEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false,0,true);
      }
      
      public function get visible() : Boolean
      {
         return alpha > 0;
      }
   }
}

