package away3d.core.stats
{
   import away3d.cameras.*;
   import away3d.containers.*;
   import away3d.core.base.*;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.*;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.*;
   
   public class Stats extends Sprite
   {
      
      private var meshLabel:StaticTextField;
      
      private var bar:Sprite;
      
      private var barscale:int = 0;
      
      private var swfframerateLabel:StaticTextField;
      
      private var cambtn:Sprite;
      
      private const APPLICATION_NAME:String = "Away3D.com";
      
      private var geomDetailsLabel:TextField;
      
      public var displayMenu:Sprite = null;
      
      internal var type:String;
      
      private var defautTF:TextFormat = new TextFormat("Verdana",10,0);
      
      private var geomLastAdded:String;
      
      public var sourceURL:String;
      
      private var peakLabel:StaticTextField;
      
      private var totalElements:int = 0;
      
      private var faceRenderLabel:StaticTextField;
      
      private var meshes:int = 0;
      
      private var camLabel:TextField;
      
      private var closebtn:Sprite;
      
      internal var url:String;
      
      private var rectcam:Rectangle = new Rectangle(207,4,18,17);
      
      private var defautTFBold:TextFormat = new TextFormat("Verdana",10,0,true);
      
      private var ramLabel:StaticTextField;
      
      private var bestfps:int = 0;
      
      private var titleField:StaticTextField;
      
      private var fpsLabel:StaticTextField;
      
      private var stageframerate:Number;
      
      private var perfLabel:StaticTextField;
      
      private var barwidth:int = 0;
      
      private var rectclose:Rectangle = new Rectangle(228,4,18,17);
      
      private var faceLabel:StaticTextField;
      
      public var stats:String = "";
      
      private var geombtn:Sprite;
      
      internal var elementcount:int;
      
      private var lastrender:int;
      
      private var menu0:ContextMenuItem;
      
      private var menu1:ContextMenuItem;
      
      private var menu2:ContextMenuItem;
      
      private const VERSION:String = "2";
      
      public var geomMenu:Sprite = null;
      
      private var avfpsLabel:StaticTextField;
      
      private var refreshes:int = 0;
      
      private var camMenu:Sprite;
      
      private var camProp:Array;
      
      public var scopeMenu:View3D = null;
      
      private const REVISION:String = "4.0";
      
      private var rectclear:Rectangle = new Rectangle(186,4,18,17);
      
      private var rectdetails:Rectangle = new Rectangle(165,4,18,17);
      
      private var clearbtn:Sprite;
      
      private var lowestfps:int = 999;
      
      private var fpstotal:int = 0;
      
      private var displayState:int;
      
      public function Stats(param1:View3D, param2:Number = 0)
      {
         super();
         scopeMenu = param1;
         stageframerate = param2 ? param2 : 30;
         displayState = 0;
         sourceURL = param1.sourceURL;
         tabEnabled = false;
         menu0 = new ContextMenuItem("Away3D Project stats",true,true,true);
         menu1 = new ContextMenuItem("View Source",true,true,true);
         menu2 = new ContextMenuItem(APPLICATION_NAME + "\tv" + VERSION + "." + REVISION,true,true,true);
         var _loc3_:ContextMenu = new ContextMenu();
         _loc3_ = new ContextMenu();
         _loc3_.customItems = sourceURL ? [menu0,menu1,menu2] : [menu0,menu2];
         menu0.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,displayStats);
         menu1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,viewSource);
         menu2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,visitWebsite);
         _loc3_.hideBuiltInItems();
         scopeMenu.contextMenu = _loc3_;
      }
      
      private function mouseReleased(param1:MouseEvent) : void
      {
         displayMenu.stopDrag();
         scopeMenu.removeEventListener(MouseEvent.MOUSE_UP,mouseReleased);
      }
      
      private function createGeometryMenu() : void
      {
         geomMenu = new Sprite();
         var _loc1_:Matrix = new Matrix();
         _loc1_.rotate(90 * Math.PI / 180);
         geomMenu.graphics.beginGradientFill("linear",[3355494,13421772],[1,1],[0,255],_loc1_,"pad","rgb",0);
         geomMenu.graphics.drawRect(0,0,250,200);
         displayMenu.addChild(geomMenu);
         geomMenu.y = 26;
         geomDetailsLabel = new TextField();
         geomDetailsLabel.x = 3;
         geomDetailsLabel.y = 3;
         geomDetailsLabel.defaultTextFormat = defautTF;
         geomDetailsLabel.text = stats;
         geomDetailsLabel.height = 200;
         geomDetailsLabel.width = 235;
         geomDetailsLabel.multiline = true;
         geomDetailsLabel.selectable = true;
         geomDetailsLabel.wordWrap = true;
         geomMenu.addChild(geomDetailsLabel);
      }
      
      public function clearObjects() : void
      {
         stats = "";
         totalElements = 0;
         meshes = 0;
         geomLastAdded = "";
      }
      
      public function viewSource(param1:ContextMenuEvent) : void
      {
         var e:ContextMenuEvent = param1;
         var request:URLRequest = new URLRequest(sourceURL);
         try
         {
            navigateToURL(request,"_blank");
         }
         catch(error:Error)
         {
         }
      }
      
      private function showGeomInfo() : void
      {
         if(geomMenu == null)
         {
            createGeometryMenu();
         }
         else
         {
            displayMenu.addChild(geomMenu);
            geomMenu.y = 26;
         }
      }
      
      private function createCamMenu() : void
      {
         camMenu = new Sprite();
         var _loc1_:Matrix = new Matrix();
         _loc1_.rotate(90 * Math.PI / 180);
         camMenu.graphics.beginGradientFill("linear",[3355494,13421772],[1,1],[0,255],_loc1_,"pad","rgb",0);
         camMenu.graphics.drawRect(0,0,250,220);
         displayMenu.addChild(camMenu);
         camMenu.y = 26;
         camLabel = new TextField();
         camLabel.height = 210;
         camLabel.width = 170;
         camLabel.multiline = true;
         camLabel.selectable = false;
         var _loc2_:TextFormat = defautTF;
         _loc2_.leading = 1.5;
         camLabel.defaultTextFormat = _loc2_;
         camLabel.wordWrap = true;
         camMenu.addChild(camLabel);
         camLabel.x = 100;
         camLabel.y = 3;
         camProp = ["x","y","z","zoom","focus","distance","panangle","tiltangle","targetpanangle","targettiltangle","mintiltangle","maxtiltangle","steps","target"];
         var _loc3_:TextField = new TextField();
         _loc2_ = new TextFormat("Verdana",10,0,true);
         _loc2_.leading = 1.5;
         _loc2_.align = "right";
         _loc3_.defaultTextFormat = _loc2_;
         _loc3_.x = _loc3_.y = 3;
         _loc3_.multiline = true;
         _loc3_.selectable = false;
         _loc3_.autoSize = "left";
         _loc3_.height = 210;
         var _loc4_:int = int(camProp.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_.appendText(camProp[_loc5_] + ":\n");
            _loc5_++;
         }
         camMenu.addChild(_loc3_);
      }
      
      public function addObject(param1:Mesh) : void
      {
         type = param1.type;
         elementcount = param1.elements.length;
         url = param1.url;
         if(type != null && elementcount != 0)
         {
            stats += " - " + type + " , elements: " + elementcount + ", url: " + url + "\n";
            geomLastAdded = " - " + type + " , elements: " + elementcount + ", url: " + url + "\n";
            totalElements += elementcount;
            meshes += 1;
         }
         else
         {
            stats += " - " + type + " , url: " + url + "\n";
            geomLastAdded = " - " + type + " , url: " + url + "\n";
         }
      }
      
      public function updateStats(param1:int, param2:Camera3D) : void
      {
         var colorTransform:ColorTransform;
         var procent:int;
         var fps:int = 0;
         var average:int = 0;
         var w:int = 0;
         var caminfo:String = null;
         var _length:int = 0;
         var i:int = 0;
         var info:String = null;
         var renderedfaces:int = param1;
         var camera:Camera3D = param2;
         var now:int = getTimer();
         var perf:int = now - lastrender;
         lastrender = now;
         if(perf < 1000)
         {
            fps = int(1000 / (perf + 0.001));
            fpstotal += fps;
            ++refreshes;
            average = fpstotal / refreshes;
            bestfps = fps > bestfps ? fps : bestfps;
            lowestfps = fps < lowestfps ? fps : lowestfps;
            w = barscale * fps;
            bar.width = w <= barwidth ? w : barwidth;
         }
         procent = bar.width / barwidth * 100;
         colorTransform = bar.transform.colorTransform;
         colorTransform.color = 255 - 2.55 * procent << 16 | 2.55 * procent << 8 | 0x28;
         bar.transform.colorTransform = colorTransform;
         if(displayState == 0)
         {
            avfpsLabel.text = "" + average;
            ramLabel.text = "" + int(System.totalMemory / 1024 / 102.4) / 10 + "MB";
            peakLabel.text = lowestfps + "/" + bestfps;
            fpsLabel.text = "" + fps;
            perfLabel.text = "" + perf;
            faceLabel.text = "" + totalElements;
            faceRenderLabel.text = "" + renderedfaces;
            meshLabel.text = "" + meshes;
            swfframerateLabel.text = "" + stageframerate;
         }
         else if(displayState == 1)
         {
            caminfo = "";
            _length = int(camProp.length);
            i = 0;
            while(i < _length)
            {
               try
               {
                  if(i > 12)
                  {
                     caminfo += String(camera[camProp[i]]) + "\n";
                  }
                  else
                  {
                     info = String(camera[camProp[i]]);
                     caminfo += info.substring(0,19) + "\n";
                  }
               }
               catch(e:Error)
               {
                  caminfo += "\n";
               }
               i++;
            }
            camLabel.text = caminfo;
         }
         else if(displayState == 2)
         {
            geomDetailsLabel.text = stats;
         }
      }
      
      private function clearStats() : void
      {
         fpstotal = 0;
         refreshes = 0;
         bestfps = 0;
         lowestfps = 999;
      }
      
      private function showCamInfo() : void
      {
         if(camMenu == null)
         {
            createCamMenu();
         }
         else
         {
            displayMenu.addChild(camMenu);
            camMenu.y = 26;
         }
      }
      
      private function hideGeomInfo() : void
      {
         if(geomMenu != null)
         {
            displayMenu.removeChild(geomMenu);
         }
      }
      
      private function hideCamInfo() : void
      {
         if(camMenu != null)
         {
            displayMenu.removeChild(camMenu);
         }
      }
      
      private function closeOtherScreen(param1:int) : void
      {
         switch(param1)
         {
            case 1:
               hideCamInfo();
               break;
            case 2:
               hideGeomInfo();
         }
      }
      
      private function closeStats() : void
      {
         scopeMenu.statsOpen = false;
         displayState = 0;
         scopeMenu.removeEventListener(MouseEvent.MOUSE_DOWN,onCheckMouse);
         scopeMenu.removeEventListener(MouseEvent.MOUSE_MOVE,updateTips);
         scopeMenu.removeChild(displayMenu);
         displayMenu = null;
      }
      
      private function updateTips(param1:MouseEvent) : void
      {
         var x:Number = NaN;
         var y:Number = NaN;
         var pt:Point = null;
         var me:MouseEvent = param1;
         if(scopeMenu != null)
         {
            x = displayMenu.mouseX;
            y = displayMenu.mouseY;
            pt = new Point(x,y);
            try
            {
               if(rectcam.containsPoint(pt))
               {
                  titleField.text = "CAMERA INFO";
               }
               else if(rectclose.containsPoint(pt))
               {
                  titleField.text = "CLOSE STATS";
               }
               else if(rectclear.containsPoint(pt))
               {
                  titleField.text = "CLEAR AVERAGES";
               }
               else if(rectdetails.containsPoint(pt))
               {
                  titleField.text = "MESH INFO";
               }
               else
               {
                  titleField.text = "AWAY3D PROJECT";
               }
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function generateSprite() : void
      {
         displayMenu = new Sprite();
         var _loc1_:Matrix = new Matrix();
         _loc1_.rotate(90 * Math.PI / 180);
         displayMenu.graphics.beginGradientFill("linear",[3355494,13421772],[1,1],[0,255],_loc1_,"pad","rgb",0);
         displayMenu.graphics.drawRect(0,0,250,86);
         displayMenu.graphics.beginFill(3355494);
         displayMenu.graphics.drawRect(3,3,244,20);
         scopeMenu.addChild(displayMenu);
         displayMenu.x -= displayMenu.width * 0.5;
         displayMenu.y -= displayMenu.height * 0.5;
         closebtn = new Sprite();
         closebtn.graphics.beginFill(6710886);
         closebtn.graphics.drawRect(0,0,18,17);
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(13029592);
         _loc2_.graphics.drawRect(2,7,14,4);
         _loc2_.graphics.endFill();
         _loc2_.graphics.beginFill(13029592);
         _loc2_.graphics.drawRect(7,2,4,14);
         _loc2_.graphics.endFill();
         _loc2_.rotation = 45;
         _loc2_.x += 9;
         _loc2_.y -= 4;
         closebtn.addChild(_loc2_);
         displayMenu.addChild(closebtn);
         closebtn.x = 228;
         closebtn.y = 4;
         cambtn = new Sprite();
         var _loc3_:Graphics = cambtn.graphics;
         _loc3_.beginFill(6710886);
         _loc3_.drawRect(0,0,18,17);
         _loc3_.endFill();
         _loc3_.beginFill(13029592);
         _loc3_.moveTo(10,8);
         _loc3_.lineTo(16,4);
         _loc3_.lineTo(16,14);
         _loc3_.lineTo(10,10);
         _loc3_.lineTo(10,8);
         _loc3_.drawRect(2,6,8,6);
         _loc3_.endFill();
         displayMenu.addChild(cambtn);
         cambtn.x = 207;
         cambtn.y = 4;
         clearbtn = new Sprite();
         var _loc4_:Graphics = clearbtn.graphics;
         _loc4_.beginFill(6710886);
         _loc4_.drawRect(0,0,18,17);
         _loc4_.endFill();
         _loc4_.beginFill(13029592);
         _loc4_.drawRect(6,6,6,6);
         _loc4_.endFill();
         displayMenu.addChild(clearbtn);
         clearbtn.x = 186;
         clearbtn.y = 4;
         geombtn = new Sprite();
         var _loc5_:Graphics = geombtn.graphics;
         _loc5_.beginFill(6710886);
         _loc5_.drawRect(0,0,18,17);
         _loc5_.endFill();
         _loc5_.beginFill(13029592,0.7);
         _loc5_.moveTo(3,4);
         _loc5_.lineTo(11,2);
         _loc5_.lineTo(16,5);
         _loc5_.lineTo(7,7);
         _loc5_.lineTo(3,4);
         _loc5_.beginFill(8225929,0.8);
         _loc5_.moveTo(3,4);
         _loc5_.lineTo(7,7);
         _loc5_.lineTo(7,16);
         _loc5_.lineTo(3,12);
         _loc5_.lineTo(3,4);
         _loc5_.beginFill(13029592,1);
         _loc5_.moveTo(7,7);
         _loc5_.lineTo(16,5);
         _loc5_.lineTo(15,13);
         _loc5_.lineTo(7,16);
         _loc5_.lineTo(7,7);
         _loc5_.endFill();
         _loc5_.endFill();
         displayMenu.addChild(geombtn);
         geombtn.x = 165;
         geombtn.y = 4;
         displayMenu.graphics.beginGradientFill("linear",[0,16777215],[1,1],[0,255],new Matrix(),"pad","rgb",0);
         displayMenu.graphics.drawRect(3,22,244,4);
         displayMenu.graphics.endFill();
         bar = new Sprite();
         bar.graphics.beginFill(16777215);
         bar.graphics.drawRect(0,0,244,4);
         displayMenu.addChild(bar);
         bar.x = 3;
         bar.y = 22;
         barwidth = 244;
         barscale = int(barwidth / stageframerate);
         displayPicto();
         titleField = new StaticTextField("AWAY3D PROJECT",new TextFormat("Verdana",10,16777215,true));
         titleField.height = 20;
         titleField.width = 140;
         titleField.x = 22;
         titleField.y = 4;
         displayMenu.addChild(titleField);
         var _loc6_:StaticTextField = new StaticTextField("FPS:",defautTFBold);
         fpsLabel = new StaticTextField();
         displayMenu.addChild(_loc6_);
         displayMenu.addChild(fpsLabel);
         _loc6_.x = 3;
         _loc6_.y = fpsLabel.y = 30;
         fpsLabel.x = _loc6_.x + _loc6_.width - 2;
         var _loc7_:StaticTextField = new StaticTextField("AFPS:",defautTFBold);
         avfpsLabel = new StaticTextField();
         displayMenu.addChild(_loc7_);
         displayMenu.addChild(avfpsLabel);
         _loc7_.x = 52;
         _loc7_.y = avfpsLabel.y = fpsLabel.y;
         avfpsLabel.x = _loc7_.x + _loc7_.width - 2;
         var _loc8_:StaticTextField = new StaticTextField("Max:",defautTFBold);
         peakLabel = new StaticTextField();
         displayMenu.addChild(_loc8_);
         displayMenu.addChild(peakLabel);
         _loc8_.x = 107;
         _loc8_.y = peakLabel.y = avfpsLabel.y;
         _loc8_.autoSize = "left";
         peakLabel.x = _loc8_.x + _loc8_.width - 2;
         var _loc9_:StaticTextField = new StaticTextField("MS:",defautTFBold);
         perfLabel = new StaticTextField();
         perfLabel.defaultTextFormat = defautTF;
         displayMenu.addChild(_loc9_);
         displayMenu.addChild(perfLabel);
         _loc9_.x = 177;
         _loc9_.y = perfLabel.y = fpsLabel.y;
         _loc9_.autoSize = "left";
         perfLabel.x = _loc9_.x + _loc9_.width - 2;
         var _loc10_:StaticTextField = new StaticTextField("RAM:",defautTFBold);
         ramLabel = new StaticTextField();
         displayMenu.addChild(_loc10_);
         displayMenu.addChild(ramLabel);
         _loc10_.x = 3;
         _loc10_.y = ramLabel.y = 46;
         _loc10_.autoSize = "left";
         ramLabel.x = _loc10_.x + _loc10_.width - 2;
         var _loc11_:StaticTextField = new StaticTextField("MESHES:",defautTFBold);
         meshLabel = new StaticTextField();
         displayMenu.addChild(_loc11_);
         displayMenu.addChild(meshLabel);
         _loc11_.x = 90;
         _loc11_.y = meshLabel.y = ramLabel.y;
         _loc11_.autoSize = "left";
         meshLabel.x = _loc11_.x + _loc11_.width - 2;
         var _loc12_:StaticTextField = new StaticTextField("SWF FR:",defautTFBold);
         swfframerateLabel = new StaticTextField();
         displayMenu.addChild(_loc12_);
         displayMenu.addChild(swfframerateLabel);
         _loc12_.x = 170;
         _loc12_.y = swfframerateLabel.y = ramLabel.y;
         _loc12_.autoSize = "left";
         swfframerateLabel.x = _loc12_.x + _loc12_.width - 2;
         var _loc13_:StaticTextField = new StaticTextField("T ELEMENTS:",defautTFBold);
         faceLabel = new StaticTextField();
         displayMenu.addChild(_loc13_);
         displayMenu.addChild(faceLabel);
         _loc13_.x = 3;
         _loc13_.y = faceLabel.y = 62;
         _loc13_.autoSize = "left";
         faceLabel.x = _loc13_.x + _loc13_.width - 2;
         var _loc14_:StaticTextField = new StaticTextField("R ELEMENTS:",defautTFBold);
         faceRenderLabel = new StaticTextField();
         displayMenu.addChild(_loc14_);
         displayMenu.addChild(faceRenderLabel);
         _loc14_.x = 115;
         _loc14_.y = faceRenderLabel.y = faceLabel.y;
         _loc14_.autoSize = "left";
         faceRenderLabel.x = _loc14_.x + _loc14_.width - 2;
      }
      
      public function addSourceURL(param1:String) : void
      {
         sourceURL = param1;
         var _loc2_:ContextMenu = new ContextMenu();
         _loc2_.customItems = sourceURL ? [menu0,menu1,menu2] : [menu0,menu2];
         scopeMenu.contextMenu = _loc2_;
      }
      
      private function onCheckMouse(param1:MouseEvent) : void
      {
         var _loc2_:Number = displayMenu.mouseX;
         var _loc3_:Number = displayMenu.mouseY;
         var _loc4_:Point = new Point(_loc2_,_loc3_);
         if(rectcam.containsPoint(_loc4_))
         {
            if(displayState != 1)
            {
               closeOtherScreen(displayState);
               displayState = 1;
               showCamInfo();
            }
            else
            {
               displayState = 0;
               hideCamInfo();
            }
         }
         else if(rectdetails.containsPoint(_loc4_))
         {
            if(displayState != 2)
            {
               closeOtherScreen(displayState);
               displayState = 2;
               showGeomInfo();
            }
            else
            {
               displayState = 0;
               hideGeomInfo();
            }
         }
         else if(rectclose.containsPoint(_loc4_))
         {
            closeStats();
         }
         else if(rectclear.containsPoint(_loc4_))
         {
            clearStats();
         }
         else if(displayMenu.mouseY <= 20)
         {
            displayMenu.startDrag();
            scopeMenu.addEventListener(MouseEvent.MOUSE_UP,mouseReleased);
         }
      }
      
      private function addEventMouse() : void
      {
         scopeMenu.addEventListener(MouseEvent.MOUSE_DOWN,onCheckMouse);
         scopeMenu.addEventListener(MouseEvent.MOUSE_MOVE,updateTips);
      }
      
      public function visitWebsite(param1:ContextMenuEvent) : void
      {
         var e:ContextMenuEvent = param1;
         var url:String = "http://www.away3d.com";
         var request:URLRequest = new URLRequest(url);
         try
         {
            navigateToURL(request);
         }
         catch(error:Error)
         {
         }
      }
      
      private function displayPicto() : void
      {
         var _loc1_:Shape = new Logo();
         displayMenu.addChild(_loc1_);
         _loc1_.x = _loc1_.y = 4;
      }
      
      public function displayStats(param1:ContextMenuEvent = null) : void
      {
         if(!displayMenu)
         {
            scopeMenu.statsOpen = true;
            generateSprite();
            addEventMouse();
         }
      }
   }
}

