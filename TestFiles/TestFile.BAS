CLS
PRINT 5 + 10
PRINT 6 - 5
PRINT 7 * 6
PRINT 10 / 2
PRINT 5 * 2 + 10
PRINT (5 * 2) + 10
PRINT 5 * (2 + 10)

REM This is a comment
PRINT "Hello World"


PRINT 69 - 2
PRINT "Hello 2" + "kk"

PRINT 55.5 + (6 + (7 + 2))

' This is also a comment
A1$ = "Hello"
C% = -1


IF A1$ = "Hello" THEN
    PRINT A1$

    IF 2 < 5 THEN
        PRINT "2 Is Less Than 5"
    ELSE
        PRINT "2 is greater than 5"
    END IF

END IF

FOR x = 1 TO 5 STEP 2
    PRINT "loop1_1"
    PRINT "loop1_2"
    FOR y = 1 TO 5
        PRINT "loop2_1"

        FOR z = 1 TO 5
            PRINT "loop3_1"
            PRINT "loop3_2"
        NEXT z

        PRINT "loop2_2"

    NEXT y

NEXT x



FOR x = 10 TO 1 STEP -1
    PRINT x
NEXT x



PRINT "Say hi ;-)"


