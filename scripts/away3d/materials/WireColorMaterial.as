package away3d.materials
{
   import away3d.arcane;
   import away3d.containers.View3D;
   import away3d.core.base.Object3D;
   import away3d.core.draw.DrawTriangle;
   import away3d.core.utils.Cast;
   import away3d.core.utils.Init;
   import away3d.events.MaterialEvent;
   import flash.events.EventDispatcher;
   
   use namespace arcane;
   
   public class WireColorMaterial extends EventDispatcher implements ITriangleMaterial
   {
      
      public var wirealpha:Number;
      
      public var width:Number;
      
      public var wirecolor:int;
      
      public var alpha:Number;
      
      public var color:int;
      
      protected var ini:Init;
      
      arcane var _id:int;
      
      public function WireColorMaterial(param1:* = null, param2:Object = null)
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
         wirecolor = ini.getColor("wirecolor",0);
         width = ini.getNumber("width",1,{"min":0});
         wirealpha = ini.getNumber("wirealpha",1,{
            "min":0,
            "max":1
         });
      }
      
      public function removeOnMaterialUpdate(param1:Function) : void
      {
         removeEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false);
      }
      
      public function renderTriangle(param1:DrawTriangle) : void
      {
         param1.source.session.renderTriangleLineFill(width,color,alpha,wirecolor,wirealpha,param1.screenVertices,param1.screenCommands,param1.screenIndices,param1.startIndex,param1.endIndex);
      }
      
      public function updateMaterial(param1:Object3D, param2:View3D) : void
      {
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function addOnMaterialUpdate(param1:Function) : void
      {
         addEventListener(MaterialEvent.MATERIAL_UPDATED,param1,false,0,true);
      }
      
      public function get visible() : Boolean
      {
         return alpha > 0 || wirealpha > 0;
      }
   }
}

