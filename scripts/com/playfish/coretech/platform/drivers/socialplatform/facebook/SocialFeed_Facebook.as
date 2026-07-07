package com.playfish.coretech.platform.drivers.socialplatform.facebook
{
   import com.facebook.commands.stream.PublishPost;
   import com.playfish.coretech.engine.core.PFDebug;
   import com.playfish.coretech.engine.core.PFString;
   import com.playfish.coretech.engine.debug.*;
   import com.playfish.coretech.platform.socialplatform.SocialFeed;
   import com.playfish.coretech.platform.socialplatform.SocialPlatform;
   import com.playfish.coretech.platform.socialplatform.stream.*;
   import com.playfish.external.*;
   
   public class SocialFeed_Facebook extends SocialFeed
   {
      
      private var attachment:Object = null;
      
      private var message:String = null;
      
      private var actionLinkData:Array = null;
      
      public function SocialFeed_Facebook(param1:String, param2:Boolean)
      {
         super(param2);
      }
      
      override public function createMediaImage(param1:String, param2:String, param3:String) : IStreamParameter
      {
         prepareAttachment();
         attachment.media = new Array();
         attachment.media[0] = new Object();
         attachment.media[0].type = "image";
         attachment.media[0].src = param1;
         attachment.media[0].href = param2;
         attachment.caption = param3;
         return super.createMediaImage(param1,param2,param3);
      }
      
      override public function createTitleText(param1:String) : IStreamParameter
      {
         return super.createTitleText(param1);
      }
      
      private function prepareAttachment() : void
      {
         if(attachment == null)
         {
            attachment = new Object();
         }
      }
      
      override public function createMediaVideo(param1:String, param2:String, param3:String) : IStreamParameter
      {
         prepareAttachment();
         attachment.media = new Array();
         attachment.media[0] = new Object();
         attachment.media[0].type = "video";
         attachment.media[0].video_src = param1;
         attachment.media[0].video_link = param3;
         attachment.media[0].preview_img = param2;
         return super.createMediaVideo(param1,param2,param3);
      }
      
      override public function createDescriptionText(param1:String) : IStreamParameter
      {
         prepareAttachment();
         attachment.description = param1;
         if(PFDebug.DEBUG)
         {
            if(param1.length > 300)
            {
               PFDebug.warning("Text description may be truncated by Facebook. (" + param1 + ")");
            }
         }
         return super.createDescriptionText(purifyTextForFacebook(param1));
      }
      
      override public function publish(param1:Function = null) : Boolean
      {
         var s:Stream = null;
         var streamData:IStreamParameter = null;
         var streamArray:Array = null;
         var cExternalPage:ExternalPage = null;
         var fbcall:PublishPost = null;
         var callbackFunctionHandler:Function = param1;
         super.publish(callbackFunctionHandler);
         if(userRequired)
         {
            s = new Stream();
            s.setTarget(userId);
            for each(streamData in parameters)
            {
               s.addParameters(streamData);
            }
            streamArray = s.toStream(message);
            cExternalPage = new ExternalPage("stream");
            if(callbackHandler != null)
            {
               cExternalPage.addEventListener(ExternalPageEvent.COMPLETE,callbackHandler);
            }
            cExternalPage.show(streamArray);
         }
         else
         {
            if(actionLinkData == null)
            {
               DebugConsoleView.current.console.traceMessage(null,"No actionLinkData specified. Using default...");
               addStreamData(createLink("Play " + SocialPlatform.getGameName(),SocialPlatform.getGameURL()));
            }
            try
            {
               fbcall = new PublishPost(message,attachment,actionLinkData,userId);
               SocialPlatform_Facebook.facebook.post(fbcall);
            }
            catch(errObject:Error)
            {
               DebugConsoleView.current.console.traceMessage(null,"Couldn\'t post feed. Exception: " + errObject.message);
               return false;
            }
            if(callbackHandler != null)
            {
               callbackHandler(null);
            }
         }
         return true;
      }
      
      override public function createUserInput(param1:String) : IStreamParameter
      {
         message = param1;
         return super.createUserInput(param1);
      }
      
      protected function purifyTextForFacebook(param1:String) : String
      {
         return PFString.replaceAll(param1,"<a.*?>(.*?)</a>","$1");
      }
      
      override public function createLink(param1:String, param2:String) : IStreamParameter
      {
         PFDebug.assert(actionLinkData == null,"A link has already been created. Only one\'s allowed.");
         actionLinkData = new Array();
         actionLinkData[0] = new Object();
         actionLinkData[0].text = param1;
         actionLinkData[0].href = param2;
         if(PFDebug.DEBUG)
         {
            if(param1.length > 100)
            {
               PFDebug.warning("Link text may be truncated by Facebook. (" + param1 + ")");
            }
            if(param2.length > 1024)
            {
               PFDebug.error("Link HREF is too long for Facebook. Please truncate. (" + param2 + ")");
            }
         }
         return super.createLink(param1,param2);
      }
      
      override public function createCaptionText(param1:String) : IStreamParameter
      {
         if(PFDebug.DEBUG)
         {
            if(param1.length > 100)
            {
               PFDebug.warning("Text caption may be truncated by Facebook. (" + param1 + ")");
            }
         }
         return new StreamCaptionText(purifyTextForFacebook(param1));
      }
      
      override public function createInformationText(param1:String, param2:String) : IStreamParameter
      {
         prepareAttachment();
         attachment.name = param1;
         attachment.href = param2;
         if(PFDebug.DEBUG)
         {
            if(param1.length > 100)
            {
               PFDebug.warning("Link text may be truncated by Facebook. (" + param1 + ")");
            }
            if(param2.length > 1024)
            {
               PFDebug.error("Link HREF is too long for Facebook. Please truncate. (" + param2 + ")");
            }
         }
         return super.createInformationText(param1,param2);
      }
      
      override public function setTargetUser(param1:*) : Boolean
      {
         if(param1 is String)
         {
            userId = param1;
         }
         return true;
      }
   }
}

