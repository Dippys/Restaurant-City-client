package com.playfish.rpc.cooking
{
   import com.playfish.rpc.share.NetworkUid;
   
   public class Mail
   {
      
      public var globalItemIds:Array;
      
      public var sendDate:Date;
      
      public var message:String;
      
      public var senderId:NetworkUid;
      
      public var recipientId:NetworkUid;
      
      public var itemId:Number;
      
      public var deleteTime:uint;
      
      public var type:int;
      
      public var id:uint;
      
      public var read:Boolean;
      
      public function Mail()
      {
         super();
      }
   }
}

