package com.facebook.delegates
{
   import com.facebook.net.FacebookCall;
   import com.facebook.session.DesktopSession;
   
   public class DesktopDelegate extends WebDelegate
   {
      
      public function DesktopDelegate(param1:FacebookCall, param2:DesktopSession)
      {
         super(param1,param2);
      }
      
      override protected function addOptionalArguments() : void
      {
      }
   }
}

