DECLARE FUNCTION DoubleNum! (x AS SINGLE)
DIM Num1 AS SINGLE

CLS

INPUT "Enter A Number To Double: ", Num1

PRINT "The Number Doubled:"; DoubleNum!(Num1)

FUNCTION DoubleNum! (x AS SINGLE)
DoubleNum! = x*2
END FUNCTION

