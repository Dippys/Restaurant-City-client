package com.playfish.coretech.billing.providers
{
   import com.playfish.coretech.billing.PFPaymentProvider;
   import com.playfish.rpc.share.Pricepoint;
   
   public class PFPaymentProviderPayByCash extends PFPaymentProvider
   {
      
      public function PFPaymentProviderPayByCash()
      {
         super();
         id = Pricepoint.PAYMENT_PROVIDER_PAYBYCASH;
         textPayUsing = "Pay using";
         providerRefName = "paybycash";
         providerDisplayName = "Pay By Cash";
         priority = 9;
      }
   }
}

