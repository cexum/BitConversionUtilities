using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
namespace DynamicLinkerProof
{
    public class TestConsole
    {
        static void Main(string[] args)
        {
            byte[] barrPopulateme;
            Console.WriteLine("Output the number of bytes in an array of Int32s and Doubles respectively to proof bit-width...");
            double[] darrByteCount = new double[32];
            barrPopulateme = BitConverter.GetBytes(darrByteCount[0]);
            Console.WriteLine("One Double consumes: " + barrPopulateme.Length + " bytes...");

            UInt32[] uiarrByteCount = new UInt32[32];
            Byte[] barrByteCount = new byte[32];            

            int iAddToMe = 0;//counter
            for (int x = 0; x < 10; x++)
            {
                iAddToMe = DynamicLinker.Increment(iAddToMe); //makes this call just fine
                Console.WriteLine(iAddToMe);
            }

            int iArraySize = 16;
            byte[] barrRawData = new byte[iArraySize];

            for (byte a = 0; a < iArraySize; a++)
            {
                barrRawData[a] = 42;
            }


            byte[] barrProcessedData = new byte[iArraySize];
            UInt32[] iarrULongArray = new UInt32[iArraySize / 4];
            double[] darrDest = new double[iArraySize / 4];//bytes double, but I need iArraySize number of indexes here

            unsafe
            {
                fixed (UInt32* piDest = &iarrULongArray[0])
                {
                    fixed (double* pdDest = &darrDest[0])
                    {
                        fixed (byte* pSource = &barrRawData[0], pTarget = &barrProcessedData[0])
                        {
                            //prove that the array contains a bunch of 42s pre modification
                            for (byte b = 0; b < iArraySize; b++)
                            {
                                Console.WriteLine("source array: " + barrRawData[b]);
                            }

                            for (byte b = 0; b < iArraySize; b++)
                            {
                                Console.WriteLine("dest array: " + barrProcessedData[b]);
                            }

                            Console.WriteLine("pSource and pTarget : " + (int)pSource + " : " + (int)pTarget);
                            //byte* ps = pSource;
                            //byte* pt = pTarget;
                            int iSourceOffset = 1, iTargetOffset = 1;

                            //CopyArray(pSource, pTarget, iArraySize);

                            for (byte b = 0; b < iArraySize; b++)
                            {
                                Console.WriteLine("dest array: " + barrProcessedData[b]);
                            }                        

                            Console.WriteLine("Test out ReturnULongArray:");
                            DynamicLinker.ReturnULongArray(pSource, piDest, (uint)barrRawData.Length);
                            Console.WriteLine(iarrULongArray.Length);
                            for (int c = 0; c < iarrULongArray.Length; c++)
                                Console.WriteLine("iarrULongArray index: " + c + " " + iarrULongArray[c]);

                            Console.WriteLine("Test ReturnDoubleArray: ");
                            DynamicLinker.ReturnDoubleArray(pSource, pdDest, (uint)iArraySize);
                            for (int c = 0; c < darrDest.Length; c++)
                                Console.WriteLine("darrDest index: " + c + " " + darrDest[c]);


                     

                        }
                    }
                }
            }           

            string wait = Console.ReadLine();
        }
    }
}