PRINT "Sound check ... 1, 2, 3 ..."
PRINT 5 + 5
PRINT "5", "+", "5", "="; 5 + 5
PRINT "QB", "Tutorial", "3"
PRINT "QB "; "Tutorial "; "3"
PRINT "Calculation"; 4 + 5

PRINT "5 + 10 ="; 5 + 10
PRINT "6 - 5 ="; 6 - 5
PRINT "7 * 6 ="; 7 * 6
PRINT "10 / 2 ="; 10 / 2
PRINT "5 * 2 + 10 ="; 5 * 2 + 10
PRINT "(5 * 2) + 10 ="; (5 * 2) + 10
PRINT "5 * (2 + 10) ="; 5 * (2 + 10)

PRINT ,"Hey"
~~~~~~~~~~~~~~~~~~~~
KEYWORD     	#@# PRINT
STRING      	#@# Sound check ... 1, 2, 3 ...
KEYWORD     	#@# PRINT
NUMBER      	#@# 5
OPERATOR    	#@# +
NUMBER      	#@# 5
KEYWORD     	#@# PRINT
STRING      	#@# 5
OPERATOR    	#@# ,
STRING      	#@# +
OPERATOR    	#@# ,
STRING      	#@# 5
OPERATOR    	#@# ,
STRING      	#@# =
OPERATOR    	#@# ;
NUMBER      	#@# 5
OPERATOR    	#@# +
NUMBER      	#@# 5
KEYWORD     	#@# PRINT
STRING      	#@# QB
OPERATOR    	#@# ,
STRING      	#@# Tutorial
OPERATOR    	#@# ,
STRING      	#@# 3
KEYWORD     	#@# PRINT
STRING      	#@# QB 
OPERATOR    	#@# ;
STRING      	#@# Tutorial 
OPERATOR    	#@# ;
STRING      	#@# 3
KEYWORD     	#@# PRINT
STRING      	#@# Calculation
OPERATOR    	#@# ;
NUMBER      	#@# 4
OPERATOR    	#@# +
NUMBER      	#@# 5
KEYWORD     	#@# PRINT
STRING      	#@# 5 + 10 =
OPERATOR    	#@# ;
NUMBER      	#@# 5
OPERATOR    	#@# +
NUMBER      	#@# 10
KEYWORD     	#@# PRINT
STRING      	#@# 6 - 5 =
OPERATOR    	#@# ;
NUMBER      	#@# 6
OPERATOR    	#@# -
NUMBER      	#@# 5
KEYWORD     	#@# PRINT
STRING      	#@# 7 * 6 =
OPERATOR    	#@# ;
NUMBER      	#@# 7
OPERATOR    	#@# *
NUMBER      	#@# 6
KEYWORD     	#@# PRINT
STRING      	#@# 10 / 2 =
OPERATOR    	#@# ;
NUMBER      	#@# 10
OPERATOR    	#@# /
NUMBER      	#@# 2
KEYWORD     	#@# PRINT
STRING      	#@# 5 * 2 + 10 =
OPERATOR    	#@# ;
NUMBER      	#@# 5
OPERATOR    	#@# *
NUMBER      	#@# 2
OPERATOR    	#@# +
NUMBER      	#@# 10
KEYWORD     	#@# PRINT
STRING      	#@# (5 * 2) + 10 =
OPERATOR    	#@# ;
OPERATOR    	#@# (
NUMBER      	#@# 5
OPERATOR    	#@# *
NUMBER      	#@# 2
OPERATOR    	#@# )
OPERATOR    	#@# +
NUMBER      	#@# 10
KEYWORD     	#@# PRINT
STRING      	#@# 5 * (2 + 10) =
OPERATOR    	#@# ;
NUMBER      	#@# 5
OPERATOR    	#@# *
OPERATOR    	#@# (
NUMBER      	#@# 2
OPERATOR    	#@# +
NUMBER      	#@# 10
OPERATOR    	#@# )
KEYWORD     	#@# PRINT
OPERATOR    	#@# ,
STRING      	#@# Hey
~~~~~~~~~~~~~~~~~~~~
_ = {
    print("\("Sound check ... 1, 2, 3 ...")", terminator: "\n")
    print("\(5+5)", terminator: "\n")
    print("\("5")"+"\t"+"\("+")"+"\t"+"\("5")"+"\t"+"\("=")"+"\(5+5)", terminator: "\n")
    print("\("QB")"+"\t"+"\("Tutorial")"+"\t"+"\("3")", terminator: "\n")
    print("\("QB ")"+"\("Tutorial ")"+"\("3")", terminator: "\n")
    print("\("Calculation")"+"\(4+5)", terminator: "\n")
    print("\("5 + 10 =")"+"\(5+10)", terminator: "\n")
    print("\("6 - 5 =")"+"\(6-5)", terminator: "\n")
    print("\("7 * 6 =")"+"\(7*6)", terminator: "\n")
    print("\("10 / 2 =")"+"\(10/2)", terminator: "\n")
    print("\("5 * 2 + 10 =")"+"\(5*2+10)", terminator: "\n")
    print("\("(5 * 2) + 10 =")"+"\((5*2)+10)", terminator: "\n")
    print("\("5 * (2 + 10) =")"+"\(5*(2+10))", terminator: "\n")
    print("\t"+"\("Hey")", terminator: "\n")
}()
