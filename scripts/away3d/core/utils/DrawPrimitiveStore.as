package away3d.core.utils
{
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.block.*;
   import away3d.core.draw.*;
   import away3d.core.render.*;
   import away3d.materials.*;
   import flash.display.*;
   import flash.utils.*;
   
   public class DrawPrimitiveStore
   {
      
      private var _sv:ScreenVertex;
      
      private var _cbStore:Array = [];
      
      private var _length:int;
      
      private var _sbArray:Array;
      
      private var _dbDictionary:Dictionary = new Dictionary(true);
      
      private var _seg:DrawSegment;
      
      private var _sbStore:Array = [];
      
      private var _screenIndices:Array = new Array();
      
      private var _cblocker:ConvexBlocker;
      
      private var _sbitmap:DrawScaledBitmap;
      
      private var _screenVertices:Array = new Array();
      
      private var _dtDictionary:Dictionary = new Dictionary(true);
      
      private var _sbDictionary:Dictionary = new Dictionary(true);
      
      public var blockerDictionary:Dictionary = new Dictionary(true);
      
      private var _screenCommands:Array = new Array();
      
      private var _cbDictionary:Dictionary = new Dictionary(true);
      
      private var _source:Object3D;
      
      private var _vertex:Object;
      
      private var _dbStore:Array = [];
      
      public var view:View3D;
      
      private var _indexDictionary:Dictionary;
      
      private var _dsArray:Array;
      
      private var _index:int;
      
      private var _doArray:Array;
      
      private var _session:AbstractRenderSession;
      
      private var _array:Array = new Array();
      
      private var _object:Object;
      
      private var _dsStore:Array = [];
      
      private var _doDictionary:Dictionary = new Dictionary(true);
      
      private var _dbArray:Array;
      
      private var _dtArray:Array;
      
      private var _dsDictionary:Dictionary = new Dictionary(true);
      
      private var _tri:DrawTriangle;
      
      private var _bill:DrawBillboard;
      
      private var _doStore:Array = [];
      
      private var _dtStore:Array = [];
      
      private var _dobject:DrawDisplayObject;
      
      private var _svArray:Array;
      
      private var _cbArray:Array;
      
      private var _svStore:Array = [];
      
      public function DrawPrimitiveStore()
      {
         super();
      }
      
      public function createDrawTriangle(param1:Object3D, param2:FaceVO, param3:ITriangleMaterial, param4:Array, param5:Array, param6:Array, param7:int, param8:int, param9:UV, param10:UV, param11:UV, param12:Boolean = false) : DrawTriangle
      {
         if(!(_dtArray = _dtDictionary[param1.session]))
         {
            _dtArray = _dtDictionary[param1.session] = [];
         }
         if(_dtStore.length)
         {
            _dtArray[_dtArray.length] = _tri = _dtStore.pop();
         }
         else
         {
            _dtArray[_dtArray.length] = _tri = new DrawTriangle();
            _tri.view = view;
            _tri.create = createDrawTriangle;
         }
         _tri.reverseArea = param2.reverseArea;
         _tri.generated = param12;
         _tri.source = param1;
         _tri.faceVO = param2;
         _tri.material = param3;
         _tri.screenVertices = param4;
         _tri.screenIndices = param5;
         _tri.screenCommands = param6;
         _tri.startIndex = param7;
         _tri.endIndex = param8;
         _tri.uv0 = param9;
         _tri.uv1 = param10;
         _tri.uv2 = param11;
         _tri.calc();
         return _tri;
      }
      
      public function getScreenCommands(param1:int) : Array
      {
         return _screenCommands[param1] || (_screenCommands[param1] = []);
      }
      
      public function createConvexBlocker(param1:Object3D, param2:Array) : ConvexBlocker
      {
         if(!(_cbArray = _cbDictionary[param1.session]))
         {
            _cbArray = _cbDictionary[param1.session] = [];
         }
         if(_cbStore.length)
         {
            _cbArray[_cbArray.length] = _cblocker = blockerDictionary[param1] = _cbStore.pop();
         }
         else
         {
            _cbArray[_cbArray.length] = _cblocker = blockerDictionary[param1] = new ConvexBlocker();
            _cblocker.view = view;
            _cblocker.create = createConvexBlocker;
         }
         _cblocker.source = param1;
         _cblocker.vertices = param2;
         _cblocker.calc();
         return _cblocker;
      }
      
      public function createDrawDisplayObject(param1:Object3D, param2:Number, param3:Number, param4:Number, param5:AbstractRenderSession, param6:DisplayObject, param7:Boolean = false) : DrawDisplayObject
      {
         if(!(_doArray = _doDictionary[param1.session]))
         {
            _doArray = _doDictionary[param1.session] = [];
         }
         if(_doStore.length)
         {
            _doArray[_doArray.length] = _dobject = _doStore.pop();
         }
         else
         {
            _doArray[_doArray.length] = _dobject = new DrawDisplayObject();
            _dobject.view = view;
            _dobject.create = createDrawSegment;
         }
         _dobject.generated = param7;
         _dobject.source = param1;
         _dobject.vx = param2;
         _dobject.vy = param3;
         _dobject.vz = param4;
         _dobject.session = param5;
         _dobject.displayobject = param6;
         _dobject.calc();
         return _dobject;
      }
      
      public function getScreenVertices(param1:int) : Array
      {
         return _screenVertices[param1] || (_screenVertices[param1] = []);
      }
      
      public function createDrawScaledBitmap(param1:Object3D, param2:Array, param3:Boolean, param4:BitmapData, param5:Number, param6:Number, param7:Boolean = false) : DrawScaledBitmap
      {
         if(!(_sbArray = _sbDictionary[param1.session]))
         {
            _sbArray = _sbDictionary[param1.session] = [];
         }
         if(_sbStore.length)
         {
            _sbArray[_sbArray.length] = _sbitmap = _sbStore.pop();
         }
         else
         {
            _sbArray[_sbArray.length] = _sbitmap = new DrawScaledBitmap();
            _sbitmap.view = view;
            _sbitmap.create = createDrawSegment;
         }
         _sbitmap.generated = param7;
         _sbitmap.source = param1;
         _sbitmap.vx = param2[0];
         _sbitmap.vy = param2[1];
         _sbitmap.vz = param2[2];
         _sbitmap.smooth = param3;
         _sbitmap.bitmap = param4;
         _sbitmap.scale = param5;
         _sbitmap.rotation = param6;
         _sbitmap.calc();
         return _sbitmap;
      }
      
      public function createDrawBillboard(param1:Object3D, param2:BillboardVO, param3:IBillboardMaterial, param4:Array, param5:Array, param6:uint, param7:Number, param8:Boolean = false) : DrawBillboard
      {
         if(!(_dbArray = _dbDictionary[param1.session]))
         {
            _dbArray = _dbDictionary[param1.session] = [];
         }
         if(_dbStore.length)
         {
            _dbArray.push(_bill = _dbStore.pop());
         }
         else
         {
            _dbArray.push(_bill = new DrawBillboard());
            _bill.view = view;
            _bill.create = createDrawBillboard;
         }
         _bill.generated = param8;
         _bill.source = param1;
         _bill.material = param3;
         _bill.billboardVO = param2;
         _bill.screenVertices = param4;
         _bill.screenIndices = param5;
         _bill.index = param6;
         _bill.width = param2.width;
         _bill.height = param2.height;
         _bill.rotation = param2.rotation;
         _bill.scale = param7;
         _bill.calc();
         return _bill;
      }
      
      public function createDrawSegment(param1:Object3D, param2:SegmentVO, param3:ISegmentMaterial, param4:Array, param5:Array, param6:Array, param7:int, param8:int, param9:Boolean = false) : DrawSegment
      {
         if(!(_dsArray = _dsDictionary[param1.session]))
         {
            _dsArray = _dsDictionary[param1.session] = [];
         }
         if(_dsStore.length)
         {
            _dsArray[_dsArray.length] = _seg = _dsStore.pop();
         }
         else
         {
            _dsArray[_dsArray.length] = _seg = new DrawSegment();
            _seg.view = view;
            _seg.create = createDrawSegment;
         }
         _seg.generated = param9;
         _seg.source = param1;
         _seg.segmentVO = param2;
         _seg.material = param3;
         _seg.screenVertices = param4;
         _seg.screenIndices = param5;
         _seg.screenCommands = param6;
         _seg.startIndex = param7;
         _seg.endIndex = param8;
         _seg.calc();
         return _seg;
      }
      
      public function getScreenIndices(param1:int) : Array
      {
         return _screenIndices[param1] || (_screenIndices[param1] = []);
      }
      
      public function reset() : void
      {
         for(_object in _dtDictionary)
         {
            _session = _object as AbstractRenderSession;
            if(_session.updated)
            {
               _dtArray = _dtDictionary[_session] as Array;
               if(_dtArray.length)
               {
                  _dtStore = _dtStore.concat(_dtArray);
                  _dtArray.length = 0;
               }
            }
         }
         for(_object in _dsDictionary)
         {
            _session = _object as AbstractRenderSession;
            if(_session.updated)
            {
               _dsArray = _dsDictionary[_session] as Array;
               if(_dsArray.length)
               {
                  _dsStore = _dsStore.concat(_dsArray);
                  _dsArray.length = 0;
               }
            }
         }
         for(_object in _dbDictionary)
         {
            _session = _object as AbstractRenderSession;
            if(_session.updated)
            {
               _dbArray = _dbDictionary[_session] as Array;
               if(_dbArray.length)
               {
                  _dbStore = _dbStore.concat(_dbArray);
                  _dbArray.length = 0;
               }
            }
         }
         for(_object in _cbDictionary)
         {
            _session = _object as AbstractRenderSession;
            if(_session.updated)
            {
               _cbArray = _cbDictionary[_session] as Array;
               if(_cbArray.length)
               {
                  _cbStore = _cbStore.concat(_cbArray);
                  _cbArray.length = 0;
               }
            }
         }
         for(_object in _sbDictionary)
         {
            _session = _object as AbstractRenderSession;
            if(_session.updated)
            {
               _sbArray = _sbDictionary[_session] as Array;
               if(_sbArray.length)
               {
                  _sbStore = _sbStore.concat(_sbArray);
                  _sbArray.length = 0;
               }
            }
         }
         for(_object in _doDictionary)
         {
            _session = _object as AbstractRenderSession;
            if(_session.updated)
            {
               _doArray = _doDictionary[_session] as Array;
               if(_doArray.length)
               {
                  _doStore = _doStore.concat(_doArray);
                  _doArray.length = 0;
               }
            }
         }
      }
   }
}

