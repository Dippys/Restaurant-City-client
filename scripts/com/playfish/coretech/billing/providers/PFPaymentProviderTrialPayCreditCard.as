package com.playfish.coretech.billing.providers
{
   import com.playfish.coretech.billing.PFPaymentProvider;
   import com.playfish.rpc.share.Pricepoint;
   
   public class PFPaymentProviderTrialPayCreditCard extends PFPaymentProvider
   {
      
      public function PFPaymentProviderTrialPayCreditCard()
      {
         super();
         id = Pricepoint.PAYMENT_PROVIDER_TRIALPAY;
         textPayUsing = "Pay by Credit Card";
         providerRefName = "trialpaycc";
         providerDisplayName = "Credit Card";
         priority = 3;
      }
   }
}

