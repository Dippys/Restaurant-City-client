package com.facebook.commands.batch
{
   import com.adobe.serialization.json.JSON;
   import com.facebook.data.InternalErrorMessages;
   import com.facebook.data.batch.BatchCollection;
   import com.facebook.delegates.RequestHelper;
   import com.facebook.facebook_internal;
   import com.facebook.net.FacebookCall;
   import flash.net.URLVariables;
   
   use namespace facebook_internal;
   
   public class BatchRun extends FacebookCall
   {
      
      public static const METHOD_NAME:String = "batch.run";
      
      public static const SCHEMA:Array = ["method_feed","serial_only"];
      
      public var method_feed:BatchCollection;
      
      public var serial_only:Boolean;
      
      public function BatchRun(param1:BatchCollection, param2:Boolean = false)
      {
         super(METHOD_NAME);
         if(param1.length > 20)
         {
            throw new RangeError(InternalErrorMessages.BATCH_RUN_RANGE_ERROR);
         }
         this.method_feed = param1;
         this.serial_only = param2;
      }
      
      override facebook_internal function initialize() : void
      {
         var _loc5_:FacebookCall = null;
         var _loc6_:URLVariables = null;
         var _loc1_:Array = [];
         var _loc2_:uint = uint(this.method_feed.length);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc5_ = this.method_feed.getItemAt(_loc3_) as FacebookCall;
            _loc5_.session = session;
            _loc5_.initialize();
            RequestHelper.formatRequest(_loc5_);
            _loc6_ = _loc5_.args;
            _loc1_.push(_loc6_.toString());
            _loc3_++;
         }
         var _loc4_:String = com.adobe.serialization.json.JSON.encode(_loc1_);
         applySchema(SCHEMA,_loc4_,this.serial_only);
         super.facebook_internal::initialize();
         super.facebook_internal::initialize();
      }
   }
}

