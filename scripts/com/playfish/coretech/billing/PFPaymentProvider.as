package com.playfish.coretech.billing
{
   public class PFPaymentProvider
   {
      
      public var textPayUsing:String;
      
      public var priority:int;
      
      public var providerRefName:String;
      
      public var enabled:Boolean;
      
      public var popupAgreementMovie:String;
      
      public var id:int;
      
      public var providerDisplayName:String;
      
      public var textAgreement:String;
      
      public function PFPaymentProvider()
      {
         super();
         id = -1;
         textPayUsing = "";
         textAgreement = "BillingSupportText";
         popupAgreementMovie = "BankAgreementPopup";
         providerRefName = "";
         providerDisplayName = "";
         priority = 0;
         enabled = true;
      }
      
      public function getWhatIsMovieClip() : String
      {
         return null;
      }
      
      public function getWhatIsHandler() : Function
      {
         return null;
      }
      
      public function getIcon() : Object
      {
         return null;
      }
      
      public function toString() : String
      {
         return "Provider: " + providerDisplayName + " (" + providerRefName + ")";
      }
      
      public function disable() : void
      {
         enabled = false;
      }
      
      public function isEnabled() : Boolean
      {
         return enabled;
      }
      
      public function hasPaymentOptionsScreen() : Boolean
      {
         return true;
      }
   }
}

