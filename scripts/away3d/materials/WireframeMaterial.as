package away3d.materials
{
   import away3d.arcane;
   import away3d.containers.View3D;
   import away3d.core.base.Object3D;
   import away3d.core.draw.DrawSegment;
   import away3d.core.draw.DrawTriangle;
   import away3d.core.utils.Cast;
   import away3d.core.utils.Init;
   import away3d.events.MaterialEvent;
   import flash.events.EventDispatcher;
   
   use namespace arcane;
   
   public class WireframeMaterial extends EventDispatcher implements ITriangleMaterial, ISegmentMaterial
   {
      
      public var color:int;
      
      protected var ini:Init;
      
      public var width:Number;
      
      arcane var _id:int;
      
      public var alpha:Number;
      
      public function WireframeMaterial(param1:* = null, param2:Object = null)
      {
         super();
         if(param1 == null)
         {
            param1 = "random";
         }
         this.color = Cast.trycolor(param1);
         ini = Init.parse(param2);
         alpha = ini.getNumber("alpha",1,{
            "min":0,
            "max":1
         });
         width = ini.getNumber("width",1,{"min":0});
      }
      
      public function renderTriangle(param1:DrawTriangle) : void
      {
         if(alpha <= 0)
         {
            return;
         }
         param1.source.session.renderTriangleLine(width,color,alpha,param1.screenVertices,param1.screenCommands,param1.screenIndices,param1.startIndex,param1.endIndex);
      }
      
      public function removeOnMaterialUpdate(param1:Function) : void
      {
         removeEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false);
      }
      
      public function updateMaterial(param1:Object3D, param2:View3D) : void
      {
      }
      
      public function get visible() : Boolean
      {
         return alpha > 0;
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function renderSegment(param1:DrawSegment) : void
      {
         if(alpha <= 0)
         {
            return;
         }
         param1.source.session.renderLine(param1.v0x,param1.v0y,param1.v1x,param1.v1y,width,color,alpha);
      }
      
      public function addOnMaterialUpdate(param1:Function) : void
      {
         addEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false,0,true);
      }
   }
}

