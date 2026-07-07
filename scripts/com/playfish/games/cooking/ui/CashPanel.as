package com.playfish.games.cooking.ui
{
   import com.playfish.coretech.billing.*;
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.ui.bank.*;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.*;
   
   public class CashPanel extends BaseObject
   {
      
      private var coinsToolTip:ToolTip;
      
      private var playfishCashToolTip:ToolTip;
      
      private var scene:MovieClip;
      
      private var moneyTextField:TextField;
      
      private var playfishCashTextField:TextField;
      
      public function CashPanel()
      {
         super();
         scene = Engine.getMovieClip("CashAndAddCash");
         addChild(scene);
         moneyTextField = scene.mc_money.tf_money;
         moneyTextField.mouseEnabled = false;
         GameWorld.textHandler.setTextFieldWithId(scene.mc_addCash.mc_content.tf_text,"AddCoins");
         setButtonMode(scene.mc_addCash,true);
         scene.mc_addCash.addEventListener(MouseEvent.CLICK,onAddCoinsClick,false,0,true);
         scene.mc_addCash.mc_content.tf_text.mouseEnabled = false;
         playfishCashTextField = scene.mc_playfishCash.tf_money;
         playfishCashTextField.mouseEnabled = false;
         GameWorld.textHandler.setTextFieldWithId(scene.mc_addPlayfishCash.mc_content.tf_text,"AddPfCash");
         setButtonMode(scene.mc_addPlayfishCash,true);
         scene.mc_addPlayfishCash.addEventListener(MouseEvent.CLICK,onAddPlayfishCashClick,false,0,true);
         scene.mc_addPlayfishCash.mc_content.tf_text.mouseEnabled = false;
         scene.mc_playfishCash.addEventListener(MouseEvent.CLICK,onPlayfishCashClick,false,0,true);
         scene.mc_playfishCash.buttonMode = true;
         scene.mc_playfishCash.toolTip = new ToolTip(scene.mc_playfishCash,GameWorld.textHandler.getTextFromId("ToolTipPlayfishCash"));
         scene.mc_money.toolTip = new ToolTip(scene.mc_money,GameWorld.textHandler.getTextFromId("ToolTipCoins"));
         showAddCashButton();
         showAddPlayfishCashButton();
         Engine.instance.stage.addEventListener(Event.FULLSCREEN,onFullScreen,false,-1,true);
         refresh();
      }
      
      public function hideAddCoins() : void
      {
         scene.mc_addCash.visible = false;
      }
      
      public function showCoins() : void
      {
         showAddCoins();
         scene.mc_money.visible = true;
      }
      
      private function showNumberPopUp(param1:int, param2:Number, param3:Number) : void
      {
         var _loc4_:GameObject = null;
         var _loc5_:String = null;
         if(param1 > 0)
         {
            _loc4_ = new GameObject("CoinsAdded");
            _loc5_ = "+" + param1;
         }
         else
         {
            _loc4_ = new GameObject("CoinsSubtract");
            _loc5_ = param1.toString();
         }
         _loc4_.getChildMovieClipInstance("mc_content").tf_amount.text = _loc5_;
         _loc4_.drawPriority = 1000;
         _loc4_.numLoops = 1;
         _loc4_.removeWhenComplete = true;
         _loc4_.x = Engine.getStageX() + param2;
         _loc4_.y = Engine.getStageY() + param3;
         Engine.worldContainer.addObject(_loc4_);
      }
      
      private function onAddPlayfishCashClick(param1:MouseEvent) : void
      {
         showAddPlayfishCashPopUp();
      }
      
      public function showAddCashButton() : void
      {
         var _loc1_:Array = WorldBankPaymentProvider.getPaymentProviders(WorldBankPaymentProvider.PRODUCT_TYPE_COIN);
         if(_loc1_.length <= 0)
         {
            scene.mc_addCash.visible = false;
         }
         else
         {
            scene.mc_addCash.visible = true;
         }
      }
      
      private function onPlayfishCashClick(param1:MouseEvent) : void
      {
         var _loc2_:WorldWhatIsPlayFishCash = new WorldWhatIsPlayFishCash(false);
         _loc2_.show();
      }
      
      public function hideAddPlayfishCash() : void
      {
         scene.mc_addPlayfishCash.visible = false;
      }
      
      public function showPlayfishCashToolTip() : void
      {
         if(coinsToolTip)
         {
            coinsToolTip.remove();
         }
         if(!playfishCashToolTip)
         {
            playfishCashToolTip = new ToolTip(scene.mc_addPlayfishCash,GameWorld.textHandler.getTextFromId("NeedMorePlayfishCashToBuyThisItem"),false,false,false);
         }
         playfishCashToolTip.show(5000);
      }
      
      private function onAddCoinsClick(param1:MouseEvent) : void
      {
         showAddCoinsPopUp();
      }
      
      public function hidePlayfishCash() : void
      {
         hideAddPlayfishCash();
         scene.mc_playfishCash.visible = false;
      }
      
      public function refresh() : void
      {
         moneyTextField.text = GameWorld.gameUser.money.value.toString();
         playfishCashTextField.text = GameWorld.gameUser.playfishCash.value.toString();
      }
      
      public function showCoinsToolTip() : void
      {
         if(playfishCashToolTip)
         {
            playfishCashToolTip.remove();
         }
         if(!coinsToolTip)
         {
            coinsToolTip = new ToolTip(scene.mc_addCash,GameWorld.textHandler.getTextFromId("NeedMoreCoinsToBuyThisItem"),false,false,false);
         }
         coinsToolTip.show(5000);
      }
      
      public function hideCoins() : void
      {
         hideAddCoins();
         scene.mc_money.visible = false;
      }
      
      private function onFullScreen(param1:Event) : void
      {
         if(coinsToolTip)
         {
            coinsToolTip.refresh();
         }
         if(playfishCashToolTip)
         {
            playfishCashToolTip.refresh();
         }
      }
      
      public function addPlayfishCash(param1:int, param2:Boolean = true) : void
      {
         GameWorld.gameUser.playfishCash.value = Math.max(0,GameWorld.gameUser.playfishCash.value + param1);
         refresh();
         if(param1 != 0 && param2)
         {
            showPlayfishCashPopUp(param1);
         }
      }
      
      public function addCoins(param1:int, param2:Boolean = true) : void
      {
         GameWorld.gameUser.money.value = Math.max(0,GameWorld.gameUser.money.value + param1);
         refresh();
         if(param1 != 0 && param2)
         {
            showNumberPopUp(param1,scene.mc_money.x,scene.mc_money.y);
         }
      }
      
      public function showAddPlayfishCashPopUp() : void
      {
         var _loc1_:WorldBankPaymentProvider = new WorldBankPaymentProvider(WorldBankPaymentProvider.PRODUCT_TYPE_PLAYFISH_CASH);
         _loc1_.show();
      }
      
      public function showPlayfishCashPopUp(param1:int) : void
      {
         showNumberPopUp(param1,scene.mc_playfishCash.x,scene.mc_playfishCash.y);
      }
      
      public function showAddPlayfishCashButton() : void
      {
         var _loc1_:Array = WorldBankPaymentProvider.getPaymentProviders(WorldBankPaymentProvider.PRODUCT_TYPE_PLAYFISH_CASH);
         if(_loc1_.length <= 0)
         {
            scene.mc_addPlayfishCash.visible = false;
         }
         else
         {
            scene.mc_addPlayfishCash.visible = true;
         }
      }
      
      public function showPlayfishCash() : void
      {
         showAddPlayfishCashButton();
         scene.mc_playfishCash.visible = true;
      }
      
      public function showAddCoinsPopUp() : void
      {
         var _loc1_:WorldBankPaymentProvider = new WorldBankPaymentProvider(WorldBankPaymentProvider.PRODUCT_TYPE_COIN);
         _loc1_.show();
      }
      
      public function showAddCoins() : void
      {
         scene.mc_addCash.visible = true;
      }
   }
}

