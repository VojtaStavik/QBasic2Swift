DECLARE SUB DoubleNum (Number AS INTEGER)
DIM Num1 AS INTEGER

CLS

INPUT "Enter An Integer To Double: ", Num1

DoubleNum(Num1)

SUB DoubleNum (Number AS INTEGER)
PRINT "The Number Doubled: "; Number * 2
END SUB

