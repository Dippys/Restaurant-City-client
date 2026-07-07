package away3d.loaders.utils
{
   import away3d.core.utils.Debug;
   import away3d.loaders.data.*;
   import flash.utils.Dictionary;
   
   public dynamic class GeometryLibrary extends Dictionary
   {
      
      private var _geometryArray:Array;
      
      private var _geometryArrayDirty:Boolean;
      
      public var name:String;
      
      public function GeometryLibrary()
      {
         super();
      }
      
      public function getGeometryArray() : Array
      {
         if(_geometryArrayDirty)
         {
            updateGeometryArray();
         }
         return _geometryArray;
      }
      
      public function addGeometry(param1:String, param2:XML = null, param3:XML = null) : GeometryData
      {
         if(this[param1])
         {
            return this[param1];
         }
         _geometryArrayDirty = true;
         var _loc4_:GeometryData = new GeometryData();
         _loc4_.geoXML = param2;
         _loc4_.ctrlXML = param3;
         var _loc5_:String;
         this[_loc5_ = _loc4_.name = param1] = _loc4_;
         return _loc4_;
      }
      
      private function updateGeometryArray() : void
      {
         var _loc1_:GeometryData = null;
         _geometryArray = [];
         for each(_loc1_ in this)
         {
            _geometryArray.push(_loc1_);
         }
      }
      
      public function getGeometry(param1:String) : GeometryData
      {
         if(this[param1])
         {
            return this[param1];
         }
         Debug.warning("Geometry \'" + param1 + "\' does not exist");
         return null;
      }
   }
}

