STDLIBINTERNAL:

' This is a collection of basic functions provided by QBasic
' STDLIB functions are marked _FUNCTION and _SUB

//SWIFT // Because QBasic is not that strict about types, we need these helper functions
//SWIFT // to make it work the same way.

//SWIFT func + (l: Double, r: Int) -> Double { return l + Double(r) }
//SWIFT func + (l: Int, r: Double) -> Double { return r + l }
//SWIFT func - (l: Double, r: Int) -> Double { return l - Double(r) }
//SWIFT func - (l: Int, r: Double) -> Double { return Double(l) - r }
//SWIFT func * (l: Double, r: Int) -> Double { return l * Double(r) }
//SWIFT func * (l: Int, r: Double) -> Double { return r * l }
//SWIFT func / (l: Double, r: Int) -> Double { return l / Double(r) }
//SWIFT func / (l: Int, r: Double) -> Double { return Double(l) / r }

//SWIFT func > (l: Double, r: Int) -> Bool { return l > Double(r) }
//SWIFT func > (l: Int, r: Double) -> Bool { return Double(l) > r }
//SWIFT func < (l: Double, r: Int) -> Bool { return l < Double(r) }
//SWIFT func < (l: Int, r: Double) -> Bool { return Double(l) < r }
//SWIFT func == (l: Double, r: Int) -> Bool { return l == Double(r) }
//SWIFT func == (l: Int, r: Double) -> Bool { return Double(l) == r }
//SWIFT func != (l: Double, r: Int) -> Bool { return l != Double(r) }
//SWIFT func != (l: Int, r: Double) -> Bool { return Double(l) != r }

_FUNCTION ABS AS INTEGER (absInternal AS INTEGER)
    IF absInternal >= 0 THEN
        ABS = absInternal
    ELSE
        ABS = -absInternal
    END IF
END FUNCTION

_FUNCTION LCASE$ (text$)
    //SWIFT return text__string.lowercased()
END FUNCTION

_FUNCTION LOG AS DOUBLE (num#)
    //SWIFT return log(num__double)
END FUNCTION

' How to make func work for all number types? Generics?
_FUNCTION STR$ (num#)
    //SWIFT return String(num__double)
END FUNCTION
