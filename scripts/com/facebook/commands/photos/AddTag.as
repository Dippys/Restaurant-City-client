package com.facebook.commands.photos
{
   import com.facebook.data.photos.PhotoTagCollection;
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import com.facebook.utils.FacebookDataUtils;
   
   use namespace facebook_internal;
   
   public class AddTag extends FacebookCall
   {
      
      public static const METHOD_NAME:String = "photos.addTag";
      
      public static const SCHEMA:Array = ["pid","tag_uid","tag_text","x","y","tags","owner_uid"];
      
      public var tags:PhotoTagCollection;
      
      public var pid:String;
      
      public var owner_uid:String;
      
      public var tag_text:String;
      
      public var tag_uid:String;
      
      public var yPos:Number;
      
      public var xPos:Number;
      
      public function AddTag(param1:String, param2:String = null, param3:String = null, param4:Number = NaN, param5:Number = NaN, param6:PhotoTagCollection = null, param7:String = null)
      {
         super(METHOD_NAME);
         if(param6 == null && param2 == null && param3 == null && isNaN(param4) && isNaN(param5))
         {
            throw new Error("Please specify a tags array or all of [tag_uid, tag_text, x, y] ");
         }
         if(param6 == null && (param2 == null || param3 == null || isNaN(param4) || isNaN(param5)))
         {
            throw new Error("When tags is null you must specify [tag_uid, tag_text, x, y]");
         }
         this.pid = param1;
         this.tag_uid = param2;
         this.tag_text = param3;
         this.xPos = param4;
         this.yPos = param5;
         this.tags = param6;
         this.owner_uid = param7;
      }
      
      override facebook_internal function initialize() : void
      {
         applySchema(SCHEMA,this.pid,this.tag_uid,this.tag_text,this.xPos,this.yPos,FacebookDataUtils.facebookCollectionToJSONArray(this.tags),this.owner_uid);
         super.facebook_internal::initialize();
      }
   }
}

