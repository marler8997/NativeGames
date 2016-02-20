using System;

namespace GameExplore
{
    public struct Color
    {
        Byte red;
        Byte green;
        Byte blue;
        public Color(Byte red, Byte green, Byte blue)
        {
            this.red = red;
            this.green = green;
            this.blue = blue;
        }

        public static Boolean operator ==(Color c1, Color c2)
        {
            return c1.red == c2.red &&
                c1.green == c2.green &&
                c1.blue == c2.blue;
        }
        public static Boolean operator !=(Color c1, Color c2)
        {
            return c1.red != c2.red ||
                c1.green != c2.green ||
                c1.blue != c2.blue;
        }
        public static Color White = new Color(255, 255, 255);
    }
    public struct AlphaColor
    {
    }

    public abstract class Graphics
    {
        public abstract void SetBackground(Color color);
    }



    public class Image
    {
        public UInt32 width, height;
    }

    public class ImageSystemDrawingBitmap : Image
    {
        readonly System.Drawing.Bitmap bitmap;
        public ImageSystemDrawingBitmap(System.Drawing.Bitmap bitmap)
        {
            this.bitmap = bitmap;
            this.width = (uint)bitmap.Width;
            this.height = (uint)bitmap.Height;
        }

        public void Render(Graphics graphics)
        {
        }
    }

    [Flags]
    public enum RepeatFlags
    {
        X = 0x01,
        Y = 0x02,
    }
    public enum Repeat
    {
        None = 0,
        X = RepeatFlags.X,
        Y = RepeatFlags.Y,
        XAndY = RepeatFlags.X | RepeatFlags.Y,
    }
    public enum Anchor
    {
        TopLeft     = 0,
        TopRight    = 1,
        BottomRight = 2,
        BottomLeft  = 3,
    }

    
    public class Box
    {
        public Color backColor;
        public Image backImage;
        //public RepeatFlags backRepeat;
        public Anchor backAnchor;

        UInt32 x;
        UInt32 y;
        UInt32 width;
        UInt32 height;

        public void Render()
        {

        }
    }


    public class RenderLayer
    {
    }

    public class StaticBackground : RenderLayer
    {
    }
    public class HorizontalPanningBackground : RenderLayer
    {
    }
    public class PanningBackground : RenderLayer
    {

    }


    public class Tile
    {
       
    }
    public class TileMapLayer
    {
        
    }

}
