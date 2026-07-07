package away3d.sprites
{
   import away3d.core.base.Object3D;
   import away3d.core.project.ProjectorType;
   import flash.display.BitmapData;
   
   public class Sprite2D extends Object3D
   {
      
      public var deltaZ:Number;
      
      public var smooth:Boolean;
      
      public var scaling:Number;
      
      public var rotation:Number;
      
      public var bitmap:BitmapData;
      
      public function Sprite2D(param1:BitmapData, param2:Object = null)
      {
         this.bitmap = param1;
         super(param2);
         scaling = ini.getNumber("scaling",1,{"min":0});
         rotation = ini.getNumber("rotation",0);
         smooth = ini.getBoolean("smooth",false);
         deltaZ = ini.getNumber("deltaZ",0);
         projectorType = ProjectorType.SPRITE;
      }
   }
}

