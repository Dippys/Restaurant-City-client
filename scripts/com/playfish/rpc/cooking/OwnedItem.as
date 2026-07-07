package com.playfish.rpc.cooking
{
   import com.playfish.rpc.share.NetworkUid;
   
   public class OwnedItem
   {
      
      public var employeeId:NetworkUid;
      
      public var data:Number;
      
      public var positionX:Number;
      
      public var positionY:Number;
      
      public var globalItemId:Number;
      
      public var roomIndex:uint;
      
      public var id:Number;
      
      public function OwnedItem()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[Item id=" + id + " global Id (type)=" + globalItemId + " positionX =" + positionX + " positionY=" + positionY + " data=" + data + " employeeId=" + employeeId + "]";
      }
   }
}

