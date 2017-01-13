DECLARE FUNCTION Power! (x AS SINGLE, y AS SINGLE)
DIM Num1 AS SINGLE
DIM Num2 AS SINGLE
DIM Answer AS SINGLE

CLS

INPUT "Enter First Number: ", Num1
INPUT "Enter Second Number: ", Num2

Answer = Power!(Num1, Num2)

PRINT "The Answer Is:"; Answer

FUNCTION Power! (x AS SINGLE, y AS SINGLE)
Power! = x + y
END FUNCTION

