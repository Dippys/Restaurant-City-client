package com.playfish.games.cooking.events
{
   import com.playfish.games.cooking.GameUser;
   import flash.events.Event;
   
   public class FriendListEvent extends Event
   {
      
      public static const USER_CLICKED:String = "user_clicked";
      
      public var user:GameUser;
      
      public function FriendListEvent(param1:String, param2:GameUser)
      {
         super(param1);
         this.user = param2;
      }
   }
}

