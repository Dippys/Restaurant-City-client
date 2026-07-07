package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.facebook.events.FacebookEvent;
   import com.playfish.coretech.engine.core.*;
   import com.playfish.coretech.engine.debug.*;
   import com.playfish.coretech.platform.socialplatform.*;
   
   public class SocialPlatformFriends_Facebook extends SocialPlatformFriends
   {
      
      private var firstPrepareAttempt:Boolean;
      
      public function SocialPlatformFriends_Facebook(param1:SocialPlatformFriendsSettings)
      {
         super(param1);
         firstPrepareAttempt = true;
      }
      
      override public function isSupported() : Boolean
      {
         return true;
      }
      
      private function triggerRequest() : Boolean
      {
         var _loc1_:String = SocialPlatform.current.user.getID();
         var _loc2_:String = "SELECT sex,uid, name, first_name, last_name, birthday_date, pic_square, pic_big, online_presence, is_app_user FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1=" + _loc1_ + ")";
         return SocialPlatform_Facebook.makeQuery(_loc2_,onGetFriendList);
      }
      
      private function onGetFriendList(param1:FacebookEvent) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Namespace = null;
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:SocialPlatformUser_Facebook = null;
         if(SocialPlatform_Facebook.isValidEventSuccess(param1))
         {
            _loc2_ = new XML(param1.data.rawResult);
            _loc3_ = SocialPlatform_Facebook.fb_namespace;
            if(_loc2_ != null)
            {
               for each(_loc4_ in _loc2_.._loc3_::user)
               {
                  _loc5_ = _loc4_.._loc3_::uid.toString();
                  _loc6_ = SocialPlatform.current.createUser(_loc5_) as SocialPlatformUser_Facebook;
                  _loc6_.setFromXML(_loc4_);
                  SocialPlatform.current.user.addFriend(_loc6_);
                  SocialPlatform.current.user.applyFriendStats(_loc5_);
               }
               available = true;
            }
         }
         if(!available && firstPrepareAttempt)
         {
            triggerRequest();
            firstPrepareAttempt = false;
         }
         else
         {
            platformBackRef.onPrepareComplete(PREPARATION_MASK,this);
         }
      }
      
      override public function prepare(param1:SocialPlatform, param2:SocialPlatformModuleSettings) : Boolean
      {
         super.prepare(param1,param2);
         if(platformBackRef.isPreparing(PREPARATION_MASK) || !param2.enable || isAvailable())
         {
            return true;
         }
         if(triggerRequest())
         {
            platformBackRef.onPrepareBegin(PREPARATION_MASK);
            return true;
         }
         return false;
      }
   }
}

