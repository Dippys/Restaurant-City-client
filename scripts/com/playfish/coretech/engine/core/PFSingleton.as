package com.playfish.coretech.engine.core
{
   import flash.events.EventDispatcher;
   import flash.utils.*;
   
   public class PFSingleton extends EventDispatcher
   {
      
      private static var root:Object;
      
      public function PFSingleton()
      {
         super();
         if(root == null)
         {
            root = new Object();
         }
         var _loc1_:String = getQualifiedClassName(this);
         if(root[_loc1_] != null)
         {
            PFDebug.error("Attempting to create multiple singleton objects.");
            return;
         }
         root[_loc1_] = this;
      }
      
      public static function getInstance(param1:Class) : PFSingleton
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(root == null)
         {
            return null;
         }
         _loc2_ = getQualifiedClassName(param1);
         _loc3_ = root.toString();
         return root[_loc2_];
      }
      
      public function dispose() : void
      {
         var _loc1_:String = getQualifiedClassName(this);
         root[_loc1_] = null;
      }
   }
}

