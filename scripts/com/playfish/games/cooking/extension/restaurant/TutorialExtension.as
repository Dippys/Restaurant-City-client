package com.playfish.games.cooking.extension.restaurant
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.tutorials.*;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   
   public class TutorialExtension extends RestaurantExtensionBase
   {
      
      private var firstTimeStreetAccess:Boolean = false;
      
      private var happyCustomerStep:int = -1;
      
      private var restaurant:WorldRestaurantPlay;
      
      public function TutorialExtension(param1:WorldRestaurantPlay)
      {
         super();
         this.restaurant = param1;
         if(GameWorld.gameUser.awards.getValue(GameAwards.AWARD_HAPPY_CUSTOMERS) < 1)
         {
            happyCustomerStep = 0;
         }
         firstTimeStreetAccess = GameWorld.gameUser.settings.getValue(GameSettings.TYPE_STREET_TUTORIAL_STEP) == 0;
      }
      
      override public function destroy() : void
      {
      }
      
      override public function tick(param1:uint) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:MovieClip = null;
         if(happyCustomerStep != -1)
         {
            if(happyCustomerStep == 0)
            {
               if(GameWorld.gameUser.awards.getValue(GameAwards.AWARD_HAPPY_CUSTOMERS) >= 1)
               {
                  GameWorld.showTutorialTextPopUp(GameWorld.textHandler.getTextFromId("TutorialHappyCustomers"));
                  happyCustomerStep = -1;
               }
            }
         }
         if(firstTimeStreetAccess)
         {
            if(GameWorld.gameUser.awards.getValue(GameAwards.AWARD_HAPPY_CUSTOMERS) >= 1)
            {
               _loc2_ = restaurant.buttonStreet.getBounds(null);
               _loc3_ = Engine.getMovieClip("TutArrowAnim");
               _loc3_.y = _loc2_.top;
               restaurant.buttonStreet.addChild(_loc3_);
               restaurant.buttonStreet.glowEffect = new GlowEffect(restaurant.buttonStreet);
               firstTimeStreetAccess = false;
            }
         }
      }
   }
}

