package com.playfish.coretech.billing.providers
{
   import com.playfish.coretech.billing.PFPaymentProvider;
   import com.playfish.rpc.share.Pricepoint;
   
   public class PFPaymentProviderSuperRewards extends PFPaymentProvider
   {
      
      public function PFPaymentProviderSuperRewards()
      {
         super();
         id = Pricepoint.PAYMENT_PROVIDER_SUPERREWARDS;
         textPayUsing = "Earn free coins by completing offers";
         textAgreement = "SuperRewardsText";
         popupAgreementMovie = "BankAgreementPopupSuperRewards";
         providerRefName = "superrewards";
         providerDisplayName = "SuperRewards";
         priority = 8;
      }
      
      override public function hasPaymentOptionsScreen() : Boolean
      {
         return false;
      }
   }
}

