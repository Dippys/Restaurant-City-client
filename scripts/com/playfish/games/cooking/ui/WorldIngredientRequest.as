package com.playfish.games.cooking.ui
{
   import com.playfish.games.cooking.*;
   import com.playfish.games.cooking.events.ItemChooserEvent;
   import com.playfish.rpc.cooking.RpcClient;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.*;
   
   public class WorldIngredientRequest extends WorldPopUp
   {
      
      private static const NUM_INGREDIENTS:int = 1;
      
      private var toolTip:ToolTip;
      
      private var hasSelectedIngredients:Boolean;
      
      private var shareButton:MovieClip;
      
      private var sceneContent:MovieClip;
      
      private var selectedIngredientButtons:Array;
      
      private var ingredientItemChooser:IngredientItemChooser;
      
      public function WorldIngredientRequest()
      {
         var _loc5_:MovieClip = null;
         super(null,null,null);
         var _loc1_:MovieClip = Engine.getMovieClip("ShoutPopupAnim");
         addChild(_loc1_);
         sceneContent = _loc1_.mc_content;
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_title,"IngredientFeedPopUpTitle");
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_selectIngredients,"IngredientFeedSelectIngredients");
         GameWorld.textHandler.setTextFieldWithId(sceneContent.tf_addRequestText,"IngredientFeedAddRequestText");
         sceneContent.tf_message.addEventListener(Event.CHANGE,onTextFieldChanged,false,0,true);
         sceneContent.tf_message.text = "";
         Engine.setFocus(sceneContent.tf_message);
         var _loc2_:Array = new Array();
         var _loc3_:Array = GameWorld.ingredientItemDatabase.getItems("Ingredient");
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_.push(new IngredientItem(_loc3_[_loc4_]));
            _loc4_++;
         }
         _loc2_ = _loc2_.sortOn(["rarity","name"]);
         ingredientItemChooser = new IngredientItemChooser(_loc2_,sceneContent,false,false,false);
         ingredientItemChooser.addEventListener(ItemChooserEvent.EVENT_ITEM_MOUSE_DOWN,onIngredientClick);
         selectedIngredientButtons = new Array();
         _loc4_ = 0;
         while(_loc4_ < NUM_INGREDIENTS)
         {
            _loc5_ = sceneContent["mc_selectedItem" + _loc4_];
            _loc5_.stop();
            _loc5_.cancelButton = sceneContent["mc_cancel" + _loc4_];
            setButtonMode(_loc5_.cancelButton,true);
            _loc5_.cancelButton.index = _loc4_;
            _loc5_.cancelButton.addEventListener(MouseEvent.CLICK,onSelectedIngredientCancelClick,false,0,true);
            _loc5_.cancelButton.visible = false;
            WorldTradePanel.setupIngredientIcon(_loc5_,null);
            selectedIngredientButtons.push(_loc5_);
            _loc4_++;
         }
         setButtonMode(sceneContent.mc_cancel,true);
         setHandCursor(sceneContent.mc_cancel,true);
         sceneContent.mc_cancel.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         GameWorld.textHandler.setTextFieldWithId(sceneContent.mc_cancel.mc_content.tf_text,"ButtonCancelText");
         shareButton = sceneContent.mc_share;
         if(GameWorld.isUserInSplitTestingGroupA(GameWorld.gameUser))
         {
            GameWorld.textHandler.setTextFieldWithId(shareButton.mc_content.tf_text,"ButtonContinueText");
         }
         else
         {
            GameWorld.textHandler.setTextFieldWithId(shareButton.mc_content.tf_text,"ButtonShareText");
         }
         setButtonMode(shareButton,true);
         setHandCursor(shareButton,true);
         shareButton.addEventListener(MouseEvent.CLICK,onShareButtonClick,false,0,true);
         hasSelectedIngredients = false;
         toolTip = new ToolTip(shareButton,GameWorld.textHandler.getTextFromId("ToolTipCannotRequestIngredient"),false,false,false);
      }
      
      override public function remove() : void
      {
         super.remove();
         Engine.instance.stage.removeEventListener(Event.FULLSCREEN,onFullScreen);
         FullScreenTextFieldHandler.unlockTextFieldInFullScreenMode(sceneContent.tf_message);
      }
      
      private function setupIngredientIcon(param1:MovieClip, param2:Object) : void
      {
         WorldTradePanel.setupIngredientIcon(param1,param2);
         param1.mc_rarity.visible = false;
      }
      
      private function onTextFieldChanged(param1:Event) : void
      {
         var _loc2_:TextField = TextField(param1.currentTarget);
         if(_loc2_.scrollV > 1)
         {
            _loc2_.text = _loc2_.text.substring(0,_loc2_.text.length - 1);
            _loc2_.scrollV = 1;
         }
      }
      
      private function onFullScreen(param1:Event) : void
      {
         if(Engine.isFullScreen())
         {
            FullScreenTextFieldHandler.lockTextFieldInFullScreenMode(sceneContent.tf_message);
         }
         else
         {
            FullScreenTextFieldHandler.unlockTextFieldInFullScreenMode(sceneContent.tf_message);
         }
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         remove();
      }
      
      private function onSelectedIngredientCancelClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = selectedIngredientButtons[param1.currentTarget.index];
         setupIngredientIcon(_loc2_,null);
         _loc2_.cancelButton.visible = false;
         hasSelectedIngredients = false;
         var _loc3_:int = 0;
         while(_loc3_ < selectedIngredientButtons.length)
         {
            if(selectedIngredientButtons[_loc3_].itemConfig != null)
            {
               hasSelectedIngredients = true;
               break;
            }
            _loc3_++;
         }
      }
      
      private function onShareButtonClick(param1:MouseEvent) : void
      {
         var logParam:String;
         var i:int;
         var imageNames:Array;
         var e:MouseEvent = param1;
         if(!hasSelectedIngredients)
         {
            showToolTip();
            return;
         }
         imageNames = new Array();
         i = 0;
         while(i < selectedIngredientButtons.length)
         {
            if(selectedIngredientButtons[i].itemConfig != null)
            {
               imageNames.push(selectedIngredientButtons[i].itemConfig.id + ".png");
            }
            i++;
         }
         logParam = shareButton.mc_content.tf_text.text;
         GameWorld.rpcClient.recordGameEvent(RpcClient.GAME_EVENT_BUTTON_CLICK,logParam.toLocaleLowerCase(),function():void
         {
         },function():void
         {
         });
         Debug.out("Logging Button Click Event: " + logParam.toLocaleLowerCase());
         GameWorld.textHandler.setReplaceString("FeedFormGameLink",GameWorld.FEED_FORM_GAME_LINK);
         GameWorld.textHandler.setReplaceString("IngredientName",selectedIngredientButtons[0].itemConfig.name);
         GameWorld.textHandler.setReplaceString("PlayerName",GameWorld.gameUser.firstName);
         GameWorld.postFeed(GameWorld.textHandler.getTextFromId("IngredientStreamTitle"),GameWorld.textHandler.getTextFromId("IngredientStreamInformation"),GameWorld.textHandler.getTextFromId("IngredientStreamCaption"),GameWorld.textHandler.getTextFromId("IngredientStreamDescription"),GameWorld.textHandler.getTextFromId("IngredientStreamLinkText"),GameWorld.STREAM_FEED_GAME_LINK + "&" + GameWorld.textHandler.getTextFromId("IngredientStreamLinkRef"),GameWorld.textHandler.getTextFromId("IngredientStreamDashboardText"),sceneContent.tf_message.text," " + GameWorld.textHandler.getTextFromId("IngredientFeedTitle"),GameWorld.textHandler.getTextFromId("IngredientFeedBody"),GameWorld.textHandler.getTextFromId("FeedLinkText"),GameWorld.FEED_FORM_GAME_LINK,sceneContent.tf_message.text,imageNames);
      }
      
      private function onIngredientClick(param1:ItemChooserEvent) : void
      {
         setupIngredientIcon(selectedIngredientButtons[0],param1.itemConfig);
         selectedIngredientButtons[0].cancelButton.visible = true;
         hasSelectedIngredients = true;
      }
      
      override public function show() : void
      {
         super.show();
         Engine.instance.stage.addEventListener(Event.FULLSCREEN,onFullScreen,false,0,true);
         onFullScreen(null);
      }
      
      private function showToolTip() : void
      {
         if(toolTip)
         {
            toolTip.show(5000);
         }
      }
   }
}

