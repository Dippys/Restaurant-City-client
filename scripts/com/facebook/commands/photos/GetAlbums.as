package com.facebook.commands.photos
{
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import com.facebook.utils.FacebookDataUtils;
   
   use namespace facebook_internal;
   
   public class GetAlbums extends FacebookCall
   {
      
      public static const METHOD_NAME:String = "photos.getAlbums";
      
      public static const SCHEMA:Array = ["uid","aids"];
      
      public var uid:String;
      
      public var aids:Array;
      
      public function GetAlbums(param1:String = "", param2:Array = null)
      {
         super(METHOD_NAME);
         this.uid = param1;
         this.aids = param2;
      }
      
      override facebook_internal function initialize() : void
      {
         applySchema(SCHEMA,this.uid,FacebookDataUtils.toArrayString(this.aids));
         super.facebook_internal::initialize();
      }
   }
}

