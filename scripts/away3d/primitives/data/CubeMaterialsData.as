package away3d.primitives.data
{
   import away3d.core.utils.Init;
   import away3d.events.MaterialEvent;
   import away3d.materials.ITriangleMaterial;
   import flash.events.EventDispatcher;
   
   public class CubeMaterialsData extends EventDispatcher
   {
      
      private var _back:ITriangleMaterial;
      
      private var _bottom:ITriangleMaterial;
      
      private var _top:ITriangleMaterial;
      
      protected var ini:Init;
      
      private var _left:ITriangleMaterial;
      
      private var _front:ITriangleMaterial;
      
      private var _materialchanged:MaterialEvent;
      
      private var _right:ITriangleMaterial;
      
      public function CubeMaterialsData(param1:Object = null)
      {
         super();
         ini = Init.parse(param1);
         _left = ini.getMaterial("left") as ITriangleMaterial;
         _right = ini.getMaterial("right") as ITriangleMaterial;
         _bottom = ini.getMaterial("bottom") as ITriangleMaterial;
         _top = ini.getMaterial("top") as ITriangleMaterial;
         _front = ini.getMaterial("front") as ITriangleMaterial;
         _back = ini.getMaterial("back") as ITriangleMaterial;
      }
      
      public function get left() : ITriangleMaterial
      {
         return _left;
      }
      
      public function set left(param1:ITriangleMaterial) : void
      {
         if(_left == param1)
         {
            return;
         }
         _left = param1;
         notifyMaterialChange(_left,"left");
      }
      
      public function set front(param1:ITriangleMaterial) : void
      {
         if(_front == param1)
         {
            return;
         }
         _front = param1;
         notifyMaterialChange(_front,"front");
      }
      
      public function get top() : ITriangleMaterial
      {
         return _top;
      }
      
      public function set bottom(param1:ITriangleMaterial) : void
      {
         if(_bottom == param1)
         {
            return;
         }
         _bottom = param1;
         notifyMaterialChange(_bottom,"bottom");
      }
      
      public function removeOnMaterialChange(param1:Function) : void
      {
         removeEventListener(MaterialEvent.MATERIAL_CHANGED,param1,false);
      }
      
      public function get right() : ITriangleMaterial
      {
         return _right;
      }
      
      private function notifyMaterialChange(param1:ITriangleMaterial, param2:String) : void
      {
         if(!hasEventListener(MaterialEvent.MATERIAL_CHANGED))
         {
            return;
         }
         _materialchanged = new MaterialEvent(MaterialEvent.MATERIAL_CHANGED,param1);
         _materialchanged.extra = param2;
         dispatchEvent(_materialchanged);
      }
      
      public function get back() : ITriangleMaterial
      {
         return _back;
      }
      
      public function get front() : ITriangleMaterial
      {
         return _front;
      }
      
      public function get bottom() : ITriangleMaterial
      {
         return _bottom;
      }
      
      public function set back(param1:ITriangleMaterial) : void
      {
         if(_back == param1)
         {
            return;
         }
         _back = param1;
         notifyMaterialChange(_back,"back");
      }
      
      public function set top(param1:ITriangleMaterial) : void
      {
         if(_top == param1)
         {
            return;
         }
         _top = param1;
         notifyMaterialChange(_top,"top");
      }
      
      public function addOnMaterialChange(param1:Function) : void
      {
         addEventListener(MaterialEvent.MATERIAL_CHANGED,param1,false,0,false);
      }
      
      public function set right(param1:ITriangleMaterial) : void
      {
         if(_right == param1)
         {
            return;
         }
         _right = param1;
         notifyMaterialChange(_right,"right");
      }
   }
}

