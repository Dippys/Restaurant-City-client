package away3d.core.base
{
   import away3d.arcane;
   import away3d.events.ElementEvent;
   import flash.events.EventDispatcher;
   
   use namespace arcane;
   
   public class Element extends EventDispatcher
   {
      
      private var _mappingchanged:ElementEvent;
      
      public var vertexDirty:Boolean;
      
      public var extra:Object;
      
      private var _vertexchanged:ElementEvent;
      
      private var _visiblechanged:ElementEvent;
      
      public var parent:Geometry;
      
      private var _vertexvaluechanged:ElementEvent;
      
      arcane var _visible:Boolean = true;
      
      public function Element()
      {
         super();
      }
      
      arcane function notifyVisibleChange() : void
      {
         if(!hasEventListener(ElementEvent.VISIBLE_CHANGED))
         {
            return;
         }
         if(_visiblechanged == null)
         {
            _visiblechanged = new ElementEvent(ElementEvent.VISIBLE_CHANGED,this);
         }
         dispatchEvent(_visiblechanged);
      }
      
      public function addOnVertexChange(param1:Function) : void
      {
         addEventListener(ElementEvent.VERTEX_CHANGED,param1,false,0,true);
      }
      
      public function get minX() : Number
      {
         return -Math.sqrt(radius2);
      }
      
      public function get minY() : Number
      {
         return -Math.sqrt(radius2);
      }
      
      public function get commands() : Array
      {
         throw new Error("Not implemented");
      }
      
      public function addOnVisibleChange(param1:Function) : void
      {
         addEventListener(ElementEvent.VISIBLE_CHANGED,param1,false,0,true);
      }
      
      public function get minZ() : Number
      {
         return -Math.sqrt(radius2);
      }
      
      arcane function notifyMappingChange() : void
      {
         if(!hasEventListener(ElementEvent.MAPPING_CHANGED))
         {
            return;
         }
         if(_mappingchanged == null)
         {
            _mappingchanged = new ElementEvent(ElementEvent.MAPPING_CHANGED,this);
         }
         dispatchEvent(_mappingchanged);
      }
      
      public function removeOnVertexChange(param1:Function) : void
      {
         removeEventListener(ElementEvent.VERTEX_CHANGED,param1,false);
      }
      
      public function removeOnMappingChange(param1:Function) : void
      {
         removeEventListener(ElementEvent.MAPPING_CHANGED,param1,false);
      }
      
      arcane function notifyVertexChange() : void
      {
         if(!hasEventListener(ElementEvent.VERTEX_CHANGED))
         {
            return;
         }
         if(_vertexchanged == null)
         {
            _vertexchanged = new ElementEvent(ElementEvent.VERTEX_CHANGED,this);
         }
         dispatchEvent(_vertexchanged);
      }
      
      public function addOnMappingChange(param1:Function) : void
      {
         addEventListener(ElementEvent.MAPPING_CHANGED,param1,false,0,true);
      }
      
      public function set visible(param1:Boolean) : void
      {
         if(param1 == _visible)
         {
            return;
         }
         _visible = param1;
         notifyVisibleChange();
      }
      
      public function get radius2() : Number
      {
         var _loc2_:Vertex = null;
         var _loc3_:Number = NaN;
         var _loc1_:Number = 0;
         for each(_loc2_ in vertices)
         {
            _loc3_ = _loc2_._x * _loc2_._x + _loc2_._y * _loc2_._y + _loc2_._z * _loc2_._z;
            if(_loc3_ > _loc1_)
            {
               _loc1_ = _loc3_;
            }
         }
         return _loc1_;
      }
      
      public function get visible() : Boolean
      {
         return _visible;
      }
      
      arcane function notifyVertexValueChange() : void
      {
         if(!hasEventListener(ElementEvent.VERTEXVALUE_CHANGED))
         {
            return;
         }
         if(_vertexvaluechanged == null)
         {
            _vertexvaluechanged = new ElementEvent(ElementEvent.VERTEXVALUE_CHANGED,this);
         }
         dispatchEvent(_vertexvaluechanged);
      }
      
      public function get maxY() : Number
      {
         return Math.sqrt(radius2);
      }
      
      public function get maxZ() : Number
      {
         return Math.sqrt(radius2);
      }
      
      public function get vertices() : Array
      {
         throw new Error("Not implemented");
      }
      
      public function removeOnVertexValueChange(param1:Function) : void
      {
         removeEventListener(ElementEvent.VERTEXVALUE_CHANGED,param1,false);
      }
      
      public function get maxX() : Number
      {
         return Math.sqrt(radius2);
      }
      
      public function addOnVertexValueChange(param1:Function) : void
      {
         addEventListener(ElementEvent.VERTEXVALUE_CHANGED,param1,false,0,true);
      }
      
      public function removeOnVisibleChange(param1:Function) : void
      {
         removeEventListener(ElementEvent.VISIBLE_CHANGED,param1,false);
      }
   }
}

