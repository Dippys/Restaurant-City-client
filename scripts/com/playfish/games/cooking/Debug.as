package com.playfish.games.cooking
{
   import com.playfish.games.cooking.debug.*;
   
   public class Debug
   {
      
      private static var debugEntries:Array;
      
      public static const DEBUG:Boolean = false;
      
      public static const NETWORK_ONLY:Boolean = false;
      
      public static const NETWORK_TEST_FLASH_VARS:String = "pf_network=facebook&pf_billing_config=http%3A%2F%2Flocalhost%3A8090%2Fproject%2Fcooking%2Fintegration%2Fswf%2Fbillingconfig.xml&pf_paymo_url=popup%3AaddPurchaseIFramePaymo&pf_trialpay_url=popup%3AaddPurchaseIFrame&pf_facebook_url=popup%3AsubmitFacebookOrder&pf_moneybookers_url=popup%3AaddPurchaseIFrameMoneybookers&pf_superrewards_url=popup%3AaddPurchaseIFrameSuperRewards&pf_onebip_url=popup%3AaddPurchaseIFrameOnebip&pf_trialpay_currency_url=popup%3AaddPurchaseIFrameTrialPayCurrency&pf_lang=en&pf_user_country=GB&pf_game_swf_url=http%3A%2F%2Flocalhost%3A8090%2Fproject%2Fcooking%2Fintegration%2Fswf%2Fgame.swf&pf_url=http%3A%2F%2Flocalhost%3A8090%2Fg%2Frpc%2Fcooking&pf_session_id=al2eEaanaaibGTB5Oq6C6ONW3t.0FXHe_q5S8IGtndiUn3HNzdvUvuj3rdu2AKjkn19hz1bcD19FlJm2mdaUmti2ntGYodqWmc03mtKYmti2odzt7ZMhvRq7rW&pf_lang_url=http%3A%2F%2Flocalhost%3A8090%2Fproject%2Fcooking%2Fintegration%2Fswf%2Flang.bin&pf_res_base_url=http%3A%2F%2Flocalhost%3A8090%2Fproject%2Fcooking%2Fintegration%2F&pf_retry_url=http://apps.facebook.com/cooking-integration/?pf_ref=retry&pf_lang=en&pf_feed_list=http%3A%2F%2Flocalhost%3A8090%2Fg%2Ffbfeed%2Fcooking&pf_feed_url=popup%3AaddFeedSystem&pf_stream_url=popup%3AaddStream&pf_invite_url=popup%3AaddInviteFriendsIFrame&pf_send_gift_url=popup%3AaddSendGiftIFrame&pf_visitus_url=http%3A%2F%2Fwww.playfish.com%2F&pf_profile_base=http%3A%2F%2Fapps.facebook.com%2Fcooking-integration%2Fprofile%3Fpf_uid%3D&pf_purchase_base=http%3A%2F%2Flocalhost%3A8090%2Fg%2Fbilling%2Fpurchase&pf_ingameads=&fb_sig_time=1265823033.8207&fb_sig_in_new_facebook=1&fb_sig_session_key=2.7xgd5nUBwD56jBJ7_GgPBw__.3600.1265828400-719212686&fb_sig_profile_update_time=1252573788&fb_sig_app_id=78500156402&fb_sig_user=719212686&fb_sig_added=1&fb_sig_iframe_key=d3d9446802a44259755d38e6d163e820&fb_sig_ss=9ZBjDo_AoLKZmemvmw9VmQ__&fb_sig_expires=1265828400&fb_sig_in_iframe=1&fb_sig_ext_perms=status_update%2Cphoto_upload%2Cvideo_upload%2Ccreate_note%2Cshare_item%2Cauto_publish_short_feed%2Cpublish_stream%2Cauto_publish_recent_activity&fb_sig_cookie_sig=6fa62a19d5fc502a28059acdf0dc6edb&fb_sig_locale=en_GB&fb_sig=d7aa9ce03a49772b5f50559def7b91a6&fb_sig_api_key=9cea89f0dd3fb47f1844fd0e6cf22813&pf_console_config_url=http%3A%2F%2Flocalhost%3A8090%2Fproject%2Fcooking%2Fintegration%2Fswf%2Fconsole_config_cooking_020204.xml&pf_console_swf_base_url=http%3A%2F%2Flocalhost%3A8090%2Fproject%2Fconsole%2Fconsole_integration_swf%2F&pf_console_width=760&pf_console_height=756&pf_console_gameloader_url=http%3A%2F%2Flocalhost%3A8090%2Fproject%2Fcooking%2Fintegration%2Fswf%2Fpreloader.swf&pf_bookmark_url=popup%3AaddBookmark&pf_permissions_url=popup%3AaddPermission";
      
      public static const OFFLINE_MODE:Boolean = false;
      
      public static const FORCE_ENABLE_TUTORIAL:Boolean = false;
      
      public static const SHOW_AVATAR_BASE:Boolean = false;
      
      public static const GENERATE_RANDOM_STREET_BUILDING:Boolean = false;
      
      public static const GENERATE_RANDOM_INGREDIENTS:Boolean = false;
      
      public static const TEST_CASH_MAILS:int = 0;
      
      public static const TEST_PLAYFISH_MAILS:int = 0;
      
      public static const TEST_NET_PROMOTER:Boolean = false;
      
      public function Debug()
      {
         super();
      }
      
      public static function assert(param1:Boolean, param2:String = "Unspecified assertion") : Boolean
      {
         if(!param1)
         {
            warning(param2);
         }
         return param1;
      }
      
      public static function out(param1:String) : void
      {
         if(DEBUG)
         {
            trace(param1);
         }
      }
      
      public static function init() : void
      {
         if(DEBUG)
         {
            debugEntries = new Array();
            debugEntries.push(new DebugAddCoins(100));
            debugEntries.push(new DebugAddCoins(1000));
            debugEntries.push(new DebugAddCoins(-10000));
            debugEntries.push(new DebugAddCoins(-100000));
            debugEntries.push(new DebugAddPlayfishCash(100));
            debugEntries.push(new DebugAddPlayfishCash(-100000));
            debugEntries.push(new DebugAddGourmetPoints(100));
            debugEntries.push(new DebugAddGourmetPoints(10000));
            debugEntries.push(new DebugAddGourmetPoints(-10000));
            debugEntries.push(new DebugAddDemand(10));
            debugEntries.push(new DebugAddDemand(-10));
            debugEntries.push(new DebugAddTrash(1));
            debugEntries.push(new DebugAddQuizMail());
            debugEntries.push(new DebugAddInviteGiftFoodMail());
            debugEntries.push(new DebugResetFirstTimeAccess());
            debugEntries.push(new DebugShowAllShopItems());
            debugEntries.push(new DebugAddAwardValue(GameAwards.AWARD_HARVEST,5));
            debugEntries.push(new DebugPostFeed());
            debugEntries.push(new DebugTogglePaymentCountry());
            debugEntries.push(new DebugOverrideFullScreenAspectRatio(4,3));
            debugEntries.push(new DebugOverrideFullScreenAspectRatio(9,16));
            debugEntries.push(new DebugTestLevel10DishPopUp());
            debugEntries.push(new DebugResetOutsideArea());
            debugEntries.push(new DebugToggleLevelGate());
            debugEntries.push(new DebugAddBlackSheep());
            debugEntries.push(new DebugAddShopTime());
            debugEntries.push(new DebugDailyBonus());
            debugEntries.push(new DebugDecreaseWorkTime(10));
         }
      }
      
      public static function warning(param1:String) : void
      {
         if(DEBUG)
         {
            new ErrorDialog(param1,ErrorDialog.TYPE_WARNING);
         }
      }
      
      public static function showDebugPanel() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:DebugPanel = null;
         var _loc4_:DebugEntry = null;
         if(DEBUG)
         {
            if(DebugPanel.instance)
            {
               DebugPanel.instance.remove();
            }
            else
            {
               _loc1_ = new Array();
               _loc2_ = 0;
               while(_loc2_ < debugEntries.length)
               {
                  _loc4_ = debugEntries[_loc2_];
                  if(_loc4_.isAvailable())
                  {
                     _loc1_.push(_loc4_);
                  }
                  _loc2_++;
               }
               _loc3_ = new DebugPanel(_loc1_);
               _loc3_.show();
            }
         }
      }
   }
}

