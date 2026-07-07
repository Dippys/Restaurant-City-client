package com.playfish.rpc.cooking
{
   import com.playfish.rpc.share.NetworkUid;
   import flash.utils.ByteArray;
   
   public class UserInfo
   {
      
      public static var MAX_FLOOR_SIZE:Number = 400;
      
      public var userLevel:uint;
      
      public var employees:Array;
      
      public var profileUrl:String;
      
      public var inventoryItem:Array;
      
      public var floor:Array;
      
      public var imageUrl:String;
      
      public var lastSurveyTime:Date;
      
      public var gourmetPoint:Number;
      
      public var credits:Number;
      
      public var id:NetworkUid;
      
      public var demandPoint:Number;
      
      public var totalMark:Number = 0;
      
      public var lastSave:uint;
      
      public var garden:Array;
      
      public var trashPoint:Number;
      
      public var fullName:String;
      
      public var playCount:uint;
      
      public var nbVote:Number = 0;
      
      public var gender:uint;
      
      public var ingredients:Array;
      
      public var awards:ByteArray;
      
      public var offlineShard:Boolean = false;
      
      public var activeFloorIndex:uint;
      
      public var isInStreet:Boolean;
      
      public var consecutionCount:uint;
      
      public var ownedItem:Array;
      
      public var firstName:String;
      
      public var largeImage:Array;
      
      public var floors:Array;
      
      public var restaurantName:String;
      
      public var image:Array;
      
      public var largeImageUrl:String;
      
      public var visitedFriend:Array;
      
      public var musicPlay:Number;
      
      public var visitedFriendsToday:Array;
      
      public function UserInfo()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc2_:OwnedItem = null;
         var _loc3_:Number = NaN;
         var _loc4_:InventoryItem = null;
         var _loc1_:String = "[profile: id=" + id + " Play count =" + playCount + " firstName=\"" + firstName + "\" fullName=\"" + fullName + "\" imageUrl=" + imageUrl + " largeImageUrl=" + largeImageUrl;
         _loc1_ += " restaurantName=" + restaurantName;
         _loc1_ += " credits=" + credits + " offline=" + offlineShard + " item List :";
         for each(_loc2_ in ownedItem)
         {
            _loc1_ += _loc2_.toString();
         }
         _loc1_ += " Floor:";
         for each(_loc3_ in floor)
         {
            _loc1_ += _loc3_ + ",";
         }
         _loc1_ += " Inventory:";
         for each(_loc4_ in inventoryItem)
         {
            _loc1_ += _loc4_ + ",";
         }
         return _loc1_ + "]";
      }
   }
}

