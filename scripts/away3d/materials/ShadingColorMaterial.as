package away3d.materials
{
   import away3d.arcane;
   import away3d.core.draw.DrawTriangle;
   import away3d.core.render.AbstractRenderSession;
   import away3d.core.utils.Cast;
   
   use namespace arcane;
   
   public class ShadingColorMaterial extends CenterLightingMaterial
   {
      
      private var fg:int;
      
      public var specular:uint;
      
      public var cache:Boolean;
      
      private var fr:int;
      
      private var fb:int;
      
      public var ambient:uint;
      
      public var alpha:Number;
      
      public var diffuse:uint;
      
      private var _color:uint;
      
      private var sfb:int;
      
      private var sfg:int;
      
      private var sfr:int;
      
      public function ShadingColorMaterial(param1:* = null, param2:Object = null)
      {
         color = param1 == null ? "random" : param1;
         super(param2);
         ambient = ini.getColor("ambient",color);
         diffuse = ini.getColor("diffuse",color);
         specular = ini.getColor("specular",color);
         alpha = ini.getNumber("alpha",1);
         cache = ini.getBoolean("cache",false);
      }
      
      public function set color(param1:*) : void
      {
         if(_color == Cast.trycolor(param1))
         {
            return;
         }
         _color = Cast.trycolor(param1);
         ambient = diffuse = specular = _color;
         _materialDirty = true;
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      override public function get visible() : Boolean
      {
         return true;
      }
      
      override protected function renderTri(param1:DrawTriangle, param2:AbstractRenderSession, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number) : void
      {
         fr = int((ambient & 0xFF0000) * param3 + (diffuse & 0xFF0000) * param6 + (specular & 0xFF0000) * param9 >> 16);
         fg = int((ambient & 0xFF00) * param4 + (diffuse & 0xFF00) * param7 + (specular & 0xFF00) * param10 >> 8);
         fb = int((ambient & 0xFF) * param5 + (diffuse & 0xFF) * param8 + (specular & 0xFF) * param11);
         if(fr > 255)
         {
            fr = 255;
         }
         if(fg > 255)
         {
            fg = 255;
         }
         if(fb > 255)
         {
            fb = 255;
         }
         param2.renderTriangleColor(fr << 16 | fg << 8 | fb,alpha,param1.screenVertices,param1.screenCommands,param1.screenIndices,param1.startIndex,param1.endIndex);
         if(cache)
         {
            if(param1.faceVO != null)
            {
               sfr = int((ambient & 0xFF0000) * param3 + (diffuse & 0xFF0000) * param6 >> 16);
               sfg = int((ambient & 0xFF00) * param4 + (diffuse & 0xFF00) * param7 >> 8);
               sfb = int((ambient & 0xFF) * param5 + (diffuse & 0xFF) * param8);
               if(sfr > 255)
               {
                  sfr = 255;
               }
               if(sfg > 255)
               {
                  sfg = 255;
               }
               if(sfb > 255)
               {
                  sfb = 255;
               }
               param1.faceVO.material = new ColorMaterial(sfr << 16 | sfg << 8 | sfb);
            }
         }
      }
   }
}

