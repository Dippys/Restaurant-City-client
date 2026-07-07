package com.playfish.coretech.billing.providers
{
   import com.playfish.coretech.billing.PFPaymentProvider;
   import com.playfish.rpc.share.Pricepoint;
   
   public class PFPaymentProviderPayMo extends PFPaymentProvider
   {
      
      public function PFPaymentProviderPayMo()
      {
         super();
         id = Pricepoint.PAYMENT_PROVIDER_PAYMO;
         textPayUsing = "Pay using your mobile/cellphone";
         providerRefName = "paymo";
         providerDisplayName = "paymo";
         priority = 5;
      }
   }
}

