package away3d.containers
{
   import away3d.arcane;
   import away3d.blockers.*;
   import away3d.cameras.*;
   import away3d.core.base.*;
   import away3d.core.block.*;
   import away3d.core.clip.*;
   import away3d.core.draw.*;
   import away3d.core.math.*;
   import away3d.core.project.*;
   import away3d.core.render.*;
   import away3d.core.stats.*;
   import away3d.core.traverse.*;
   import away3d.core.utils.*;
   import away3d.events.*;
   import away3d.materials.*;
   import away3d.overlays.IOverlay;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class View3D extends Sprite
   {
      
      private var _x:Number;
      
      private var _internalsession:AbstractRenderSession;
      
      private var _container:DisplayObject;
      
      private var _stageHeight:Number;
      
      private var _stageWidth:Number;
      
      private var _renderComplete:ViewEvent;
      
      arcane var _movieClipSpriteProjector:MovieClipSpriteProjector = new MovieClipSpriteProjector();
      
      public var mouseEvents:Boolean;
      
      private var _clipping:Clipping;
      
      private var _renderer:IRenderer;
      
      private var _ini:Init;
      
      private var material:IUVMaterial;
      
      private var _mouseIsOverView:Boolean;
      
      public var background:Sprite = new Sprite();
      
      private var _ddo:DrawDisplayObject = new DrawDisplayObject();
      
      private var _cameraVarsStore:CameraVarsStore = new CameraVarsStore();
      
      arcane var _spriteProjector:SpriteProjector = new SpriteProjector();
      
      arcane var _objectContainerProjector:ObjectContainerProjector = new ObjectContainerProjector();
      
      private var persp:Number;
      
      private var _drawPrimitiveStore:DrawPrimitiveStore = new DrawPrimitiveStore();
      
      private var object:Object3D;
      
      private var _camera:Camera3D;
      
      private var _mousedown:Boolean;
      
      private var _viewZero:Point = new Point();
      
      private var sceneY:Number;
      
      arcane var _meshProjector:MeshProjector = new MeshProjector();
      
      private var sceneX:Number;
      
      public var sourceURL:String;
      
      arcane var _convexBlockProjector:ConvexBlockProjector = new ConvexBlockProjector();
      
      private var _session:AbstractRenderSession;
      
      private var _pritraverser:PrimitiveTraverser = new PrimitiveTraverser();
      
      arcane var _dofSpriteProjector:DofSpriteProjector = new DofSpriteProjector();
      
      private var _consumer:IPrimitiveConsumer;
      
      private var sceneZ:Number;
      
      public var mouseZeroMove:Boolean;
      
      public var overlay:Sprite = new Sprite();
      
      private var _screenClippingDirty:Boolean;
      
      public var mouseObject:Object3D;
      
      private var screenX:Number;
      
      private var screenY:Number;
      
      private var screenZ:Number = Infinity;
      
      arcane var _screenClipping:Clipping;
      
      private var _updated:Boolean;
      
      private var _overlays:Dictionary = new Dictionary();
      
      public var statsOpen:Boolean;
      
      private var _scene:Scene3D;
      
      public var forceUpdate:Boolean;
      
      private var uv:UV;
      
      private var _updatescene:ViewEvent;
      
      public var statsPanel:Stats;
      
      public var stats:Boolean;
      
      private var _loaderWidth:Number;
      
      private var _hitPointX:Number;
      
      private var _hitPointY:Number;
      
      private var _loaderDirty:Boolean;
      
      public var blockerarray:BlockerArray = new BlockerArray();
      
      arcane var _dirSpriteProjector:DirSpriteProjector = new DirSpriteProjector();
      
      public var blockers:Dictionary;
      
      private var drawpri:DrawPrimitive;
      
      private var _lastmove_mouseX:Number;
      
      private var _lastmove_mouseY:Number;
      
      arcane var _interactiveLayer:Sprite = new Sprite();
      
      private var inv:away3d.core.math.Matrix3D = new away3d.core.math.Matrix3D();
      
      public var mouseMaterial:IUVMaterial;
      
      public var hud:Sprite = new Sprite();
      
      private var _loaderHeight:Number;
      
      private var _y:Number;
      
      private var element:Object;
      
      public function View3D(param1:Object = null)
      {
         super();
         _ini = Init.parse(param1) as Init;
         var _loc2_:Boolean = _ini.getBoolean("stats",true);
         session = _ini.getObject("session") as AbstractRenderSession || new SpriteRenderSession();
         scene = _ini.getObjectOrInit("scene",Scene3D) as Scene3D || new Scene3D();
         camera = _ini.getObjectOrInit("camera",Camera3D) as Camera3D || new Camera3D({
            "x":0,
            "y":0,
            "z":-1000,
            "lookat":"center"
         });
         renderer = _ini.getObject("renderer") as IRenderer || new BasicRenderer();
         clipping = _ini.getObject("clipping",Clipping) as Clipping || new RectangleClipping();
         x = _ini.getNumber("x",0);
         y = _ini.getNumber("y",0);
         forceUpdate = _ini.getBoolean("forceUpdate",false);
         mouseZeroMove = _ini.getBoolean("mouseZeroMove",false);
         mouseEvents = _ini.getBoolean("mouseEvents",true);
         arcane::_interactiveLayer.blendMode = BlendMode.ALPHA;
         arcane::_convexBlockProjector.view = this;
         arcane::_dirSpriteProjector.view = this;
         arcane::_dofSpriteProjector.view = this;
         arcane::_meshProjector.view = this;
         arcane::_movieClipSpriteProjector.view = this;
         arcane::_objectContainerProjector.view = this;
         arcane::_spriteProjector.view = this;
         _drawPrimitiveStore.view = this;
         _cameraVarsStore.view = this;
         _pritraverser.view = this;
         addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
         addEventListener(MouseEvent.ROLL_OUT,onRollOut);
         addEventListener(MouseEvent.ROLL_OVER,onRollOver);
         if(_loc2_)
         {
            addEventListener(Event.ADDED_TO_STAGE,createStatsMenu);
         }
      }
      
      public function getMouseEvent(param1:String) : MouseEvent3D
      {
         var _loc2_:MouseEvent3D = new MouseEvent3D(param1);
         _loc2_.screenX = screenX;
         _loc2_.screenY = screenY;
         _loc2_.screenZ = screenZ;
         _loc2_.sceneX = sceneX;
         _loc2_.sceneY = sceneY;
         _loc2_.sceneZ = sceneZ;
         _loc2_.view = this;
         _loc2_.drawpri = drawpri;
         _loc2_.material = material;
         _loc2_.element = element;
         _loc2_.object = object;
         _loc2_.uv = uv;
         return _loc2_;
      }
      
      private function createStatsMenu(param1:Event) : void
      {
         statsPanel = new Stats(this,stage.frameRate);
         statsOpen = false;
         stage.addEventListener(Event.RESIZE,onStageResized);
      }
      
      arcane function dispatchMouseEvent(param1:MouseEvent3D) : void
      {
         if(!hasEventListener(param1.type))
         {
            return;
         }
         dispatchEvent(param1);
      }
      
      private function onScreenUpdated(param1:ClippingEvent) : void
      {
         _updated = true;
      }
      
      public function fireMouseEvent(param1:String, param2:Number, param3:Number, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc9_:int = 0;
         if(!mouseEvents)
         {
            return;
         }
         findHit(_internalsession,param2,param3);
         var _loc6_:MouseEvent3D = getMouseEvent(param1);
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         _loc6_.ctrlKey = param4;
         _loc6_.shiftKey = param5;
         if(param1 != MouseEvent3D.MOUSE_OUT && param1 != MouseEvent3D.MOUSE_OVER)
         {
            dispatchMouseEvent(_loc6_);
            bubbleMouseEvent(_loc6_);
         }
         if(mouseObject != object || mouseMaterial != material)
         {
            if(mouseObject != null)
            {
               _loc6_ = getMouseEvent(MouseEvent3D.MOUSE_OUT);
               _loc6_.object = mouseObject;
               _loc6_.material = mouseMaterial;
               _loc6_.ctrlKey = param4;
               _loc6_.shiftKey = param5;
               dispatchMouseEvent(_loc6_);
               _loc7_ = bubbleMouseEvent(_loc6_);
            }
            if(object != null)
            {
               _loc6_ = getMouseEvent(MouseEvent3D.MOUSE_OVER);
               _loc6_.ctrlKey = param4;
               _loc6_.shiftKey = param5;
               dispatchMouseEvent(_loc6_);
               _loc8_ = bubbleMouseEvent(_loc6_);
            }
            if(mouseObject != object)
            {
               _loc9_ = 0;
               while(Boolean(_loc7_[_loc9_]) && _loc7_[_loc9_] == _loc8_[_loc9_])
               {
                  _loc9_++;
               }
               if(mouseObject != null)
               {
                  _loc6_ = getMouseEvent(MouseEvent3D.ROLL_OUT);
                  _loc6_.object = mouseObject;
                  _loc6_.material = mouseMaterial;
                  _loc6_.ctrlKey = param4;
                  _loc6_.shiftKey = param5;
                  traverseRollEvent(_loc6_,_loc7_.slice(_loc9_),false);
               }
               if(object != null)
               {
                  _loc6_ = getMouseEvent(MouseEvent3D.ROLL_OVER);
                  _loc6_.ctrlKey = param4;
                  _loc6_.shiftKey = param5;
                  traverseRollEvent(_loc6_,_loc8_.slice(_loc9_),true);
               }
            }
            mouseObject = object;
            mouseMaterial = material;
         }
      }
      
      public function removeOnMouseOut(param1:Function) : void
      {
         removeEventListener(MouseEvent3D.MOUSE_OUT,param1,false);
      }
      
      public function set scene(param1:Scene3D) : void
      {
         if(_scene == param1)
         {
            return;
         }
         if(_scene)
         {
            _scene.internalRemoveView(this);
            delete _scene.viewDictionary[this];
            _scene.removeOnSessionChange(onSessionChange);
            if(_session)
            {
               _session.internalRemoveSceneSession(_scene.ownSession);
            }
         }
         _scene = param1;
         _updated = true;
         if(_scene)
         {
            _scene.internalAddView(this);
            _scene.addOnSessionChange(onSessionChange);
            _scene.viewDictionary[this] = this;
            if(_session)
            {
               _session.internalAddSceneSession(_scene.ownSession);
            }
            return;
         }
         throw new Error("View cannot have scene set to null");
      }
      
      public function removeOnMouseUp(param1:Function) : void
      {
         removeEventListener(MouseEvent3D.MOUSE_UP,param1,false);
      }
      
      public function getContainer() : DisplayObject
      {
         return _session.getContainer(this);
      }
      
      public function addOnMouseOver(param1:Function) : void
      {
         addEventListener(MouseEvent3D.MOUSE_OVER,param1,false,0,false);
      }
      
      public function findHit(param1:AbstractRenderSession, param2:Number, param3:Number) : void
      {
         screenX = param2;
         screenY = param3;
         screenZ = Infinity;
         material = null;
         object = null;
         if(!param1 || !_mouseIsOverView)
         {
            return;
         }
         _hitPointX = stage.mouseX;
         _hitPointY = stage.mouseY;
         if(this.session is BitmapRenderSession)
         {
            _container = this.session.getContainer(this);
            _hitPointX += _container.x;
            _hitPointY += _container.y;
         }
         checkSession(param1);
      }
      
      public function set session(param1:AbstractRenderSession) : void
      {
         if(_session == param1)
         {
            return;
         }
         if(_session)
         {
            _session.removeOnSessionUpdate(onSessionUpdate);
            if(_scene)
            {
               _session.internalRemoveSceneSession(_scene.ownSession);
            }
         }
         _session = param1;
         _updated = true;
         if(_session)
         {
            _session.addOnSessionUpdate(onSessionUpdate);
            if(_scene)
            {
               _session.internalAddSceneSession(_scene.ownSession);
            }
            while(numChildren)
            {
               removeChildAt(0);
            }
            addChild(background);
            addChild(_session.getContainer(this));
            addChild(_interactiveLayer);
            addChild(overlay);
            addChild(hud);
            return;
         }
         throw new Error("View cannot have session set to null");
      }
      
      public function get camera() : Camera3D
      {
         return _camera;
      }
      
      private function onCameraUpdated(param1:CameraEvent) : void
      {
         _updated = true;
      }
      
      public function removeOverlay(param1:IOverlay) : void
      {
         if(_overlays[param1])
         {
            overlay.removeChild(param1 as Sprite);
            _overlays[param1] = null;
         }
      }
      
      public function fireMouseMoveEvent(param1:Boolean = false) : void
      {
         if(!_mouseIsOverView)
         {
            return;
         }
         if(!(mouseZeroMove || param1))
         {
            if(mouseX == _lastmove_mouseX && mouseY == _lastmove_mouseY)
            {
               return;
            }
         }
         fireMouseEvent(MouseEvent3D.MOUSE_MOVE,mouseX,mouseY);
         _lastmove_mouseX = mouseX;
         _lastmove_mouseY = mouseY;
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         _mousedown = false;
         fireMouseEvent(MouseEvent3D.MOUSE_UP,mouseX,mouseY,param1.ctrlKey,param1.shiftKey);
      }
      
      private function onSessionChange(param1:Object3DEvent) : void
      {
         _session.sessions = [param1.object.session];
      }
      
      public function set camera(param1:Camera3D) : void
      {
         if(_camera == param1)
         {
            return;
         }
         if(_camera)
         {
            _camera.removeOnSceneTransformChange(onCameraTransformChange);
            _camera.removeOnCameraUpdate(onCameraUpdated);
         }
         _camera = param1;
         _camera.view = this;
         _updated = true;
         if(_camera)
         {
            _camera.addOnSceneTransformChange(onCameraTransformChange);
            _camera.addOnCameraUpdate(onCameraUpdated);
            return;
         }
         throw new Error("View cannot have camera set to null");
      }
      
      private function onSessionUpdate(param1:SessionEvent) : void
      {
         if(param1.target is BitmapRenderSession)
         {
            _scene.updatedSessions[param1.target] = param1.target;
         }
      }
      
      public function addOverlay(param1:IOverlay) : void
      {
         if(_overlays[param1])
         {
            return;
         }
         _overlays[param1] = param1;
         overlay.addChild(param1 as Sprite);
      }
      
      private function notifySceneUpdate() : void
      {
         if(!_updatescene)
         {
            _updatescene = new ViewEvent(ViewEvent.UPDATE_SCENE,this);
         }
         dispatchEvent(_updatescene);
      }
      
      private function checkSession(param1:AbstractRenderSession) : void
      {
         var _loc2_:Array = null;
         var _loc3_:DrawPrimitive = null;
         var _loc4_:Array = null;
         if(param1.getContainer(this).hitTestPoint(_hitPointX,_hitPointY))
         {
            if(param1 is BitmapRenderSession)
            {
               _container = (param1 as BitmapRenderSession).getBitmapContainer(this);
               _hitPointX += _container.x;
               _hitPointY += _container.y;
            }
            _loc2_ = param1.getConsumer(this).list();
            for each(_loc3_ in _loc2_)
            {
               checkPrimitive(_loc3_);
            }
            _loc4_ = param1.sessions;
            for each(param1 in _loc4_)
            {
               checkSession(param1);
            }
            if(param1 is BitmapRenderSession)
            {
               _container = (param1 as BitmapRenderSession).getBitmapContainer(this);
               _hitPointX -= _container.x;
               _hitPointY -= _container.y;
            }
         }
      }
      
      public function getBitmapData() : BitmapData
      {
         if(_session is BitmapRenderSession)
         {
            return (_session as BitmapRenderSession).getBitmapData(this);
         }
         throw new Error("incorrect session object - require BitmapRenderSession");
      }
      
      public function get cameraVarsStore() : CameraVarsStore
      {
         return _cameraVarsStore;
      }
      
      public function addOnMouseDown(param1:Function) : void
      {
         addEventListener(MouseEvent3D.MOUSE_DOWN,param1,false,0,false);
      }
      
      public function set clipping(param1:Clipping) : void
      {
         if(_clipping == param1)
         {
            return;
         }
         if(_clipping)
         {
            _clipping.removeOnClippingUpdate(onClippingUpdated);
            _clipping.removeOnScreenUpdate(onScreenUpdated);
         }
         _clipping = param1;
         _clipping.view = this;
         if(_clipping)
         {
            _clipping.addOnClippingUpdate(onClippingUpdated);
            _clipping.addOnScreenUpdate(onScreenUpdated);
            _updated = true;
            _screenClippingDirty = true;
            return;
         }
         throw new Error("View cannot have clip set to null");
      }
      
      public function set renderer(param1:IRenderer) : void
      {
         if(_renderer == param1)
         {
            return;
         }
         _renderer = param1;
         _updated = true;
         if(!_renderer)
         {
            throw new Error("View cannot have renderer set to null");
         }
      }
      
      public function get screenClipping() : Clipping
      {
         if(_screenClippingDirty)
         {
            updateScreenClipping();
            _screenClippingDirty = false;
            return _screenClipping = _clipping.screen(this,_loaderWidth,_loaderHeight);
         }
         return _screenClipping;
      }
      
      public function get scene() : Scene3D
      {
         return _scene;
      }
      
      public function clear() : void
      {
         _updated = true;
         if(_internalsession)
         {
            _internalsession.clear(this);
         }
      }
      
      public function get session() : AbstractRenderSession
      {
         return _session;
      }
      
      public function updateScreenClipping() : void
      {
         try
         {
            _loaderWidth = loaderInfo.width;
            _loaderHeight = loaderInfo.height;
            if(_loaderDirty)
            {
               _loaderDirty = false;
               _screenClippingDirty = true;
            }
         }
         catch(error:Error)
         {
            _loaderDirty = true;
            _loaderWidth = stage.stageWidth;
            _loaderHeight = stage.stageHeight;
         }
         _viewZero.x = 0;
         _viewZero.y = 0;
         _viewZero = localToGlobal(_viewZero);
         if(_x != _viewZero.x || _y != _viewZero.y || stage.scaleMode != StageScaleMode.NO_SCALE && (_stageWidth != stage.stageWidth || _stageHeight != stage.stageHeight))
         {
            _x = _viewZero.x;
            _y = _viewZero.y;
            _stageWidth = stage.stageWidth;
            _stageHeight = stage.stageHeight;
            _screenClippingDirty = true;
         }
      }
      
      public function render() : void
      {
         var _loc1_:ConvexBlock = null;
         notifySceneUpdate();
         if(_internalsession != _session)
         {
            _internalsession = _session;
         }
         if(_session.renderer != _renderer as IPrimitiveConsumer)
         {
            _session.renderer = _renderer as IPrimitiveConsumer;
         }
         _session.clear(this);
         _drawPrimitiveStore.reset();
         if(_session.updated)
         {
            if(_scene.ownSession is SpriteRenderSession)
            {
               (_scene.ownSession as SpriteRenderSession).cacheAsBitmap = true;
            }
            _ddo.view = this;
            _ddo.displayobject = _scene.session.getContainer(this);
            _ddo.session = _session;
            _ddo.vx = 0;
            _ddo.vy = 0;
            _ddo.vz = 0;
            _ddo.calc();
            _consumer = _session.getConsumer(this);
            _consumer.primitive(_ddo);
         }
         for each(_loc1_ in blockers)
         {
            _convexBlockProjector.blockers(_loc1_,cameraVarsStore.viewTransformDictionary[_loc1_],blockerarray);
         }
         _scene.traverse(_pritraverser);
         _session.render(this);
         _updated = false;
         if(statsOpen)
         {
            statsPanel.updateStats(_session.getTotalFaces(this),camera);
         }
         Init.checkUnusedArguments();
         processOverlays();
         fireMouseMoveEvent();
         notifyRenderComplete();
      }
      
      public function get drawPrimitiveStore() : DrawPrimitiveStore
      {
         return _drawPrimitiveStore;
      }
      
      private function notifyRenderComplete() : void
      {
         if(!hasEventListener(ViewEvent.RENDER_COMPLETE))
         {
            return;
         }
         if(!_renderComplete)
         {
            _renderComplete = new ViewEvent(ViewEvent.RENDER_COMPLETE,this);
         }
         dispatchEvent(_renderComplete);
      }
      
      private function bubbleMouseEvent(param1:MouseEvent3D) : Array
      {
         var _loc2_:Object3D = param1.object;
         var _loc3_:Array = [];
         while(_loc2_ != null)
         {
            _loc3_.unshift(_loc2_);
            _loc2_.dispatchMouseEvent(param1);
            _loc2_ = _loc2_.parent;
         }
         return _loc3_;
      }
      
      public function removeOnMouseDown(param1:Function) : void
      {
         removeEventListener(MouseEvent3D.MOUSE_DOWN,param1,false);
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         _mouseIsOverView = false;
         fireMouseEvent(MouseEvent3D.MOUSE_OUT,mouseX,mouseY,param1.ctrlKey,param1.shiftKey);
      }
      
      public function addSourceURL(param1:String) : void
      {
         sourceURL = param1;
         if(statsPanel)
         {
            statsPanel.addSourceURL(param1);
         }
      }
      
      private function onCameraTransformChange(param1:Object3DEvent) : void
      {
         _updated = true;
      }
      
      private function processOverlays() : void
      {
         var _loc1_:IOverlay = null;
         for each(_loc1_ in _overlays)
         {
            _loc1_.update();
         }
      }
      
      private function onClippingUpdated(param1:ClippingEvent) : void
      {
         _screenClippingDirty = true;
      }
      
      public function get updated() : Boolean
      {
         return _updated;
      }
      
      private function checkPrimitive(param1:DrawPrimitive) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:DrawTriangle = null;
         var _loc4_:UV = null;
         var _loc5_:IUVMaterial = null;
         if(param1 is DrawFog)
         {
            return;
         }
         if(!param1.source || !param1.source._mouseEnabled)
         {
            return;
         }
         if(param1.minX > screenX)
         {
            return;
         }
         if(param1.maxX < screenX)
         {
            return;
         }
         if(param1.minY > screenY)
         {
            return;
         }
         if(param1.maxY < screenY)
         {
            return;
         }
         if(param1 is DrawDisplayObject && !(param1 as DrawDisplayObject).displayobject.hitTestPoint(_hitPointX,_hitPointY,true))
         {
            return;
         }
         if(param1.contains(screenX,screenY))
         {
            _loc2_ = param1.getZ(screenX,screenY);
            if(_loc2_ < screenZ)
            {
               if(param1 is DrawTriangle)
               {
                  _loc3_ = param1 as DrawTriangle;
                  _loc4_ = _loc3_.getUV(screenX,screenY);
                  if(_loc3_.material is IUVMaterial)
                  {
                     _loc5_ = _loc3_.material as IUVMaterial;
                     if(!(_loc3_.material is BitmapMaterialContainer) && !(_loc5_.getPixel32(_loc4_.u,_loc4_.v) >> 24))
                     {
                        return;
                     }
                     uv = _loc4_;
                  }
                  material = _loc5_;
               }
               else
               {
                  uv = null;
               }
               screenZ = _loc2_;
               persp = camera.zoom / (1 + screenZ / camera.focus);
               inv = camera.invViewMatrix;
               sceneX = screenX / persp * inv.sxx + screenY / persp * inv.sxy + screenZ * inv.sxz + inv.tx;
               sceneY = screenX / persp * inv.syx + screenY / persp * inv.syy + screenZ * inv.syz + inv.ty;
               sceneZ = screenX / persp * inv.szx + screenY / persp * inv.szy + screenZ * inv.szz + inv.tz;
               drawpri = param1;
               object = param1.source;
               element = null;
            }
         }
      }
      
      public function get clipping() : Clipping
      {
         return _clipping;
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         _mousedown = true;
         fireMouseEvent(MouseEvent3D.MOUSE_DOWN,mouseX,mouseY,param1.ctrlKey,param1.shiftKey);
      }
      
      private function traverseRollEvent(param1:MouseEvent3D, param2:Array, param3:Boolean) : void
      {
         var _loc4_:Object3D = null;
         for each(_loc4_ in param2)
         {
            _loc4_.dispatchMouseEvent(param1);
            if(param3)
            {
               buttonMode = buttonMode || _loc4_.useHandCursor;
            }
            else if(buttonMode && _loc4_.useHandCursor)
            {
               buttonMode = false;
            }
         }
      }
      
      public function addOnMouseUp(param1:Function) : void
      {
         addEventListener(MouseEvent3D.MOUSE_UP,param1,false,0,false);
      }
      
      public function addOnMouseMove(param1:Function) : void
      {
         addEventListener(MouseEvent3D.MOUSE_MOVE,param1,false,0,false);
      }
      
      private function onStageResized(param1:Event) : void
      {
         _screenClippingDirty = true;
      }
      
      public function get renderer() : IRenderer
      {
         return _renderer;
      }
      
      public function removeOnMouseMove(param1:Function) : void
      {
         removeEventListener(MouseEvent3D.MOUSE_MOVE,param1,false);
      }
      
      public function removeOnMouseOver(param1:Function) : void
      {
         removeEventListener(MouseEvent3D.MOUSE_OVER,param1,false);
      }
      
      public function addOnMouseOut(param1:Function) : void
      {
         addEventListener(MouseEvent3D.MOUSE_OUT,param1,false,0,false);
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         _mouseIsOverView = true;
         fireMouseEvent(MouseEvent3D.MOUSE_OVER,mouseX,mouseY,param1.ctrlKey,param1.shiftKey);
      }
   }
}

