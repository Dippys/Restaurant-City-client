package away3d.primitives
{
   import away3d.arcane;
   import away3d.core.base.Vertex;
   
   use namespace arcane;
   
   public class WireCube extends AbstractPrimitive
   {
      
      public var v001:Vertex;
      
      private var _depth:Number;
      
      private var _height:Number;
      
      private var _width:Number;
      
      public var v011:Vertex;
      
      public var v111:Vertex;
      
      public var v010:Vertex;
      
      public var v110:Vertex;
      
      public var v000:Vertex;
      
      public var v100:Vertex;
      
      public var v101:Vertex;
      
      public function WireCube(param1:Object = null)
      {
         super(param1);
         _width = ini.getNumber("width",100,{"min":0});
         _height = ini.getNumber("height",100,{"min":0});
         _depth = ini.getNumber("depth",100,{"min":0});
         type = "WireCube";
         url = "primitive";
      }
      
      public function get depth() : Number
      {
         return _depth;
      }
      
      public function get width() : Number
      {
         return _width;
      }
      
      public function set width(param1:Number) : void
      {
         if(_width == param1)
         {
            return;
         }
         _width = param1;
         _primitiveDirty = true;
      }
      
      public function set height(param1:Number) : void
      {
         if(_height == param1)
         {
            return;
         }
         _height = param1;
         _primitiveDirty = true;
      }
      
      override protected function buildPrimitive() : void
      {
         super.buildPrimitive();
         v000 = createVertex(-_width / 2,-_height / 2,-_depth / 2);
         v001 = createVertex(-_width / 2,-_height / 2,_depth / 2);
         v010 = createVertex(-_width / 2,_height / 2,-_depth / 2);
         v011 = createVertex(-_width / 2,_height / 2,_depth / 2);
         v100 = createVertex(_width / 2,-_height / 2,-_depth / 2);
         v101 = createVertex(_width / 2,-_height / 2,_depth / 2);
         v110 = createVertex(_width / 2,_height / 2,-_depth / 2);
         v111 = createVertex(_width / 2,_height / 2,_depth / 2);
         addSegment(createSegment(v000,v001));
         addSegment(createSegment(v011,v001));
         addSegment(createSegment(v011,v010));
         addSegment(createSegment(v000,v010));
         addSegment(createSegment(v100,v000));
         addSegment(createSegment(v101,v001));
         addSegment(createSegment(v111,v011));
         addSegment(createSegment(v110,v010));
         addSegment(createSegment(v100,v101));
         addSegment(createSegment(v111,v101));
         addSegment(createSegment(v111,v110));
         addSegment(createSegment(v100,v110));
      }
      
      public function set depth(param1:Number) : void
      {
         if(_depth == param1)
         {
            return;
         }
         _depth = param1;
         _primitiveDirty = true;
      }
      
      public function get height() : Number
      {
         return _height;
      }
   }
}

