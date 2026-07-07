package away3d.core.base
{
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.draw.*;
   import away3d.core.light.*;
   import away3d.core.math.*;
   import away3d.core.render.*;
   import away3d.core.traverse.*;
   import away3d.core.utils.*;
   import away3d.events.*;
   import away3d.loaders.utils.*;
   import away3d.primitives.*;
   import flash.display.*;
   import flash.events.EventDispatcher;
   
   use namespace arcane;
   
   public class Object3D extends EventDispatcher implements IClonable
   {
      
      private static var toDEGREES:Number = 180 / Math.PI;
      
      private static var toRADIANS:Number = Math.PI / 180;
      
      arcane var _boundingScale:Number = 1;
      
      protected var _pivotPoint:Number3D = new Number3D();
      
      public var extra:Object;
      
      arcane var _objectDirty:Boolean;
      
      private var _blendMode:String;
      
      public var projectorType:String;
      
      private var _renderer:IPrimitiveConsumer;
      
      private var _oldscene:Scene3D;
      
      private var _transformchanged:Object3DEvent;
      
      private var _dispatchedDimensionsChange:Boolean;
      
      private var _zAxis:Number3D = new Number3D();
      
      arcane var _maxX:Number = 0;
      
      arcane var _maxY:Number = 0;
      
      arcane var _maxZ:Number = 0;
      
      arcane var _sceneTransform:Matrix3D = new Matrix3D();
      
      public var screenYOffset:Number;
      
      private var _vector:Number3D = new Number3D();
      
      public var center:Array = [new Vertex()];
      
      private var _alpha:Number;
      
      private var _scenechanged:Object3DEvent;
      
      private var _pivotZero:Boolean;
      
      public var animationLibrary:AnimationLibrary;
      
      public var name:String;
      
      private var _lightarray:ILightConsumer;
      
      arcane var _sceneTransformDirty:Boolean;
      
      private var _yAxis:Number3D = new Number3D();
      
      private var _filters:Array;
      
      private var _quaternion:Quaternion = new Quaternion();
      
      arcane var _mouseEnabled:Boolean = true;
      
      arcane var _sessionDirty:Boolean;
      
      private var _parentupdated:Object3DEvent;
      
      public var mouseEnabled:Boolean = true;
      
      private var _rotationDirty:Boolean;
      
      private var _ownCanvas:Boolean;
      
      public var pushback:Boolean;
      
      private var _debugBoundingSphere:WireSphere;
      
      private var _rot:Number3D = new Number3D();
      
      arcane var _rotationX:Number = 0;
      
      arcane var _rotationY:Number = 0;
      
      arcane var _rotationZ:Number = 0;
      
      arcane var _minX:Number = 0;
      
      arcane var _minY:Number = 0;
      
      arcane var _minZ:Number = 0;
      
      public var screenXOffset:Number;
      
      private var _visible:Boolean;
      
      private var _xAxis:Number3D = new Number3D();
      
      private var _eulers:Number3D = new Number3D();
      
      public var pushfront:Boolean;
      
      arcane var _localTransformDirty:Boolean;
      
      private var _scenetransformchanged:Object3DEvent;
      
      arcane var _session:AbstractRenderSession;
      
      private var _sca:Number3D = new Number3D();
      
      arcane var _lookingAtTarget:Number3D = new Number3D();
      
      arcane var _scaleX:Number = 1;
      
      arcane var _scaleY:Number = 1;
      
      arcane var _scaleZ:Number = 1;
      
      arcane var _boundingRadius:Number = 0;
      
      private var _sessionchanged:Object3DEvent;
      
      private var _sessionupdated:Object3DEvent;
      
      arcane var _scene:Scene3D;
      
      private var _debugBoundingBox:WireCube;
      
      public var materialLibrary:MaterialLibrary;
      
      public var inverseSceneTransform:Matrix3D = new Matrix3D();
      
      public var useHandCursor:Boolean = false;
      
      public var screenZOffset:Number;
      
      arcane var _id:int;
      
      arcane var _dimensionsDirty:Boolean = false;
      
      private var _dimensionschanged:Object3DEvent;
      
      private var _parent:ObjectContainer3D;
      
      private var _ownLights:Boolean;
      
      private var _ownSession:AbstractRenderSession;
      
      public var debugbb:Boolean;
      
      private var _scenePivotPoint:Number3D = new Number3D();
      
      protected var ini:Init;
      
      arcane var _transformDirty:Boolean;
      
      public var geometryLibrary:GeometryLibrary;
      
      public var debugbs:Boolean;
      
      arcane var _transform:Matrix3D = new Matrix3D();
      
      private var _m:Matrix3D = new Matrix3D();
      
      private var _lightsDirty:Boolean;
      
      public function Object3D(param1:Object = null)
      {
         super();
         ini = Init.parse(param1);
         name = ini.getString("name",name);
         ownSession = ini.getObject("ownSession",AbstractRenderSession) as AbstractRenderSession;
         ownCanvas = ini.getBoolean("ownCanvas",ownCanvas);
         ownLights = ini.getBoolean("ownLights",false);
         visible = ini.getBoolean("visible",true);
         mouseEnabled = ini.getBoolean("mouseEnabled",mouseEnabled);
         useHandCursor = ini.getBoolean("useHandCursor",useHandCursor);
         renderer = ini.getObject("renderer",IPrimitiveConsumer) as IPrimitiveConsumer;
         filters = ini.getArray("filters");
         alpha = ini.getNumber("alpha",1);
         blendMode = ini.getString("blendMode",BlendMode.NORMAL);
         debugbb = ini.getBoolean("debugbb",false);
         debugbs = ini.getBoolean("debugbs",false);
         pushback = ini.getBoolean("pushback",false);
         pushfront = ini.getBoolean("pushfront",false);
         screenXOffset = ini.getNumber("screenXOffset",0);
         screenYOffset = ini.getNumber("screenYOffset",0);
         screenZOffset = ini.getNumber("screenZOffset",0);
         x = ini.getNumber("x",0);
         y = ini.getNumber("y",0);
         z = ini.getNumber("z",0);
         rotationX = ini.getNumber("rotationX",0);
         rotationY = ini.getNumber("rotationY",0);
         rotationZ = ini.getNumber("rotationZ",0);
         pivotPoint = ini.getNumber3D("pivotPoint") || new Number3D();
         extra = ini.getObject("extra");
         scale(ini.getNumber("scale",1));
         if(this is Scene3D)
         {
            arcane::_scene = this as Scene3D;
         }
         else
         {
            parent = ini.getObject3D("parent") as ObjectContainer3D;
         }
      }
      
      public function get pivotZero() : Boolean
      {
         return _pivotZero;
      }
      
      public function moveDown(param1:Number) : void
      {
         translate(Number3D.DOWN,param1);
      }
      
      public function get scenePivotPoint() : Number3D
      {
         if(_sceneTransformDirty)
         {
            updateSceneTransform();
         }
         return _scenePivotPoint;
      }
      
      public function get eulers() : Number3D
      {
         if(_rotationDirty)
         {
            updateRotation();
         }
         _eulers.x = _rotationX * toDEGREES;
         _eulers.y = _rotationY * toDEGREES;
         _eulers.z = _rotationZ * toDEGREES;
         return _eulers;
      }
      
      private function onParentSceneChange(param1:Object3DEvent) : void
      {
         if(_scene)
         {
            _scene.clearId(_id);
         }
         _scene = _parent.scene;
         if(_scene)
         {
            _scene.setId(this);
         }
         notifySceneChange();
      }
      
      arcane function notifySessionUpdate() : void
      {
         if(_scene)
         {
            _scene.updatedSessions[_session] = _session;
         }
         if(!hasEventListener(Object3DEvent.SESSION_UPDATED))
         {
            return;
         }
         if(!_sessionupdated)
         {
            _sessionupdated = new Object3DEvent(Object3DEvent.SESSION_UPDATED,this);
         }
         dispatchEvent(_sessionupdated);
      }
      
      public function get ownSession() : AbstractRenderSession
      {
         return _ownSession;
      }
      
      public function removeOnTransformChange(param1:Function) : void
      {
         removeEventListener(Object3DEvent.TRANSFORM_CHANGED,param1,false);
      }
      
      public function moveTo(param1:Number, param2:Number, param3:Number) : void
      {
         if(_transform.tx == param1 && _transform.ty == param2 && _transform.tz == param3)
         {
            return;
         }
         _transform.tx = param1;
         _transform.ty = param2;
         _transform.tz = param3;
         _localTransformDirty = true;
         _sceneTransformDirty = true;
      }
      
      public function get sceneTransform() : Matrix3D
      {
         if(_scene == null || _scene == this)
         {
            if(_transformDirty)
            {
               _sceneTransformDirty = true;
            }
            if(_sceneTransformDirty)
            {
               notifySceneTransformChange();
            }
            return transform;
         }
         if(_transformDirty)
         {
            updateTransform();
         }
         if(_sceneTransformDirty)
         {
            updateSceneTransform();
         }
         if(_localTransformDirty)
         {
            notifyTransformChange();
         }
         return _sceneTransform;
      }
      
      private function updateLights() : void
      {
         if(!_ownLights)
         {
            _lightarray = parent.lightarray;
         }
         else
         {
            _lightarray = new LightArray();
         }
         _lightsDirty = false;
      }
      
      public function get minY() : Number
      {
         if(_dimensionsDirty)
         {
            updateDimensions();
         }
         return _minY;
      }
      
      public function removeOnSceneTransformChange(param1:Function) : void
      {
         removeEventListener(Object3DEvent.SCENETRANSFORM_CHANGED,param1,false);
      }
      
      public function get minX() : Number
      {
         if(_dimensionsDirty)
         {
            updateDimensions();
         }
         return _minX;
      }
      
      public function get minZ() : Number
      {
         if(_dimensionsDirty)
         {
            updateDimensions();
         }
         return _minZ;
      }
      
      public function get scaleZ() : Number
      {
         return _scaleZ;
      }
      
      public function set position(param1:Number3D) : void
      {
         _transform.tx = param1.x;
         _transform.ty = param1.y;
         _transform.tz = param1.z;
         _sceneTransformDirty = true;
         _localTransformDirty = true;
      }
      
      public function get scaleY() : Number
      {
         return _scaleY;
      }
      
      arcane function notifySceneChange() : void
      {
         _sceneTransformDirty = true;
         if(!hasEventListener(Object3DEvent.SCENE_CHANGED))
         {
            return;
         }
         if(!_scenechanged)
         {
            _scenechanged = new Object3DEvent(Object3DEvent.SCENE_CHANGED,this);
         }
         dispatchEvent(_scenechanged);
      }
      
      public function set eulers(param1:Number3D) : void
      {
         _rotationX = param1.x * toRADIANS;
         _rotationY = param1.y * toRADIANS;
         _rotationZ = param1.z * toRADIANS;
         _transformDirty = true;
      }
      
      public function get scaleX() : Number
      {
         return _scaleX;
      }
      
      public function set ownSession(param1:AbstractRenderSession) : void
      {
         if(_ownSession == param1)
         {
            return;
         }
         if(_ownSession)
         {
            if(Boolean(_parent) && Boolean(_parent.session))
            {
               _parent.session.removeChildSession(_ownSession);
            }
            _ownSession.clearChildSessions();
            _ownSession.renderer = null;
            _ownSession.internalRemoveOwnSession(this);
            _ownSession.removeOnSessionUpdate(onSessionUpdate);
         }
         else if(Boolean(_parent) && Boolean(_parent.session))
         {
            _parent.session.internalRemoveOwnSession(this);
         }
         _ownSession = param1;
         if(_ownSession)
         {
            if(Boolean(_parent) && Boolean(_parent.session))
            {
               _parent.session.addChildSession(_ownSession);
            }
            _ownSession.clearChildSessions();
            _ownSession.renderer = _renderer;
            _ownSession.filters = _filters;
            _ownSession.alpha = _alpha;
            _ownSession.blendMode = _blendMode;
            _ownSession.internalAddOwnSession(this);
            _ownSession.addOnSessionUpdate(onSessionUpdate);
         }
         else
         {
            if(this is Scene3D)
            {
               throw new Error("Scene cannot have ownSession set to null");
            }
            if(Boolean(_parent) && Boolean(_parent.session))
            {
               _parent.session.internalAddOwnSession(this);
            }
         }
         if(_ownSession)
         {
            _ownCanvas = true;
         }
         else
         {
            _ownCanvas = false;
         }
         notifySessionChange();
      }
      
      override public function toString() : String
      {
         return (name ? name : "$") + ": x:" + Math.round(x) + " y:" + Math.round(y) + " z:" + Math.round(z);
      }
      
      public function get pivotPoint() : Number3D
      {
         return _pivotPoint;
      }
      
      public function yaw(param1:Number) : void
      {
         rotate(Number3D.UP,param1);
      }
      
      public function get visible() : Boolean
      {
         return _visible;
      }
      
      public function addOnDimensionsChange(param1:Function) : void
      {
         addEventListener(Object3DEvent.DIMENSIONS_CHANGED,param1,false,0,true);
      }
      
      public function addOnMouseDown(param1:Function) : void
      {
         addEventListener(MouseEvent3D.MOUSE_DOWN,param1,false,0,false);
      }
      
      public function get y() : Number
      {
         return _transform.ty;
      }
      
      public function get z() : Number
      {
         return _transform.tz;
      }
      
      public function roll(param1:Number) : void
      {
         rotate(Number3D.FORWARD,param1);
      }
      
      public function get ownCanvas() : Boolean
      {
         return _ownCanvas;
      }
      
      public function get x() : Number
      {
         return _transform.tx;
      }
      
      public function moveUp(param1:Number) : void
      {
         translate(Number3D.UP,param1);
      }
      
      public function set ownLights(param1:Boolean) : void
      {
         _ownLights = param1;
         _lightsDirty = true;
      }
      
      public function get scene() : Scene3D
      {
         return _scene;
      }
      
      public function removeOnRollOut(param1:Function) : void
      {
         removeEventListener(MouseEvent3D.ROLL_OUT,param1,false);
      }
      
      public function addOnSceneTransformChange(param1:Function) : void
      {
         addEventListener(Object3DEvent.SCENETRANSFORM_CHANGED,param1,false,0,true);
      }
      
      public function addOnParentUpdate(param1:Function) : void
      {
         addEventListener(Object3DEvent.PARENT_UPDATED,param1,false,0,true);
      }
      
      public function get session() : AbstractRenderSession
      {
         return _session;
      }
      
      public function addOnMouseOver(param1:Function) : void
      {
         addEventListener(MouseEvent3D.MOUSE_OVER,param1,false,0,false);
      }
      
      public function get rotationY() : Number
      {
         if(_rotationDirty)
         {
            updateRotation();
         }
         return _rotationY * toDEGREES;
      }
      
      public function get rotationZ() : Number
      {
         if(_rotationDirty)
         {
            updateRotation();
         }
         return _rotationZ * toDEGREES;
      }
      
      public function get parentBoundingRadius() : Number
      {
         return boundingRadius * _boundingScale;
      }
      
      public function get rotationX() : Number
      {
         if(_rotationDirty)
         {
            updateRotation();
         }
         return _rotationX * toDEGREES;
      }
      
      protected function updateTransform() : void
      {
         if(_rotationDirty)
         {
            updateRotation();
         }
         _quaternion.euler2quaternion(_rotationY,_rotationZ,-_rotationX);
         _transform.quaternion2matrix(_quaternion);
         _transform.scale(_transform,_scaleX,_scaleY,_scaleZ);
         _transformDirty = false;
         _sceneTransformDirty = true;
         _localTransformDirty = true;
      }
      
      public function set scaleY(param1:Number) : void
      {
         if(_scaleY == param1)
         {
            return;
         }
         _scaleY = param1;
         _transformDirty = true;
         _dimensionsDirty = true;
      }
      
      public function set scaleZ(param1:Number) : void
      {
         if(_scaleZ == param1)
         {
            return;
         }
         _scaleZ = param1;
         _transformDirty = true;
         _dimensionsDirty = true;
      }
      
      public function set scaleX(param1:Number) : void
      {
         if(_scaleX == param1)
         {
            return;
         }
         _scaleX = param1;
         _transformDirty = true;
         _dimensionsDirty = true;
      }
      
      public function applyPosition(param1:Number, param2:Number, param3:Number) : void
      {
         throw new Error("Not implemented in Object3D - Use Mesh or ObjectContainer3D");
      }
      
      public function get renderer() : IPrimitiveConsumer
      {
         return _renderer;
      }
      
      public function get objectDepth() : Number
      {
         if(_dimensionsDirty)
         {
            updateDimensions();
         }
         return _maxZ - _minZ;
      }
      
      private function changeSession() : void
      {
         if(_ownSession)
         {
            _session = _ownSession;
         }
         else if(_parent)
         {
            _session = _parent.session;
         }
         else
         {
            _session = null;
         }
         _sessionDirty = true;
      }
      
      public function get parent() : ObjectContainer3D
      {
         return _parent;
      }
      
      public function removeOnMouseDown(param1:Function) : void
      {
         removeEventListener(MouseEvent3D.MOUSE_DOWN,param1,false);
      }
      
      public function set alpha(param1:Number) : void
      {
         if(_alpha == param1)
         {
            return;
         }
         _alpha = param1;
         if(_ownSession)
         {
            _ownSession.alpha = _alpha;
         }
      }
      
      public function removeOnMouseOver(param1:Function) : void
      {
         removeEventListener(MouseEvent3D.MOUSE_OVER,param1,false);
      }
      
      public function set transform(param1:Matrix3D) : void
      {
         if(_transform.compare(param1))
         {
            return;
         }
         _transform.clone(param1);
         _transformDirty = false;
         _rotationDirty = true;
         _sceneTransformDirty = true;
         _localTransformDirty = true;
         _sca.matrix2scale(_transform);
         if(_scaleX != _sca.x || _scaleY != _sca.y || _scaleZ != _sca.z)
         {
            _scaleX = _sca.x;
            _scaleY = _sca.y;
            _scaleZ = _sca.z;
            _dimensionsDirty = true;
         }
      }
      
      public function moveBackward(param1:Number) : void
      {
         translate(Number3D.BACKWARD,param1);
      }
      
      public function set visible(param1:Boolean) : void
      {
         if(_visible == param1)
         {
            return;
         }
         _visible = param1;
         _sessionDirty = true;
         notifyParentUpdate();
      }
      
      public function applyRotations() : void
      {
         throw new Error("Not implemented in Object3D - Use Mesh or ObjectContainer3D");
      }
      
      public function addOnMouseOut(param1:Function) : void
      {
         addEventListener(MouseEvent3D.MOUSE_OUT,param1,false,0,false);
      }
      
      public function set pivotPoint(param1:Number3D) : void
      {
         _pivotPoint.clone(param1);
         _pivotZero = !_pivotPoint.x && !_pivotPoint.y && !_pivotPoint.z;
         _sceneTransformDirty = true;
         _dimensionsDirty = true;
         notifyParentUpdate();
      }
      
      public function moveRight(param1:Number) : void
      {
         translate(Number3D.RIGHT,param1);
      }
      
      public function set x(param1:Number) : void
      {
         if(isNaN(param1))
         {
            throw new Error("isNaN(x)");
         }
         if(_transform.tx == param1)
         {
            return;
         }
         if(param1 == Infinity)
         {
            Debug.warning("x == Infinity");
         }
         if(param1 == -Infinity)
         {
            Debug.warning("x == -Infinity");
         }
         _transform.tx = param1;
         _sceneTransformDirty = true;
         _localTransformDirty = true;
      }
      
      public function movePivot(param1:Number, param2:Number, param3:Number) : void
      {
         _pivotPoint.x = param1;
         _pivotPoint.y = param2;
         _pivotPoint.z = param3;
         _pivotZero = !param1 && !param2 && !param3;
         _sceneTransformDirty = true;
         _dimensionsDirty = true;
         notifyParentUpdate();
      }
      
      public function set y(param1:Number) : void
      {
         if(isNaN(param1))
         {
            throw new Error("isNaN(y)");
         }
         if(_transform.ty == param1)
         {
            return;
         }
         if(param1 == Infinity)
         {
            Debug.warning("y == Infinity");
         }
         if(param1 == -Infinity)
         {
            Debug.warning("y == -Infinity");
         }
         _transform.ty = param1;
         _sceneTransformDirty = true;
         _localTransformDirty = true;
      }
      
      public function set z(param1:Number) : void
      {
         if(isNaN(param1))
         {
            throw new Error("isNaN(z)");
         }
         if(_transform.tz == param1)
         {
            return;
         }
         if(param1 == Infinity)
         {
            Debug.warning("z == Infinity");
         }
         if(param1 == -Infinity)
         {
            Debug.warning("z == -Infinity");
         }
         _transform.tz = param1;
         _sceneTransformDirty = true;
         _localTransformDirty = true;
      }
      
      arcane function notifySceneTransformChange() : void
      {
         _sceneTransformDirty = false;
         _objectDirty = true;
         if(!hasEventListener(Object3DEvent.SCENETRANSFORM_CHANGED))
         {
            return;
         }
         if(!_scenetransformchanged)
         {
            _scenetransformchanged = new Object3DEvent(Object3DEvent.SCENETRANSFORM_CHANGED,this);
         }
         dispatchEvent(_scenetransformchanged);
      }
      
      public function set ownCanvas(param1:Boolean) : void
      {
         if(_ownCanvas == param1)
         {
            return;
         }
         if(param1)
         {
            ownSession = new SpriteRenderSession();
         }
         else
         {
            if(this is Scene3D)
            {
               throw new Error("Scene cannot have ownCanvas set to false");
            }
            ownSession = null;
         }
      }
      
      private function onParentSessionChange(param1:Object3DEvent) : void
      {
         if(Boolean(_ownSession) && Boolean(param1.object.parent))
         {
            param1.object.parent.session.removeChildSession(_ownSession);
         }
         if(Boolean(_ownSession) && Boolean(_parent.session))
         {
            _parent.session.addChildSession(_ownSession);
         }
         if(!_ownSession && _session != _parent.session)
         {
            changeSession();
            dispatchEvent(param1);
         }
      }
      
      public function addOnSceneChange(param1:Function) : void
      {
         addEventListener(Object3DEvent.SCENE_CHANGED,param1,false,0,true);
      }
      
      public function get lightarray() : ILightConsumer
      {
         if(_lightsDirty)
         {
            updateLights();
         }
         return _lightarray;
      }
      
      public function removeOnMouseOut(param1:Function) : void
      {
         removeEventListener(MouseEvent3D.MOUSE_OUT,param1,false);
      }
      
      arcane function dispatchMouseEvent(param1:MouseEvent3D) : Boolean
      {
         if(!hasEventListener(param1.type))
         {
            return false;
         }
         dispatchEvent(param1);
         return true;
      }
      
      public function addOnRollOut(param1:Function) : void
      {
         addEventListener(MouseEvent3D.ROLL_OUT,param1,false,0,false);
      }
      
      arcane function notifySessionChange() : void
      {
         changeSession();
         if(!hasEventListener(Object3DEvent.SESSION_CHANGED))
         {
            return;
         }
         if(!_sessionchanged)
         {
            _sessionchanged = new Object3DEvent(Object3DEvent.SESSION_CHANGED,this);
         }
         dispatchEvent(_sessionchanged);
      }
      
      public function get parentmaxX() : Number
      {
         return boundingRadius * _boundingScale + _transform.tx;
      }
      
      public function get parentmaxY() : Number
      {
         return boundingRadius * _boundingScale + _transform.ty;
      }
      
      public function get parentmaxZ() : Number
      {
         return boundingRadius * _boundingScale + _transform.tz;
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function removeOnSessionChange(param1:Function) : void
      {
         removeEventListener(Object3DEvent.SESSION_CHANGED,param1,false);
      }
      
      public function get position() : Number3D
      {
         return transform.position;
      }
      
      public function removeOnMouseUp(param1:Function) : void
      {
         removeEventListener(MouseEvent3D.MOUSE_UP,param1,false);
      }
      
      public function lookAt(param1:Number3D, param2:Number3D = null) : void
      {
         _lookingAtTarget = param1;
         _zAxis.sub(param1,position);
         _zAxis.normalize();
         if(_zAxis.modulo > 0.1 && (_zAxis.x != _transform.sxz || _zAxis.y != _transform.syz || _zAxis.z != _transform.szz))
         {
            _xAxis.cross(_zAxis,param2 || Number3D.UP);
            if(!_xAxis.modulo2)
            {
               _xAxis.cross(_zAxis,Number3D.BACKWARD);
            }
            _xAxis.normalize();
            _yAxis.cross(_zAxis,_xAxis);
            _yAxis.normalize();
            _transform.sxx = _xAxis.x * _scaleX;
            _transform.syx = _xAxis.y * _scaleX;
            _transform.szx = _xAxis.z * _scaleX;
            _transform.sxy = -_yAxis.x * _scaleY;
            _transform.syy = -_yAxis.y * _scaleY;
            _transform.szy = -_yAxis.z * _scaleY;
            _transform.sxz = _zAxis.x * _scaleZ;
            _transform.syz = _zAxis.y * _scaleZ;
            _transform.szz = _zAxis.z * _scaleZ;
            _transformDirty = false;
            _rotationDirty = true;
            _sceneTransformDirty = true;
            _localTransformDirty = true;
         }
      }
      
      public function get debugBoundingBox() : WireCube
      {
         if(_dimensionsDirty || !_debugBoundingBox)
         {
            updateDimensions();
         }
         return _debugBoundingBox;
      }
      
      public function set rotationY(param1:Number) : void
      {
         if(rotationY == param1)
         {
            return;
         }
         _rotationY = param1 * toRADIANS;
         _transformDirty = true;
      }
      
      public function set blendMode(param1:String) : void
      {
         if(_blendMode == param1)
         {
            return;
         }
         _blendMode = param1;
         if(_ownSession)
         {
            _ownSession.blendMode = _blendMode;
         }
      }
      
      public function set rotationX(param1:Number) : void
      {
         if(rotationX == param1)
         {
            return;
         }
         _rotationX = param1 * toRADIANS;
         _transformDirty = true;
      }
      
      public function rotateTo(param1:Number, param2:Number, param3:Number) : void
      {
         _rotationX = param1 * toRADIANS;
         _rotationY = param2 * toRADIANS;
         _rotationZ = param3 * toRADIANS;
         _rotationDirty = false;
         _transformDirty = true;
      }
      
      public function set rotationZ(param1:Number) : void
      {
         if(rotationZ == param1)
         {
            return;
         }
         _rotationZ = param1 * toRADIANS;
         _transformDirty = true;
      }
      
      public function pitch(param1:Number) : void
      {
         rotate(Number3D.RIGHT,param1);
      }
      
      public function centerPivot() : void
      {
         var _loc1_:Number3D = new Number3D((maxX + minX) / 2,(maxY + minY) / 2,(maxZ + minZ) / 2);
         movePivot(_loc1_.x,_loc1_.y,_loc1_.z);
         _loc1_.transform(_loc1_,transform);
         moveTo(x + _loc1_.x,y + _loc1_.y,z + _loc1_.z);
      }
      
      public function get ownLights() : Boolean
      {
         return _ownLights;
      }
      
      public function removeOnParentUpdate(param1:Function) : void
      {
         removeEventListener(Object3DEvent.PARENT_UPDATED,param1,false);
      }
      
      arcane function notifyDimensionsChange() : void
      {
         _dimensionsDirty = true;
         if(_dispatchedDimensionsChange || !hasEventListener(Object3DEvent.DIMENSIONS_CHANGED))
         {
            return;
         }
         if(!_dimensionschanged)
         {
            _dimensionschanged = new Object3DEvent(Object3DEvent.DIMENSIONS_CHANGED,this);
         }
         dispatchEvent(_dimensionschanged);
         _dispatchedDimensionsChange = true;
      }
      
      public function scale(param1:Number) : void
      {
         _scaleX = _scaleY = _scaleZ = param1;
         _transformDirty = true;
         _dimensionsDirty = true;
      }
      
      public function get objectHeight() : Number
      {
         if(_dimensionsDirty)
         {
            updateDimensions();
         }
         return _maxY - _minY;
      }
      
      public function translate(param1:Number3D, param2:Number) : void
      {
         param1.normalize();
         _vector.rotate(param1,transform);
         x += param2 * _vector.x;
         y += param2 * _vector.y;
         z += param2 * _vector.z;
      }
      
      public function distanceTo(param1:Object3D) : Number
      {
         var _loc2_:Matrix3D = _scene == this ? transform : sceneTransform;
         var _loc3_:Matrix3D = param1.scene == param1 ? param1.transform : param1.sceneTransform;
         var _loc4_:Number = _loc2_.tx - _loc3_.tx;
         var _loc5_:Number = _loc2_.ty - _loc3_.ty;
         var _loc6_:Number = _loc2_.tz - _loc3_.tz;
         return Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_ + _loc6_ * _loc6_);
      }
      
      public function set parent(param1:ObjectContainer3D) : void
      {
         if(this is Scene3D)
         {
            throw new Error("Scene cannot be parented");
         }
         if(param1 == _parent)
         {
            return;
         }
         _oldscene = _scene;
         if(_parent != null)
         {
            _parent.removeOnParentUpdate(onParentUpdate);
            _parent.removeOnSessionChange(onParentSessionChange);
            _parent.removeOnSceneChange(onParentSceneChange);
            _parent.removeOnSceneTransformChange(onParentTransformChange);
            _parent.internalRemoveChild(this);
            if(Boolean(_ownSession) && Boolean(_parent.session))
            {
               _parent.session.removeChildSession(_ownSession);
            }
         }
         _parent = param1;
         _scene = _parent ? _parent.scene : null;
         if(_parent != null)
         {
            _parent.internalAddChild(this);
            _parent.addOnParentUpdate(onParentUpdate);
            _parent.addOnSessionChange(onParentSessionChange);
            _parent.addOnSceneChange(onParentSceneChange);
            _parent.addOnSceneTransformChange(onParentTransformChange);
            if(Boolean(_ownSession) && Boolean(_parent.session))
            {
               _parent.session.addChildSession(_ownSession);
            }
         }
         if(_scene != _oldscene)
         {
            if(_oldscene)
            {
               _oldscene.clearId(_id);
            }
            if(_scene)
            {
               _scene.setId(this);
            }
            notifySceneChange();
         }
         if(!_ownSession && (!_parent || _session != _parent.session))
         {
            notifySessionChange();
         }
         _sceneTransformDirty = true;
         _localTransformDirty = true;
      }
      
      public function get boundingRadius() : Number
      {
         if(_dimensionsDirty)
         {
            updateDimensions();
         }
         return _boundingRadius;
      }
      
      public function rotate(param1:Number3D, param2:Number) : void
      {
         param1.normalize();
         _m.rotationMatrix(param1.x,param1.y,param1.z,param2 * toRADIANS);
         _transform.multiply3x3(transform,_m);
         _rotationDirty = true;
         _sceneTransformDirty = true;
         _localTransformDirty = true;
      }
      
      public function clone(param1:Object3D = null) : Object3D
      {
         var _loc2_:Object3D = param1 || new Object3D();
         _loc2_.transform = transform;
         _loc2_.name = name;
         _loc2_.ownCanvas = _ownCanvas;
         _loc2_.renderer = _renderer;
         _loc2_.filters = _filters.concat();
         _loc2_.blendMode = blendMode;
         _loc2_.alpha = _alpha;
         _loc2_.visible = visible;
         _loc2_.mouseEnabled = mouseEnabled;
         _loc2_.useHandCursor = useHandCursor;
         _loc2_.pushback = pushback;
         _loc2_.pushfront = pushfront;
         _loc2_.screenZOffset = screenZOffset;
         _loc2_.pivotPoint = pivotPoint;
         _loc2_.projectorType = projectorType;
         _loc2_.extra = extra is IClonable ? (extra as IClonable).clone() : extra;
         return _loc2_;
      }
      
      public function get alpha() : Number
      {
         return _alpha;
      }
      
      private function onSessionUpdate(param1:SessionEvent) : void
      {
         if(param1.target is BitmapRenderSession)
         {
            _scene.updatedSessions[param1.target] = param1.target;
         }
      }
      
      private function updateRotation() : void
      {
         _rot.matrix2euler(_transform);
         _rotationX = _rot.x;
         _rotationY = _rot.y;
         _rotationZ = _rot.z;
         _rotationDirty = false;
      }
      
      private function updateSceneTransform() : void
      {
         _sceneTransform.multiply(_parent.sceneTransform,transform);
         if(!_pivotZero)
         {
            _scenePivotPoint.rotate(_pivotPoint,_sceneTransform);
            _sceneTransform.tx -= _scenePivotPoint.x;
            _sceneTransform.ty -= _scenePivotPoint.y;
            _sceneTransform.tz -= _scenePivotPoint.z;
         }
         inverseSceneTransform.inverse(_sceneTransform);
         notifySceneTransformChange();
      }
      
      public function get transform() : Matrix3D
      {
         if(_transformDirty)
         {
            updateTransform();
         }
         return _transform;
      }
      
      public function addOnRollOver(param1:Function) : void
      {
         addEventListener(MouseEvent3D.ROLL_OVER,param1,false,0,false);
      }
      
      public function traverse(param1:Traverser) : void
      {
         if(param1.match(this))
         {
            param1.enter(this);
            param1.apply(this);
            param1.leave(this);
         }
      }
      
      public function updateObject() : void
      {
         if(_objectDirty)
         {
            _scene.updatedObjects[this] = this;
            _objectDirty = false;
            _sessionDirty = true;
         }
      }
      
      public function get maxX() : Number
      {
         if(_dimensionsDirty)
         {
            updateDimensions();
         }
         return _maxX;
      }
      
      public function get maxY() : Number
      {
         if(_dimensionsDirty)
         {
            updateDimensions();
         }
         return _maxY;
      }
      
      public function addOnSessionChange(param1:Function) : void
      {
         addEventListener(Object3DEvent.SESSION_CHANGED,param1,false,0,true);
      }
      
      public function moveLeft(param1:Number) : void
      {
         translate(Number3D.LEFT,param1);
      }
      
      public function removeOnDimensionsChange(param1:Function) : void
      {
         removeEventListener(Object3DEvent.DIMENSIONS_CHANGED,param1,false);
      }
      
      public function set renderer(param1:IPrimitiveConsumer) : void
      {
         if(_renderer == param1)
         {
            return;
         }
         _renderer = param1;
         if(_ownSession)
         {
            _ownSession.renderer = _renderer;
         }
         _sessionDirty = true;
      }
      
      protected function updateDimensions() : void
      {
         _dimensionsDirty = false;
         _dispatchedDimensionsChange = false;
         if(debugbb)
         {
            if(!_debugBoundingBox)
            {
               _debugBoundingBox = new WireCube({"material":"#333333"});
               _scene.setId(_debugBoundingBox);
            }
            if(_boundingRadius)
            {
               _debugBoundingBox.visible = true;
               _debugBoundingBox.v000.setValue(_minX,_minY,_minZ);
               _debugBoundingBox.v100.setValue(_maxX,_minY,_minZ);
               _debugBoundingBox.v010.setValue(_minX,_maxY,_minZ);
               _debugBoundingBox.v110.setValue(_maxX,_maxY,_minZ);
               _debugBoundingBox.v001.setValue(_minX,_minY,_maxZ);
               _debugBoundingBox.v101.setValue(_maxX,_minY,_maxZ);
               _debugBoundingBox.v011.setValue(_minX,_maxY,_maxZ);
               _debugBoundingBox.v111.setValue(_maxX,_maxY,_maxZ);
            }
            else
            {
               debugBoundingBox.visible = false;
            }
         }
         if(debugbs)
         {
            if(!_debugBoundingSphere)
            {
               _debugBoundingSphere = new WireSphere({
                  "material":"#cyan",
                  "segmentsW":16,
                  "segmentsH":12
               });
               _scene.setId(_debugBoundingSphere);
            }
            if(_boundingRadius)
            {
               _debugBoundingSphere.visible = true;
               _debugBoundingSphere.radius = _boundingRadius;
               _debugBoundingSphere.updateObject();
               _debugBoundingSphere.applyPosition(-_pivotPoint.x,-_pivotPoint.y,-_pivotPoint.z);
            }
            else
            {
               debugBoundingSphere.visible = false;
            }
         }
      }
      
      public function addOnMouseMove(param1:Function) : void
      {
         addEventListener(MouseEvent3D.MOUSE_MOVE,param1,false,0,false);
      }
      
      public function get maxZ() : Number
      {
         if(_dimensionsDirty)
         {
            updateDimensions();
         }
         return _maxZ;
      }
      
      private function onParentUpdate(param1:Object3DEvent) : void
      {
         _sessionDirty = true;
         dispatchEvent(param1);
      }
      
      private function onParentTransformChange(param1:Object3DEvent) : void
      {
         _sceneTransformDirty = true;
      }
      
      public function updateSession() : void
      {
         if(_sessionDirty)
         {
            notifySessionUpdate();
            _sessionDirty = false;
         }
      }
      
      public function tick(param1:int) : void
      {
      }
      
      public function addOnMouseUp(param1:Function) : void
      {
         addEventListener(MouseEvent3D.MOUSE_UP,param1,false,0,false);
      }
      
      public function get blendMode() : String
      {
         return _blendMode;
      }
      
      public function get lookingAtTarget() : Number3D
      {
         return _lookingAtTarget;
      }
      
      public function removeOnRollOver(param1:Function) : void
      {
         removeEventListener(MouseEvent3D.ROLL_OVER,param1,false);
      }
      
      arcane function notifyTransformChange() : void
      {
         _localTransformDirty = false;
         if(!hasEventListener(Object3DEvent.TRANSFORM_CHANGED))
         {
            return;
         }
         if(!_transformchanged)
         {
            _transformchanged = new Object3DEvent(Object3DEvent.TRANSFORM_CHANGED,this);
         }
         dispatchEvent(_transformchanged);
      }
      
      public function moveForward(param1:Number) : void
      {
         translate(Number3D.FORWARD,param1);
      }
      
      public function addOnTransformChange(param1:Function) : void
      {
         addEventListener(Object3DEvent.TRANSFORM_CHANGED,param1,false,0,true);
      }
      
      public function get debugBoundingSphere() : WireSphere
      {
         if(_dimensionsDirty || !_debugBoundingSphere)
         {
            updateDimensions();
         }
         return _debugBoundingSphere;
      }
      
      public function get objectWidth() : Number
      {
         if(_dimensionsDirty)
         {
            updateDimensions();
         }
         return _maxX - _minX;
      }
      
      public function get scenePosition() : Number3D
      {
         return sceneTransform.position;
      }
      
      public function removeOnSceneChange(param1:Function) : void
      {
         removeEventListener(Object3DEvent.SCENE_CHANGED,param1,false);
      }
      
      public function removeOnMouseMove(param1:Function) : void
      {
         removeEventListener(MouseEvent3D.MOUSE_MOVE,param1,false);
      }
      
      public function get parentminX() : Number
      {
         return -boundingRadius * _boundingScale + _transform.tx;
      }
      
      public function get parentminY() : Number
      {
         return -boundingRadius * _boundingScale + _transform.ty;
      }
      
      public function get parentminZ() : Number
      {
         return -boundingRadius * _boundingScale + _transform.tz;
      }
      
      public function get filters() : Array
      {
         return _filters;
      }
      
      arcane function notifyParentUpdate() : void
      {
         if(_ownCanvas && Boolean(_parent))
         {
            _parent._sessionDirty = true;
         }
         if(!hasEventListener(Object3DEvent.PARENT_UPDATED))
         {
            return;
         }
         if(!_parentupdated)
         {
            _parentupdated = new Object3DEvent(Object3DEvent.PARENT_UPDATED,this);
         }
         dispatchEvent(_parentupdated);
      }
      
      public function set filters(param1:Array) : void
      {
         if(_filters == param1)
         {
            return;
         }
         _filters = param1;
         if(_ownSession)
         {
            _ownSession.filters = _filters;
         }
      }
   }
}

