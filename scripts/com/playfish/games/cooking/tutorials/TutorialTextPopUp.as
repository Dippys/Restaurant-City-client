package com.playfish.games.cooking.tutorials
{
   import com.playfish.games.cooking.*;
   import flash.display.MovieClip;
   
   public class TutorialTextPopUp extends BaseObject
   {
      
      private var scene:MovieClip;
      
      public function TutorialTextPopUp(param1:String, param2:Number, param3:Number)
      {
         super();
         scene = Engine.getMovieClip("TutorialToolTip");
         GameWorld.textHandler.setTextField(scene.mc_content.tf_text,param1);
         scene.x = param2;
         scene.y = param3;
         addChild(scene);
         drawPriority = 100;
         Engine.worldContainer.addObject(this);
      }
      
      override public function tick(param1:uint) : void
      {
         if(scene.currentFrame >= scene.totalFrames)
         {
            remove();
         }
      }
      
      public function remove() : void
      {
         Engine.worldContainer.removeObject(this);
      }
      
      public function close() : void
      {
         scene.gotoAndPlay("out");
      }
   }
}

