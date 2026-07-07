package com.playfish.coretech.platform.socialplatform.stream
{
   public class Stream
   {
      
      private var psLinkJSon:String = null;
      
      private var psMediaJSon:String = null;
      
      private var messagePrompt:String = "What\'s on your mind?";
      
      private var targetId:String = null;
      
      private var piNbLinkJSon:uint = 0;
      
      private var piNbAttachment:uint = 0;
      
      private var piNbMedia:uint = 0;
      
      private var psAttachmentJSon:String = null;
      
      private var messageUser:String = null;
      
      private var paParameters:Array;
      
      public function Stream()
      {
         super();
         paParameters = new Array();
         psAttachmentJSon = null;
      }
      
      private function closeAttachment() : void
      {
         if(piNbAttachment > 0)
         {
            psAttachmentJSon += ",";
         }
         psAttachmentJSon += psMediaJSon;
         psAttachmentJSon += "}";
      }
      
      public function setTarget(param1:String) : Boolean
      {
         this.targetId = param1;
         return true;
      }
      
      private function setMessage(param1:String) : Boolean
      {
         this.messagePrompt = param1;
         return true;
      }
      
      private function closeLink() : void
      {
         if(psLinkJSon != null)
         {
            psLinkJSon += "]";
         }
      }
      
      private function closeMedia() : void
      {
         if(psMediaJSon != null)
         {
            psMediaJSon += "]";
         }
      }
      
      private function addLink(param1:IStreamParameter) : void
      {
         if(piNbLinkJSon > 0)
         {
            psLinkJSon += ",";
         }
         psLinkJSon += param1.build();
         ++piNbLinkJSon;
      }
      
      private function startMedia() : void
      {
         if(psMediaJSon == null)
         {
            psMediaJSon = "\"media\":[";
         }
      }
      
      private function startAttachment() : void
      {
         if(psAttachmentJSon == null)
         {
            psAttachmentJSon = "{";
         }
      }
      
      private function addFlash() : void
      {
      }
      
      public function toStream(param1:String) : Array
      {
         var _loc2_:Array = new Array();
         build();
         _loc2_.push(param1);
         _loc2_.push(psAttachmentJSon);
         _loc2_.push(psLinkJSon);
         _loc2_.push(targetId);
         _loc2_.push(messagePrompt);
         return _loc2_;
      }
      
      public function addParameters(param1:IStreamParameter) : void
      {
         paParameters.push(param1);
      }
      
      private function addAttachmentElement(param1:IStreamParameter) : void
      {
         if(piNbAttachment > 0)
         {
            psAttachmentJSon += ",";
         }
         psAttachmentJSon += param1.build();
         ++piNbAttachment;
      }
      
      private function addMediaElement(param1:IStreamParameter) : void
      {
         if(piNbMedia > 0)
         {
            psMediaJSon += ",";
         }
         psMediaJSon += param1.build();
         ++piNbMedia;
      }
      
      private function startLink() : void
      {
         if(psLinkJSon == null)
         {
            psLinkJSon = "[";
         }
      }
      
      private function build() : void
      {
         var _loc1_:IStreamParameter = null;
         startLink();
         startMedia();
         startAttachment();
         for each(_loc1_ in paParameters)
         {
            if(_loc1_ is StreamLink)
            {
               addLink(_loc1_);
            }
            else if(_loc1_ is StreamCaptionText || _loc1_ is StreamDescriptionText || _loc1_ is StreamInformationLink)
            {
               addAttachmentElement(_loc1_);
            }
            else if(_loc1_ is StreamMedia)
            {
               addMediaElement(_loc1_ as StreamMedia);
            }
            else if(_loc1_ is StreamTitleText)
            {
               setMessage(_loc1_.build());
            }
         }
         closeLink();
         closeMedia();
         closeAttachment();
      }
   }
}

