package away3d.core.base
{
   import away3d.arcane;
   import away3d.core.utils.ValueObject;
   
   use namespace arcane;
   
   public class UV extends ValueObject
   {
      
      public var extra:Object;
      
      arcane var _u:Number;
      
      arcane var _v:Number;
      
      public function UV(param1:Number = 0, param2:Number = 0)
      {
         super();
         arcane::_u = param1;
         arcane::_v = param2;
      }
      
      arcane static function median(param1:UV, param2:UV) : UV
      {
         if(param1 == null)
         {
            return null;
         }
         if(param2 == null)
         {
            return null;
         }
         return new UV((param1._u + param2._u) / 2,(param1._v + param2._v) / 2);
      }
      
      arcane static function weighted(param1:UV, param2:UV, param3:Number, param4:Number) : UV
      {
         if(param1 == null)
         {
            return null;
         }
         if(param2 == null)
         {
            return null;
         }
         var _loc5_:Number = param3 + param4;
         var _loc6_:Number = param3 / _loc5_;
         var _loc7_:Number = param4 / _loc5_;
         return new UV(param1._u * _loc6_ + param2._u * _loc7_,param1._v * _loc6_ + param2._v * _loc7_);
      }
      
      override public function toString() : String
      {
         return "new UV(" + _u + ", " + _v + ")";
      }
      
      public function get v() : Number
      {
         return _v;
      }
      
      public function set u(param1:Number) : void
      {
         if(param1 == _u)
         {
            return;
         }
         _u = param1;
         notifyChange();
      }
      
      public function set v(param1:Number) : void
      {
         if(param1 == _v)
         {
            return;
         }
         _v = param1;
         notifyChange();
      }
      
      public function get u() : Number
      {
         return _u;
      }
      
      public function clone() : UV
      {
         return new UV(_u,_v);
      }
   }
}

