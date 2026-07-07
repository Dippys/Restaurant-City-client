package com.playfish.games.cooking.ui.mail
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class WorldMailPlayfish extends WorldPopUp
   {
      
      private var mailClient:WorldMail;
      
      private var mailItem:MailItem;
      
      private var scene:MovieClip;
      
      public function WorldMailPlayfish(param1:MailItem, param2:WorldMail)
      {
         super(null,null,null);
         this.mailClient = param2;
         this.mailItem = param1;
         scene = Engine.getMovieClip("PlayfishMessageAnim");
         addChild(scene);
         var _loc3_:MovieClip = scene.mc_content;
         GameWorld.textHandler.setTextFieldWithId(_loc3_.tf_title,"FromPlayfish");
         GameWorld.textHandler.setTextField(_loc3_.tf_message,param1.mailObject.message.replace(/\\n/g,"\n"),true);
         _loc3_.tf_date.text = param1.mailObject.sendDate.toDateString();
         setButtonMode(_loc3_.mc_tick,true);
         _loc3_.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
      }
      
      override public function show() : void
      {
         super.show();
         scene.gotoAndPlay("in");
      }
      
      private function onTickClick(param1:MouseEvent) : void
      {
         remove();
         if(mailClient)
         {
            mailClient.refresh();
            mailClient.show();
         }
      }
   }
}

