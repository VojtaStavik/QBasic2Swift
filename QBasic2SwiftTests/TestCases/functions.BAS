DECLARE FUNCTION Power! (x AS SINGLE, y AS SINGLE)
DIM Num1 AS SINGLE
DIM Num2 AS SINGLE
DIM Answer AS SINGLE

CLS

INPUT "Enter First Number: ", Num1
INPUT "Enter Second Number: ", Num2

Answer = Power!(Num1, Num2)

PRINT "The Answer Is:"; Answer

PRINT STR$(158)

FUNCTION Power! (x AS SINGLE, y AS SINGLE)
Power! = x + y
END FUNCTION
~~~~~~~~~~~~~~~~~~~~
// User functions
func Power__single(y: Double, x: Double) -> Double {
    return x+y
}
_ = {
    // Main loop vars declaration
    var Num2: Double = 0
    var Num1: Double = 0
    var Answer: Double = 0
    // CLS is not implemented yet
    print("Enter First Number: ", terminator: "")
    let _ = {
        let input = readLine() ?? ""
        Num1 = Double(input) ?? 0
    }()
    print("Enter Second Number: ", terminator: "")
    let _ = {
        let input = readLine() ?? ""
        Num2 = Double(input) ?? 0
    }()
    Answer &= Power__single(y: Num1, x: Num2)
    print("\("The Answer Is:")"+"\(Answer)", terminator: "\n")
    print("\(STR__string(158))", terminator: "\n")
}()
