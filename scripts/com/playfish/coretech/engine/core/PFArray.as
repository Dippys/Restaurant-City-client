package com.playfish.coretech.engine.core
{
   public class PFArray
   {
      
      public function PFArray()
      {
         super();
      }
      
      public static function insert(param1:Array, param2:uint, param3:Object) : void
      {
         var _loc4_:uint = param1.length;
         while(_loc4_ > param2)
         {
            param1[_loc4_] = param1[_loc4_ - 1];
            _loc4_--;
         }
         param1[param2] = param3;
      }
      
      public static function intersection(param1:Array, param2:Array) : Array
      {
         var _loc4_:Object = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in param1)
         {
            if(param2.indexOf(_loc4_) != -1)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public static function remove(param1:Array, param2:Array) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         if(param1 == null)
         {
            return null;
         }
         var _loc3_:Array = param1.slice();
         if(param2 != null)
         {
            for each(_loc4_ in param2)
            {
               _loc5_ = _loc3_.indexOf(_loc4_);
               if(_loc5_ != -1)
               {
                  _loc3_.splice(_loc5_,1);
               }
            }
         }
         return _loc3_;
      }
      
      public static function getRandomEntry(param1:Array) : Object
      {
         if(param1 == null || param1.length == 0)
         {
            return null;
         }
         return param1[uint(Math.random() * param1.length)];
      }
      
      public static function embedInplace(param1:Array, param2:*, param3:int) : void
      {
         PFDebug.assert(param3 < param1.length);
         param1.splice.apply(param1,[param3,0].concat(param2));
      }
      
      public static function getMappingReverse(param1:Array, param2:Object, param3:int = 1) : Object
      {
         var _loc4_:Array = null;
         for each(_loc4_ in param1)
         {
            if(_loc4_[param3] == param2)
            {
               return _loc4_[0];
            }
         }
         return null;
      }
      
      public static function removeFromArray(param1:Array, param2:Object) : void
      {
         var _loc3_:int = param1.indexOf(param2);
         if(_loc3_ != -1)
         {
            param1.splice(_loc3_,1);
         }
      }
      
      public static function clearArray(param1:Array) : void
      {
         param1.splice(0,param1.length);
      }
      
      public static function union(param1:Array, param2:Array) : Array
      {
         var _loc4_:Object = null;
         var _loc3_:Array = param1.slice();
         for each(_loc4_ in param2)
         {
            if(param1.indexOf(_loc4_) == -1)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public static function addToArrayAt(param1:Array, param2:Array, param3:int = 0) : void
      {
         if(param2 == null)
         {
            return;
         }
         if(param1 == null)
         {
            param1 = new Array();
         }
         var _loc4_:Array = param1.splice(param3,param1.length - param3);
         addToArray(param1,param2);
         addToArray(param1,_loc4_);
      }
      
      public static function randomize(param1:Array) : Array
      {
         return param1;
      }
      
      public static function unique(param1:Array, param2:Array) : Array
      {
         var _loc4_:Object = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in param2)
         {
            if(param1.indexOf(_loc4_) == -1)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public static function getMapping(param1:Array, param2:Object, param3:int = 1) : Object
      {
         var _loc4_:Array = null;
         for each(_loc4_ in param1)
         {
            if(_loc4_[0] == param2)
            {
               return _loc4_[param3];
            }
         }
         return null;
      }
      
      public static function embed(param1:Array, param2:*, param3:int) : Array
      {
         PFDebug.assert(param3 < param1.length);
         var _loc4_:Array = param1.slice();
         _loc4_.splice.apply(_loc4_,[param3,0].concat(param2));
         return _loc4_;
      }
      
      public static function uniqueString(param1:Array, param2:Array) : Array
      {
         var _loc4_:Object = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in param2)
         {
            if(param1.indexOf(String(_loc4_)) == -1)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public static function toString(param1:Array) : String
      {
         var _loc4_:String = null;
         var _loc2_:String = "";
         var _loc3_:String = "";
         for each(_loc4_ in param1)
         {
            _loc2_ += _loc3_;
            _loc2_ += _loc4_.toString();
            _loc3_ = ", ";
         }
         return _loc2_ + ".";
      }
      
      public static function sortByValue(param1:Array, param2:Function = null) : Array
      {
         var _loc3_:int = int(param1.length);
         var _loc4_:Array = param1.slice();
         _loc4_ = _loc4_.slice(0,_loc3_);
         if(param2 != null)
         {
            _loc4_.sort(param2);
         }
         else
         {
            _loc4_.sort(Array.NUMERIC);
         }
         return _loc4_;
      }
      
      public static function addToArray(param1:Array, param2:Array) : void
      {
         if(param2 == null)
         {
            return;
         }
         if(param1 == null)
         {
            param1 = new Array();
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            param1.push(param2[_loc3_]);
            _loc3_++;
         }
      }
      
      public static function sharesEntry(param1:Array, param2:Array) : Boolean
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         for each(_loc3_ in param1)
         {
            for each(_loc4_ in param2)
            {
               if(_loc3_ == _loc4_)
               {
                  return true;
               }
            }
         }
         return false;
      }
   }
}

