package com.facebook.utils
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class PostRequest
   {
      
      protected var _boundary:String = "-----";
      
      protected var postData:ByteArray;
      
      public function PostRequest()
      {
         super();
         this.createPostData();
      }
      
      public function getPostData() : ByteArray
      {
         this.postData.position = 0;
         return this.postData;
      }
      
      protected function writeBoundary() : void
      {
         this.writeDoubleDash();
         var _loc1_:Number = 0;
         while(_loc1_ < this.boundary.length)
         {
            this.postData.writeByte(this.boundary.charCodeAt(_loc1_));
            _loc1_++;
         }
      }
      
      protected function writeDoubleDash() : void
      {
         this.postData.writeShort(11565);
      }
      
      public function writeFileData(param1:String, param2:ByteArray, param3:String) : void
      {
         var _loc4_:String = null;
         this.writeBoundary();
         this.writeLineBreak();
         _loc4_ = "Content-Disposition: form-data; filename=\"";
         var _loc5_:Number = 0;
         while(_loc5_ < _loc4_.length)
         {
            this.postData.writeByte(_loc4_.charCodeAt(_loc5_));
            _loc5_++;
         }
         this.postData.writeUTFBytes(param1);
         this.writeQuotationMark();
         this.writeLineBreak();
         _loc4_ = param3;
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            this.postData.writeByte(_loc4_.charCodeAt(_loc5_));
            _loc5_++;
         }
         this.writeLineBreak();
         this.writeLineBreak();
         param2.position = 0;
         this.postData.writeBytes(param2,0,param2.length);
         this.writeLineBreak();
      }
      
      public function createPostData() : void
      {
         this.postData = new ByteArray();
         this.postData.endian = Endian.BIG_ENDIAN;
      }
      
      public function writePostData(param1:String, param2:String) : void
      {
         var _loc3_:String = null;
         this.writeBoundary();
         this.writeLineBreak();
         _loc3_ = "Content-Disposition: form-data; name=\"" + param1 + "\"";
         var _loc4_:uint = uint(_loc3_.length);
         var _loc5_:Number = 0;
         while(_loc5_ < _loc4_)
         {
            this.postData.writeByte(_loc3_.charCodeAt(_loc5_));
            _loc5_++;
         }
         this.writeLineBreak();
         this.writeLineBreak();
         this.postData.writeUTFBytes(param2);
         this.writeLineBreak();
      }
      
      public function get boundary() : String
      {
         return this._boundary;
      }
      
      protected function writeLineBreak() : void
      {
         this.postData.writeShort(3338);
      }
      
      public function close() : void
      {
         this.writeBoundary();
         this.writeDoubleDash();
      }
      
      protected function writeQuotationMark() : void
      {
         this.postData.writeByte(34);
      }
      
      public function set boundary(param1:String) : void
      {
         this._boundary = param1;
      }
   }
}

