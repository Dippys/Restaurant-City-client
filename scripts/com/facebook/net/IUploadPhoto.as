package com.facebook.net
{
   public interface IUploadPhoto
   {
      
      function set data(param1:Object) : void;
      
      function set uploadType(param1:String) : void;
      
      function get data() : Object;
      
      function get uploadType() : String;
      
      function set uploadQuality(param1:uint) : void;
      
      function get uploadQuality() : uint;
   }
}

