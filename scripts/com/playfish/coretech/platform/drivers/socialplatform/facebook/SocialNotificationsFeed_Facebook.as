package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.facebook.commands.notifications.SendNotification;
   import com.playfish.coretech.engine.core.PFArray;
   import com.playfish.coretech.platform.socialplatform.SocialFeed;
   import com.playfish.coretech.platform.socialplatform.stream.IStreamParameter;
   import com.playfish.coretech.platform.socialplatform.stream.StreamLink;
   import com.playfish.coretech.platform.socialplatform.stream.StreamUnlinkedText;
   
   public class SocialNotificationsFeed_Facebook extends SocialFeed
   {
      
      private var userList:Array;
      
      public function SocialNotificationsFeed_Facebook(param1:String, param2:Boolean = false)
      {
         super(param2);
         userList = new Array();
      }
      
      override public function setTargetUser(param1:*) : Boolean
      {
         if(param1 is String)
         {
            userList.push(param1);
         }
         else if(param1 is Array)
         {
            userList = PFArray.union(userList,param1);
         }
         return true;
      }
      
      override public function publish(param1:Function = null) : Boolean
      {
         var _loc5_:IStreamParameter = null;
         var _loc6_:SendNotification = null;
         var _loc7_:StreamLink = null;
         super.publish(param1);
         var _loc2_:SocialNewsStory_Facebook = new SocialNewsStory_Facebook();
         var _loc3_:String = "";
         var _loc4_:String = "";
         for each(_loc5_ in parameters)
         {
            if(_loc5_ is StreamLink)
            {
               _loc7_ = _loc5_ as StreamLink;
               _loc4_ += _loc3_;
               _loc4_ = _loc4_ + ("<a href=\'" + _loc7_.href + "\'>" + _loc7_.text + "</a>");
               _loc3_ = " ";
            }
            if(_loc5_ is StreamUnlinkedText)
            {
               _loc4_ += _loc3_;
               _loc4_ = _loc4_ + (_loc5_ as StreamUnlinkedText).textMessage;
               _loc3_ = " ";
            }
         }
         _loc6_ = new SendNotification(userList,_loc4_);
         SocialPlatform_Facebook.facebook.post(_loc6_);
         return true;
      }
   }
}

