package away3d.core.utils
{
   import away3d.core.base.Face;
   import away3d.core.base.UV;
   import away3d.core.base.Vertex;
   import away3d.materials.ITriangleMaterial;
   import flash.geom.Rectangle;
   
   public class FaceVO
   {
      
      public var v0:Vertex;
      
      public var commands:Array = new Array();
      
      public var generated:Boolean;
      
      public var reverseArea:Boolean;
      
      public var face:Face;
      
      public var material:ITriangleMaterial;
      
      public var back:ITriangleMaterial;
      
      public var uv0:UV;
      
      public var uv1:UV;
      
      public var uv2:UV;
      
      public var bitmapRect:Rectangle;
      
      public var vertices:Array = new Array();
      
      public var v1:Vertex;
      
      public var v2:Vertex;
      
      public function FaceVO()
      {
         super();
      }
      
      public function get maxU() : Number
      {
         if(uv0.u > uv1.u)
         {
            if(uv0.u > uv2.u)
            {
               return uv0.u;
            }
            return uv2.u;
         }
         if(uv1.u > uv2.u)
         {
            return uv1.u;
         }
         return uv2.u;
      }
      
      public function get minU() : Number
      {
         if(uv0.u < uv1.u)
         {
            if(uv0.u < uv2.u)
            {
               return uv0.u;
            }
            return uv2.u;
         }
         if(uv1.u < uv2.u)
         {
            return uv1.u;
         }
         return uv2.u;
      }
      
      public function get minV() : Number
      {
         if(uv0.v < uv1.v)
         {
            if(uv0.v < uv2.v)
            {
               return uv0.v;
            }
            return uv2.v;
         }
         if(uv1.v < uv2.v)
         {
            return uv1.v;
         }
         return uv2.v;
      }
      
      public function get maxV() : Number
      {
         if(uv0.v > uv1.v)
         {
            if(uv0.v > uv2.v)
            {
               return uv0.v;
            }
            return uv2.v;
         }
         if(uv1.v > uv2.v)
         {
            return uv1.v;
         }
         return uv2.v;
      }
   }
}

