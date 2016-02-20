using System;
using System.Drawing;
using System.IO;

namespace GameExplore
{
    public static class ResourceManager
    {
        static readonly String ResourcePath;
        static ResourceManager()
        {
            // find the resource path
            if (Directory.Exists("img"))
            {
                ResourcePath = "";
                Console.WriteLine("[DEBUG] Resource path is current directory ({0})", Directory.GetCurrentDirectory());
            }
            else
            {
                ResourcePath = Directory.GetCurrentDirectory();
                while (true)
                {
                    DirectoryInfo parent = Directory.GetParent(ResourcePath);
                    if (parent.FullName.Equals(ResourcePath))
                    {
                        throw new InvalidOperationException("Could not find resource path");
                    }

                    ResourcePath = parent.FullName;
                    if (Directory.Exists(Path.Combine(ResourcePath, "img")))
                    {
                        Console.WriteLine("[DEBUG] Resource path is {0} (cwd={1})", ResourcePath, Directory.GetCurrentDirectory());
                        break;
                    }
                }
            }
        }
        public static Image LoadImage(String imageName)
        {
            string filename = Path.Combine(ResourcePath, Path.Combine("img", imageName));

            return new ImageSystemDrawingBitmap(new Bitmap(filename));
        }
    }
}