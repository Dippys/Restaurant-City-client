package away3d.core.render
{
   import away3d.cameras.Camera3D;
   import away3d.containers.Scene3D;
   import away3d.containers.View3D;
   import away3d.core.block.Blocker;
   import away3d.core.clip.Clipping;
   import away3d.core.draw.DrawPrimitive;
   import away3d.core.draw.IPrimitiveConsumer;
   import away3d.core.filter.IPrimitiveFilter;
   import away3d.core.filter.ZSortFilter;
   
   public class BasicRenderer implements IRenderer, IPrimitiveConsumer
   {
      
      private var _camera:Camera3D;
      
      private var _primitives:Array = new Array();
      
      private var _filter:IPrimitiveFilter;
      
      private var _blockers:Array;
      
      private var _scene:Scene3D;
      
      private var _primitive:DrawPrimitive;
      
      private var _screenClipping:Clipping;
      
      private var _filters:Array;
      
      public function BasicRenderer(... rest)
      {
         super();
         _filters = rest;
         _filters.push(new ZSortFilter());
      }
      
      public function clear(param1:View3D) : void
      {
         _primitives.length = 0;
         _scene = param1.scene;
         _camera = param1.camera;
         _screenClipping = param1.screenClipping;
         _blockers = param1.blockerarray.list();
      }
      
      public function render(param1:View3D) : void
      {
         for each(_filter in _filters)
         {
            _primitives = _filter.filter(_primitives,_scene,_camera,_screenClipping);
         }
         for each(_primitive in _primitives)
         {
            _primitive.render();
         }
      }
      
      public function clone() : IPrimitiveConsumer
      {
         var _loc1_:BasicRenderer = new BasicRenderer();
         _loc1_.filters = filters;
         return _loc1_;
      }
      
      public function list() : Array
      {
         return _primitives;
      }
      
      public function primitive(param1:DrawPrimitive) : Boolean
      {
         var _loc2_:Blocker = null;
         if(!_screenClipping.checkPrimitive(param1))
         {
            return false;
         }
         for each(_loc2_ in _blockers)
         {
            if(_loc2_.screenZ <= param1.minZ)
            {
               if(_loc2_.block(param1))
               {
                  return false;
               }
            }
         }
         _primitives.push(param1);
         return true;
      }
      
      public function toString() : String
      {
         return "Basic [" + _filters.join("+") + "]";
      }
      
      public function set filters(param1:Array) : void
      {
         _filters = param1;
         _filters.push(new ZSortFilter());
      }
      
      public function get filters() : Array
      {
         return _filters.slice(0,_filters.length - 1);
      }
   }
}

