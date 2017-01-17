DIM KeyPressed AS STRING
KeyPressed = " "

SELECT CASE KeyPressed
  CASE "A"
     PRINT "A Was Entered"
  CASE "B"
     PRINT "B Was Entered"
  CASE "C"
     PRINT "C Was Entered"
  CASE "D"
     PRINT "D Was Entered"
  CASE ELSE
     PRINT "Some Other Key Was Entered"
END SELECT

~~~~~~~~~~~~~~~~~~~~
KEYWORD     	#@# DIM
IDENTIFIER  	#@# KeyPressed
KEYWORD     	#@# AS
KEYWORD     	#@# STRING
IDENTIFIER  	#@# KeyPressed
OPERATOR    	#@# =
STRING      	#@#  
KEYWORD     	#@# SELECT
KEYWORD     	#@# CASE
IDENTIFIER  	#@# KeyPressed
KEYWORD     	#@# CASE
STRING      	#@# A
KEYWORD     	#@# PRINT
STRING      	#@# A Was Entered
KEYWORD     	#@# CASE
STRING      	#@# B
KEYWORD     	#@# PRINT
STRING      	#@# B Was Entered
KEYWORD     	#@# CASE
STRING      	#@# C
KEYWORD     	#@# PRINT
STRING      	#@# C Was Entered
KEYWORD     	#@# CASE
STRING      	#@# D
KEYWORD     	#@# PRINT
STRING      	#@# D Was Entered
KEYWORD     	#@# CASE
KEYWORD     	#@# ELSE
KEYWORD     	#@# PRINT
STRING      	#@# Some Other Key Was Entered
KEYWORD     	#@# END
KEYWORD     	#@# SELECT
~~~~~~~~~~~~~~~~~~~~
_ = {
    // Main loop vars declaration
    var KeyPressed: String = ""
    KeyPressed &= " "
    switch KeyPressed {
    case "A":
        print("\("A Was Entered")", terminator: "\n")
    case "B":
        print("\("B Was Entered")", terminator: "\n")
    case "C":
        print("\("C Was Entered")", terminator: "\n")
    case "D":
        print("\("D Was Entered")", terminator: "\n")
    default:
        print("\("Some Other Key Was Entered")", terminator: "\n")
    }
}()
