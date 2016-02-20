using System;
using System.Runtime.InteropServices;

using unsigned = System.UInt32;
using size_t = System.UInt32;

namespace LodePng
{
    public static class LodePngNative
    {
        [DllImport("lodepng")]
        public static extern unsigned lodepng_decode32(IntPtr outBuffer, IntPtr w, IntPtr h,
            IntPtr inBuffer, size_t inBufferSize);

    }
    public class LodePng
    {
    }
}