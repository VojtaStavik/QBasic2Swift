DECLARE SUB Multiply (Number1 AS INTEGER, Number2 AS INTEGER)
DIM Num1 AS INTEGER
DIM Num2 AS INTEGER

CLS

INPUT "Enter num1: ", Num1
INPUT "Enter num2: ", Num2

Multiply(Num1, Num2)

SUB Multiply (Number1 AS INTEGER, Number2 AS INTEGER)
PRINT "The Number multiplied: "; Number1 * Number2
END SUB

