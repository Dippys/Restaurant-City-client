package com.facebook.utils
{
   import com.facebook.data.FacebookEducationInfo;
   import com.facebook.data.FacebookNetwork;
   import com.facebook.data.FacebookWorkInfo;
   import com.facebook.data.users.FacebookUser;
   import com.facebook.data.users.StatusData;
   
   public class FacebookUserXMLParser
   {
      
      public function FacebookUserXMLParser()
      {
         super();
      }
      
      protected static function parseWorkHistory(param1:XML, param2:Namespace) : Array
      {
         var _loc5_:Object = null;
         var _loc6_:FacebookWorkInfo = null;
         var _loc3_:Array = [];
         var _loc4_:XMLList = param1.children();
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = new FacebookWorkInfo();
            _loc6_.location = FacebookXMLParserUtils.createLocation(_loc5_.param2::location[0],param2);
            _loc6_.company_name = String(_loc5_.param2::company_name);
            _loc6_.description = String(_loc5_.param2::description);
            _loc6_.position = String(_loc5_.param2::position);
            _loc6_.start_date = FacebookDataUtils.formatDate(_loc5_.param2::start_date);
            _loc6_.end_date = FacebookDataUtils.formatDate(_loc5_.param2::end_date);
            _loc3_.push(_loc6_);
         }
         return _loc3_;
      }
      
      protected static function createStatus(param1:XML, param2:Namespace) : StatusData
      {
         var _loc3_:StatusData = new StatusData();
         _loc3_.message = String(param1.param2::message);
         _loc3_.time = FacebookDataUtils.formatDate(String(param1.param2::time));
         return _loc3_;
      }
      
      protected static function parseEducationHistory(param1:XML, param2:Namespace) : Array
      {
         var _loc5_:Object = null;
         var _loc6_:FacebookEducationInfo = null;
         var _loc7_:XML = null;
         var _loc3_:Array = [];
         var _loc4_:XMLList = param1.children();
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = new FacebookEducationInfo();
            _loc6_.name = String(_loc5_.param2::name);
            _loc6_.year = String(_loc5_.param2::year);
            _loc6_.degree = String(_loc5_.param2::degree);
            _loc6_.concentrations = [];
            for each(_loc7_ in _loc5_.concentration)
            {
               _loc6_.concentrations.push(_loc7_);
            }
            _loc3_.push(_loc6_);
         }
         return _loc3_;
      }
      
      public static function createFacebookUser(param1:XML, param2:Namespace) : FacebookUser
      {
         var _loc6_:XML = null;
         var _loc7_:String = null;
         var _loc3_:FacebookUser = new FacebookUser();
         var _loc4_:XMLList = param1.children();
         var _loc5_:uint = uint(_loc4_.length());
         var _loc8_:uint = 0;
         while(_loc8_ < _loc5_)
         {
            _loc6_ = _loc4_[_loc8_];
            _loc7_ = _loc6_.localName().toString();
            switch(_loc7_)
            {
               case "status":
                  _loc3_[_loc7_] = createStatus(_loc6_,param2);
                  break;
               case "affiliations":
                  _loc3_[_loc7_] = createAffiliations(_loc6_.children(),param2);
                  break;
               case "hometown_location":
               case "current_location":
                  _loc3_[_loc7_] = FacebookXMLParserUtils.createLocation(_loc6_,param2);
                  break;
               case "profile_update_time":
                  _loc3_[_loc7_] = FacebookDataUtils.formatDate(_loc6_.toString());
                  break;
               case "hs_info":
                  _loc3_.hs1_id = parseInt(_loc6_.param2::hs1_id);
                  _loc3_.hs1_name = String(_loc6_.param2::hs1_name);
                  _loc3_.hs2_id = parseInt(_loc6_.param2::hs2_id);
                  _loc3_.hs2_name = String(_loc6_.param2::hs2_name);
                  _loc3_.grad_year = String(_loc6_.param2::grad_year);
                  break;
               case "education_history":
                  _loc3_[_loc7_] = parseEducationHistory(_loc6_,param2);
                  break;
               case "work_history":
                  _loc3_[_loc7_] = parseWorkHistory(_loc6_,param2);
                  break;
               case "timezone":
               case "notes_count":
               case "wall_count":
                  _loc3_[_loc7_] = Number(_loc6_.toString());
                  break;
               case "has_added_app":
               case "is_app_user":
                  _loc3_[_loc7_] = FacebookXMLParserUtils.toBoolean(_loc6_);
                  break;
               case "meeting_sex":
               case "meeting_for":
               case "email_hashes":
                  _loc3_[_loc7_] = toArray(_loc6_,param2);
                  break;
               default:
                  if(_loc7_ in _loc3_)
                  {
                     _loc3_[_loc7_] = String(_loc6_);
                  }
            }
            _loc8_++;
         }
         return _loc3_;
      }
      
      protected static function toArray(param1:XML, param2:Namespace) : Array
      {
         var _loc3_:Array = [];
         var _loc4_:XMLList = param1.children();
         var _loc5_:uint = uint(_loc4_.length());
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_.push(_loc4_[_loc6_].toString());
            _loc6_++;
         }
         return _loc3_;
      }
      
      protected static function createAffiliations(param1:XMLList, param2:Namespace) : Array
      {
         var _loc4_:* = undefined;
         var _loc5_:FacebookNetwork = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param1)
         {
            _loc5_ = new FacebookNetwork();
            _loc5_.nid = parseInt(_loc4_.param2::nid);
            _loc5_.name = String(_loc4_.param2::name);
            _loc5_.type = String(_loc4_.param2::type);
            _loc5_.status = String(_loc4_.param2::status);
            _loc5_.year = String(_loc4_.param2::year);
            _loc3_.push(_loc5_);
         }
         return _loc3_;
      }
   }
}

