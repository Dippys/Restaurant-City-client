package com.playfish.coretech.billing.providers
{
   import com.playfish.coretech.billing.PFPaymentProvider;
   import com.playfish.rpc.share.Pricepoint;
   
   public class PFPaymentProviderCreditCard extends PFPaymentProvider
   {
      
      public function PFPaymentProviderCreditCard()
      {
         super();
         id = Pricepoint.PAYMENT_PROVIDER_MONEYBOOKERS;
         textPayUsing = "Pay by Credit Card";
         providerRefName = "moneybookers";
         providerDisplayName = "Credit Card";
         priority = 2;
      }
   }
}

