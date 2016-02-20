using System;

namespace GameExplore
{
    public class WindowsGraphics : Graphics
    {
        Color backColor;
        public WindowsGraphics()
        {
            this.backColor = Color.White;
        }
        public override void SetBackground(Color color)
        {
            if (color != backColor)
            {
                this.backColor = color;
            }
        }

        public void Render()
        {

        }
    }
}