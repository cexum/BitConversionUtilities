               /'
Date: 2017.03.20
Author: Charles DeGrapharee Exum
Purpose: To create an unmanaged .dll which casts bytes.
'/' 

#include "crt/math.bi"

Extern "Windows-MS"

Public Function Increment(ByVal a As Long) As Long Export 'test function
    Dim iNumber as Long
    iNumber = a + 1
    Return iNumber
End Function

Public Sub CopySBytes(pbarrSource As Byte Ptr, pbarrDest As Byte Ptr, elements As ULong) Export'test function to copy memory from one location to another    
    
    For i As ULong = 0 To elements - 1    
        *(pbarrDest + i) = *(pbarrSource + i)
    Next i

End Sub

Public Sub CopyMemory(pbarrSource As UByte Ptr, pbarrDest As UByte Ptr, elements As ULong) Export'test function to copy memory from one location to another    
    
    For i As ULong = 0 To elements - 1    
        *(pbarrDest + i) = *(pbarrSource + i)
    Next i

End Sub

/'
Takes 4 bytes of data and stores it as a long.
Datums can be proper data, or in some cases meta data.
'/'
Public Function Return32BitDatum(barrudata() As UByte) As ULong Export 
    Dim iDatum As ULong = 0
    Dim iArraySize As ULong = 4
    Dim iarrDatum(iArraySize) As ULong 'need to take 4 of bytes (first 32-bits,) and cast to an array of 32-bit integers
    
    For c As Long = 0 To 3 'take the first 4 8-bit indexes, cast into 4 32-bit indexes
        iarrDatum(c) = barrudata(c)    
    Next c
    'bit shift values so that each index can sum into one larger number
    iarrDatum(0) = iarrDatum(0) SHL 24 
    iarrDatum(1) = iarrDatum(1) SHL 16
    iarrDatum(2) = iarrDatum(2) SHL 8
    'iarrDatum(3) = iarrDatum(3) SHL 0 'these bits are already in place and don't require a shift
    
    iDatum = iarrDatum(0) + iarrDatum(1) + iarrDatum(2) + iarrDatum(3) 'add each 32-bit index value together to create 1 32-bit long
    Return iDatum
End Function

Public Sub ReturnDoubleArray(pbarrSource As UByte Ptr, pdarrDest As Double Ptr, elements As ULong) Export
    Dim iTemp As Ulong = 0
    Dim b As UByte = 0
    Dim barrTempDatum(4) As Ubyte
    Dim barrTemp(elements) As UByte
    Dim iarrTemp(elements / 4) As ULong
    Dim dTemp As Double
    Dim darrTemp(elements / 4) As Double '**the double is 64-bit, so there are secretly 2x ubytes here
    
    'create a local UByte array from the source pointer
    For c As ULong = 0 To elements - 1 Step 1
        b = *(pbarrSource + c)
        barrTemp(c) = b        
    Next c 
    
    'create a local ULong array
    For d As ULong = 0 To elements - 1 Step 4
        'get the ubytes
        barrTempDatum(0) = barrTemp(d)
        barrTempDatum(1) = barrTemp(d + 1)
        barrTempDatum(2) = barrTemp(d + 2)
        barrTempDatum(3) = barrTemp(d + 3)
        'bit shift
        barrTempDatum(0) = barrTempDatum(0) SHL 24
        barrTempDatum(1) = barrTempDatum(1) SHL 16
        barrTempDatum(2) = barrTempDatum(2) SHL 8
        barrTempDatum(3) = barrTempDatum(3) SHL 0
        'return ulong
        iTemp = barrTempDatum(0) + barrTempDatum(1) + barrTempDatum(2) + barrTempDatum(3)
        'store in ulong()
        iarrTemp(d / 4) = iTemp
        'iarrTemp(d / 4) = Return32BitDatum(barrTempDatum())
        'Print "iarrTemp(d / 4) " & " " & (d / 4) & " " & iarrTemp(d / 4) 
        'For e As ULong = 0 To 3 Step 1
        '    barrTempDatum(e) = 0
        'Next e                
    Next d
    
    'create a local double array -- seems like an extra step, but I secretly need to do math here later on
    'copy the memory back to caller via pointer
    For a As ULong = 0 To (elements / 4) - 1 Step 1
        'local double()
        'dTemp = CDbl(iarrTemp(a))        
        'store in local double()
        'darrTemp(a) = dTemp       
        
        darrTemp(a) = iarrTemp(a)
        print darrTemp(a)
    Next a
    
    'copy the memory back to caller via pointer
    For a As Ulong = 0 To (elements / 4) - 1 Step 1
        *(pdarrDest + a) = darrTemp(a)
    Next a
    
End Sub

Public Sub ReturnULongArray(pbarrSource As UByte Ptr, piarrDest As ULong Ptr, elements As ULong) Export
    Dim i As Ulong = 0
    Dim b As UByte = 0
    Dim barrTempDatum(4) As Ubyte
    Dim barrTemp(elements) As UByte
    Dim iarrTemp(elements / 4) As ULong    
    
    'create a local UByte array from the source pointer
    For c As ULong = 0 To elements - 1 Step 1
        b = *(pbarrSource + c)
        barrTemp(c) = b        
    Next c    
    'create a local ULong array
    For d As ULong = 0 To elements - 1 Step 4
        'get the ubytes
        barrTempDatum(0) = barrTemp(d)
        barrTempDatum(1) = barrTemp(d + 1)
        barrTempDatum(2) = barrTemp(d + 2)
        barrTempDatum(3) = barrTemp(d + 3)
        'bit shift
        barrTempDatum(0) = barrTempDatum(0) SHL 24
        barrTempDatum(1) = barrTempDatum(1) SHL 16
        barrTempDatum(2) = barrTempDatum(2) SHL 8
        barrTempDatum(3) = barrTempDatum(3) SHL 0
        'return ulong
        i = barrTempDatum(0) + barrTempDatum(1) + barrTempDatum(2) + barrTempDatum(3)
        iarrTemp(d / 4) = i
        'iarrTemp(d / 4) = Return32BitDatum(barrTempDatum())
        'Print "iarrTemp(d / 4) " & " " & (d / 4) & " " & iarrTemp(d / 4) 
        For e As ULong = 0 To 3 Step 1
            barrTempDatum(e) = 0
        Next e
                
    Next d
    
    'populate destination array via ulong pointer
    For e As Ulong = 0 To (elements / 4) - 1 Step 1
        *(piarrDest + e) = iarrTemp(e)
    Next e
    
End Sub

End Extern
