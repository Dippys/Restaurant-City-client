package com.playfish.coretech.platform.socialplatform
{
   import com.playfish.coretech.platform.marina.MarinaGames;
   
   public class FanPage
   {
      
      private var fanFriendsList:Array;
      
      private var available:Boolean;
      
      public var id:String;
      
      public function FanPage(param1:String)
      {
         super();
         id = param1;
         fanFriendsList = new Array();
         available = false;
      }
      
      public function addFans(param1:Array) : void
      {
         fanFriendsList = fanFriendsList.concat(param1);
         available = true;
      }
      
      public function getFanID() : String
      {
         return id;
      }
      
      public function getFanList() : Array
      {
         return fanFriendsList;
      }
      
      public function toString() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "Fan Page ID:" + id + "(" + MarinaGames.getGameName(id) + ") ";
         for each(_loc2_ in fanFriendsList)
         {
            _loc1_ += _loc2_.toString();
            _loc1_ += ", ";
         }
         return _loc1_ + ("(" + fanFriendsList.length + ")");
      }
      
      public function isPlayerFan(param1:String) : Boolean
      {
         return fanFriendsList.indexOf(param1) == -1 ? false : true;
      }
   }
}

