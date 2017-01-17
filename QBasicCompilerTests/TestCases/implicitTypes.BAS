10 CLS
Header$ = "This is an example program"
Num1% = 5
Num2% = 6
Num3& = 45000
Num4& = 54000
Num5! = 4.5
Num6! = 6.75
Num7# = 56000.25
Num8# = 89000.34

50 PRINT Header$
PRINT Num1% + Num2% + Num3&
PRINT Num6! / Num5!
PRINT Num8# + Num2%
PRINT Num4& / Num1%
~~~~~~~~~~~~~~~~~~~~
NUMBER      	#@# 10
KEYWORD     	#@# CLS
IDENTIFIER  	#@# Header$
OPERATOR    	#@# =
STRING      	#@# This is an example program
IDENTIFIER  	#@# Num1%
OPERATOR    	#@# =
NUMBER      	#@# 5
IDENTIFIER  	#@# Num2%
OPERATOR    	#@# =
NUMBER      	#@# 6
IDENTIFIER  	#@# Num3&
OPERATOR    	#@# =
NUMBER      	#@# 45000
IDENTIFIER  	#@# Num4&
OPERATOR    	#@# =
NUMBER      	#@# 54000
IDENTIFIER  	#@# Num5!
OPERATOR    	#@# =
NUMBER      	#@# 4.5
IDENTIFIER  	#@# Num6!
OPERATOR    	#@# =
NUMBER      	#@# 6.75
IDENTIFIER  	#@# Num7#
OPERATOR    	#@# =
NUMBER      	#@# 56000.25
IDENTIFIER  	#@# Num8#
OPERATOR    	#@# =
NUMBER      	#@# 89000.34
NUMBER      	#@# 50
KEYWORD     	#@# PRINT
IDENTIFIER  	#@# Header$
KEYWORD     	#@# PRINT
IDENTIFIER  	#@# Num1%
OPERATOR    	#@# +
IDENTIFIER  	#@# Num2%
OPERATOR    	#@# +
IDENTIFIER  	#@# Num3&
KEYWORD     	#@# PRINT
IDENTIFIER  	#@# Num6!
OPERATOR    	#@# /
IDENTIFIER  	#@# Num5!
KEYWORD     	#@# PRINT
IDENTIFIER  	#@# Num8#
OPERATOR    	#@# +
IDENTIFIER  	#@# Num2%
KEYWORD     	#@# PRINT
IDENTIFIER  	#@# Num4&
OPERATOR    	#@# /
IDENTIFIER  	#@# Num1%
~~~~~~~~~~~~~~~~~~~~
_ = {
    // Main loop vars declaration
    var Num2__int: Int = 0
    var Num5__single: Double = 0
    var Num4__long: Int = 0
    var Header__string: String = ""
    var Num3__long: Int = 0
    var Num6__single: Double = 0
    var Num1__int: Int = 0
    var Num8__double: Double = 0
    var Num7__double: Double = 0
    // main loop:
    var mainNextLabel__internal = "name"
    var mainLoopDone__internal = false
    repeat {
        switch mainNextLabel__internal {
        case "10":
            // CLS is not implemented yet
            Header__string &= "This is an example program"
            Num1__int &= 5
            Num2__int &= 6
            Num3__long &= 45000
            Num4__long &= 54000
            Num5__single &= 4.5
            Num6__single &= 6.75
            Num7__double &= 56000.25
            Num8__double &= 89000.34
            fallthrough
        case "50":
            print("\(Header__string)", terminator: "\n")
            print("\(Num1__int+Num2__int+Num3__long)", terminator: "\n")
            print("\(Num6__single/Num5__single)", terminator: "\n")
            print("\(Num8__double+Num2__int)", terminator: "\n")
            print("\(Num4__long/Num1__int)", terminator: "\n")
            fallthrough
        default:
            mainLoopDone__internal = true
        }
    } while mainLoopDone__internal == false
}()
