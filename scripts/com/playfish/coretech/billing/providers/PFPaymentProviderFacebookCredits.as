package com.playfish.coretech.billing.providers
{
   import com.playfish.coretech.billing.PFPaymentProvider;
   import com.playfish.rpc.share.Pricepoint;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class PFPaymentProviderFacebookCredits extends PFPaymentProvider
   {
      
      private static const WHAT_IS_FACEBOOK_CREDITS_URL:String = "http://www.facebook.com/help.php?page=837";
      
      public function PFPaymentProviderFacebookCredits()
      {
         super();
         id = Pricepoint.PAYMENT_PROVIDER_FACEBOOK;
         textPayUsing = "Pay using Facebook Credits";
         providerRefName = "facebook";
         providerDisplayName = "Facebook Credits";
         priority = 4;
      }
      
      public static function processWhatIsHandler(param1:*) : void
      {
         var _loc2_:URLRequest = new URLRequest(WHAT_IS_FACEBOOK_CREDITS_URL);
         navigateToURL(_loc2_,"_blank");
      }
      
      override public function getWhatIsMovieClip() : String
      {
         return "mc_facebook";
      }
      
      override public function getWhatIsHandler() : Function
      {
         return processWhatIsHandler;
      }
   }
}

