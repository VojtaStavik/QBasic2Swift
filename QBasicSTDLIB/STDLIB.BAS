STDLIBINTERNAL:

' This is a collection of basic functions provided by QBasic
' STDLIB functions are marked _FUNCTION and _SUB

//SWIFT // Because QBasic is not that strict about types, we need these helper functions
//SWIFT // to make Swift work the same way.

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

//SWIFT func &= ( left: inout Int, right: Double) { left = Int(right) }
//SWIFT func &= ( left: inout Double, right: Int) { left = Double(right) }
//SWIFT func &= ( left: inout String, right: String) { left = right }

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

_FUNCTION UCASE$ (text$)
    //SWIFT return text__string.uppercased()
END FUNCTION

_FUNCTION LOG AS DOUBLE (num#)
    //SWIFT return log(num__double)
END FUNCTION

_FUNCTION RND AS DOUBLE ()
    //SWIFT return Double(arc4random()) / 0xFFFFFFFF
END FUNCTION

' How to make func work for all number types? Generics?
_FUNCTION STR$ (num#)
    //SWIFT return String(num__double)
END FUNCTION
