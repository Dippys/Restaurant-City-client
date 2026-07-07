package com.playfish.games.cooking.ui.mail
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.*;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class NewspaperMail extends WorldPopUp
   {
      
      private var mailClient:WorldMail;
      
      private var mailItem:MailItem;
      
      private var scene:MovieClip;
      
      public function NewspaperMail(param1:MailItem, param2:WorldMail)
      {
         var _loc5_:Loader = null;
         super(null,null,null);
         this.mailClient = param2;
         this.mailItem = param1;
         scene = Engine.getMovieClip("NewsletterMessageAnim2");
         addChild(scene);
         var _loc3_:MovieClip = scene.mc_content;
         _loc3_.tf_date.text = param1.mailObject.sendDate.toDateString();
         var _loc4_:int = 0;
         while(_loc4_ < 3)
         {
            _loc5_ = new Loader();
            _loc5_.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaderComplete,false,0,true);
            _loc5_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoaderError,false,0,true);
            _loc5_.load(new URLRequest(Engine.instance.resHandler.getResUrl("news" + _loc4_)));
            _loc3_["mc_news" + _loc4_].addChild(_loc5_);
            _loc4_++;
         }
         setButtonMode(_loc3_.mc_tick,true);
         _loc3_.mc_tick.addEventListener(MouseEvent.CLICK,onTickClick,false,0,true);
      }
      
      override public function show() : void
      {
         super.show();
         scene.gotoAndPlay("in");
         if(!mailItem.mailObject.read)
         {
            mailItem.mailObject.read = true;
            GameWorld.newsletterHandler.setRead(mailItem.newsletterId,GameWorld.gameUser);
         }
      }
      
      private function onLoaderComplete(param1:Event) : void
      {
         var _loc2_:Loader = Loader(param1.currentTarget.loader);
         _loc2_.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoaderComplete);
         _loc2_.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoaderError);
         _loc2_.width = _loc2_.parent.width;
         _loc2_.height = _loc2_.parent.height;
         _loc2_.x = -_loc2_.width / 2;
         _loc2_.y = -_loc2_.height / 2;
      }
      
      private function onLoaderError(param1:IOErrorEvent) : void
      {
         var _loc2_:Loader = Loader(param1.currentTarget.loader);
         Debug.out("NewspaperMail image load failed: " + param1.text);
         _loc2_.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoaderComplete);
         _loc2_.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoaderError);
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

