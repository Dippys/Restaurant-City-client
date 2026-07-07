package away3d.core.utils
{
   import away3d.materials.*;
   import flash.display.*;
   import flash.geom.Matrix;
   import flash.utils.*;
   
   public class Cast
   {
      
      private static var colornames:Dictionary;
      
      private static var hexchars:String = "0123456789abcdefABCDEF";
      
      private static var notclasses:Dictionary = new Dictionary();
      
      private static var classes:Dictionary = new Dictionary();
      
      public function Cast()
      {
         super();
      }
      
      public static function color(param1:*) : uint
      {
         var _loc2_:uint = trycolor(param1);
         if(_loc2_ == 4294967295)
         {
            throw new CastError("Can\'t cast to color: " + param1);
         }
         return _loc2_;
      }
      
      public static function material(param1:*) : IMaterial
      {
         var hash:Array = null;
         var line:Array = null;
         var bmd:BitmapData = null;
         var ini:Init = null;
         var bitmap:BitmapData = null;
         var color:uint = 0;
         var alpha:Number = NaN;
         var lighting:Boolean = false;
         var wire:WireframeMaterial = null;
         var smooth:Boolean = false;
         var precision:Number = NaN;
         var data:* = param1;
         if(data == null)
         {
            return null;
         }
         if(data is String)
         {
            data = tryclass(data);
         }
         if(data is Class)
         {
            try
            {
               data = new data();
            }
            catch(materialerror:ArgumentError)
            {
               data = new data(0,0);
            }
         }
         if(data is IMaterial)
         {
            return data;
         }
         if(data is int)
         {
            return new ColorMaterial(data);
         }
         if(data is MovieClip)
         {
            return new MovieMaterial(data);
         }
         if(data is String)
         {
            if(data == "")
            {
               return null;
            }
            if((data as String).indexOf("#") != -1)
            {
               hash = (data as String).split("#");
               if(hash[1] == "")
               {
                  return new WireColorMaterial(Cast.color(hash[0]));
               }
               if(hash[1].indexOf("|") == -1)
               {
                  if(hash[0] == "")
                  {
                     return new WireframeMaterial(Cast.color(hash[1]));
                  }
                  return new WireColorMaterial(Cast.color(hash[0]),{"wirecolor":Cast.color(hash[1])});
               }
               line = hash[1].split("|");
               if(hash[0] == "")
               {
                  return new WireframeMaterial(Cast.color(line[0]),{"width":parseFloat(line[1])});
               }
               return new WireColorMaterial(Cast.color(hash[0]),{
                  "wirecolor":Cast.color(line[0]),
                  "width":parseFloat(line[1])
               });
            }
            if((data as String).indexOf("@") == -1)
            {
               return new ColorMaterial(Cast.color(data));
            }
            hash = (data as String).split("@");
            if(hash[1] == "")
            {
               return new ShadingColorMaterial({"color":Cast.color(hash[0])});
            }
         }
         try
         {
            bmd = Cast.bitmap(data);
            return new BitmapMaterial(bmd);
         }
         catch(error:CastError)
         {
         }
         if(data is Object)
         {
            ini = Init.parse(data);
            bitmap = ini.getBitmap("bitmap");
            color = ini.getColor("color",4294967295);
            alpha = ini.getNumber("alpha",1,{
               "min":0,
               "max":1
            });
            lighting = ini.getBoolean("lighting",false);
            wire = wirematerial(ini.getObject("wire")) as WireframeMaterial;
            if(bitmap != null && color != 4294967295)
            {
               throw new CastError("Can\'t create material with color and bitmap: " + data);
            }
            if(bitmap != null)
            {
               if(wire != null)
               {
                  Debug.warning("Bitmap materials do not support wire");
               }
               smooth = ini.getBoolean("smooth",false);
               precision = ini.getNumber("precision",0);
               if(precision)
               {
                  if(lighting)
                  {
                     return new WhiteShadingBitmapMaterial(bitmap,{
                        "smooth":smooth,
                        "precision":precision
                     });
                  }
                  if(alpha < 1)
                  {
                     Debug.warning("Can\'t create precise bitmap material with alpha (yet)");
                  }
                  return new BitmapMaterial(bitmap,{
                     "smooth":smooth,
                     "precision":precision
                  });
               }
               if(lighting)
               {
                  if(alpha < 1)
                  {
                     Debug.warning("Can\'t create bitmap material with lighting and alpha (yet)");
                  }
                  return new WhiteShadingBitmapMaterial(bitmap,{
                     "smooth":smooth,
                     "alpha":alpha
                  });
               }
               return new BitmapMaterial(bitmap,{"smooth":smooth});
            }
            if(color != 4294967295)
            {
               if(lighting)
               {
                  if(wire != null)
                  {
                     Debug.warning("Can\'t create shading material with wire");
                  }
                  return new ShadingColorMaterial({
                     "color":color,
                     "alpha":alpha
                  });
               }
               if(wire == null)
               {
                  return new ColorMaterial(color,{"alpha":alpha});
               }
               return new WireColorMaterial(color,{
                  "alpha":alpha,
                  "wirecolor":wire.color,
                  "wirealpha":wire.alpha,
                  "width":wire.width
               });
            }
            if(wire != null)
            {
               return wire;
            }
         }
         throw new CastError("Can\'t cast to material: " + data);
      }
      
      public static function trycolor(param1:*) : uint
      {
         if(param1 is uint)
         {
            return param1 as uint;
         }
         if(param1 is int)
         {
            return param1 as uint;
         }
         if(param1 is String)
         {
            if(param1 == "random")
            {
               return uint(Math.random() * 16777216);
            }
            if(colornames == null)
            {
               colornames = new Dictionary();
               colornames["steelblue"] = 4620980;
               colornames["royalblue"] = 267920;
               colornames["cornflowerblue"] = 6591981;
               colornames["lightsteelblue"] = 11584734;
               colornames["mediumslateblue"] = 8087790;
               colornames["slateblue"] = 6970061;
               colornames["darkslateblue"] = 4734347;
               colornames["midnightblue"] = 1644912;
               colornames["navy"] = 128;
               colornames["darkblue"] = 139;
               colornames["mediumblue"] = 205;
               colornames["blue"] = 255;
               colornames["dodgerblue"] = 2003199;
               colornames["deepskyblue"] = 49151;
               colornames["lightskyblue"] = 8900346;
               colornames["skyblue"] = 8900331;
               colornames["lightblue"] = 11393254;
               colornames["powderblue"] = 11591910;
               colornames["azure"] = 15794175;
               colornames["lightcyan"] = 14745599;
               colornames["paleturquoise"] = 11529966;
               colornames["mediumturquoise"] = 4772300;
               colornames["lightseagreen"] = 2142890;
               colornames["darkcyan"] = 35723;
               colornames["teal"] = 32896;
               colornames["cadetblue"] = 6266528;
               colornames["darkturquoise"] = 52945;
               colornames["aqua"] = 65535;
               colornames["cyan"] = 65535;
               colornames["turquoise"] = 4251856;
               colornames["aquamarine"] = 8388564;
               colornames["mediumaquamarine"] = 6737322;
               colornames["darkseagreen"] = 9419919;
               colornames["mediumseagreen"] = 3978097;
               colornames["seagreen"] = 3050327;
               colornames["darkgreen"] = 25600;
               colornames["green"] = 32768;
               colornames["forestgreen"] = 2263842;
               colornames["limegreen"] = 3329330;
               colornames["lime"] = 65280;
               colornames["chartreuse"] = 8388352;
               colornames["lawngreen"] = 8190976;
               colornames["greenyellow"] = 11403055;
               colornames["yellowgreen"] = 10145074;
               colornames["palegreen"] = 10025880;
               colornames["lightgreen"] = 9498256;
               colornames["springgreen"] = 65407;
               colornames["mediumspringgreen"] = 64154;
               colornames["darkolivegreen"] = 5597999;
               colornames["olivedrab"] = 7048739;
               colornames["olive"] = 8421376;
               colornames["darkkhaki"] = 12433259;
               colornames["darkgoldenrod"] = 12092939;
               colornames["goldenrod"] = 14329120;
               colornames["gold"] = 16766720;
               colornames["yellow"] = 16776960;
               colornames["khaki"] = 15787660;
               colornames["palegoldenrod"] = 15657130;
               colornames["blanchedalmond"] = 16772045;
               colornames["moccasin"] = 16770229;
               colornames["wheat"] = 16113331;
               colornames["navajowhite"] = 16768685;
               colornames["burlywood"] = 14596231;
               colornames["tan"] = 13808780;
               colornames["rosybrown"] = 12357519;
               colornames["sienna"] = 10506797;
               colornames["saddlebrown"] = 9127187;
               colornames["chocolate"] = 13789470;
               colornames["peru"] = 13468991;
               colornames["sandybrown"] = 16032864;
               colornames["darkred"] = 9109504;
               colornames["maroon"] = 8388608;
               colornames["brown"] = 10824234;
               colornames["firebrick"] = 11674146;
               colornames["indianred"] = 13458524;
               colornames["lightcoral"] = 15761536;
               colornames["salmon"] = 16416882;
               colornames["darksalmon"] = 15308410;
               colornames["lightsalmon"] = 16752762;
               colornames["coral"] = 16744272;
               colornames["tomato"] = 16737095;
               colornames["darkorange"] = 16747520;
               colornames["orange"] = 16753920;
               colornames["orangered"] = 16729344;
               colornames["crimson"] = 14423100;
               colornames["red"] = 16711680;
               colornames["deeppink"] = 16716947;
               colornames["fuchsia"] = 16711935;
               colornames["magenta"] = 16711935;
               colornames["hotpink"] = 16738740;
               colornames["lightpink"] = 16758465;
               colornames["pink"] = 16761035;
               colornames["palevioletred"] = 14381203;
               colornames["mediumvioletred"] = 13047173;
               colornames["purple"] = 8388736;
               colornames["darkmagenta"] = 9109643;
               colornames["mediumpurple"] = 9662683;
               colornames["blueviolet"] = 9055202;
               colornames["indigo"] = 4915330;
               colornames["darkviolet"] = 9699539;
               colornames["darkorchid"] = 10040012;
               colornames["mediumorchid"] = 12211667;
               colornames["orchid"] = 14315734;
               colornames["violet"] = 15631086;
               colornames["plum"] = 14524637;
               colornames["thistle"] = 14204888;
               colornames["lavender"] = 15132410;
               colornames["ghostwhite"] = 16316671;
               colornames["aliceblue"] = 15792383;
               colornames["mintcream"] = 16121850;
               colornames["honeydew"] = 15794160;
               colornames["lightgoldenrodyellow"] = 16448210;
               colornames["lemonchiffon"] = 16775885;
               colornames["cornsilk"] = 16775388;
               colornames["lightyellow"] = 16777184;
               colornames["ivory"] = 16777200;
               colornames["floralwhite"] = 16775920;
               colornames["linen"] = 16445670;
               colornames["oldlace"] = 16643558;
               colornames["antiquewhite"] = 16444375;
               colornames["bisque"] = 16770244;
               colornames["peachpuff"] = 16767673;
               colornames["papayawhip"] = 16773077;
               colornames["beige"] = 16119260;
               colornames["seashell"] = 16774638;
               colornames["lavenderblush"] = 16773365;
               colornames["mistyrose"] = 16770273;
               colornames["snow"] = 16775930;
               colornames["white"] = 16777215;
               colornames["whitesmoke"] = 16119285;
               colornames["gainsboro"] = 14474460;
               colornames["lightgrey"] = 13882323;
               colornames["silver"] = 12632256;
               colornames["darkgrey"] = 11119017;
               colornames["grey"] = 8421504;
               colornames["lightslategrey"] = 7833753;
               colornames["slategrey"] = 7372944;
               colornames["dimgrey"] = 6908265;
               colornames["darkslategrey"] = 3100495;
               colornames["black"] = 0;
               colornames["transparent"] = 4278190080;
            }
            if(colornames[param1] != null)
            {
               return colornames[param1];
            }
            if((param1 as String).length == 6 && hexstring(param1))
            {
               return parseInt("0x" + param1);
            }
         }
         return 16777215;
      }
      
      private static function hexstring(param1:String) : Boolean
      {
         var _loc2_:int = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(hexchars.indexOf(param1.charAt(_loc3_)) == -1)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public static function wirematerial(param1:*) : ISegmentMaterial
      {
         var _loc2_:Array = null;
         var _loc3_:Init = null;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(param1 == null)
         {
            return null;
         }
         if(param1 is ISegmentMaterial)
         {
            return param1;
         }
         if(param1 is int)
         {
            return new WireframeMaterial(param1);
         }
         if(param1 is String)
         {
            if(param1 == "")
            {
               return null;
            }
            if((param1 as String).indexOf("#") == 0)
            {
               param1 = (param1 as String).substring(1);
            }
            if((param1 as String).indexOf("|") == -1)
            {
               return new WireframeMaterial(Cast.color(param1));
            }
            _loc2_ = (param1 as String).split("|");
            return new WireframeMaterial(Cast.color(_loc2_[0]),{"width":parseFloat(_loc2_[1])});
         }
         if(param1 is Object)
         {
            _loc3_ = Init.parse(param1);
            _loc4_ = _loc3_.getColor("color",0);
            _loc5_ = _loc3_.getNumber("alpha",1,{
               "min":0,
               "max":1
            });
            _loc6_ = _loc3_.getNumber("width",1,{"min":0});
            return new WireframeMaterial(_loc4_,{
               "alpha":_loc5_,
               "width":_loc6_
            });
         }
         throw new CastError("Can\'t cast to wirematerial: " + param1);
      }
      
      public static function bitmap(param1:*) : BitmapData
      {
         var ds:DisplayObject = null;
         var bmd:BitmapData = null;
         var mat:Matrix = null;
         var data:* = param1;
         if(data == null)
         {
            return null;
         }
         if(data is String)
         {
            data = tryclass(data);
         }
         if(data is Class)
         {
            try
            {
               data = new data();
            }
            catch(bitmaperror:ArgumentError)
            {
               data = new data(0,0);
            }
         }
         if(data is BitmapData)
         {
            return data;
         }
         if(data is Bitmap)
         {
            if((data as Bitmap).hasOwnProperty("bitmapData"))
            {
               return (data as Bitmap).bitmapData;
            }
         }
         if(data is DisplayObject)
         {
            ds = data as DisplayObject;
            bmd = new BitmapData(ds.width,ds.height,true,16777215);
            mat = ds.transform.matrix.clone();
            mat.tx = 0;
            mat.ty = 0;
            bmd.draw(ds,mat,ds.transform.colorTransform,ds.blendMode,bmd.rect,true);
            return bmd;
         }
         throw new CastError("Can\'t cast to bitmap: " + data);
      }
      
      public static function bytearray(param1:*) : ByteArray
      {
         if(param1 is Class)
         {
            param1 = new param1();
         }
         if(param1 is ByteArray)
         {
            return param1;
         }
         return ByteArray(param1);
      }
      
      public static function xml(param1:*) : XML
      {
         if(param1 is Class)
         {
            param1 = new param1();
         }
         if(param1 is XML)
         {
            return param1;
         }
         return XML(param1);
      }
      
      public static function string(param1:*) : String
      {
         if(param1 is Class)
         {
            param1 = new param1();
         }
         if(param1 is String)
         {
            return param1;
         }
         return String(param1);
      }
      
      public static function tryclass(param1:String) : Object
      {
         var result:Class;
         var name:String = param1;
         if(notclasses[name])
         {
            return name;
         }
         result = classes[name];
         if(result != null)
         {
            return result;
         }
         try
         {
            result = getDefinitionByName(name) as Class;
            classes[name] = result;
            return result;
         }
         catch(error:ReferenceError)
         {
         }
         notclasses[name] = true;
         return name;
      }
   }
}

