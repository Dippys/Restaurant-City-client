package com.playfish.coretech.billing.providers
{
   import com.playfish.coretech.billing.PFPaymentProvider;
   import com.playfish.rpc.share.Pricepoint;
   
   public class PFPaymentProviderTrialPay extends PFPaymentProvider
   {
      
      public function PFPaymentProviderTrialPay()
      {
         super();
         id = Pricepoint.PAYMENT_PROVIDER_TRIALPAY;
         textPayUsing = "Earn free coins using";
         textAgreement = "TrialPaySupportText";
         providerRefName = "trialpay";
         providerDisplayName = "trialpay";
         priority = 7;
      }
   }
}

