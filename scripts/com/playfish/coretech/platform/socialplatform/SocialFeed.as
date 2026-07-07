package com.playfish.coretech.platform.socialplatform
{
   import com.playfish.coretech.platform.socialplatform.stream.IStreamParameter;
   import com.playfish.coretech.platform.socialplatform.stream.StreamCaptionText;
   import com.playfish.coretech.platform.socialplatform.stream.StreamDescriptionText;
   import com.playfish.coretech.platform.socialplatform.stream.StreamInformationLink;
   import com.playfish.coretech.platform.socialplatform.stream.StreamLink;
   import com.playfish.coretech.platform.socialplatform.stream.StreamMediaImage;
   import com.playfish.coretech.platform.socialplatform.stream.StreamMediaSWF;
   import com.playfish.coretech.platform.socialplatform.stream.StreamTitleText;
   import com.playfish.coretech.platform.socialplatform.stream.StreamUserAcknowledgement;
   import com.playfish.coretech.platform.socialplatform.stream.StreamUserMessage;
   
   public class SocialFeed
   {
      
      public static const typeText:String = "text";
      
      public static const typeImage:String = "image";
      
      public static const typeVideo:String = "video";
      
      public static const typeLink:String = "link";
      
      public static const typeInfo:String = "info";
      
      public static const typeDescription:String = "description";
      
      public static const typeUserText:String = "user";
      
      protected var callbackHandler:Function;
      
      protected var userId:String;
      
      protected var parameters:Array;
      
      protected var userRequired:Boolean;
      
      public function SocialFeed(param1:Boolean)
      {
         super();
         parameters = new Array();
         userRequired = param1;
         userId = SocialPlatform.current.user.getID();
      }
      
      public function createMediaSWF(param1:String, param2:String, param3:int = 160, param4:int = 120, param5:int = 100, param6:int = 80) : IStreamParameter
      {
         return new StreamMediaSWF(param1,param2,param3,param4,param5,param6);
      }
      
      public function createMediaVideo(param1:String, param2:String, param3:String) : IStreamParameter
      {
         return null;
      }
      
      public function createUserInput(param1:String) : IStreamParameter
      {
         userRequired = true;
         return new StreamUserMessage(param1);
      }
      
      public function createTitleText(param1:String) : IStreamParameter
      {
         return new StreamTitleText(param1);
      }
      
      public function addStreamData(param1:IStreamParameter) : IStreamParameter
      {
         if(param1 != null)
         {
            parameters.push(param1);
         }
         return param1;
      }
      
      public function createDescriptionText(param1:String) : IStreamParameter
      {
         return new StreamDescriptionText(param1);
      }
      
      public function publish(param1:Function = null) : Boolean
      {
         callbackHandler = param1;
         return false;
      }
      
      public function isValid() : Boolean
      {
         return true;
      }
      
      public function createUserAcknowledge() : IStreamParameter
      {
         userRequired = true;
         return new StreamUserAcknowledgement();
      }
      
      public function createLink(param1:String, param2:String) : IStreamParameter
      {
         return new StreamLink(param1,param2);
      }
      
      public function createCaptionText(param1:String) : IStreamParameter
      {
         return new StreamCaptionText(param1);
      }
      
      public function createMediaImage(param1:String, param2:String, param3:String) : IStreamParameter
      {
         return new StreamMediaImage(param1,param2,param3);
      }
      
      public function createInformationText(param1:String, param2:String) : IStreamParameter
      {
         return new StreamInformationLink(param1,param2);
      }
      
      public function setTargetUser(param1:*) : Boolean
      {
         return false;
      }
   }
}

