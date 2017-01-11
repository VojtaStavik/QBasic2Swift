DIM Num1% AS INTEGER
DIM Num2% AS INTEGER

CLS

INPUT "Enter First Integer: ", Num1%
INPUT "Enter Second Integer: ", Num2%

IF Num1% > Num2% THEN
  PRINT Num1%; "Is Greater Than"; Num2%
ELSE
    IF Num2% > Num1% THEN
        PRINT Num2%; "Is Greater Than"; Num1%
    ELSE
        PRINT "The Numbers Are The Same"
    END IF
END IF

