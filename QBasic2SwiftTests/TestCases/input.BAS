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
    FirstName = String(readLine() ?? "")
    print("Enter Last Name: ", terminator: "")
    LastName = String(readLine() ?? "")
    print("", terminator: "\n")
    print("\("Nice To Meet You, ")"+"\(FirstName)"+"\(" ")"+"\(LastName)", terminator: "\n")
}()
