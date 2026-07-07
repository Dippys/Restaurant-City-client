package away3d.animators.skin
{
   import away3d.core.base.*;
   import away3d.core.math.Number3D;
   
   public class SkinVertex
   {
      
      public var skinnedVertex:Vertex;
      
      private var _position:Number3D = new Number3D();
      
      private var _i:int;
      
      public var baseVertex:Vertex;
      
      public var controllers:Array = [];
      
      public var weights:Array = [];
      
      public function SkinVertex(param1:Vertex)
      {
         super();
         skinnedVertex = param1;
         baseVertex = param1.clone();
      }
      
      public function update() : void
      {
         var _loc2_:SkinController = null;
         var _loc1_:Boolean = false;
         for each(_loc2_ in controllers)
         {
            _loc1_ ||= _loc2_.updated;
         }
         if(!_loc1_)
         {
            return;
         }
         skinnedVertex.reset();
         _i = weights.length;
         while(_i--)
         {
            _position.transform(baseVertex.position,(controllers[_i] as SkinController).sceneTransform);
            _position.scale(_position,weights[_i]);
            skinnedVertex.add(_position);
         }
      }
   }
}

