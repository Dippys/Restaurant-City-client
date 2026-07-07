package away3d.core.base
{
   import away3d.materials.WireColorMaterial;
   
   public class Graphics3D
   {
      
      private var _currentMaterial:WireColorMaterial;
      
      private var _zOffset:Number = 0;
      
      private var _geometry:Geometry;
      
      private var _currentFace:Face;
      
      public function Graphics3D()
      {
         super();
      }
      
      public function startNewShape() : void
      {
         _currentFace = new Face();
         _currentFace.material = _currentMaterial;
         _geometry.addFace(_currentFace);
      }
      
      public function set geometry(param1:Geometry) : void
      {
         _geometry = param1;
      }
      
      public function curveTo(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         _currentFace.curveTo(param1,-param2,_zOffset,param3,-param4,_zOffset);
      }
      
      public function beginFill(param1:int = -1, param2:Number = -1) : void
      {
         _currentMaterial = new WireColorMaterial();
         _currentMaterial.wirealpha = 0;
         if(param1 != -1)
         {
            _currentMaterial.color = param1;
         }
         if(param2 != -1)
         {
            _currentMaterial.alpha = param2;
         }
         if(_currentFace)
         {
            _currentFace.material = _currentMaterial;
         }
      }
      
      public function clear() : void
      {
         var _loc1_:Face = null;
         for each(_loc1_ in _geometry.faces)
         {
            _geometry.removeFace(_loc1_);
         }
      }
      
      public function lineTo(param1:Number, param2:Number) : void
      {
         _currentFace.lineTo(param1,-param2,_zOffset);
      }
      
      public function moveTo(param1:Number, param2:Number) : void
      {
         _currentFace.moveTo(param1,-param2,_zOffset);
      }
      
      public function lineStyle(param1:Number = -1, param2:int = -1, param3:Number = -1) : void
      {
      }
      
      public function endFill() : void
      {
      }
   }
}

