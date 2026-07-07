package com.facebook.utils
{
   import com.facebook.data.stream.AttachmentData;
   import com.facebook.data.stream.CommentsData;
   import com.facebook.data.stream.GetCommentsData;
   import com.facebook.data.stream.GetFiltersData;
   import com.facebook.data.stream.GetStreamData;
   import com.facebook.data.stream.LikesData;
   import com.facebook.data.stream.PhotoMedia;
   import com.facebook.data.stream.PostCommentData;
   import com.facebook.data.stream.ProfileCollection;
   import com.facebook.data.stream.ProfileData;
   import com.facebook.data.stream.StreamFilterCollection;
   import com.facebook.data.stream.StreamFilterData;
   import com.facebook.data.stream.StreamMediaData;
   import com.facebook.data.stream.StreamStoryCollection;
   import com.facebook.data.stream.StreamStoryData;
   import com.facebook.data.stream.VideoMedia;
   
   public class FacebookStreamXMLParser
   {
      
      public function FacebookStreamXMLParser()
      {
         super();
      }
      
      public static function createCommentsArray(param1:XMLList, param2:Namespace) : Array
      {
         var _loc6_:XML = null;
         var _loc7_:PostCommentData = null;
         var _loc3_:Array = [];
         var _loc4_:uint = uint(param1.length());
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param1[_loc5_];
            _loc7_ = new PostCommentData();
            _loc7_.fromid = FacebookXMLParserUtils.toStringValue(_loc6_.param2::fromid[0]);
            _loc7_.id = FacebookXMLParserUtils.toStringValue(_loc6_.param2::id[0]);
            _loc7_.text = FacebookXMLParserUtils.toStringValue(_loc6_.param2::text[0]);
            _loc7_.time = FacebookXMLParserUtils.toDate(_loc6_.param2::time[0]);
            _loc3_.push(_loc7_);
            _loc5_++;
         }
         return _loc3_;
      }
      
      protected static function createMediaArray(param1:XML, param2:Namespace) : Array
      {
         var _loc7_:XML = null;
         var _loc8_:StreamMediaData = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc3_:Array = [];
         var _loc4_:XMLList = param1.children();
         var _loc5_:uint = uint(_loc4_.length());
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc4_[_loc6_];
            _loc8_ = new StreamMediaData();
            _loc8_.type = FacebookXMLParserUtils.toStringValue(_loc7_.param2::type[0]);
            _loc8_.alt = FacebookXMLParserUtils.toStringValue(_loc7_.param2::alt[0]);
            _loc8_.href = FacebookXMLParserUtils.toStringValue(_loc7_.param2::href[0]);
            _loc8_.src = FacebookXMLParserUtils.toStringValue(_loc7_.param2::src[0]);
            _loc8_.video = createVideoMedia(_loc7_.param2::video[0],param2);
            _loc8_.photo = createPhotoMedia(_loc7_.param2::photo[0],param2);
            _loc3_.push(_loc8_);
            _loc6_++;
         }
         return _loc3_;
      }
      
      public static function createStreamFilterCollection(param1:XML, param2:Namespace) : GetFiltersData
      {
         var _loc8_:XML = null;
         var _loc9_:StreamFilterData = null;
         var _loc3_:GetFiltersData = new GetFiltersData();
         var _loc4_:StreamFilterCollection = new StreamFilterCollection();
         var _loc5_:XMLList = param1..param2::stream_filter;
         var _loc6_:uint = uint(_loc5_.length());
         var _loc7_:uint = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc5_[_loc7_];
            _loc9_ = new StreamFilterData();
            _loc9_.filter_key = FacebookXMLParserUtils.toStringValue(_loc8_.param2::filter_key[0]);
            _loc9_.icon_url = FacebookXMLParserUtils.toStringValue(_loc8_.param2::icon_url[0]);
            _loc9_.is_visible = FacebookXMLParserUtils.toBoolean(_loc8_.param2::is_visible[0]);
            _loc9_.name = FacebookXMLParserUtils.toStringValue(_loc8_.param2::name[0]);
            _loc9_.rank = FacebookXMLParserUtils.toNumber(_loc8_.param2::rank[0]);
            _loc9_.type = FacebookXMLParserUtils.toStringValue(_loc8_.param2::type[0]);
            _loc9_.uid = FacebookXMLParserUtils.toStringValue(_loc8_.param2::uid[0]);
            _loc9_.value = FacebookXMLParserUtils.toStringValue(_loc8_.param2::value[0]);
            _loc4_.addItem(_loc9_);
            _loc7_++;
         }
         _loc3_.filters = _loc4_;
         return _loc3_;
      }
      
      protected static function createVideoMedia(param1:XML, param2:Namespace) : VideoMedia
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc3_:VideoMedia = new VideoMedia();
         _loc3_.display_url = FacebookXMLParserUtils.toStringValue(param1.param2::display_url[0]);
         _loc3_.owner = FacebookXMLParserUtils.toStringValue(param1.param2::owner[0]);
         _loc3_.permalink = FacebookXMLParserUtils.toStringValue(param1.param2::permalink[0]);
         _loc3_.source_url = FacebookXMLParserUtils.toStringValue(param1.param2::source_url[0]);
         _loc3_.preview_img = FacebookXMLParserUtils.toStringValue(param1.param2::preview_img[0]);
         return _loc3_;
      }
      
      protected static function createComments(param1:XML, param2:Namespace) : CommentsData
      {
         var _loc3_:CommentsData = new CommentsData();
         _loc3_.can_remove = FacebookXMLParserUtils.toBoolean(param1.param2::can_remove[0]);
         _loc3_.can_post = FacebookXMLParserUtils.toBoolean(param1.param2::can_post[0]);
         _loc3_.count = FacebookXMLParserUtils.toNumber(param1.param2::count[0]);
         var _loc4_:XMLList = param1.param2::posts.children();
         _loc3_.posts = createCommentsArray(_loc4_,param2);
         return _loc3_;
      }
      
      public static function createGetCommentsData(param1:XML, param2:Namespace) : GetCommentsData
      {
         var _loc3_:XMLList = param1..param2::comment;
         var _loc4_:GetCommentsData = new GetCommentsData();
         _loc4_.comments = createCommentsArray(_loc3_,param2);
         return _loc4_;
      }
      
      public static function createStream(param1:XML, param2:Namespace) : GetStreamData
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc10_:XML = null;
         var _loc11_:StreamStoryData = null;
         var _loc12_:XML = null;
         var _loc13_:AttachmentData = null;
         var _loc14_:LikesData = null;
         var _loc15_:XML = null;
         var _loc16_:XML = null;
         var _loc17_:ProfileData = null;
         var _loc18_:XML = null;
         var _loc3_:GetStreamData = new GetStreamData();
         var _loc4_:StreamStoryCollection = new StreamStoryCollection();
         var _loc5_:ProfileCollection = new ProfileCollection();
         _loc3_.stories = _loc4_;
         _loc3_.profiles = _loc5_;
         var _loc8_:XMLList = param1.param2::posts.children();
         _loc6_ = uint(_loc8_.length());
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc10_ = _loc8_[_loc7_];
            _loc11_ = new StreamStoryData();
            _loc11_.sourceXML = _loc10_;
            _loc12_ = _loc10_.param2::attachment[0];
            _loc13_ = new AttachmentData();
            _loc13_.name = FacebookXMLParserUtils.toStringValue(_loc12_.param2::name[0]);
            _loc13_.text = FacebookXMLParserUtils.toStringValue(_loc12_.param2::text[0]);
            _loc13_.body = FacebookXMLParserUtils.toStringValue(_loc12_.param2::body[0]);
            _loc13_.icon = FacebookXMLParserUtils.toStringValue(_loc12_.param2::icon[0]);
            _loc13_.label = FacebookXMLParserUtils.toStringValue(_loc12_.param2::label[0]);
            _loc13_.media = createMediaArray(_loc12_.param2::media[0],param2);
            _loc13_.title = FacebookXMLParserUtils.toStringValue(_loc12_.param2::title[0]);
            _loc13_.href = FacebookXMLParserUtils.toStringValue(_loc12_.param2::href[0]);
            _loc13_.caption = FacebookXMLParserUtils.toStringValue(_loc12_.param2::caption[0]);
            _loc13_.description = FacebookXMLParserUtils.toStringValue(_loc12_.param2::description[0]);
            _loc13_.properties = FacebookXMLParserUtils.xmlListToObjectArray(_loc12_..param2::stream_property);
            _loc11_.attachment = _loc13_;
            _loc11_.actor_id = FacebookXMLParserUtils.toStringValue(_loc10_.param2::actor_id[0]);
            _loc11_.comments = createComments(_loc10_.param2::comments[0],param2);
            _loc14_ = new LikesData();
            _loc15_ = _loc10_.param2::likes[0];
            _loc14_.can_like = FacebookXMLParserUtils.toBoolean(_loc15_.param2::can_like[0]);
            _loc14_.user_likes = FacebookXMLParserUtils.toBoolean(_loc15_.param2::user_likes[0]);
            _loc14_.count = FacebookXMLParserUtils.toNumber(_loc15_.param2::count[0]);
            _loc14_.friends = FacebookXMLParserUtils.toUIDArray(_loc15_.param2::friends[0]);
            _loc14_.sample = FacebookXMLParserUtils.toUIDArray(_loc15_.param2::sample[0]);
            _loc14_.href = FacebookXMLParserUtils.toStringValue(_loc15_.param2::href[0]);
            _loc11_.likes = _loc14_;
            _loc11_.attribution = FacebookXMLParserUtils.toStringValue(_loc10_.param2::attribution[0]);
            _loc11_.app_id = FacebookXMLParserUtils.toStringValue(_loc10_.param2::app_id[0]);
            _loc11_.metadata = FacebookXMLParserUtils.nodeToObject(_loc10_.param2::metadata);
            _loc11_.message = FacebookXMLParserUtils.toStringValue(_loc10_.param2::message[0]);
            _loc11_.source_id = FacebookXMLParserUtils.toStringValue(_loc10_.param2::source_id[0]);
            _loc11_.target_id = FacebookXMLParserUtils.toStringValue(_loc10_.param2::target_id[0]);
            _loc11_.post_id = FacebookXMLParserUtils.toStringValue(_loc10_.param2::post_id[0]);
            _loc11_.updated_time = FacebookXMLParserUtils.toDate(_loc10_.param2::updated_time[0]);
            _loc11_.created_time = FacebookXMLParserUtils.toDate(_loc10_.param2::created_time[0]);
            _loc11_.type = FacebookXMLParserUtils.toNumber(_loc10_.param2::type[0]);
            _loc11_.viewer_id = FacebookXMLParserUtils.toStringValue(_loc10_.param2::viewer_id[0]);
            _loc16_ = _loc10_.param2::privacy[0];
            _loc11_.privacy = FacebookXMLParserUtils.toStringValue(_loc16_.param2::value[0]);
            _loc11_.filter_key = FacebookXMLParserUtils.toStringValue(_loc10_.param2::filter_key[0]);
            _loc4_.addItem(_loc11_);
            _loc7_++;
         }
         var _loc9_:XMLList = param1.param2::profiles.children();
         _loc6_ = uint(_loc9_.length());
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc17_ = new ProfileData();
            _loc18_ = _loc9_[_loc7_];
            _loc17_.id = FacebookXMLParserUtils.toStringValue(_loc18_.param2::id[0]);
            _loc17_.name = FacebookXMLParserUtils.toStringValue(_loc18_.param2::name[0]);
            _loc17_.pic_square = FacebookXMLParserUtils.toStringValue(_loc18_.param2::pic_square[0]);
            _loc17_.url = FacebookXMLParserUtils.toStringValue(_loc18_.param2::url[0]);
            _loc5_.addItem(_loc17_);
            _loc7_++;
         }
         _loc3_.albums = FacebookXMLParserUtils.createAlbumCollection(param1.param2::albums[0],param2);
         return _loc3_;
      }
      
      protected static function createPhotoMedia(param1:XML, param2:Namespace) : PhotoMedia
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc3_:PhotoMedia = new PhotoMedia();
         _loc3_.aid = FacebookXMLParserUtils.toStringValue(param1.param2::aid[0]);
         _loc3_.index = FacebookXMLParserUtils.toNumber(param1.param2::index[0]);
         _loc3_.owner = FacebookXMLParserUtils.toStringValue(param1.param2::owner[0]);
         _loc3_.pid = FacebookXMLParserUtils.toStringValue(param1.param2::pid[0]);
         return _loc3_;
      }
   }
}

