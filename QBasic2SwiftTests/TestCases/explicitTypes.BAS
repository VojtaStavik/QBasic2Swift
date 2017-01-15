DIM Num1 AS INTEGER
DIM Num2 AS LONG
DIM Num3 AS SINGLE
DIM Num4 AS DOUBLE
DIM Header AS STRING

CLS

Header = "This is another example"
Num1 = 5
Num2 = 56000
Num3 = 45.635
Num4 = 66000.5634

PRINT Header
PRINT Num1 + Num2 + Num3 + Num4
~~~~~~~~~~~~~~~~~~~~
_ = {
    // Main loop vars declaration
    var Num4: Double = 0
    var Num2: Int = 0
    var Num1: Int = 0
    var Num3: Double = 0
    var Header: String = ""
    // CLS is not implemented yet
    Header &= "This is another example"
    Num1 &= 5
    Num2 &= 56000
    Num3 &= 45.635
    Num4 &= 66000.5634
    print("\(Header)", terminator: "\n")
    print("\(Num1+Num2+Num3+Num4)", terminator: "\n")
}()
