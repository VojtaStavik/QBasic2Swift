FOR x% = 1 TO 100
    IF x% MOD 15 = 0 THEN
        PRINT "FizzBuzz"
    ELSEIF x% MOD 5 = 0 THEN
        PRINT "Buzz"
    ELSEIF x% MOD 3 = 0 THEN
        PRINT "Fizz"
    ELSE
        PRINT x%
    END IF
NEXT x%
~~~~~~~~~~~~~~~~~~~~
KEYWORD     	#@# FOR
IDENTIFIER  	#@# x%
OPERATOR    	#@# =
NUMBER      	#@# 1
KEYWORD     	#@# TO
NUMBER      	#@# 100
KEYWORD     	#@# IF
IDENTIFIER  	#@# x%
OPERATOR    	#@# MOD
NUMBER      	#@# 15
OPERATOR    	#@# =
NUMBER      	#@# 0
KEYWORD     	#@# THEN
KEYWORD     	#@# PRINT
STRING      	#@# FizzBuzz
KEYWORD     	#@# ELSE
KEYWORD     	#@# IF
IDENTIFIER  	#@# x%
OPERATOR    	#@# MOD
NUMBER      	#@# 5
OPERATOR    	#@# =
NUMBER      	#@# 0
KEYWORD     	#@# THEN
KEYWORD     	#@# PRINT
STRING      	#@# Buzz
KEYWORD     	#@# ELSE
KEYWORD     	#@# IF
IDENTIFIER  	#@# x%
OPERATOR    	#@# MOD
NUMBER      	#@# 3
OPERATOR    	#@# =
NUMBER      	#@# 0
KEYWORD     	#@# THEN
KEYWORD     	#@# PRINT
STRING      	#@# Fizz
KEYWORD     	#@# ELSE
KEYWORD     	#@# PRINT
IDENTIFIER  	#@# x%
KEYWORD     	#@# END
KEYWORD     	#@# IF
KEYWORD     	#@# NEXT
IDENTIFIER  	#@# x%
~~~~~~~~~~~~~~~~~~~~
_ = {
    for x__int in stride(from: 1, to: 100, by: 1) {
        if x__int%15==0 {
            print("\("FizzBuzz")", terminator: "\n")
        } else {
            if x__int%5==0 {
                print("\("Buzz")", terminator: "\n")
            } else {
                if x__int%3==0 {
                    print("\("Fizz")", terminator: "\n")
                } else {
                    print("\(x__int)", terminator: "\n")
                }
            }
        }
    }
}()
