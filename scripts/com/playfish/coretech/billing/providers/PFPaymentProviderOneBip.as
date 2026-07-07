package com.playfish.coretech.billing.providers
{
   import com.playfish.coretech.billing.PFPaymentProvider;
   import com.playfish.rpc.share.Pricepoint;
   
   public class PFPaymentProviderOneBip extends PFPaymentProvider
   {
      
      public function PFPaymentProviderOneBip()
      {
         super();
         id = Pricepoint.PAYMENT_PROVIDER_ONEBIP;
         textPayUsing = "Pay using your mobile/cellphone";
         providerRefName = "onebip";
         providerDisplayName = "onebip";
         priority = 6;
      }
   }
}

