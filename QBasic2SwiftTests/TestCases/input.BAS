DIM FirstName AS STRING
DIM LastName AS STRING

CLS

INPUT "Enter First Name: ", FirstName
INPUT "Enter Last Name: ", LastName

PRINT
PRINT "Nice To Meet You, "; FirstName; " "; LastName
~~~~~~~~~~~~~~~~~~~~
_ = {
    // Main loop vars declaration
    var FirstName: String = ""
    var LastName: String = ""
    // CLS is not implemented yet
    print("Enter First Name: ", terminator: "")
    let _ = {
        let input = readLine() ?? ""
        FirstName = String(input)
    }()
    print("Enter Last Name: ", terminator: "")
    let _ = {
        let input = readLine() ?? ""
        LastName = String(input)
    }()
    print("", terminator: "\n")
    print("\("Nice To Meet You, ")"+"\(FirstName)"+"\(" ")"+"\(LastName)", terminator: "\n")
}()
