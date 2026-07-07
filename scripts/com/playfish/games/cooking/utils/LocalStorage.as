package com.playfish.games.cooking.utils
{
   import flash.net.*;
   import flash.utils.*;
   
   public class LocalStorage
   {
      
      public var sharedObject:SharedObject;
      
      public function LocalStorage(param1:String)
      {
         var name:String = param1;
         super();
         try
         {
            sharedObject = SharedObject.getLocal(name);
         }
         catch(e:Error)
         {
         }
      }
      
      public function save(param1:String, param2:Object) : void
      {
         var entryName:String = param1;
         var data:Object = param2;
         if(sharedObject)
         {
            try
            {
               sharedObject.setProperty(entryName,data);
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function load(param1:String) : Object
      {
         var entryName:String = param1;
         if(sharedObject)
         {
            try
            {
               return sharedObject.data[entryName];
            }
            catch(e:Error)
            {
            }
         }
         return null;
      }
   }
}

