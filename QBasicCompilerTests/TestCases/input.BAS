DIM FirstName AS STRING
DIM LastName AS STRING

CLS

INPUT "Enter First Name: ", FirstName
INPUT "Enter Last Name: ", LastName

PRINT
PRINT "Nice To Meet You, "; FirstName; " "; LastName
~~~~~~~~~~~~~~~~~~~~
KEYWORD     	#@# DIM
IDENTIFIER  	#@# First
IDENTIFIER  	#@# Name
KEYWORD     	#@# AS
KEYWORD     	#@# STRING
KEYWORD     	#@# DIM
IDENTIFIER  	#@# Last
IDENTIFIER  	#@# Name
KEYWORD     	#@# AS
KEYWORD     	#@# STRING
KEYWORD     	#@# CLS
KEYWORD     	#@# INPUT
STRING      	#@# Enter First Name: 
OPERATOR    	#@# ,
IDENTIFIER  	#@# First
IDENTIFIER  	#@# Name
KEYWORD     	#@# INPUT
STRING      	#@# Enter Last Name: 
OPERATOR    	#@# ,
IDENTIFIER  	#@# Last
IDENTIFIER  	#@# Name
KEYWORD     	#@# PRINT
KEYWORD     	#@# PRINT
STRING      	#@# Nice To Meet You, 
OPERATOR    	#@# ;
IDENTIFIER  	#@# First
IDENTIFIER  	#@# Name
OPERATOR    	#@# ;
STRING      	#@#  
OPERATOR    	#@# ;
IDENTIFIER  	#@# Last
IDENTIFIER  	#@# Name
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
