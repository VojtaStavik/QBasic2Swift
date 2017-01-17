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
KEYWORD     	#@# DIM
IDENTIFIER  	#@# Num1
KEYWORD     	#@# AS
KEYWORD     	#@# INTEGER
KEYWORD     	#@# DIM
IDENTIFIER  	#@# Num2
KEYWORD     	#@# AS
KEYWORD     	#@# LONG
KEYWORD     	#@# DIM
IDENTIFIER  	#@# Num3
KEYWORD     	#@# AS
KEYWORD     	#@# SINGLE
KEYWORD     	#@# DIM
IDENTIFIER  	#@# Num4
KEYWORD     	#@# AS
KEYWORD     	#@# DOUBLE
KEYWORD     	#@# DIM
IDENTIFIER  	#@# Header
KEYWORD     	#@# AS
KEYWORD     	#@# STRING
KEYWORD     	#@# CLS
IDENTIFIER  	#@# Header
OPERATOR    	#@# =
STRING      	#@# This is another example
IDENTIFIER  	#@# Num1
OPERATOR    	#@# =
NUMBER      	#@# 5
IDENTIFIER  	#@# Num2
OPERATOR    	#@# =
NUMBER      	#@# 56000
IDENTIFIER  	#@# Num3
OPERATOR    	#@# =
NUMBER      	#@# 45.635
IDENTIFIER  	#@# Num4
OPERATOR    	#@# =
NUMBER      	#@# 66000.5634
KEYWORD     	#@# PRINT
IDENTIFIER  	#@# Header
KEYWORD     	#@# PRINT
IDENTIFIER  	#@# Num1
OPERATOR    	#@# +
IDENTIFIER  	#@# Num2
OPERATOR    	#@# +
IDENTIFIER  	#@# Num3
OPERATOR    	#@# +
IDENTIFIER  	#@# Num4
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
