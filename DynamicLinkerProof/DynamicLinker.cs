using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using System;

namespace DynamicLinkerProof
{
    public static unsafe class DynamicLinker
    {
        [DllImport("BitConversionUtilities.dll")]
        public static extern int Increment(int x);         

        [DllImport("BitConversionUtilities.dll", CallingConvention = CallingConvention.StdCall)]
        public unsafe static extern void CopyArray(byte* s, byte* d, Int32 l);

        [DllImport("BitConversionUtilities.dll", CallingConvention = CallingConvention.StdCall)]
        public unsafe static extern void ReturnULongArray(byte* s, UInt32* d, UInt32 l);

        [DllImport("BitConversionUtilities.dll", CallingConvention = CallingConvention.StdCall)]
        public unsafe static extern void ReturnDoubleArray(byte* s, double* d, UInt32 l); 
    }
}
