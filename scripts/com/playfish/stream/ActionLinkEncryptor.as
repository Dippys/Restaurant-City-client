package com.playfish.stream
{
   import com.playfish.stream.hurlant.crypto.*;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class ActionLinkEncryptor
   {
      
      private static const KEY_STRING:String = "d4ae3749fdd284924b4567bdbc7e3744";
      
      private static const CIPHER_NAME:String = "aes-ecb";
      
      private static const BITS_BLOCK_SIZE:int = 128;
      
      private static const SIG_STRING:String = "&pf_fsig=";
      
      private var hashedArgumentDictionary:Dictionary = new Dictionary();
      
      private var encryptedURLRequest:String;
      
      private var argumentKeys:Array = new Array();
      
      private var argumentDictionary:Dictionary = new Dictionary();
      
      public function ActionLinkEncryptor()
      {
         super();
      }
      
      private function encrypt() : void
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:ByteArray = null;
         var _loc1_:ByteArray = Hex.toArray(KEY_STRING);
         var _loc2_:ECBMode = new ECBMode(new AESKey(_loc1_),new PKCS5(BITS_BLOCK_SIZE));
         var _loc3_:int = 0;
         while(_loc3_ < argumentKeys.length)
         {
            _loc8_ = argumentKeys[_loc3_];
            _loc9_ = argumentDictionary[_loc8_];
            _loc10_ = new ByteArray();
            _loc10_.writeUTFBytes(_loc9_);
            _loc2_.encrypt(_loc10_);
            hashedArgumentDictionary[_loc8_] = _loc10_;
            _loc3_++;
         }
         var _loc4_:Array = clone(argumentKeys);
         _loc4_.sort();
         var _loc5_:String = getRequestString(_loc4_,hashedArgumentDictionary);
         var _loc6_:String = computeDigest(_loc5_,KEY_STRING);
         var _loc7_:String = getRequestString(argumentKeys,hashedArgumentDictionary);
         encryptedURLRequest = appendSignature(_loc7_,_loc6_);
      }
      
      private function getRequestString(param1:Array, param2:Dictionary, param3:Boolean = true) : String
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:ByteArray = null;
         var _loc4_:String = "";
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = param1[_loc5_];
            if(param3)
            {
               _loc8_ = hashedArgumentDictionary[_loc6_];
               _loc7_ = Hex.fromArray(_loc8_);
            }
            else
            {
               _loc7_ = param2[_loc6_];
            }
            if(_loc5_ > 0)
            {
               _loc4_ += "&";
            }
            _loc4_ += param1[_loc5_];
            _loc4_ = _loc4_ + "=";
            _loc4_ = _loc4_ + _loc7_;
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function toString() : String
      {
         if(encryptedURLRequest)
         {
            return encryptedURLRequest;
         }
         encrypt();
         return encryptedURLRequest;
      }
      
      public function addParameter(param1:String, param2:Object) : void
      {
         argumentKeys.push(param1);
         argumentDictionary[param1] = param2.toString();
      }
      
      private function toByteArray(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         return _loc2_;
      }
      
      private function computeDigest(param1:String, param2:String) : String
      {
         var _loc3_:String = null;
         var _loc4_:MD5 = new MD5();
         var _loc5_:ByteArray = toByteArray(param1 + param2);
         var _loc6_:ByteArray = _loc4_.hash(_loc5_);
         return Hex.fromArray(_loc6_);
      }
      
      private function clone(param1:Object) : *
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.position = 0;
         return _loc2_.readObject();
      }
      
      private function appendSignature(param1:String, param2:String) : String
      {
         var _loc3_:String = param1;
         _loc3_ += SIG_STRING;
         return _loc3_ + param2;
      }
   }
}

