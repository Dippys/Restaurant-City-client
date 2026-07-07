package com.playfish.coretech.billing.providers
{
   import com.playfish.coretech.billing.PFPaymentProvider;
   import com.playfish.rpc.share.Pricepoint;
   
   public class PFPaymentProviderPayPal extends PFPaymentProvider
   {
      
      public function PFPaymentProviderPayPal()
      {
         super();
         id = Pricepoint.PAYMENT_PROVIDER_PAYPAL;
         textPayUsing = "Pay using";
         textAgreement = "BillingSupportText";
         providerRefName = "paypal";
         providerDisplayName = "PayPal";
         priority = 1;
      }
   }
}

