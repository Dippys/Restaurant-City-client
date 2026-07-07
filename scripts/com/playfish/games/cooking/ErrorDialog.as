package com.playfish.games.cooking
{
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ErrorDialog extends BaseObject
   {
      
      public static const TYPE_WARNING:int = 0;
      
      public static const TYPE_FATAL:int = 1;
      
      public static const TYPE_MESSAGE:int = 2;
      
      private static const TYPE_PREFIX:Array = ["WARNING: ","FATAL ERROR: ",""];
      
      private static const FRAME_WIDTH:int = 500;
      
      private static const FRAME_HEIGHT:int = 400;
      
      public function ErrorDialog(param1:String, param2:int)
      {
         var _loc5_:Sprite = null;
         super();
         graphics.beginFill(15658734,1);
         graphics.drawRect(0,0,FRAME_WIDTH,FRAME_HEIGHT);
         var _loc3_:TextField = new TextField();
         _loc3_.width = FRAME_WIDTH;
         _loc3_.height = FRAME_HEIGHT - 100;
         _loc3_.text = new Error(TYPE_PREFIX[param2] + param1).getStackTrace();
         _loc3_.wordWrap = true;
         addChild(_loc3_);
         var _loc4_:TextField = new TextField();
         _loc4_.text = "OK";
         _loc4_.selectable = false;
         _loc4_.mouseEnabled = false;
         _loc5_ = new Sprite();
         _loc5_.graphics.beginFill(15597568);
         _loc5_.graphics.drawRect(0,0,60,30);
         _loc5_.x = (FRAME_WIDTH - _loc5_.width) / 2;
         _loc5_.y = this.height - _loc5_.height - 10;
         _loc5_.buttonMode = true;
         _loc5_.addChild(_loc4_);
         _loc5_.addEventListener(MouseEvent.CLICK,onOkClick);
         addChild(_loc5_);
         Engine.showErrorDialog(this);
         Debug.out(param1);
      }
      
      public function onOkClick(param1:MouseEvent) : void
      {
         Engine.removeErrorDialog(this);
      }
   }
}

