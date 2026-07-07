package com.facebook.utils
{
   import com.facebook.data.FacebookData;
   import com.facebook.errors.FacebookError;
   
   public interface IFacebookResultParser
   {
      
      function parse(param1:String, param2:String) : FacebookData;
      
      function validateFacebookResponce(param1:String) : FacebookError;
   }
}

