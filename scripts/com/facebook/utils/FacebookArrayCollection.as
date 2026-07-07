package com.facebook.utils
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class FacebookArrayCollection extends EventDispatcher
   {
      
      protected var _source:Array;
      
      protected var hash:Dictionary;
      
      protected var _type:Class;
      
      public function FacebookArrayCollection(param1:Array = null, param2:Class = null)
      {
         super();
         this.reset();
         this._type = param2;
         this.initilizeSource(param1);
      }
      
      protected function verifyIndex(param1:uint) : void
      {
         if(this._source.length < param1)
         {
            throw new RangeError("Index: " + param1 + ", is out of range.");
         }
      }
      
      public function addItem(param1:Object) : void
      {
         this.addItemAt(param1,this.length);
      }
      
      public function get length() : int
      {
         return this._source.length;
      }
      
      public function addItemAt(param1:Object, param2:uint) : void
      {
         if(this.hash[param1] != null)
         {
            throw new Error("Item already exists.");
         }
         if(this._type !== null && !(param1 is this._type))
         {
            throw new TypeError("This collection requires " + this._type + " as the type.");
         }
         this.hash[param1] = true;
         this._source.splice(param2,0,param1);
      }
      
      public function indexOf(param1:Object) : int
      {
         return this._source.indexOf(param1);
      }
      
      public function removeItemAt(param1:uint) : void
      {
         this.verifyIndex(param1);
         var _loc2_:Object = this._source[param1];
         delete this.hash[_loc2_];
         this._source.splice(param1,1);
      }
      
      public function getItemAt(param1:uint) : Object
      {
         this.verifyIndex(param1);
         return this._source[param1];
      }
      
      override public function toString() : String
      {
         return this._source.join(", ");
      }
      
      public function reset() : void
      {
         this.hash = new Dictionary(true);
         this._source = [];
      }
      
      protected function initilizeSource(param1:Array) : void
      {
         this._source = [];
         if(param1 == null)
         {
            return;
         }
         var _loc2_:uint = param1.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            this.addItem(param1[_loc3_]);
            _loc3_++;
         }
      }
      
      public function findItemByProperty(param1:String, param2:Object, param3:Boolean = false) : Object
      {
         var _loc4_:Object = null;
         for(_loc4_ in this.hash)
         {
            if(param3 && param1 in _loc4_ && _loc4_[param1] === param2)
            {
               return _loc4_;
            }
            if(!param3 && param1 in _loc4_ && _loc4_[param1] == param2)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public function get type() : Class
      {
         return this._type;
      }
      
      public function get source() : Array
      {
         return this._source;
      }
      
      public function toArray() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = uint(this.length);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_.push(this.getItemAt(_loc3_));
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function contains(param1:Object) : Boolean
      {
         return this.hash[param1] === true;
      }
   }
}

