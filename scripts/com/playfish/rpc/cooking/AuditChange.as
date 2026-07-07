package com.playfish.rpc.cooking
{
   import com.playfish.rpc.share.NetworkUid;
   
   public class AuditChange
   {
      
      public var ingredients:Array;
      
      public var employees:Array;
      
      public var floor:Array;
      
      public var inventoryItem:InventoryItem;
      
      public var uid:NetworkUid;
      
      public var itemId:Number;
      
      public var newCredits:Number;
      
      public var ownedItem:OwnedItem;
      
      public var itemToken:String;
      
      public var floors:Array;
      
      public var mailId:Array;
      
      public var action:Number;
      
      public var flag:Boolean;
      
      public var qty:Number;
      
      public var creditsDelta:Number;
      
      public function AuditChange()
      {
         super();
      }
   }
}

