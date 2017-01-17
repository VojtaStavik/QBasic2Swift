DECLARE SUB MySub ()
DECLARE SUB AnotherSub (greeting$)
CLS
PRINT "Sub, Are You Here?"
MySub
PRINT "Let's Run Another Sub"
AnotherSub ";=)"

SUB AnotherSub (greeting$)
    PRINT "This Is AnotherSub Running"
    PRINT "I Am Going To Do A Calculation"
    PRINT "25 + 5 * 4 ="; 25 + 5 * 4
    PRINT "The greeting is: "; greeting$

    i% = 0
    counter:
    IF i% < 10 THEN
        PRINT i%
        i% = i% + 1
        GOTO counter
    ELSE
        PRINT "We're done here: "; i%
    END IF
END SUB

SUB MySub
    PRINT "Yes, I Am Here"
END SUB
~~~~~~~~~~~~~~~~~~~~
KEYWORD     	#@# DECLARE
KEYWORD     	#@# SUB
IDENTIFIER  	#@# MySub
OPERATOR    	#@# (
OPERATOR    	#@# )
KEYWORD     	#@# DECLARE
KEYWORD     	#@# SUB
IDENTIFIER  	#@# AnotherSub
OPERATOR    	#@# (
IDENTIFIER  	#@# greeting$
OPERATOR    	#@# )
KEYWORD     	#@# CLS
KEYWORD     	#@# PRINT
STRING      	#@# Sub, Are You Here?
IDENTIFIER  	#@# MySub
KEYWORD     	#@# PRINT
STRING      	#@# Let's Run Another Sub
IDENTIFIER  	#@# AnotherSub
STRING      	#@# ;=)
KEYWORD     	#@# SUB
IDENTIFIER  	#@# AnotherSub
OPERATOR    	#@# (
IDENTIFIER  	#@# greeting$
OPERATOR    	#@# )
KEYWORD     	#@# PRINT
STRING      	#@# This Is AnotherSub Running
KEYWORD     	#@# PRINT
STRING      	#@# I Am Going To Do A Calculation
KEYWORD     	#@# PRINT
STRING      	#@# 25 + 5 * 4 =
OPERATOR    	#@# ;
NUMBER      	#@# 25
OPERATOR    	#@# +
NUMBER      	#@# 5
OPERATOR    	#@# *
NUMBER      	#@# 4
KEYWORD     	#@# PRINT
STRING      	#@# The greeting is: 
OPERATOR    	#@# ;
IDENTIFIER  	#@# greeting$
IDENTIFIER  	#@# i%
OPERATOR    	#@# =
NUMBER      	#@# 0
IDENTIFIER  	#@# counter
OPERATOR    	#@# :
KEYWORD     	#@# IF
IDENTIFIER  	#@# i%
OPERATOR    	#@# <
NUMBER      	#@# 10
KEYWORD     	#@# THEN
KEYWORD     	#@# PRINT
IDENTIFIER  	#@# i%
IDENTIFIER  	#@# i%
OPERATOR    	#@# =
IDENTIFIER  	#@# i%
OPERATOR    	#@# +
NUMBER      	#@# 1
KEYWORD     	#@# GOTO
IDENTIFIER  	#@# counter
KEYWORD     	#@# ELSE
KEYWORD     	#@# PRINT
STRING      	#@# We're done here: 
OPERATOR    	#@# ;
IDENTIFIER  	#@# i%
KEYWORD     	#@# END
KEYWORD     	#@# IF
KEYWORD     	#@# END
KEYWORD     	#@# SUB
KEYWORD     	#@# SUB
IDENTIFIER  	#@# MySub
KEYWORD     	#@# PRINT
STRING      	#@# Yes, I Am Here
KEYWORD     	#@# END
KEYWORD     	#@# SUB
~~~~~~~~~~~~~~~~~~~~
// User functions
func AnotherSub(greeting__string: String) -> Void {
    // Local vars declaration
    var i__int: Int = 0
    // AnotherSub loop:
    var AnotherSubNextLabel__internal = ""
    var AnotherSubLoopDone__internal = false
    repeat {
        switch AnotherSubNextLabel__internal {
        case "":
            print("\("This Is AnotherSub Running")", terminator: "\n")
            print("\("I Am Going To Do A Calculation")", terminator: "\n")
            print("\("25 + 5 * 4 =")"+"\(25+5*4)", terminator: "\n")
            print("\("The greeting is: ")"+"\(greeting__string)", terminator: "\n")
            i__int &= 0
            fallthrough
        case "counter":
            if i__int<10 {
                print("\(i__int)", terminator: "\n")
                i__int &= i__int+1
                AnotherSubNextLabel__internal = "counter"
                continue
            } else {
                print("\("We're done here: ")"+"\(i__int)", terminator: "\n")
            }
            fallthrough
        default:
            AnotherSubLoopDone__internal = true
        }
    } while AnotherSubLoopDone__internal == false
}
func MySub() -> Void {
    print("\("Yes, I Am Here")", terminator: "\n")
}
_ = {
    // Main loop vars declaration
    var i__int: Int = 0
    // CLS is not implemented yet
    print("\("Sub, Are You Here?")", terminator: "\n")
    MySub()
    print("\("Let's Run Another Sub")", terminator: "\n")
    AnotherSub(greeting__string: ";=)")
}()
