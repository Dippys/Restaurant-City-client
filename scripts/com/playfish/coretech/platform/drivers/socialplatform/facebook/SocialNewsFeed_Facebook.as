package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.playfish.coretech.engine.core.PFDebug;
   import com.playfish.coretech.platform.socialplatform.*;
   import com.playfish.coretech.platform.socialplatform.stream.*;
   
   public class SocialNewsFeed_Facebook extends SocialFeed
   {
      
      protected var subtype:String;
      
      public function SocialNewsFeed_Facebook(param1:String, param2:String, param3:Boolean = false)
      {
         super(param3);
         if(param3)
         {
            PFDebug.warning("requireUserConfirmation is ignored in dashboard news feeds.");
         }
         switch(param2)
         {
            case "nudge":
            case "gift":
            case "add connection":
            case "new content":
            case "request":
            case "friend action":
            case "time to come back":
               subtype = param2;
               break;
            default:
               subtype = "time to come back";
               PFDebug.warning("Unknown subtype " + param1 + ". Defaulting to " + subtype);
         }
      }
      
      override public function setTargetUser(param1:*) : Boolean
      {
         if(param1 is String)
         {
            userId = param1;
         }
         return true;
      }
      
      override public function publish(param1:Function = null) : Boolean
      {
         var _loc7_:IStreamParameter = null;
         var _loc8_:StreamLink = null;
         var _loc9_:Object = null;
         super.publish(param1);
         var _loc2_:SocialNewsStory_Facebook = new SocialNewsStory_Facebook();
         var _loc3_:Array = new Array();
         var _loc4_:Object = new Object();
         var _loc5_:String = "";
         var _loc6_:Boolean = true;
         _loc4_["message"] = "";
         for each(_loc7_ in parameters)
         {
            if(_loc7_ is StreamMediaImage)
            {
               _loc2_.setArg("image",(_loc7_ as StreamMediaImage).href);
               _loc6_ = false;
            }
            if(_loc7_ is StreamLink)
            {
               _loc8_ = _loc7_ as StreamLink;
               _loc9_ = new Object();
               _loc9_["text"] = _loc8_.text;
               _loc9_["href"] = _loc8_.href;
               _loc4_["action_link"] = _loc9_;
               _loc6_ = false;
            }
            if(_loc7_ is StreamUnlinkedText)
            {
               _loc4_["message"] += _loc5_;
               _loc4_["message"] += (_loc7_ as StreamUnlinkedText).textMessage;
               _loc5_ = " ";
               _loc6_ = false;
            }
         }
         if(_loc6_)
         {
            _loc2_.resetCall("dashboard.clearNews");
            _loc2_.setArg("uid",SocialPlatform.current.user.getID());
            SocialPlatform_Facebook.facebook.post(_loc2_);
         }
         else
         {
            _loc4_["type"] = subtype;
            _loc3_.push(_loc4_);
            _loc2_.setArg("news",_loc3_);
            SocialPlatform_Facebook.facebook.post(_loc2_);
         }
         return true;
      }
   }
}

