package com.facebook.data
{
   import com.adobe.serialization.json.JSON;
   import com.facebook.commands.data.GetCookiesData;
   import com.facebook.data.admin.GetAllocationData;
   import com.facebook.data.admin.GetAppPropertiesData;
   import com.facebook.data.admin.GetMetricsData;
   import com.facebook.data.admin.MetricsData;
   import com.facebook.data.admin.MetricsDataCollection;
   import com.facebook.data.application.GetPublicInfoData;
   import com.facebook.data.auth.GetSessionData;
   import com.facebook.data.batch.BatchResult;
   import com.facebook.data.data.GetObjectTypeData;
   import com.facebook.data.data.GetObjectTypesData;
   import com.facebook.data.data.GetUserPreferencesData;
   import com.facebook.data.data.ObjectTypesCollection;
   import com.facebook.data.data.ObjectTypesData;
   import com.facebook.data.data.PreferenceCollection;
   import com.facebook.data.data.PreferenceData;
   import com.facebook.data.events.EventCollection;
   import com.facebook.data.events.EventData;
   import com.facebook.data.events.GetEventsData;
   import com.facebook.data.events.GetMembersData;
   import com.facebook.data.fbml.AbstractTagData;
   import com.facebook.data.fbml.ContainerTagData;
   import com.facebook.data.fbml.GetCustomTagsData;
   import com.facebook.data.fbml.LeafTagData;
   import com.facebook.data.fbml.TagCollection;
   import com.facebook.data.feed.GetRegisteredTemplateBundleByIDData;
   import com.facebook.data.feed.GetRegisteredTemplateBundleData;
   import com.facebook.data.feed.TemplateBundleCollection;
   import com.facebook.data.feed.TemplateCollection;
   import com.facebook.data.feed.TemplateData;
   import com.facebook.data.friends.AreFriendsData;
   import com.facebook.data.friends.FriendsCollection;
   import com.facebook.data.friends.FriendsData;
   import com.facebook.data.friends.GetAppUserData;
   import com.facebook.data.friends.GetFriendsData;
   import com.facebook.data.friends.GetListsData;
   import com.facebook.data.friends.ListsData;
   import com.facebook.data.groups.GetGroupData;
   import com.facebook.data.groups.GetMemberData;
   import com.facebook.data.groups.GroupCollection;
   import com.facebook.data.groups.GroupData;
   import com.facebook.data.notes.GetNotesData;
   import com.facebook.data.notes.NoteData;
   import com.facebook.data.notes.NotesCollection;
   import com.facebook.data.notifications.GetNotificationData;
   import com.facebook.data.notifications.NotificationCollection;
   import com.facebook.data.notifications.NotificationMessageData;
   import com.facebook.data.notifications.NotificationPokeData;
   import com.facebook.data.notifications.NotificationShareData;
   import com.facebook.data.pages.GetPageInfoData;
   import com.facebook.data.pages.PageInfoCollection;
   import com.facebook.data.pages.PageInfoData;
   import com.facebook.data.photos.AlbumData;
   import com.facebook.data.photos.FacebookPhoto;
   import com.facebook.data.photos.GetAlbumsData;
   import com.facebook.data.photos.GetCreateAlbumData;
   import com.facebook.data.photos.GetPhotosData;
   import com.facebook.data.photos.GetTagsData;
   import com.facebook.data.photos.PhotoCollection;
   import com.facebook.data.photos.PhotoData;
   import com.facebook.data.photos.PhotoTagCollection;
   import com.facebook.data.photos.TagData;
   import com.facebook.data.status.GetStatusData;
   import com.facebook.data.status.Status;
   import com.facebook.data.users.AffiliationCollection;
   import com.facebook.data.users.AffiliationData;
   import com.facebook.data.users.FacebookUser;
   import com.facebook.data.users.FacebookUserCollection;
   import com.facebook.data.users.GetInfoData;
   import com.facebook.data.users.GetStandardInfoData;
   import com.facebook.data.users.UserCollection;
   import com.facebook.data.users.UserData;
   import com.facebook.errors.FacebookError;
   import com.facebook.utils.FacebookStreamXMLParser;
   import com.facebook.utils.FacebookUserXMLParser;
   import com.facebook.utils.FacebookXMLParserUtils;
   import com.facebook.utils.IFacebookResultParser;
   import flash.events.ErrorEvent;
   
   public class XMLDataParser implements IFacebookResultParser
   {
      
      protected var fb_namespace:Namespace;
      
      public function XMLDataParser()
      {
         super();
         this.fb_namespace = new Namespace("http://api.facebook.com/1.0/");
      }
      
      protected function parseSendEmail(param1:XML) : ArrayResultData
      {
         var _loc2_:ArrayResultData = new ArrayResultData();
         _loc2_.arrayResult = FacebookXMLParserUtils.toArray(param1);
         return _loc2_;
      }
      
      protected function parseGetPhotos(param1:XML) : GetPhotosData
      {
         var _loc4_:* = undefined;
         var _loc5_:PhotoData = null;
         var _loc2_:GetPhotosData = new GetPhotosData();
         var _loc3_:PhotoCollection = new PhotoCollection();
         for each(_loc4_ in param1..fb_namespace::photo)
         {
            _loc5_ = new PhotoData();
            _loc5_.pid = _loc4_.fb_namespace::pid;
            _loc5_.aid = _loc4_.fb_namespace::aid;
            _loc5_.owner = _loc4_.fb_namespace::owner;
            _loc5_.src = _loc4_.fb_namespace::src;
            _loc5_.src_big = _loc4_.fb_namespace::src_big;
            _loc5_.src_small = _loc4_.fb_namespace::src_small;
            _loc5_.caption = _loc4_.fb_namespace::caption;
            _loc5_.created = FacebookXMLParserUtils.toDate(_loc4_.fb_namespace::created);
            _loc3_.addPhoto(_loc5_);
         }
         _loc2_.photoCollection = _loc3_;
         return _loc2_;
      }
      
      protected function parseGetNotifications(param1:XML) : GetNotificationData
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:NotificationMessageData = null;
         var _loc8_:NotificationPokeData = null;
         var _loc9_:NotificationShareData = null;
         var _loc2_:GetNotificationData = new GetNotificationData();
         var _loc3_:NotificationCollection = new NotificationCollection();
         for each(_loc4_ in param1.fb_namespace::messages)
         {
            _loc7_ = new NotificationMessageData();
            _loc7_.unread = _loc4_.fb_namespace::unread;
            _loc7_.most_recent = _loc4_.fb_namespace::most_recent;
            _loc3_.addItem(_loc7_);
         }
         for each(_loc5_ in param1.fb_namespace::pokes)
         {
            _loc8_ = new NotificationPokeData();
            _loc8_.unread = _loc5_.fb_namespace::unread;
            _loc8_.most_recent = _loc5_.fb_namespace::most_recent;
            _loc3_.addItem(_loc8_);
         }
         for each(_loc6_ in param1.fb_namespace::shares)
         {
            _loc9_ = new NotificationShareData();
            _loc9_.unread = _loc6_.fb_namespace::unread;
            _loc9_.most_recent = _loc6_.fb_namespace::most_recent;
            _loc3_.addItem(_loc9_);
         }
         _loc2_.friendsRequests = FacebookXMLParserUtils.toUIDArray(param1.fb_namespace::friend_requests[0]);
         _loc2_.group_invites = FacebookXMLParserUtils.toUIDArray(param1.fb_namespace::group_invites[0]);
         _loc2_.event_invites = FacebookXMLParserUtils.toUIDArray(param1.fb_namespace::event_invites[0]);
         _loc2_.notificationCollection = _loc3_;
         return _loc2_;
      }
      
      public function createFacebookError(param1:Object, param2:String) : FacebookError
      {
         var _loc3_:FacebookError = new FacebookError();
         _loc3_.rawResult = param2;
         _loc3_.errorCode = FacebookErrorCodes.SERVER_ERROR;
         if(param1 is Error)
         {
            _loc3_.error = param1 as Error;
         }
         else
         {
            _loc3_.errorEvent = param1 as ErrorEvent;
         }
         return _loc3_;
      }
      
      protected function getAffiliation(param1:XML) : AffiliationCollection
      {
         var _loc3_:* = undefined;
         var _loc4_:AffiliationData = null;
         var _loc2_:AffiliationCollection = new AffiliationCollection();
         for each(_loc3_ in param1..fb_namespace::afflication)
         {
            _loc4_ = new AffiliationData();
            _loc4_.nid = _loc3_.fb_namespace::nid;
            _loc4_.name = _loc3_.fb_namespace::name;
            _loc4_.type = _loc3_.fb_namespace::type;
            _loc4_.status = _loc3_.fb_namespace::status;
            _loc4_.year = _loc3_.fb_namespace::year;
            _loc2_.addAffiliation(_loc4_);
         }
         return _loc2_;
      }
      
      protected function parseGetUserPreferences(param1:XML) : GetUserPreferencesData
      {
         var _loc4_:* = undefined;
         var _loc5_:PreferenceData = null;
         var _loc2_:GetUserPreferencesData = new GetUserPreferencesData();
         var _loc3_:PreferenceCollection = new PreferenceCollection();
         for each(_loc4_ in param1..fb_namespace::preference)
         {
            _loc5_ = new PreferenceData();
            _loc5_.pref_id = _loc4_.fb_namespace::pref_id;
            _loc5_.value = _loc4_.fb_namespace::value;
            _loc3_.addItem(_loc5_);
         }
         _loc2_.perferenceCollection = _loc3_;
         return _loc2_;
      }
      
      public function parse(param1:String, param2:String) : FacebookData
      {
         var _loc3_:FacebookData = null;
         var _loc4_:XML = new XML(param1);
         switch(param2)
         {
            case "application.getPublicInfo":
               _loc3_ = this.parseGetPublicInfo(_loc4_);
               break;
            case "data.getCookies":
               _loc3_ = this.parseGetCookies(_loc4_);
               break;
            case "admin.getAllocation":
               _loc3_ = this.parseGetAllocation(_loc4_);
               break;
            case "admin.getAppProperties":
               _loc3_ = this.parseGetAppProperties(_loc4_);
               break;
            case "admin.getMetrics":
               _loc3_ = this.parseGetMetrics(_loc4_);
               break;
            case "auth.getSession":
               _loc3_ = new GetSessionData();
               (_loc3_ as GetSessionData).expires = FacebookXMLParserUtils.toDate(_loc4_.fb_namespace::expires);
               (_loc3_ as GetSessionData).uid = FacebookXMLParserUtils.toStringValue(_loc4_.fb_namespace::uid[0]);
               (_loc3_ as GetSessionData).session_key = _loc4_.fb_namespace::session_key.toString();
               (_loc3_ as GetSessionData).secret = String(_loc4_.fb_namespace::secret);
               break;
            case "feed.getRegisteredTemplateBundles":
               _loc3_ = this.parseGetRegisteredTemplateBundles(_loc4_);
               break;
            case "friends.areFriends":
               _loc3_ = this.parseAreFriends(_loc4_);
               break;
            case "notes.get":
               _loc3_ = this.parseGetNotes(_loc4_);
               break;
            case "friends.get":
               _loc3_ = this.parseGetFriends(_loc4_);
               break;
            case "friends.getAppUsers":
               _loc3_ = this.parseGetAppUsersData(_loc4_);
               break;
            case "friends.getLists":
               _loc3_ = this.parseGetLists(_loc4_);
               break;
            case "groups.get":
               _loc3_ = this.parseGetGroups(_loc4_);
               break;
            case "data.getAssociationDefinitions":
               _loc3_ = new FacebookData();
               break;
            case "data.getAssociationDefinition":
               _loc3_ = new FacebookData();
               break;
            case "data.getObject":
            case "data.getObjects":
               _loc3_ = new FacebookData();
               break;
            case "groups.getMembers":
               _loc3_ = this.parseGetGroupMembers(_loc4_);
               break;
            case "users.getInfo":
               _loc3_ = this.parseGetInfo(_loc4_);
               break;
            case "data.createObject":
            case "data.setHashValue":
            case "connect.getUnconnectedFriendsCount":
            case "feed.registerTemplateBundle":
               _loc3_ = new NumberResultData();
               (_loc3_ as NumberResultData).value = FacebookXMLParserUtils.toNumber(_loc4_);
               break;
            case "notifications.get":
               _loc3_ = this.parseGetNotifications(_loc4_);
               break;
            case "feed.getRegisteredTemplateBundleByID":
               _loc3_ = this.parseGetRegisteredTemplateBundleByID(_loc4_);
               break;
            case "users.getStandardInfo":
               _loc3_ = this.parseGetStandardInfo(_loc4_);
               break;
            case "feed.getRegisteredTemplateBundles":
               _loc3_ = this.parseGetRegisteredTemplateBundles(_loc4_);
               break;
            case "data.getUserPreferences":
               _loc3_ = this.parseGetUserPreferences(_loc4_);
               break;
            case "users.isAppUser":
            case "users.hasAppPermission":
            case "users.setStatus":
            case "pages.isFan":
            case "pages.isAppAdded":
            case "pages.isAdmin":
            case "admin.setAppProperties":
            case "auth.expireSession":
            case "auth.revokeAuthorization":
            case "events.cancel":
            case "events.edit":
            case "events.rsvp":
            case "liveMessage.send":
            case "data.undefineAssociation":
            case "data.defineAssociation":
            case "data.removeHashKeys":
            case "data.removeHashKey":
            case "data.incHashValue":
            case "data.updateObject":
            case "data.deleteObject":
            case "data.deleteObjects":
            case "data.renameAssociation":
            case "data.setObjectProperty":
            case "profile.setInfo":
            case "profile.setInfoOptions":
            case "feed.deactivateTemplateBundleByID":
            case "feed.publishTemplatizedAction":
            case "admin.setRestrictionInfo":
            case "data.setCookie":
            case "data.createObjectType":
            case "notes.delete":
            case "notes.edit":
            case "data.setUserPreference":
            case "data.dropObjectType":
            case "data.renameObjectType":
            case "fbml.registerCustomTags":
            case "fbml.deleteCustomTags":
            case "fbml.refreshRefUrl":
            case "fbml.refreshImgSrc":
            case "fbml.setRefHandle":
            case "data.setUserPreferences":
            case "data.defineObjectProperty":
            case "photos.addTag":
            case "stream.addLike":
            case "stream.removeLike":
            case "stream.removeComment":
            case "sms.canSend":
               _loc3_ = new BooleanResultData();
               (_loc3_ as BooleanResultData).value = FacebookXMLParserUtils.toBoolean(_loc4_);
               break;
            case "feed.publishUserAction":
               _loc3_ = new BooleanResultData();
               (_loc3_ as BooleanResultData).value = FacebookXMLParserUtils.toBoolean(_loc4_.children()[0]);
               break;
            case "notifications.sendEmail":
               _loc3_ = this.parseSendEmail(_loc4_);
               break;
            case "data.getObjectTypes":
               _loc3_ = this.parseGetObjectTypes(_loc4_);
               break;
            case "users.getStandardInfo":
               _loc3_ = this.parseGetStandardInfo(_loc4_);
               break;
            case "data.getObjectType":
               _loc3_ = this.parseGetObjectType(_loc4_);
               break;
            case "events.get":
               _loc3_ = this.parseGetEvent(_loc4_);
               break;
            case "events.getMembers":
               _loc3_ = this.parseGetMembers(_loc4_);
               break;
            case "fql.query":
               _loc3_ = new FacebookData();
               break;
            case "photos.createAlbum":
               _loc3_ = this.parseCreateAlbum(_loc4_);
               break;
            case "photos.get":
               _loc3_ = this.parseGetPhotos(_loc4_);
               break;
            case "photos.getTags":
               _loc3_ = this.parseGetTags(_loc4_);
               break;
            case "photos.getAlbums":
               _loc3_ = this.parseGetAlbums(_loc4_);
               break;
            case "photos.upload":
               _loc3_ = this.parseFacebookPhoto(_loc4_);
               break;
            case "pages.getInfo":
               _loc3_ = this.parsePageGetInfo(_loc4_);
               break;
            case "batch.run":
               _loc3_ = this.parseBatchRun(_loc4_);
               break;
            case "fbml.getCustomTags":
               _loc3_ = this.parseGetCustomTags(_loc4_);
               break;
            case "connect.unregisterUsers":
            case "connect.registerUsers":
               _loc3_ = new ArrayResultData();
               (_loc3_ as ArrayResultData).arrayResult = FacebookXMLParserUtils.toArray(_loc4_);
               break;
            case "status.get":
               _loc3_ = this.parseGetStatus(_loc4_);
               break;
            case "stream.get":
               _loc3_ = FacebookStreamXMLParser.createStream(_loc4_,this.fb_namespace);
               break;
            case "stream.getComments":
               _loc3_ = FacebookStreamXMLParser.createGetCommentsData(_loc4_,this.fb_namespace);
               break;
            case "stream.getFilters":
               _loc3_ = FacebookStreamXMLParser.createStreamFilterCollection(_loc4_,this.fb_namespace);
               break;
            case "auth.createToken":
            case "events.create":
            case "links.post":
            case "auth.promoteSession":
            case "admin.getRestrictionInfo":
            case "data.getObjectProperty":
            case "notifications.send":
            case "notes.create":
            case "data.getUserPreference":
            case "profile.setFBML":
            case "users.getLoggedInUser":
            case "stream.addComment":
            default:
               _loc3_ = new StringResultData();
               (_loc3_ as StringResultData).value = FacebookXMLParserUtils.toStringValue(_loc4_);
         }
         _loc3_.rawResult = param1;
         return _loc3_;
      }
      
      protected function parseGetStandardInfo(param1:XML) : GetStandardInfoData
      {
         var _loc4_:* = undefined;
         var _loc5_:UserData = null;
         var _loc2_:GetStandardInfoData = new GetStandardInfoData();
         var _loc3_:UserCollection = new UserCollection();
         for each(_loc4_ in param1..fb_namespace::user)
         {
            _loc5_ = new UserData();
            _loc5_.uid = _loc4_.fb_namespace::uid;
            _loc5_.affiations = this.getAffiliation(_loc4_.fb_namespace::affiliations);
            _loc5_.first_name = _loc4_.fb_namespace::first_name;
            _loc5_.last_name = _loc4_.fb_namespace::last_name;
            _loc5_.name = _loc4_.fb_namespace::name;
            _loc5_.timezone = _loc4_.fb_namespace::timezone;
            _loc3_.addItem(_loc5_);
         }
         _loc2_.userCollection = _loc3_;
         return _loc2_;
      }
      
      protected function parseGetAppProperties(param1:XML) : GetAppPropertiesData
      {
         var _loc2_:GetAppPropertiesData = new GetAppPropertiesData();
         _loc2_.appProperties = com.adobe.serialization.json.JSON.decode(param1.toString());
         return _loc2_;
      }
      
      protected function parseGetRegisteredTemplateBundles(param1:XML) : GetRegisteredTemplateBundleData
      {
         var _loc5_:* = undefined;
         var _loc2_:GetRegisteredTemplateBundleData = new GetRegisteredTemplateBundleData();
         var _loc3_:TemplateBundleCollection = new TemplateBundleCollection();
         var _loc4_:TemplateCollection = new TemplateCollection();
         for each(_loc5_ in param1..fb_namespace::template_bundle)
         {
            this.getTemplate(_loc5_.fb_namespace::one_line_story_template,_loc4_);
            this.getTemplate(_loc5_.fb_namespace::short_story_templates,_loc4_);
            this.getTemplate(_loc5_.fb_namespace::full_story_template,_loc4_);
            _loc4_.template_bundle_id = _loc5_.fb_namespace::template_bundle_id;
            _loc4_.time_created = FacebookXMLParserUtils.toDate(_loc5_.fb_namespace::time_created);
         }
         _loc2_.bundleCollection = _loc4_;
         return _loc2_;
      }
      
      protected function parseGetRegisteredTemplateBundleByID(param1:XML) : GetRegisteredTemplateBundleByIDData
      {
         var _loc2_:GetRegisteredTemplateBundleByIDData = new GetRegisteredTemplateBundleByIDData();
         var _loc3_:TemplateCollection = new TemplateCollection();
         this.getTemplate(param1.fb_namespace::one_line_story_template,_loc3_);
         this.getTemplate(param1.fb_namespace::short_story_templates,_loc3_);
         this.getTemplate(param1.fb_namespace::full_story_template,_loc3_);
         _loc3_.template_bundle_id = param1.fb_namespace::template_bundle_id;
         _loc3_.time_created = FacebookXMLParserUtils.toDate(param1.fb_namespace::time_created);
         _loc2_.templateCollection = _loc3_;
         return _loc2_;
      }
      
      protected function responseNodeNameToMethodName(param1:String) : String
      {
         var _loc2_:Array = param1.split("_");
         _loc2_.pop();
         return _loc2_.join(".");
      }
      
      protected function parseGetObjectTypes(param1:XML) : GetObjectTypesData
      {
         var _loc4_:* = undefined;
         var _loc5_:ObjectTypesData = null;
         var _loc2_:GetObjectTypesData = new GetObjectTypesData();
         var _loc3_:ObjectTypesCollection = new ObjectTypesCollection();
         for each(_loc4_ in param1..fb_namespace::object_type_info)
         {
            _loc5_ = new ObjectTypesData();
            _loc5_.name = _loc4_.fb_namespace::name;
            _loc5_.object_class = _loc4_.fb_namespace::object_class;
            _loc3_.addItem(_loc5_);
         }
         _loc2_.objectTypeCollection = _loc3_;
         return _loc2_;
      }
      
      protected function parseFacebookPhoto(param1:XML) : FacebookPhoto
      {
         var _loc2_:FacebookPhoto = new FacebookPhoto();
         _loc2_.pid = FacebookXMLParserUtils.toStringValue(param1.fb_namespace::pid[0]);
         _loc2_.aid = FacebookXMLParserUtils.toStringValue(param1.fb_namespace::aid[0]);
         _loc2_.owner = FacebookXMLParserUtils.toNumber(param1.fb_namespace::owner[0]);
         _loc2_.src = FacebookXMLParserUtils.toStringValue(param1.fb_namespace::src[0]);
         _loc2_.src_big = FacebookXMLParserUtils.toStringValue(param1.fb_namespace::src_big[0]);
         _loc2_.src_small = FacebookXMLParserUtils.toStringValue(param1.fb_namespace::src_small[0]);
         _loc2_.link = FacebookXMLParserUtils.toStringValue(param1.fb_namespace::link[0]);
         _loc2_.caption = FacebookXMLParserUtils.toStringValue(param1.fb_namespace::caption[0]);
         return _loc2_;
      }
      
      protected function parseGetObjectType(param1:XML) : GetObjectTypeData
      {
         var _loc2_:GetObjectTypeData = new GetObjectTypeData();
         _loc2_.name = param1.fb_namespace::name;
         _loc2_.data_type = param1.fb_namespace::data_type;
         _loc2_.index_type = param1.fb_namespace::index_type;
         return _loc2_;
      }
      
      protected function createTagObject(param1:XML, param2:Array) : *
      {
         var _loc5_:AbstractTagData = null;
         var _loc7_:Object = null;
         var _loc3_:Number = param1.children().length();
         var _loc4_:String = param1.children()[0].toLowerCase();
         if(_loc4_ == "leaf")
         {
            _loc5_ = new LeafTagData(null,null,null,null,null);
            (_loc5_ as LeafTagData).fbml = param1.children()[9];
         }
         else
         {
            _loc5_ = new ContainerTagData(null,null,null,null,null,null,null);
            (_loc5_ as ContainerTagData).open_tag_fbml = param1.children()[2];
            (_loc5_ as ContainerTagData).close_tag_fbml = param1.children()[4];
         }
         var _loc6_:Number = 0;
         while(_loc6_ < _loc3_)
         {
            _loc7_ = param1.children()[_loc6_];
            switch(param2[_loc6_])
            {
               case "name":
               case "type":
               case "description":
               case "is_public":
               case "header_fbml":
               case "footer_fbml":
                  _loc5_[param2[_loc6_]] = _loc7_.text();
                  break;
               case "attributes":
                  if(_loc7_.children() is XMLList)
                  {
                     if(_loc7_.children().length() == 0)
                     {
                        _loc5_[param2[_loc6_]] = null;
                     }
                  }
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      protected function parseGetNotes(param1:XML) : GetNotesData
      {
         var _loc4_:* = undefined;
         var _loc5_:NoteData = null;
         var _loc2_:GetNotesData = new GetNotesData();
         var _loc3_:NotesCollection = new NotesCollection();
         for each(_loc4_ in param1..fb_namespace::note)
         {
            _loc5_ = new NoteData();
            _loc5_.note_id = _loc4_.fb_namespace::note_id;
            _loc5_.title = _loc4_.fb_namespace::title;
            _loc5_.content = _loc4_.fb_namespace::content;
            _loc5_.created_time = FacebookXMLParserUtils.toDate(_loc4_.fb_namespace::created_time);
            _loc5_.updated_time = FacebookXMLParserUtils.toDate(_loc4_.fb_namespace::updated_time);
            _loc5_.uid = _loc4_.fb_namespace::uid;
            _loc3_.addItem(_loc5_);
         }
         _loc2_.notesCollection = _loc3_;
         return _loc2_;
      }
      
      protected function parseGetMetrics(param1:XML) : GetMetricsData
      {
         var _loc4_:* = undefined;
         var _loc5_:MetricsData = null;
         var _loc2_:GetMetricsData = new GetMetricsData();
         var _loc3_:MetricsDataCollection = new MetricsDataCollection();
         for each(_loc4_ in param1..fb_namespace::metrics)
         {
            _loc5_ = new MetricsData();
            _loc5_.end_time = FacebookXMLParserUtils.toDate(_loc4_.fb_namespace::end_time);
            _loc5_.active_users = _loc4_.fb_namespace::active_users;
            _loc5_.canvas_page_views = _loc4_.fb_namespace::canvas_page_views;
            _loc3_.addItem(_loc5_);
         }
         _loc2_.metricsCollection = _loc3_;
         return _loc2_;
      }
      
      protected function parsePageGetInfo(param1:XML) : GetPageInfoData
      {
         var _loc5_:Object = null;
         var _loc6_:PageInfoData = null;
         var _loc2_:GetPageInfoData = new GetPageInfoData();
         var _loc3_:PageInfoCollection = new PageInfoCollection();
         var _loc4_:XMLList = param1.fb_namespace::page;
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = new PageInfoData();
            _loc6_.page_id = _loc5_.fb_namespace::page_id;
            _loc6_.name = _loc5_.fb_namespace::name;
            _loc6_.pic_small = _loc5_.fb_namespace::pic_small;
            _loc6_.pic_big = _loc5_.fb_namespace::pic_big;
            _loc6_.pic_square = _loc5_.fb_namespace::pic_square;
            _loc6_.pic_large = _loc5_.fb_namespace::pic_large;
            _loc6_.type = _loc5_.fb_namespace::type;
            _loc6_.website = _loc5_.fb_namespace::website;
            _loc6_.location = FacebookXMLParserUtils.createLocation(_loc5_.fb_namespace::location[0],this.fb_namespace);
            _loc6_.hours = _loc5_.fb_namespace::hours;
            _loc6_.band_members = _loc5_.fb_namespace::band_members;
            _loc6_.bio = _loc5_.fb_namespace::bio;
            _loc6_.hometown = _loc5_.fb_namespace::hometown;
            _loc6_.genre = FacebookXMLParserUtils.toStringValue(_loc5_.fb_namespace::genre[0]);
            _loc6_.record_label = _loc5_.fb_namespace::record_label;
            _loc6_.influences = _loc5_.fb_namespace::influences;
            _loc6_.has_added_app = FacebookXMLParserUtils.toBoolean(_loc5_.fb_namespace::has_added_app[0]);
            _loc6_.founded = _loc5_.fb_namespace::founded;
            _loc6_.company_overview = _loc5_.fb_namespace::company_overview;
            _loc6_.mission = _loc5_.fb_namespace::mission;
            _loc6_.products = _loc5_.fb_namespace::products;
            _loc6_.release_date = _loc5_.fb_namespace::release_date;
            _loc6_.starring = _loc5_.fb_namespace::starring;
            _loc6_.written_by = _loc5_.fb_namespace::written_by;
            _loc6_.directed_by = _loc5_.fb_namespace::directed_by;
            _loc6_.produced_by = _loc5_.fb_namespace::produced_by;
            _loc6_.studio = _loc5_.fb_namespace::studio;
            _loc6_.awards = _loc5_.fb_namespace::awards;
            _loc6_.plot_outline = _loc5_.fb_namespace::plot_outline;
            _loc6_.network = _loc5_.fb_namespace::network;
            _loc6_.season = _loc5_.fb_namespace::season;
            _loc6_.schedule = _loc5_.fb_namespace::schedule;
            _loc3_.addPageInfo(_loc6_);
         }
         _loc2_.pageInfoCollection = _loc3_;
         return _loc2_;
      }
      
      protected function parseGetTags(param1:XML) : GetTagsData
      {
         var _loc4_:* = undefined;
         var _loc5_:TagData = null;
         var _loc2_:GetTagsData = new GetTagsData();
         var _loc3_:PhotoTagCollection = new PhotoTagCollection();
         for each(_loc4_ in param1..fb_namespace::photo_tag)
         {
            _loc5_ = new TagData();
            _loc5_.text = _loc4_.fb_namespace::text;
            _loc5_.pid = _loc4_.fb_namespace::pid;
            _loc5_.subject = _loc4_.fb_namespace::subject;
            _loc5_.xcoord = _loc4_.fb_namespace::xcoord;
            _loc5_.ycoord = _loc4_.fb_namespace::ycoord;
            _loc5_.created = FacebookXMLParserUtils.toDate(_loc4_.fb_namespace::created);
            _loc3_.addPhotoTag(_loc5_);
         }
         _loc2_.photoTagsCollection = _loc3_;
         return _loc2_;
      }
      
      protected function parseGetGroupMembers(param1:XML) : GetMemberData
      {
         var _loc2_:GetMemberData = new GetMemberData();
         _loc2_.members = FacebookXMLParserUtils.toUIDArray(param1.fb_namespace::members[0]);
         _loc2_.admins = FacebookXMLParserUtils.toUIDArray(param1.fb_namespace::admins[0]);
         _loc2_.officers = FacebookXMLParserUtils.toUIDArray(param1.fb_namespace::officers[0]);
         _loc2_.notReplied = FacebookXMLParserUtils.toUIDArray(param1.fb_namespace::not_replied[0]);
         return _loc2_;
      }
      
      protected function parseGetGroups(param1:XML) : GetGroupData
      {
         var _loc4_:* = undefined;
         var _loc5_:GroupData = null;
         var _loc2_:GetGroupData = new GetGroupData();
         var _loc3_:GroupCollection = new GroupCollection();
         for each(_loc4_ in param1..fb_namespace::group)
         {
            _loc5_ = new GroupData();
            _loc5_.gid = _loc4_.fb_namespace::gid;
            _loc5_.name = _loc4_.fb_namespace::name;
            _loc5_.nid = _loc4_.fb_namespace::nid;
            _loc5_.description = _loc4_.fb_namespace::description;
            _loc5_.group_type = _loc4_.fb_namespace::group_type;
            _loc5_.group_subtype = _loc4_.fb_namespace::group_subtype;
            _loc5_.recent_news = _loc4_.fb_namespace::recent_news;
            _loc5_.pic = _loc4_.fb_namespace::pic;
            _loc5_.pic_big = _loc4_.fb_namespace::pic_big;
            _loc5_.pic_small = _loc4_.fb_namespace::pic_small;
            _loc5_.creator = _loc4_.fb_namespace::creator;
            _loc5_.update_time = FacebookXMLParserUtils.toDate(_loc4_.fb_namespace::update_time);
            _loc5_.office = _loc4_.fb_namespace::office;
            _loc5_.website = _loc4_.fb_namespace::website;
            _loc5_.venue = FacebookXMLParserUtils.createLocation(_loc4_.fb_namespace::venue[0],this.fb_namespace);
            _loc5_.privacy = _loc4_.fb_namespace::privacy;
            _loc3_.addGroup(_loc5_);
         }
         _loc2_.groups = _loc3_;
         return _loc2_;
      }
      
      protected function parseCreateAlbum(param1:XML) : GetCreateAlbumData
      {
         var _loc2_:GetCreateAlbumData = new GetCreateAlbumData();
         var _loc3_:AlbumData = new AlbumData();
         _loc3_.aid = param1.fb_namespace::aid;
         _loc3_.cover_pid = param1.fb_namespace::cover_pid;
         _loc3_.owner = param1.fb_namespace::owner;
         _loc3_.name = param1.fb_namespace::name;
         _loc3_.created = FacebookXMLParserUtils.toDate(param1.fb_namespace::created);
         _loc3_.modified = FacebookXMLParserUtils.toDate(param1.fb_namespace::modified);
         _loc3_.description = param1.fb_namespace::description;
         _loc3_.location = param1.fb_namespace::location;
         _loc3_.link = param1.fb_namespace::link;
         _loc3_.size = param1.fb_namespace::size;
         _loc3_.visible = param1.fb_namespace::visible;
         _loc2_.albumData = _loc3_;
         return _loc2_;
      }
      
      protected function parseGetAllocation(param1:XML) : GetAllocationData
      {
         var _loc2_:GetAllocationData = new GetAllocationData();
         _loc2_.allocationLimit = Number(param1.toString());
         return _loc2_;
      }
      
      protected function parseGetCookies(param1:XML) : GetCookiesData
      {
         var _loc2_:GetCookiesData = new GetCookiesData();
         _loc2_.uid = param1.fb_namespace::uid;
         _loc2_.name = param1.fb_namespace::name;
         _loc2_.value = param1.fb_namespace::value;
         _loc2_.expires = param1.fb_namespace::expires;
         _loc2_.path = param1.fb_namespace::path;
         return _loc2_;
      }
      
      protected function parseGetCustomTags(param1:XML) : GetCustomTagsData
      {
         var _loc5_:* = undefined;
         var _loc2_:Array = ["type","name","open_tag_fbml","description","close_tag_fbml","is_public","attributes","header_fbml","footer_fbml","fbml"];
         var _loc3_:GetCustomTagsData = new GetCustomTagsData();
         var _loc4_:TagCollection = new TagCollection();
         for each(_loc5_ in param1..fb_namespace::custom_tag)
         {
            _loc4_.addItem(this.createTagObject(_loc5_,_loc2_));
         }
         _loc3_.tagCollection = _loc4_;
         return _loc3_;
      }
      
      protected function parseGetAlbums(param1:XML) : GetAlbumsData
      {
         var _loc2_:GetAlbumsData = new GetAlbumsData();
         _loc2_.albumCollection = FacebookXMLParserUtils.createAlbumCollection(param1,this.fb_namespace);
         return _loc2_;
      }
      
      protected function parseGetInfo(param1:XML) : GetInfoData
      {
         var _loc7_:FacebookUser = null;
         var _loc2_:FacebookUserCollection = new FacebookUserCollection();
         var _loc3_:XMLList = param1..fb_namespace::user;
         var _loc4_:uint = uint(_loc3_.length());
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = FacebookUserXMLParser.createFacebookUser(_loc3_[_loc5_],this.fb_namespace);
            _loc2_.addItem(_loc7_);
            _loc5_++;
         }
         var _loc6_:GetInfoData = new GetInfoData();
         _loc6_.userCollection = _loc2_;
         return _loc6_;
      }
      
      protected function parseGetLists(param1:XML) : GetListsData
      {
         var _loc4_:* = undefined;
         var _loc5_:ListsData = null;
         var _loc2_:GetListsData = new GetListsData();
         var _loc3_:Array = [];
         for each(_loc4_ in param1..fb_namespace::friendlist)
         {
            _loc5_ = new ListsData();
            _loc5_.flid = _loc4_.fb_namespace::flid;
            _loc5_.name = _loc4_.fb_namespace::name;
            _loc3_.push(_loc5_);
         }
         _loc2_.lists = _loc3_;
         return _loc2_;
      }
      
      protected function parseGetAppUsersData(param1:XML) : GetAppUserData
      {
         var _loc2_:Array = FacebookXMLParserUtils.toUIDArray(param1);
         var _loc3_:GetAppUserData = new GetAppUserData();
         _loc3_.uids = _loc2_;
         return _loc3_;
      }
      
      protected function parseGetStatus(param1:XML) : GetStatusData
      {
         var _loc7_:XMLList = null;
         var _loc8_:Status = null;
         var _loc2_:GetStatusData = new GetStatusData();
         var _loc3_:Array = [];
         var _loc4_:XMLList = param1.children();
         var _loc5_:uint = uint(_loc4_.length());
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc4_[_loc6_].children();
            _loc8_ = new Status();
            _loc8_.uid = FacebookXMLParserUtils.toStringValue(_loc7_[0]);
            _loc8_.status_id = FacebookXMLParserUtils.toStringValue(_loc7_[1]);
            _loc8_.time = FacebookXMLParserUtils.toDate(_loc7_[2]);
            _loc8_.source = FacebookXMLParserUtils.toStringValue(_loc7_[3]);
            _loc8_.message = FacebookXMLParserUtils.toStringValue(_loc7_[4]);
            _loc3_.push(_loc8_);
            _loc6_++;
         }
         _loc2_.status = _loc3_;
         return _loc2_;
      }
      
      protected function parseGetMembers(param1:XML) : GetMembersData
      {
         var _loc2_:GetMembersData = new GetMembersData();
         _loc2_.attending = FacebookXMLParserUtils.toUIDArray(param1..fb_namespace::attending[0]);
         _loc2_.unsure = FacebookXMLParserUtils.toUIDArray(param1..fb_namespace::unsure[0]);
         _loc2_.declined = FacebookXMLParserUtils.toUIDArray(param1..fb_namespace::declined[0]);
         _loc2_.not_replied = FacebookXMLParserUtils.toUIDArray(param1..fb_namespace::not_replied[0]);
         return _loc2_;
      }
      
      protected function parseGetEvent(param1:XML) : GetEventsData
      {
         var _loc4_:* = undefined;
         var _loc5_:EventData = null;
         var _loc2_:GetEventsData = new GetEventsData();
         var _loc3_:EventCollection = new EventCollection();
         for each(_loc4_ in param1..fb_namespace::event)
         {
            _loc5_ = new EventData();
            _loc5_.eid = _loc4_.fb_namespace::eid;
            _loc5_.name = _loc4_.fb_namespace::name;
            _loc5_.tagline = _loc4_.fb_namespace::tagline;
            _loc5_.nid = _loc4_.fb_namespace::nid;
            _loc5_.pic = _loc4_.fb_namespace::pic;
            _loc5_.pic_big = _loc4_.fb_namespace::pic_big;
            _loc5_.pic_small = _loc4_.fb_namespace::pic_small;
            _loc5_.host = _loc4_.fb_namespace::host;
            _loc5_.description = _loc4_.fb_namespace::description;
            _loc5_.event_type = _loc4_.fb_namespace::event_type;
            _loc5_.event_subtype = _loc4_.fb_namespace::event_subtype;
            _loc5_.start_time = FacebookXMLParserUtils.toDate(_loc4_.fb_namespace::start_time);
            _loc5_.end_time = FacebookXMLParserUtils.toDate(_loc4_.fb_namespace::end_time);
            _loc5_.creator = _loc4_.fb_namespace::end_time;
            _loc5_.update_time = FacebookXMLParserUtils.toDate(_loc4_.fb_namespace::update_time);
            _loc5_.location = _loc4_.fb_namespace::location;
            _loc5_.venue = FacebookXMLParserUtils.createLocation(_loc4_.fb_namespace::venue[0],this.fb_namespace);
            _loc3_.addItem(_loc5_);
         }
         _loc2_.eventCollection = _loc3_;
         return _loc2_;
      }
      
      protected function parseGetFriends(param1:XML) : GetFriendsData
      {
         var _loc4_:* = undefined;
         var _loc5_:FacebookUser = null;
         var _loc2_:GetFriendsData = new GetFriendsData();
         var _loc3_:FacebookUserCollection = new FacebookUserCollection();
         for each(_loc4_ in param1..fb_namespace::uid)
         {
            _loc5_ = new FacebookUser();
            _loc5_.uid = _loc4_;
            _loc3_.addItem(_loc5_);
         }
         _loc2_.friends = _loc3_;
         return _loc2_;
      }
      
      protected function parseGetPublicInfo(param1:XML) : GetPublicInfoData
      {
         var _loc2_:GetPublicInfoData = new GetPublicInfoData();
         _loc2_.app_id = param1.fb_namespace::app_id;
         _loc2_.api_key = param1.fb_namespace::api_key;
         _loc2_.canvas_name = param1.fb_namespace::canvas_name;
         _loc2_.display_name = param1.fb_namespace::display_name;
         _loc2_.icon_url = param1.fb_namespace::icon_url;
         _loc2_.logo_url = param1.fb_namespace::logo_url;
         _loc2_.developers = param1.fb_namespace::developers;
         _loc2_.company_name = param1.fb_namespace::company_name;
         _loc2_.developers = param1.fb_namespace::developers;
         _loc2_.daily_active_users = param1.fb_namespace::daily_active_users;
         _loc2_.weekly_active_users = param1.fb_namespace::weekly_active_users;
         _loc2_.monthly_active_users = param1.fb_namespace::monthly_active_users;
         return _loc2_;
      }
      
      protected function parseAreFriends(param1:XML) : AreFriendsData
      {
         var _loc4_:* = undefined;
         var _loc5_:FriendsData = null;
         var _loc2_:AreFriendsData = new AreFriendsData();
         var _loc3_:FriendsCollection = new FriendsCollection();
         for each(_loc4_ in param1..fb_namespace::friend_info)
         {
            _loc5_ = new FriendsData();
            _loc5_.uid1 = _loc4_.fb_namespace::uid1;
            _loc5_.uid2 = _loc4_.fb_namespace::uid2;
            _loc5_.are_friends = FacebookXMLParserUtils.toBoolean(_loc4_.fb_namespace::are_friends);
            _loc3_.addItem(_loc5_);
         }
         _loc2_.friendsCollection = _loc3_;
         return _loc2_;
      }
      
      public function validateFacebookResponce(param1:String) : FacebookError
      {
         var xml:XML = null;
         var xmlError:Error = null;
         var result:String = param1;
         var error:FacebookError = null;
         var hasXMLError:Boolean = false;
         try
         {
            xml = new XML(result);
         }
         catch(e:*)
         {
            xmlError = e;
            hasXMLError = true;
         }
         if(hasXMLError == false)
         {
            if(xml.localName() == "error_response")
            {
               error = new FacebookError();
               error.rawResult = result;
               error.errorCode = Number(xml.fb_namespace::error_code);
               error.errorMsg = xml.fb_namespace::error_msg;
               error.requestArgs = FacebookXMLParserUtils.xmlToUrlVariables(xml..arg);
            }
            return error;
         }
         if(hasXMLError == true)
         {
            error = new FacebookError();
            error.error = xmlError;
            error.errorCode = -1;
         }
         return error;
      }
      
      protected function parseBatchRun(param1:XML) : FacebookData
      {
         var _loc7_:String = null;
         var _loc8_:XML = null;
         var _loc9_:FacebookError = null;
         var _loc10_:String = null;
         var _loc11_:FacebookData = null;
         var _loc2_:XMLList = param1..fb_namespace::batch_run_response_elt;
         var _loc3_:uint = uint(_loc2_.length());
         var _loc4_:Array = [];
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_)
         {
            _loc7_ = _loc2_[_loc5_].toString();
            _loc8_ = new XML(_loc7_);
            _loc9_ = this.validateFacebookResponce(_loc7_);
            if(_loc9_ === null)
            {
               _loc10_ = this.responseNodeNameToMethodName(_loc8_.localName().toString());
               _loc11_ = this.parse(_loc7_,_loc10_);
               _loc4_.push(_loc11_);
            }
            else
            {
               _loc4_.push(_loc9_);
            }
            _loc5_++;
         }
         var _loc6_:BatchResult = new BatchResult();
         _loc6_.results = _loc4_;
         return _loc6_;
      }
      
      protected function getTemplate(param1:XMLList, param2:TemplateCollection) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:TemplateData = null;
         for each(_loc3_ in param1)
         {
            _loc4_ = new TemplateData();
            _loc4_.type = _loc3_.localName();
            _loc4_.template_body = _loc3_.fb_namespace::template_body;
            _loc4_.template_title = _loc3_.fb_namespace::template_title;
            param2.addTemplateData(_loc4_);
         }
      }
   }
}

