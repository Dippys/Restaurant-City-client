package away3d.sprites
{
   import away3d.core.base.Object3D;
   import away3d.core.project.ProjectorType;
   import flash.display.DisplayObject;
   
   public class MovieClipSprite extends Object3D
   {
      
      public var movieclip:DisplayObject;
      
      public var deltaZ:Number;
      
      public var rescale:Boolean;
      
      public var scaling:Number;
      
      public var align:String;
      
      public function MovieClipSprite(param1:DisplayObject, param2:Object = null)
      {
         super(param2);
         this.movieclip = param1;
         scaling = ini.getNumber("scaling",1);
         deltaZ = ini.getNumber("deltaZ",0);
         rescale = ini.getBoolean("rescale",false);
         align = ini.getString("align","center");
         projectorType = ProjectorType.MOVIE_CLIP_SPRITE;
      }
   }
}

