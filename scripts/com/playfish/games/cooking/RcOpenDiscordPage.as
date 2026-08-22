package com.playfish.games.cooking
{
   import com.playfish.games.cooking.ui.WorldPopUp;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   // RC Reborn: Discord invite page. Code-drawn (no library asset needed).
   public class RcOpenDiscordPage extends WorldPopUp
   {
      public static const DISCORD_URL:String = "https://discord.gg/Ppuwb826eC";
      
      private static const PANEL_W:Number = 430;
      
      private static const PANEL_H:Number = 250;
      
      private var openButton:Sprite;
      
      public function RcOpenDiscordPage()
      {
         super(null,null,null);
         drawPanel();
      }
      
      private function drawPanel() : void
      {
         var _loc1_:TextField = null;
         var _loc2_:TextField = null;
         var _loc3_:TextField = null;
         var _loc4_:TextField = null;
         var _loc5_:Sprite = null;
         graphics.beginFill(0x23272A,0.97);
         graphics.lineStyle(3,0x5865F2,1);
         graphics.drawRoundRect(-PANEL_W / 2,-PANEL_H / 2,PANEL_W,PANEL_H,16,16);
         graphics.endFill();
         _loc1_ = makeTextField(-PANEL_W / 2 + 20,-PANEL_H / 2 + 18,PANEL_W - 40,40,"Join the Restaurant City Reborn community!",30,true);
         _loc2_ = makeTextField(-PANEL_W / 2 + 20,-PANEL_H / 2 + 64,PANEL_W - 40,34,"News, events, updates and live chat with fellow chefs.",17,false);
         _loc3_ = makeTextField(-PANEL_W / 2 + 20,-PANEL_H / 2 + 104,PANEL_W - 40,30,"https://discord.gg/Ppuwb826eC",18,true);
         _loc3_.setTextFormat(new TextFormat("Arial",18,0x5865F2,true));
         openButton = new Sprite();
         openButton.graphics.beginFill(0x5865F2,1);
         openButton.graphics.drawRoundRect(0,0,190,44,10,10);
         openButton.graphics.endFill();
         _loc4_ = makeTextField(0,4,190,40,"Open Discord",18,true);
         openButton.addChild(_loc4_);
         openButton.x = -PANEL_W / 2 + 20;
         openButton.y = PANEL_H / 2 - 66;
         openButton.buttonMode = true;
         openButton.useHandCursor = true;
         openButton.addEventListener(MouseEvent.CLICK,onOpenClick,false,0,true);
         openButton.addEventListener(MouseEvent.ROLL_OVER,onOpenOver,false,0,true);
         openButton.addEventListener(MouseEvent.ROLL_OUT,onOpenOut,false,0,true);
         addChild(openButton);
         _loc5_ = new Sprite();
         _loc5_.graphics.lineStyle(2,0x99AAB5,1);
         _loc5_.graphics.drawRoundRect(0,0,90,34,8,8);
         _loc5_.x = PANEL_W / 2 - 110;
         _loc5_.y = PANEL_H / 2 - 56;
         _loc5_.buttonMode = true;
         _loc5_.useHandCursor = true;
         _loc5_.addEventListener(MouseEvent.CLICK,onCloseClick,false,0,true);
         addChild(_loc5_);
         _loc4_ = makeTextField(0,4,90,30,"Close",14,false);
         _loc5_.addChild(_loc4_);
      }
      
      private function makeTextField(param1:Number, param2:Number, param3:Number, param4:Number, param5:String, param6:Number, param7:Boolean) : TextField
      {
         var _loc8_:TextField = new TextField();
         _loc8_.x = param1;
         _loc8_.y = param2;
         _loc8_.width = param3;
         _loc8_.height = param4;
         _loc8_.text = param5;
         _loc8_.selectable = false;
         _loc8_.mouseEnabled = false;
         var _loc9_:TextFormat = new TextFormat("Arial",param6,0xFFFFFF,param7);
         _loc9_.align = TextFormatAlign.CENTER;
         _loc8_.defaultTextFormat = _loc9_;
         _loc8_.setTextFormat(_loc9_);
         addChild(_loc8_);
         return _loc8_;
      }
      
      private function onOpenOver(param1:MouseEvent) : void
      {
         if(openButton)
         {
            openButton.scaleX = 1.06;
            openButton.scaleY = 1.06;
         }
      }
      
      private function onOpenOut(param1:MouseEvent) : void
      {
         if(openButton)
         {
            openButton.scaleX = 1;
            openButton.scaleY = 1;
         }
      }
      
      private function onOpenClick(param1:MouseEvent) : void
      {
         GameWorld.openUrl(DISCORD_URL);
         remove();
      }
      
      private function onCloseClick(param1:MouseEvent) : void
      {
         remove();
      }
   }
}
